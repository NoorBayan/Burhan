import 'package:flutter/material.dart';
import 'package:ijaaz_app/application/data_loader.dart';
import 'package:ijaaz_app/application/amthal_translator.dart';
import 'package:ijaaz_app/application/settings_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int? selectedConceptId;
  String? selectedSubConcept;
  int? selectedFunctionId;
  int? selectedValence;

  List<dynamic> filteredInstances = [];
  bool isLoading = true;
  bool _searchPerformed = false;

  late Map<int, String> mainConcepts;
  late Map<int, String> rhetoricalFunctions;
  late Map<int, String> emotionalValence;

  @override
  void initState() {
    super.initState();
    mainConcepts = AmthalTranslator.getMainConcepts();
    rhetoricalFunctions = AmthalTranslator.getRhetoricalFunctions();
    emotionalValence = AmthalTranslator.getEmotionalValence();
    _initData();
  }

  Future<void> _initData() async {
    if (QuranDataLoader.allInstances.isEmpty) {
      await QuranDataLoader.loadInitialData();
    }
    setState(() => isLoading = false);
  }

  void _applyFilters() {
    setState(() {
      _searchPerformed = true;
      filteredInstances = QuranDataLoader.allInstances.where((item) {
        bool matchConcept = selectedConceptId == null || item['Dominant_Concept'] == selectedConceptId;
        bool matchSub = selectedSubConcept == null || item['Child_Concept'] == selectedSubConcept || AmthalTranslator.translate(item['Child_Concept']?.toString() ?? '') == selectedSubConcept;
        bool matchFunc = selectedFunctionId == null || item['Rhetorical_Function'] == selectedFunctionId;
        bool matchValence = selectedValence == null || item['Valence'] == selectedValence;
        return matchConcept && matchSub && matchFunc && matchValence;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = SettingsService().locale.languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(isArabic ? 'مستكشف الشواهد البلاغية' : 'Rhetorical Evidence Explorer', 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
          ),
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
                  _buildMobileFilterSection(theme, isDark, isArabic),
                  Expanded(child: _buildMainContent(theme, isDark, isArabic)),
                ],
              );
            }
            return Row(
              children: [
                _buildSidebar(isMobile: false, theme: theme, isDark: isDark, isArabic: isArabic),
                Expanded(child: _buildMainContent(theme, isDark, isArabic)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileFilterSection(ThemeData theme, bool isDark, bool isArabic) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: ExpansionTile(
        title: Text(isArabic ? 'تصفية الشواهد' : 'Filter Evidence', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontSize: 14)),
        leading: Icon(Icons.filter_list_rounded, color: theme.colorScheme.primary),
        children: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
             child: _buildFilterForm(isMobile: true, theme: theme, isDark: isDark, isArabic: isArabic),
           ),
        ],
      ),
    );
  }

  Widget _buildSidebar({required bool isMobile, required ThemeData theme, required bool isDark, required bool isArabic}) {
    return Container(
      width: 320,
      color: theme.cardColor,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 24),
              const SizedBox(width: 10),
              Text(isArabic ? 'مولد الشواهد' : 'Evidence Generator', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(child: SingleChildScrollView(child: _buildFilterForm(isMobile: false, theme: theme, isDark: isDark, isArabic: isArabic))),
          const SizedBox(height: 20),
          _buildSearchButton(theme, isArabic),
        ],
      ),
    );
  }

  Widget _buildFilterForm({required bool isMobile, required ThemeData theme, required bool isDark, required bool isArabic}) {
    // استخراج المفاهيم الفرعية وترجمتها إن لزم الأمر
    List<String> subConcepts = selectedConceptId == null ? [] 
      : QuranDataLoader.allInstances
          .where((i) => i['Dominant_Concept'] == selectedConceptId)
          .map((i) => AmthalTranslator.translate(i['Child_Concept']?.toString() ?? ""))
          .toSet().where((s) => s.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown(isArabic ? "المفهوم الرئيسي" : "Primary Concept", mainConcepts, selectedConceptId, (val) => setState(() { selectedConceptId = val; selectedSubConcept = null; }), theme, isDark, isArabic),
        const SizedBox(height: 16),
        if (subConcepts.isNotEmpty) ...[
          _buildDropdown(isArabic ? "المفهوم الفرعي" : "Sub Concept", Map.fromEntries(subConcepts.map((s) => MapEntry(s, s))), selectedSubConcept, (val) => setState(() => selectedSubConcept = val), theme, isDark, isArabic),
          const SizedBox(height: 16),
        ],
        _buildDropdown(isArabic ? "الهدف البلاغي" : "Rhetorical Goal", rhetoricalFunctions, selectedFunctionId, (val) => setState(() => selectedFunctionId = val), theme, isDark, isArabic),
        const SizedBox(height: 16),
        _buildDropdown(isArabic ? "النبرة الشعورية" : "Emotional Tone", emotionalValence, selectedValence, (val) => setState(() => selectedValence = val), theme, isDark, isArabic),
        if (isMobile) ...[
          const SizedBox(height: 20),
          _buildSearchButton(theme, isArabic),
          const SizedBox(height: 10),
        ]
      ],
    );
  }

  Widget _buildSearchButton(ThemeData theme, bool isArabic) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _applyFilters,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary, 
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        child: Text(isArabic ? 'استخراج الشواهد' : 'Extract Evidence', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _buildDropdown(String label, Map items, dynamic selectedValue, Function(dynamic) onChanged, ThemeData theme, bool isDark, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.grey[400] : Colors.blueGrey, fontFamily: 'Kitab')),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.surfaceVariant : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              dropdownColor: theme.cardColor,
              value: selectedValue,
              isExpanded: true,
              hint: Text(isArabic ? 'الكل' : 'All', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.primary),
              style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Kitab'),
              items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(ThemeData theme, bool isDark, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_searchPerformed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: isDark ? theme.colorScheme.primary.withOpacity(0.2) : const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(isArabic ? 'تم العثور على ${filteredInstances.length} نتيجة:' : 'Found ${filteredInstances.length} results:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Expanded(
            child: filteredInstances.isEmpty && _searchPerformed
              ? Center(child: Text(isArabic ? 'لا توجد نتائج تطابق خيارات التصفية' : 'No results match the applied filters', style: const TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: filteredInstances.length,
                  itemBuilder: (context, index) => _ResultCard(item: filteredInstances[index]),
                ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final dynamic item;
  const _ResultCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = SettingsService().locale.languageCode == 'ar';
    
    final suraName = QuranDataLoader.getSuraName(item['Sura_No'] ?? 0);
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6, color: theme.colorScheme.primary),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\"${item['Verse_Text'] ?? item['vers_text'] ?? ""}\"', 
                        textAlign: TextAlign.center, 
                        style: TextStyle(fontSize: 19, color: theme.textTheme.bodyLarge?.color, height: 1.7, fontFamily: 'Kitab', fontWeight: FontWeight.w500)
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bookmark_border, size: 14, color: isDark ? Colors.grey[400] : Colors.blueGrey),
                          const SizedBox(width: 4),
                          Text('$suraName : ${item['Aya_No']}', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.blueGrey, fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Divider(color: isDark ? Colors.white12 : const Color(0xFFF0F2F5), height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTag(AmthalTranslator.translate(item['Child_Concept']?.toString() ?? 'مفهوم'), isDark ? theme.colorScheme.primary.withOpacity(0.2) : const Color(0xFFE3F2FD), isDark ? theme.colorScheme.primaryContainer : const Color(0xFF1976D2)),
                          _buildTag(_getFunctionLabel(item['Rhetorical_Function'], isArabic), isDark ? Colors.teal.withOpacity(0.2) : const Color(0xFFE0F2F1), isDark ? Colors.tealAccent : const Color(0xFF00796B)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFunctionLabel(int? functionId, bool isArabic) {
    final functions = AmthalTranslator.getRhetoricalFunctions();
    return functions[functionId] ?? (isArabic ? 'غرض بلاغي' : 'Rhetorical Purpose');
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Kitab')),
    );
  }
}
