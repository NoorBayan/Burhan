import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:ijaaz_app/application/data_loader.dart';

class QuranDataService {
  static final QuranDataService _instance = QuranDataService._internal();
  factory QuranDataService() => _instance;
  QuranDataService._internal();

  Map<int, dynamic> surahsMap = {};
  Map<String, bool> simileVerses = {};
  Map<String, bool> metaphorVerses = {};
  bool isInitialized = false;

  Future<void> init() async {
    if (isInitialized) return;
    try {
      await QuranDataLoader.loadInitialData();
      surahsMap = QuranDataLoader.surahsMap;
      await _loadBalaqahData();
      isInitialized = true;
    } catch (e) {
      debugPrint("Error in QuranDataService init: $e");
    }
  }

  Future<void> _loadBalaqahData() async {
    try {
      final String simileString = await rootBundle.loadString('assets/data/similes_data.json');
      final List simileData = await compute(_decodeJsonList, simileString);
      for (var item in simileData) {
        if (item is Map && item['metadata'] is Map) {
          final meta = item['metadata'];
          if (meta['chapter_no'] != null && meta['verse_no'] != null) {
            simileVerses["${meta['chapter_no']}:${meta['verse_no']}"] = true;
          }
        }
      }
      final String metaphorString = await rootBundle.loadString('assets/data/metaphors_data.json');
      final List metaphorData = await compute(_decodeJsonList, metaphorString);
      for (var item in metaphorData) {
        if (item is Map && item['metadata'] is Map) {
          final meta = item['metadata'];
          if (meta['chapter_no'] != null && meta['verse_no'] != null) {
            metaphorVerses["${meta['chapter_no']}:${meta['verse_no']}"] = true;
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading balaqah data: $e");
    }
  }

  static List<dynamic> _decodeJsonList(String jsonString) => json.decode(jsonString);

  String? getVerseText(int sura, int aya) => QuranDataLoader.uthmaniTextMap["$sura:$aya"];
  bool isSimile(int sura, int aya) => simileVerses.containsKey("$sura:$aya");
  bool isMetaphor(int sura, int aya) => metaphorVerses.containsKey("$sura:$aya");
}
