class QuranPageData {
  final List<Map<String, dynamic>> items;
  final String surahName;
  final String juzNumber;

  QuranPageData({
    required this.items,
    required this.surahName,
    required this.juzNumber,
  });
}

class TafsirItem {
  final int verseNum;
  final String quranText;
  final String tafsirText;
  final int surahNum;
  final String surahName;

  TafsirItem({
    required this.verseNum,
    required this.quranText,
    required this.tafsirText,
    required this.surahNum,
    required this.surahName,
  });
}
