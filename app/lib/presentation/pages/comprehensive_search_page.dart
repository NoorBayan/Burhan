import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ijaaz_app/presentation/pages/quran_page_viewer.dart';
import 'package:ijaaz_app/application/settings_service.dart';
import 'package:ijaaz_app/l10n/app_localizations.dart';
import 'package:ijaaz_app/data/surah_names_en.dart';
import 'package:ijaaz_app/data/surah_names_ar.dart';
import 'package:ijaaz_app/presentation/pages/simile_details_page.dart';
import 'package:ijaaz_app/presentation/pages/metaphor_details_page.dart';
import 'package:ijaaz_app/data/page_data.dart';

class ComprehensiveSearchPage extends StatefulWidget {
  const ComprehensiveSearchPage({Key? key}) : super(key: key);

  @override
  State<ComprehensiveSearchPage> createState() =>
      _ComprehensiveSearchPageState();
}

class _ComprehensiveSearchPageState extends State<ComprehensiveSearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late TabController _tabController;

  List<dynamic> _allAyahs = [];
  List<dynamic> _allSurahs = [];
  List<dynamic> _allRhetoric = [];
  List<dynamic> _searchResults = [];

  bool _isLoading = false;
  int _currentSearchType = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentSearchType = _tabController.index;
          _searchController.clear();
          _searchResults = [];
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _loadData() async {
    final String response = await rootBundle.loadString('assets/data/quran-uthmani.json');
    final data = json.decode(response);
    final List<dynamic> surahs = data['data']['surahs'];
    _allSurahs = surahs;

    List<dynamic> tempList = [];
    for (var surah in surahs) {
      for (var ayah in surah['ayahs']) {
        tempList.add({
          "surah_name": surah['name'],
          "surah_number": surah['number'],
          "ayah_number": ayah['numberInSurah'],
          "text": ayah['text'],
        });
      }
    }
    _allAyahs = tempList;

    List<dynamic> rhetoricList = [];
    try {
      final similesStr = await rootBundle.loadString('assets/data/similes_data.json');
      final metaphorsStr = await rootBundle.loadString('assets/data/metaphors_data.json');
      final List<dynamic> similes = json.decode(similesStr);
      final List<dynamic> metaphors = json.decode(metaphorsStr);
      for (var item in similes) { rhetoricList.add({...item, 'rhetoric_type': 'تشبيه'}); }
      for (var item in metaphors) { rhetoricList.add({...item, 'rhetoric_type': 'استعارة'}); }
    } catch (e) {
      debugPrint("Error loading rhetoric data: $e");
    }
    setState(() => _allRhetoric = rhetoricList);
  }

  int _findPageForVerse(int surahNum, int ayahNum) {
    for (int i = 0; i < pageData.length; i++) {
      for (var section in pageData[i]) {
        if (section['surah'] == surahNum && ayahNum >= section['start'] && ayahNum <= section['end']) return i + 1;
      }
    }
    return 1;
  }

  String _removeDiacritics(String text) {
    String normalized = text.replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06ED]'), '');
    normalized = normalized.replaceAll('أ', 'ا').replaceAll('إ', 'ا').replaceAll('آ', 'ا').replaceAll('ٱ', 'ا');
    return normalized.trim();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isLoading = true);
    String cleanQuery = _removeDiacritics(query.toLowerCase());
    List<dynamic> results = [];

    if (_currentSearchType == 0) {
      if (query.length >= 2) {
        results = _allAyahs.where((ayah) => _removeDiacritics(ayah['text']).contains(cleanQuery)).toList();
      }
    } else if (_currentSearchType == 1) {
      results = _allSurahs.where((surah) {
        String cleanNameAr = _removeDiacritics(surah['name']);
        String nameEn = surahNamesEnglish[surah['number'] - 1].toLowerCase();
        return cleanNameAr.contains(cleanQuery) || nameEn.contains(cleanQuery);
      }).toList();
    } else if (_currentSearchType == 2) {
      results = _allRhetoric.where((item) {
        final metadata = item['metadata'];
        if (metadata == null) return false;
        String ayahText = _removeDiacritics(metadata['ayah_text_uthmani'] ?? "");
        String type = item['rhetoric_type'] ?? "";
        return ayahText.contains(cleanQuery) || type.contains(cleanQuery);
      }).toList();
    }

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = SettingsService().locale;
    final isEnglish = locale.languageCode == 'en';
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(localizations.search, style: const TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(text: localizations.verses),
            Tab(text: localizations.surahs),
            Tab(text: localizations.rhetoric),
          ],
        ),
      ),
      body: Directionality(
        textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  onChanged: _performSearch,
                  textAlign: isEnglish ? TextAlign.left : TextAlign.right,
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    hintText: localizations.search_hint,
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.clear, size: 20), onPressed: () { _searchController.clear(); _performSearch(''); })
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
                  : _searchResults.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_rounded, size: 80, color: theme.colorScheme.primary.withOpacity(0.1)),
                    const SizedBox(height: 10),
                    Text(_searchController.text.isEmpty
                        ? (isEnglish ? "Search everything..." : "ابحث في كل شيء...")
                        : localizations.no_results,
                        style: TextStyle(color: theme.hintColor, fontSize: 15)),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  if (_currentSearchType == 0) return _buildAyahCard(result, isEnglish, theme, isDark);
                  if (_currentSearchType == 1) return _buildSurahCard(result, isEnglish, theme, isDark);
                  return _buildRhetoricCard(result, isEnglish, theme, isDark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAyahCard(Map<String, dynamic> ayah, bool isEn, ThemeData theme, bool isDark) {
    String surahName = isEn ? surahNamesEnglish[ayah['surah_number'] - 1] : ayah['surah_name'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: () {
          int page = _findPageForVerse(ayah['surah_number'], ayah['ayah_number']);
          Navigator.push(context, MaterialPageRoute(builder: (context) => QuranPageViewer(initialPageNumber: page)));
        },
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: Text("$surahName : ${ayah['ayah_number']}", style: TextStyle(color: theme.colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(ayah['text'], style: const TextStyle(fontFamily: 'UthmanicHafs', fontSize: 18, height: 1.6), textDirection: TextDirection.rtl),
        ),
      ),
    );
  }

  Widget _buildSurahCard(dynamic surah, bool isEn, ThemeData theme, bool isDark) {
    String nameAr = surah['name'];
    String displayName = isEn ? surahNamesEnglish[surah['number'] - 1] : nameAr;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: theme.colorScheme.primary.withOpacity(0.1), child: Text("${surah['number']}", style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 14))),
        title: Text(displayName, style: const TextStyle(fontFamily: 'UthmanicHafs', fontSize: 17, fontWeight: FontWeight.bold)),
        subtitle: Text("${surah['numberOfAyahs']} ${isEn ? "Verses" : "آيات"}", style: TextStyle(color: theme.hintColor, fontSize: 12)),
        trailing: Icon(isEn ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: theme.hintColor.withOpacity(0.5), size: 14),
        onTap: () {
          final startPage = _findPageForVerse(surah['number'], 1);
          Navigator.push(context, MaterialPageRoute(builder: (context) => QuranPageViewer(initialPageNumber: startPage)));
        },
      ),
    );
  }

  Widget _buildRhetoricCard(dynamic item, bool isEn, ThemeData theme, bool isDark) {
    final metadata = item['metadata'];
    if (metadata == null) return const SizedBox.shrink();
    final int chapterNo = metadata['chapter_no'];
    final int verseNo = metadata['verse_no'];
    final String type = item['rhetoric_type'] ?? "";
    String surahName = isEn ? surahNamesEnglish[chapterNo - 1] : surahNamesArabic[chapterNo - 1];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: Text(type, style: TextStyle(color: theme.colorScheme.primary, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            Text('$surahName : $verseNo', style: TextStyle(color: theme.colorScheme.primary.withOpacity(0.8), fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(metadata['ayah_text_uthmani'] ?? '', style: const TextStyle(fontSize: 16, fontFamily: 'UthmanicHafs', height: 1.5), textDirection: TextDirection.rtl),
        ),
        onTap: () {
          if (type == 'تشبيه') Navigator.push(context, MaterialPageRoute(builder: (context) => SimileDetailsPage(chapterNo: chapterNo, verseNo: verseNo)));
          else Navigator.push(context, MaterialPageRoute(builder: (context) => MetaphorDetailsPage(chapterNo: chapterNo, verseNo: verseNo)));
        },
      ),
    );
  }
}
