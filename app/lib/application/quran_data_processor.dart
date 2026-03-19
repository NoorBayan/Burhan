import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ijaaz_app/models/quran_page.dart';

class QuranDataProcessor {
  // A static method to load, process, and return all Quran pages.
  static Future<List<QuranPage>> loadAndProcessPages() async {
    try {
      // 1. Load the raw JSON data
      final String response = await rootBundle.loadString('assets/data/quran-uthmani.json');
      final data = json.decode(response);

      final List<dynamic> surahs = data['data']['surahs'];
      final Map<int, List<PageVerse>> pageVersesMap = {};
      final Map<int, int> pageJuzMap = {};

      // 2. Iterate through all surahs and ayahs to group verses by page number
      for (var surah in surahs) {
        for (var verse in surah['ayahs']) {
          final int pageNum = verse['page'];
          final int juzNum = verse['juz'];

          // Create the verse object
          final pageVerse = PageVerse(
            text: verse['text'],
            surahNumber: surah['number'],
            verseNumber: verse['numberInSurah'],
            surahName: surah['name'],
          );

          // Group verses into a map where the key is the page number
          if (pageVersesMap.containsKey(pageNum)) {
            pageVersesMap[pageNum]!.add(pageVerse);
          } else {
            pageVersesMap[pageNum] = [pageVerse];
          }

          // Store the juz number for each page
          pageJuzMap.putIfAbsent(pageNum, () => juzNum);
        }
      }

      // 3. Convert the map into a sorted list of QuranPage objects
      final List<QuranPage> quranPages = [];
      final sortedPageKeys = pageVersesMap.keys.toList()..sort();

      for (var pageNum in sortedPageKeys) {
        quranPages.add(
          QuranPage(
            pageNumber: pageNum,
            juzNumber: pageJuzMap[pageNum]!,
            verses: pageVersesMap[pageNum]!,
          ),
        );
      }

      return quranPages;
    } catch (e) {
      print("Error processing Quran data: $e");
      // Return an empty list in case of an error
      return [];
    }
  }
}
