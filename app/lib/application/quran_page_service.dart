import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:ijaaz_app/application/quran_data_service.dart';
import 'package:ijaaz_app/models/quran_page_models.dart';
import 'package:ijaaz_app/data/page_data.dart';
import 'package:ijaaz_app/data/meta_data_juz.dart';
import 'package:ijaaz_app/application/tajweed.dart';
import 'package:ijaaz_app/models/tajweed_token.dart';

Map<String, List<TajweedToken>> computeTajweedBatch(List<Map<String, dynamic>> verses) {
  final Map<String, List<TajweedToken>> results = {};
  for (var v in verses) {
    if (v['type'] == 'verse') {
      results["${v['surahNum']}:${v['verseNum']}"] = Tajweed.tokenize(v['text'], v['surahNum'], v['verseNum']);
    }
  }
  return results;
}

class QuranPageService {
  static final Map<String, List<TajweedToken>> globalTajweedCache = {};

  Future<QuranPageData> loadPageData(int pageNumber) async {
    final quranService = QuranDataService();
    if (!quranService.isInitialized) await quranService.init();

    final pageInfo = pageData[pageNumber - 1];
    List<Map<String, dynamic>> items = [];
    List<String> pageSurahNames = [];
    String juzNum = getJuzNumberFromMetaData(pageNumber);
    const basmalaText = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ";

    for (var section in pageInfo) {
      var surahData = quranService.surahsMap[section['surah']];
      if (surahData == null) continue;

      String sName = surahData['name'];
      if (!pageSurahNames.contains(sName)) pageSurahNames.add(sName);

      if (section['start'] == 1) {
        items.add({
          'type': 'header',
          'text': surahData['name'],
          'surahNumber': surahData['number'],
          'ayahsCount': (surahData['ayahs'] as List).length
        });
        if (section['surah'] != 1 && section['surah'] != 9) {
          items.add({'type': 'basmala', 'text': basmalaText});
        }
      }

      for (int v = section['start']; v <= section['end']; v++) {
        var ayah = (surahData['ayahs'] as List).firstWhere((a) => a['numberInSurah'] == v);
        String text = ayah['text'];
        if (v == 1 && section['surah'] != 1) {
          final basRegex = RegExp(r'^بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ|^بِسْمِ [^ ]+ [^ ]+ [^ ]+');
          text = text.replaceFirst(basRegex, '').trim();
        }
        text = text.replaceAll(RegExp(r'[\u06DF\u06E0\u06E1]'), '').replaceAll(RegExp(r'[\u06dd\u0660-\u0669\s]+$'), '').trim();
        items.add({
          'type': 'verse',
          'text': text,
          'verseNum': v,
          'surahNum': section['surah'],
          'surahName': surahData['name']
        });
      }
    }

    final versesToProcess = items.where((it) => it['type'] == 'verse' && !globalTajweedCache.containsKey("${it['surahNum']}:${it['verseNum']}")).toList();
    if (versesToProcess.isNotEmpty) {
      final results = await compute(computeTajweedBatch, versesToProcess);
      globalTajweedCache.addAll(results);
    }

    return QuranPageData(
      items: items,
      surahName: pageSurahNames.join(" - "),
      juzNumber: juzNum,
    );
  }

  String getJuzNumberFromMetaData(int pageNum) {
    for (var entry in metaDataJuz.entries) {
      final value = entry.value;
      int start = findPage(int.parse(value['fvk'].split(':')[0]), int.parse(value['fvk'].split(':')[1]));
      int end = findPage(int.parse(value['lvk'].split(':')[0]), int.parse(value['lvk'].split(':')[1]));
      if (pageNum >= start && pageNum <= end) return value['jn'].toString();
    }
    return ((pageNum + 19) ~/ 20).toString();
  }

  int findPage(int s, int a) {
    for (int i = 0; i < pageData.length; i++) {
      for (var sec in pageData[i]) {
        if (sec['surah'] == s && a >= sec['start'] && a <= sec['end']) return i + 1;
      }
    }
    return 1;
  }

  Future<List<TafsirItem>> loadTafsirContent(Map<String, dynamic> ayah, Map<String, String> provider) async {
    List<TafsirItem> surahAyahs = [];
    final quranService = QuranDataService();

    try {
      final String response = await rootBundle.loadString('assets/data/tafsir/${provider['id']}/${ayah['surahNum']}.json');
      final data = json.decode(response);
      final List tafsirList = data['ayahs'];
      final List quranList = quranService.surahsMap[ayah['surahNum']]['ayahs'];

      for (int i = 0; i < quranList.length; i++) {
        int vNum = quranList[i]['numberInSurah'];
        var t = tafsirList.firstWhere((e) => e['ayah'] == vNum, orElse: () => null);
        surahAyahs.add(TafsirItem(
          verseNum: vNum,
          quranText: quranList[i]['text'],
          tafsirText: t != null ? t['text'] : "تفسير غير متوفر",
          surahNum: ayah['surahNum'],
          surahName: ayah['surahName'],
        ));
      }
    } catch (e) {
      return [];
    }
    return surahAyahs;
  }
}
