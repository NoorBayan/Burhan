import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ijaaz_app/application/data_loader.dart';
import 'package:ijaaz_app/application/settings_service.dart';
import 'package:ijaaz_app/application/amthal_translator.dart';

class SuraAnalysisResult {
  final int id;
  final String name;
  final String type;
  final int totalAyahs;
  final Map<String, int> topConcepts;
  final Map<String, int> rhetoricalDirections;
  final double positivityScore;

  SuraAnalysisResult({
    required this.id,
    required this.name,
    required this.type,
    required this.totalAyahs,
    required this.topConcepts,
    required this.rhetoricalDirections,
    required this.positivityScore,
  });
}

class QuranStyleAnalyzerPage extends StatefulWidget {
  const QuranStyleAnalyzerPage({super.key});

  @override
  State<QuranStyleAnalyzerPage> createState() => _QuranStyleAnalyzerPageState();
}

class _QuranStyleAnalyzerPageState extends State<QuranStyleAnalyzerPage> {
  bool _isDataLoaded = false;
  final List<int> _selectedSuraIds = [];
  List<SuraAnalysisResult> _comparisonResults = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (QuranDataLoader.allInstances.isEmpty) {
      await QuranDataLoader.loadInitialData();
    }
    setState(() => _isDataLoaded = true);
  }

  void _runAnalysis() {
    if (_selectedSuraIds.isEmpty) {
      setState(() => _comparisonResults = []);
      return;
    }

    List<SuraAnalysisResult> results = [];
    final isArabic = SettingsService().locale.languageCode == 'ar';
    final funcs = AmthalTranslator.getRhetoricalFunctions();
    
    String w1 = funcs[1] ?? (isArabic ? 'وعد' : 'Promise');
    String w2 = funcs[2] ?? (isArabic ? 'وعيد' : 'Threat');
    String w3 = funcs[3] ?? (isArabic ? 'حجاج' : 'Argument');
    String w4 = funcs[4] ?? (isArabic ? 'تشريع' : 'Legislation');

    for (int id in _selectedSuraIds) {
      final suraData = QuranDataLoader.allInstances.where((i) => i['Sura_No'] == id).toList();

      Map<String, int> concepts = {};
      for (var item in suraData) {
        String arabicConcept = AmthalTranslator.translate(item['Child_Concept']?.toString() ?? 'مفاهيم متنوعة');
        concepts[arabicConcept] = (concepts[arabicConcept] ?? 0) + 1;
      }
      var sortedConcepts = Map.fromEntries(
        concepts.entries.toList()..sort((a, b) => b.value.compareTo(a.value))
      );

      Map<String, int> directions = {w1: 0, w2: 0, w3: 0, w4: 0};
      for (var item in suraData) {
        int func = item['Rhetorical_Function'] ?? 0;
        if (func == 1) directions[w1] = directions[w1]! + 1;
        else if (func == 2) directions[w2] = directions[w2]! + 1;
        else if (func == 3) directions[w3] = directions[w3]! + 1;
        else if (func == 4) directions[w4] = directions[w4]! + 1;
      }

      int positiveCount = suraData.where((i) => i['Valence'] == 1).length;
      double score = suraData.isEmpty ? 0 : positiveCount / suraData.length;

      results.add(SuraAnalysisResult(
        id: id,
        name: QuranDataLoader.getSuraName(id),
        type: id <= 20 ? (isArabic ? 'مدنية' : 'Medinan') : (isArabic ? 'مكية' : 'Meccan'),
        totalAyahs: suraData.length,
        topConcepts: Map.fromEntries(sortedConcepts.entries.take(4)), // زيادة العدد لـ 4 مفاهيم
        rhetoricalDirections: directions,
        positivityScore: score,
      ));
    }
    setState(() => _comparisonResults = results);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDataLoaded) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = SettingsService().locale.languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(isArabic ? 'محلل الأسلوب والمقارنة البلاغية' : 'Style Analyzer & Rhetorical Comparison', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Kitab')),
          backgroundColor: isDark ? theme.appBarTheme.backgroundColor : const Color(0xFF1F3444),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 800;
            
            if (isMobile) {
              return Column(
                children: [
                  _buildTopBar(theme, isDark, isArabic),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        ..._comparisonResults.map((result) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _EnhancedSuraCard(result: result, theme: theme, isDark: isDark, isArabic: isArabic, isMobile: true),
                        )),
                        if (_comparisonResults.isEmpty)
                          SizedBox(
                            height: constraints.maxHeight * 0.4,
                            child: _buildEmptyState(theme, isDark, isArabic),
                          ),
                        _buildSidebar(isFullWidth: true, isMobile: true, theme: theme, isDark: isDark, isArabic: isArabic),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _buildTopBar(theme, isDark, isArabic),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSidebar(isFullWidth: false, theme: theme, isDark: isDark, isArabic: isArabic),
                      Expanded(
                        child: _comparisonResults.isEmpty
                          ? _buildEmptyState(theme, isDark, isArabic)
                          : Padding(
                              padding: const EdgeInsets.all(16),
                              child: _buildComparisonContent(isMobile: false, theme: theme, isDark: isDark, isArabic: isArabic),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark, bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.compare_arrows_rounded, size: 80, color: isDark ? Colors.grey[700] : Colors.grey[300]),
          const SizedBox(height: 20),
          Text(isArabic ? "اختر من سورتين إلى 4 سور لبدء التحليل المقارن" : "Select 2 to 4 suras to start comparative analysis", style: TextStyle(color: isDark ? Colors.grey[400] : Colors.blueGrey, fontSize: 14, fontFamily: 'Kitab')),
        ],
      ),
    );
  }

  Widget _buildSidebar({required bool isFullWidth, bool isMobile = false, required ThemeData theme, required bool isDark, required bool isArabic}) {
    final funcs = AmthalTranslator.getRhetoricalFunctions();
    return Container(
      width: isFullWidth ? double.infinity : 280,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: isMobile ? BorderRadius.circular(15) : null,
        boxShadow: isMobile ? [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 10, offset: const Offset(0, 2))] : null,
        border: !isMobile ? Border(left: BorderSide(color: isDark ? Colors.white12 : Colors.grey.withOpacity(0.1))) : null,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isArabic ? 'دليل التحليل الأسلوبي' : 'Style Analysis Guide', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontFamily: 'Kitab')),
          const SizedBox(height: 10),
          Text(
            isArabic ? 'يقارن المحلل بين السور من حيث التوجه البلاغي (ترغيبي/ترهيبي) وكثافة المفاهيم القرآنية.' : 'The analyzer compares suras in terms of rhetorical direction (persuasive/deterrent) and density of Quranic concepts.',
            style: TextStyle(height: 1.5, fontSize: 11, color: isDark ? Colors.grey[400] : Colors.blueGrey, fontFamily: 'Kitab'),
          ),
          const Divider(height: 24),
          Wrap(
            spacing: 15,
            runSpacing: 8,
            children: [
              _legendItem(funcs[1] ?? (isArabic ? 'وعد' : 'Promise'), Colors.green, theme, isDark),
              _legendItem(funcs[2] ?? (isArabic ? 'وعيد' : 'Threat'), Colors.red, theme, isDark),
              _legendItem(funcs[3] ?? (isArabic ? 'حجاج' : 'Argument'), Colors.orange, theme, isDark),
              _legendItem(funcs[4] ?? (isArabic ? 'تشريع' : 'Legislation'), Colors.blue, theme, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String text, Color color, ThemeData theme, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 10, fontFamily: 'Kitab', color: isDark ? Colors.grey[300] : Colors.black87)),
      ],
    );
  }

  Widget _buildTopBar(ThemeData theme, bool isDark, bool isArabic) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  dropdownColor: theme.cardColor,
                  decoration: InputDecoration(
                    hintText: isArabic ? "أضف سورة للمقارنة..." : "Add a sura to compare...",
                    hintStyle: TextStyle(fontSize: 13, fontFamily: 'Kitab', color: isDark ? Colors.grey[400] : Colors.blueGrey),
                    prefixIcon: Icon(Icons.add_chart_outlined, color: theme.colorScheme.primary, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: isDark ? theme.colorScheme.surfaceVariant : const Color(0xFFF8F9FA),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: QuranDataLoader.surahNames.entries.map((e) => DropdownMenuItem(value: e.key, child: Text("${e.key}. ${isArabic ? e.value : QuranDataLoader.getSuraName(e.key)}", style: TextStyle(fontSize: 13, fontFamily: 'Kitab', color: theme.textTheme.bodyLarge?.color)))).toList(),
                  onChanged: (id) {
                    if (id != null && !_selectedSuraIds.contains(id)) {
                      if (_selectedSuraIds.length >= 4) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isArabic ? 'يمكنك اختيار 4 سور كحد أقصى للمقارنة.' : 'You can select up to 4 suras to compare.')));
                        return;
                      }
                      setState(() {
                        _selectedSuraIds.add(id);
                        _runAnalysis();
                      });
                    }
                  },
                ),
              ),
              if (_selectedSuraIds.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent, size: 22),
                  onPressed: () => setState(() { _selectedSuraIds.clear(); _comparisonResults = []; }),
                ),
            ],
          ),
          if (_selectedSuraIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _selectedSuraIds.map((id) => Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Chip(
                      label: Text(QuranDataLoader.getSuraName(id), style: TextStyle(fontSize: 11, fontFamily: 'Kitab', fontWeight: FontWeight.bold, color: isDark ? theme.colorScheme.primaryContainer : const Color(0xFF1976D2))),
                      onDeleted: () {
                        setState(() {
                          _selectedSuraIds.remove(id);
                          _runAnalysis();
                        });
                      },
                      backgroundColor: isDark ? theme.colorScheme.primary.withOpacity(0.2) : const Color(0xFFE3F2FD),
                      deleteIcon: const Icon(Icons.cancel, size: 16),
                      deleteIconColor: Colors.red[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  )).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildComparisonContent({required bool isMobile, required ThemeData theme, required bool isDark, required bool isArabic}) {
    int crossAxisCount = _selectedSuraIds.length > 2 ? 2 : _selectedSuraIds.length;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _comparisonResults.length,
      itemBuilder: (context, index) => _EnhancedSuraCard(result: _comparisonResults[index], theme: theme, isDark: isDark, isArabic: isArabic, isMobile: false),
    );
  }
}

