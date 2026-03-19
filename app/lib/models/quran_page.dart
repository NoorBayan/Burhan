import 'package:flutter/material.dart';

// Represents a single verse on a page
class PageVerse {
  final String text;
  final int surahNumber;
  final int verseNumber;
  final String surahName;

  PageVerse({
    required this.text,
    required this.surahNumber,
    required this.verseNumber,
    required this.surahName,
  });
}

// Represents a single page of the Quran
class QuranPage {
  final int pageNumber;
  final int juzNumber;
  final List<PageVerse> verses;

  // To get the name of the first surah on the page for the header
  String get firstSurahName => verses.isNotEmpty ? verses.first.surahName : '';

  QuranPage({
    required this.pageNumber,
    required this.juzNumber,
    required this.verses,
  });
}
