import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ijaaz_app/presentation/pages/quran_page_viewer.dart';
import 'package:ijaaz_app/application/settings_service.dart';
import 'package:ijaaz_app/data/surah_names_en.dart';
import 'package:ijaaz_app/l10n/app_localizations.dart'; 
import 'package:ijaaz_app/data/meta_data_surah.dart';

class SurahListPage extends StatefulWidget {
  final VoidCallback? onSurahOpened;
  const SurahListPage({Key? key, this.onSurahOpened}) : super(key: key);

  @override
  State<SurahListPage> createState() => _SurahListPageState();
}

class _SurahListPageState extends State<SurahListPage> {
  List<dynamic> _allSurahs = [];
  List<dynamic> _filteredSurahs = [];
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadAndCombineData();
  }

  Future<void> _saveLastRead(int surahNumber, String surahName, int pageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_surah_number', surahNumber);
    await prefs.setString('last_surah_name', surahName);
    await prefs.setInt('last_page_number', pageNumber);
    if (widget.onSurahOpened != null) {
      widget.onSurahOpened!();
    }
  }

  String _removeDiacritics(String text) {
    const diacritics = 'ًٌٍَُِّْـ';
    for (int i = 0; i < diacritics.length; i++) {
      text = text.replaceAll(diacritics[i], '');
    }
    return text.replaceAll('أ', 'ا').replaceAll('إ', 'ا').replaceAll('آ', 'ا').trim();
  }

  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allSurahs;
    } else {
      String cleanKeyword = _removeDiacritics(enteredKeyword.toLowerCase());
      results = _allSurahs.where((surah) {
        String cleanNameAr = _removeDiacritics(surah['name'].toString());
        String nameEn = surahNamesEnglish[surah['number'] - 1].toLowerCase();
        return cleanNameAr.contains(cleanKeyword) || nameEn.contains(cleanKeyword);
      }).toList();
    }
    setState(() {
      _filteredSurahs = results;
    });
  }

  Future<void> _loadAndCombineData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/quran-uthmani.json');
      final jsonData = await json.decode(response);
      final List<dynamic> jsonSurahs = jsonData['data']['surahs'];
      List<dynamic> tempList = [];

      for (int i = 0; i < jsonSurahs.length; i++) {
        var jsonSurah = jsonSurahs[i];
        int surahNumber = jsonSurah['number'];

        var metaInfo = metaDataSurah[surahNumber.toString()];
        String place = metaInfo != null ? (metaInfo['rp'] ?? 'makkah') : 'makkah';
        
        int startPage = 1;
        if (metaInfo != null && metaInfo.containsKey('pr')) {
          String pr = metaInfo['pr'];
          startPage = int.parse(pr.split('-')[0]);
        }

        Map<String, dynamic> combinedSurah = Map.from(jsonSurah);
        combinedSurah['place'] = place;
        combinedSurah['start_page'] = startPage;

        tempList.add(combinedSurah);
      }

      if (mounted) {
        setState(() {
          _allSurahs = tempList;
          _filteredSurahs = tempList;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: SettingsService(),
      builder: (context, child) {
        final locale = SettingsService().locale;
        final isEnglish = locale.languageCode == 'en';

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Directionality(
            textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
                : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => _runFilter(value),
                      textAlign: isEnglish ? TextAlign.left : TextAlign.right,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        hintText: isEnglish ? "Search Surah..." : "بحث عن سورة...",
                        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredSurahs.isEmpty
                      ? Center(child: Text(isEnglish ? "No results" : "لا توجد نتائج", style: const TextStyle(color: Colors.grey)))
                      : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: _filteredSurahs.length,
                        itemBuilder: (context, index) {
                          final surah = _filteredSurahs[index];
                          final int number = surah['number'];
                          final String nameAr = surah['name'];
                          final String displayName = isEnglish ? surahNamesEnglish[number - 1] : nameAr;
                          final int versesCount = surah['ayahs'].length;
                          final String place = surah['place'].toString().toLowerCase();
                          final bool isMakkah = place == 'makkah';
                          final int startPage = surah['start_page'];
                          
                          String revelationPlace = isEnglish 
                              ? (isMakkah ? "Meccan" : "Medinan")
                              : (isMakkah ? "مكية" : "مدنية");

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: isDark ? theme.colorScheme.surface : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              onTap: () async {
                                await _saveLastRead(number, displayName, startPage);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuranPageViewer(initialPageNumber: startPage),
                                  ),
                                ).then((value) {
                                  if (widget.onSurahOpened != null) widget.onSurahOpened!();
                                });
                              },
                              leading: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    "$number",
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'UthmanicHafs',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    displayName,
                                    style: TextStyle(
                                      color: theme.textTheme.bodyLarge?.color,
                                      fontFamily: 'UthmanicHafs',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Image.asset(
                                    isMakkah ? 'assets/images/kaaba.png' : 'assets/images/masjid-al-nabawi.png',
                                    width: 18,
                                    height: 18,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(isMakkah ? Icons.location_city : Icons.mosque, color: Colors.grey, size: 16),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  "$versesCount ${isEnglish ? "Verses" : "آيات"} • $revelationPlace • ${isEnglish ? "Page" : "صفحة"} $startPage",
                                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                                ),
                              ),
                              trailing: Icon(
                                isEnglish ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new, 
                                size: 14, 
                                color: Colors.grey[400]
                              ),
                            ),
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
