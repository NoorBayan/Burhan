import 'package:flutter/material.dart';
import 'package:ijaaz_app/application/data_loader.dart';
import 'package:ijaaz_app/application/settings_service.dart';
import 'package:ijaaz_app/application/amthal_translator.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int? selectedConceptId;
  int? selectedFunctionId;
  int? selectedValence;

  List<QuranInstance> searchResults = [];
  bool showResults = false;
  bool isLoading = true;

  // المفاهيم الكبرى المحدثة
  late Map<int, String> conceptOptions;
  late Map<int, String> functionOptions;
  late Map<int, String> valenceOptions;

  @override
  void initState() {
    super.initState();
    final bool isArabic = SettingsService().locale.languageCode == 'ar';
    conceptOptions = Map.from(AmthalTranslator.getMainConcepts());
    conceptOptions[0] = isArabic ? 'عام' : 'General';
    functionOptions = AmthalTranslator.getRhetoricalFunctions();
    valenceOptions = AmthalTranslator.getEmotionalValence();
    
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (QuranDataLoader.allInstances.isEmpty) {
      await QuranDataLoader.loadInitialData();
    }
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  void performSearch() {
    setState(() {
      searchResults = QuranDataLoader.allInstances.where((item) {
        final matchConcept = selectedConceptId == null || item.dominantConcept == selectedConceptId;
        final matchFunction = selectedFunctionId == null || item.rhetoricalFunction == selectedFunctionId;
        final matchValence = selectedValence == null || item.valence == selectedValence;
        return matchConcept && matchFunction && matchValence;
      }).toList();
      showResults = true;
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
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(theme, isDark, isArabic),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: _buildSearchFilters(theme, isDark, isArabic),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    _getStatusText(isArabic),
                    style: TextStyle(
                      fontStyle: FontStyle.italic, 
                      color: isDark ? Colors.grey[400] : Colors.blueGrey[400], 
                      fontSize: 13,
                      fontFamily: 'Kitab'
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            if (showResults) _buildResultsList(theme, isDark, isArabic),
            const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme, bool isDark, bool isArabic) {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      backgroundColor: isDark ? theme.appBarTheme.backgroundColor : const Color(0xFF1F3444),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          isArabic ? 'محرك البحث البلاغي' : 'Rhetorical Search Engine',
          style: const TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold, 
            fontSize: 18,
            fontFamily: 'Kitab'
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark ? [Colors.black54, Colors.black87] : const [Color(0xFF1F3444), Color(0xFF3282B8)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFilters(ThemeData theme, bool isDark, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  isArabic ? 'المفهوم الرئيسي' : 'Main Concept',
                  conceptOptions,
                  selectedConceptId,
                  (val) => setState(() => selectedConceptId = val),
                  theme, isDark, isArabic
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  isArabic ? 'الوظيفة البلاغية' : 'Rhetorical Function',
                  functionOptions,
                  selectedFunctionId,
                  (val) => setState(() => selectedFunctionId = val),
                  theme, isDark, isArabic
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            isArabic ? 'النبرة الشعورية' : 'Emotional Valence',
            valenceOptions,
            selectedValence,
            (val) => setState(() => selectedValence = val),
            theme, isDark, isArabic
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: performSearch,
              icon: const Icon(Icons.search_rounded, color: Colors.white),
              label: Text(isArabic ? 'بحث في الشواهد' : 'Search Matches', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(ThemeData theme, bool isDark, bool isArabic) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = searchResults[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildResultCard(item, theme, isDark, isArabic),
          );
        },
        childCount: searchResults.length,
      ),
    );
  }

  Widget _buildResultCard(QuranInstance item, ThemeData theme, bool isDark, bool isArabic) {
    final valenceColor = _getValenceColor(item.valence);
    final suraName = QuranDataLoader.getSuraName(item.sura);
    final String translatedChildConcept = AmthalTranslator.translate(item.childConcept);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5, 
              decoration: BoxDecoration(
                color: valenceColor, 
                borderRadius: isArabic 
                  ? const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16))
                  : const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16))
              )
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      item.text ?? item['vers_text'] ?? '',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500, height: 1.7, fontFamily: 'Kitab', color: theme.textTheme.bodyLarge?.color),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isArabic ? 'سورة $suraName : آية ${item.aya}' : 'Sura $suraName : Aya ${item.aya}',
                          style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.blueGrey, fontWeight: FontWeight.bold),
                        ),
                        Wrap(
                          spacing: 6,
                          children: [
                            _buildMiniTag(translatedChildConcept, Colors.blue),
                            _buildMiniTag(valenceOptions[item.valence] ?? (isArabic ? 'شحنة' : 'Valence'), valenceColor),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.2))),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Kitab')),
    );
  }

  Widget _buildDropdown(String title, Map<int, String> options, int? selectedValue, Function(int?) onChanged, ThemeData theme, bool isDark, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.grey[400] : Colors.blueGrey, fontFamily: 'Kitab')),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: isDark ? theme.colorScheme.surfaceVariant : const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(10), border: Border.all(color: isDark ? Colors.white12 : Colors.black12)),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<int>(
              value: selectedValue,
              isExpanded: true,
              dropdownColor: theme.cardColor,
              decoration: const InputDecoration(border: InputBorder.none),
              hint: Text(isArabic ? 'الكل' : 'All', style: TextStyle(fontSize: 14, color: theme.textTheme.bodyMedium?.color)),
              items: [
                DropdownMenuItem<int>(value: null, child: Text(isArabic ? 'الكل' : 'All', style: TextStyle(color: theme.textTheme.bodyMedium?.color))),
                ...options.entries.map((e) => DropdownMenuItem<int>(value: e.key, child: Text(e.value, style: TextStyle(fontSize: 13, fontFamily: 'Kitab', color: theme.textTheme.bodyMedium?.color)))),
              ].toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusText(bool isArabic) {
    if (!showResults) return isArabic ? 'ابدأ البحث للعثور على الشواهد البلاغية...' : 'Start search to find rhetorical matches...';
    if (searchResults.isEmpty) return isArabic ? 'لم يتم العثور على نتائج تطابق هذا البحث' : 'No matches found for your search criteria';
    return isArabic ? 'تم العثور على ${searchResults.length} شاهد يطابق بحثك:' : 'Found ${searchResults.length} matches:';
  }

  Color _getValenceColor(int? valence) {
    if (valence == 1) return const Color(0xFF4CAF50);
    if (valence == 2) return const Color(0xFFF44336);
    return Colors.blueGrey;
  }
}
