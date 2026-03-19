import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ijaaz_app/application/settings_service.dart';
import 'package:ijaaz_app/l10n/app_localizations.dart'; 
import 'package:ijaaz_app/data/surah_names_en.dart';
import 'package:ijaaz_app/data/surah_names_ar.dart';
import 'package:ijaaz_app/data/meta_data_juz.dart';
import 'package:ijaaz_app/data/page_data.dart';
import 'quran_page_viewer.dart';

class JuzListPage extends StatefulWidget {
  final VoidCallback? onJuzOpened;
  const JuzListPage({Key? key, this.onJuzOpened}) : super(key: key);

  @override
  State<JuzListPage> createState() => _JuzListPageState();
}

class _JuzListPageState extends State<JuzListPage> {
  List<Map<String, dynamic>> _processedJuzData = [];

  @override
  void initState() {
    super.initState();
    _processJuzData();
  }

  Future<void> _saveLastRead(int surahNumber, String surahName, int pageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_surah_number', surahNumber);
    await prefs.setString('last_surah_name', surahName);
    await prefs.setInt('last_page_number', pageNumber);

    if (widget.onJuzOpened != null) {
      widget.onJuzOpened!();
    }
  }

  void _processJuzData() {
    List<Map<String, dynamic>> tempList = [];
    var sortedKeys = metaDataJuz.keys.toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    for (var key in sortedKeys) {
      final value = metaDataJuz[key]!;
      final String firstVerseKey = value['fvk'];
      final parts = firstVerseKey.split(':');
      final int surahNum = int.parse(parts[0]);
      final int ayahNum = int.parse(parts[1]);

      final int startPage = _findPageForVerse(surahNum, ayahNum);

      tempList.add({
        'surahNum': surahNum,
        'ayahNum': ayahNum,
        'startPage': startPage,
        'juzNumber': value['jn']
      });
    }

    setState(() {
      _processedJuzData = tempList;
    });
  }

  int _findPageForVerse(int surahNum, int ayahNum) {
    for (int i = 0; i < pageData.length; i++) {
      var sectionsInPage = pageData[i];
      for (var section in sectionsInPage) {
        if (section['surah'] == surahNum &&
            ayahNum >= section['start'] &&
            ayahNum <= section['end']) {
          return i + 1;
        }
      }
    }
    return 1;
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
          final localizations = AppLocalizations.of(context)!;

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: _processedJuzData.isEmpty
                  ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                itemCount: _processedJuzData.length,
                itemBuilder: (context, index) {
                  final item = _processedJuzData[index];
                  final surahNum = item['surahNum'] as int;
                  final ayahNum = item['ayahNum'] as int;

                  String surahName;
                  if (isEnglish) {
                    surahName = surahNamesEnglish[surahNum - 1];
                  } else {
                    String rawName = surahNamesArabic[surahNum - 1];
                    surahName = rawName.startsWith('سورة') ? rawName : 'سورة $rawName';
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark ? theme.colorScheme.surface : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      onTap: () async {
                        await _saveLastRead(surahNum, surahName, item['startPage']);
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuranPageViewer(
                              initialPageNumber: item['startPage'],
                            ),
                          ),
                        ).then((value) {
                          if (widget.onJuzOpened != null) widget.onJuzOpened!();
                        });
                      },
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withOpacity(0.7),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            item['juzNumber'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        '${localizations.part} ${item['juzNumber']}',
                        style: TextStyle(
                          color: theme.textTheme.bodyLarge?.color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'UthmanicHafs',
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(Icons.menu_book, size: 12, color: theme.colorScheme.primary.withOpacity(0.7)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                isEnglish
                                    ? 'Starts from $surahName - Verse $ayahNum'
                                    : 'بداية من $surahName - آية $ayahNum',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
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
          );
        }
    );
  }
}