class _EnhancedSuraCard extends StatelessWidget {
  final SuraAnalysisResult result;
  final ThemeData theme;
  final bool isDark;
  final bool isArabic;
  final bool isMobile;

  const _EnhancedSuraCard({required this.result, required this.theme, required this.isDark, required this.isArabic, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.03), blurRadius: 15)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: theme.colorScheme.primary.withOpacity(0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color, fontFamily: 'Kitab')),
                      Text('${result.type} • ${result.totalAyahs} ${isArabic ? "شاهد" : "verses"}', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.blueGrey, fontSize: 10, fontFamily: 'Kitab')),
                    ],
                  ),
                  Icon(Icons.analytics_outlined, color: theme.colorScheme.primary, size: 24),
                ],
              ),
            ),
            if (isMobile)
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildCardContent(),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildCardContent(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(isArabic ? 'المفاهيم الأكثر تكراراً' : 'Most Frequent Concepts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isDark ? Colors.grey[400] : Colors.blueGrey, fontFamily: 'Kitab')),
        const SizedBox(height: 12),
        _buildConceptsBars(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Divider(height: 1, color: isDark ? Colors.white12 : const Color(0xFFF0F2F5)),
        ),
        Text(isArabic ? 'تحليل الوظيفة البلاغية' : 'Rhetorical Function Analysis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isDark ? Colors.grey[400] : Colors.blueGrey, fontFamily: 'Kitab')),
        const SizedBox(height: 12),
        SizedBox(height: 100, child: _buildDonutChart()),
        const SizedBox(height: 16),
        _buildValenceIndicator(),
      ],
    );
  }

  Widget _buildConceptsBars() {
    final entries = result.topConcepts.entries.toList();
    if (entries.isEmpty) return Text(isArabic ? 'لا توجد بيانات كافية' : 'Not enough data', style: TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'Kitab'));

    return Column(
      children: entries.map((e) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            // تحسين عرض النص العربي الطويل للمفهوم الفرعي
            Expanded(
              flex: 3,
              child: Text(
                e.key, 
                style: TextStyle(fontSize: 10, fontFamily: 'Kitab', height: 1.2, color: theme.textTheme.bodyMedium?.color), 
                overflow: TextOverflow.visible,
              )
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: e.value / (entries.first.value == 0 ? 1 : entries.first.value),
                  minHeight: 5,
                  backgroundColor: isDark ? Colors.grey[800] : const Color(0xFFF0F2F5),
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(e.value.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: theme.textTheme.bodyLarge?.color)),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildDonutChart() {
    final dirs = result.rhetoricalDirections;
    double total = dirs.values.fold(0, (sum, v) => sum + v);
    if (total == 0) return Center(child: Text(isArabic ? "بيانات غير متوفرة" : "No data available", style: const TextStyle(fontSize: 10, fontFamily: 'Kitab')));

    final funcs = AmthalTranslator.getRhetoricalFunctions();
    String w1 = funcs[1] ?? (isArabic ? 'وعد' : 'Promise');
    String w2 = funcs[2] ?? (isArabic ? 'وعيد' : 'Threat');
    String w3 = funcs[3] ?? (isArabic ? 'حجاج' : 'Argument');
    String w4 = funcs[4] ?? (isArabic ? 'تشريع' : 'Legislation');

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 25,
        sections: [
          PieChartSectionData(value: dirs[w1]!.toDouble(), color: Colors.green, title: '', radius: 15),
          PieChartSectionData(value: dirs[w2]!.toDouble(), color: Colors.red, title: '', radius: 15),
          PieChartSectionData(value: dirs[w3]!.toDouble(), color: Colors.orange, title: '', radius: 15),
          PieChartSectionData(value: dirs[w4]!.toDouble(), color: Colors.blue, title: '', radius: 15),
        ],
      ),
    );
  }

  Widget _buildValenceIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(isArabic ? 'النبرة الشعورية الإيجابية' : 'Positive Emotional Valence', style: TextStyle(fontSize: 10, color: isDark ? Colors.grey[400] : Colors.blueGrey, fontFamily: 'Kitab')),
            Text('${(result.positivityScore * 100).toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: result.positivityScore,
            minHeight: 6,
            color: Colors.teal[400],
            backgroundColor: isDark ? Colors.grey[800] : Colors.teal[50],
          ),
        ),
      ],
    );
  }
}
