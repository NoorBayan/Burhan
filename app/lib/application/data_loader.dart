import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:ijaaz_app/application/amthal_translator.dart';

/// نماذج بيانات لتحسين الأداء والوصول للبيانات
class QuranInstance {
  final int sura;
  final int aya;
  final String? text;
  final int dominantConcept;
  final String rawChildConcept;
  
  String get childConcept => AmthalTranslator.translate(rawChildConcept);
  final int instanceId;
  final int rhetoricalFunction;
  final int valence;
  final Map<String, dynamic> rawData;

  QuranInstance({
    required this.sura,
    required this.aya,
    this.text,
    required this.dominantConcept,
    required this.rawChildConcept,
    required this.instanceId,
    required this.rhetoricalFunction,
    required this.valence,
    required this.rawData,
  });

  /// مشغل الوصول بالمفاتيح (operator []) لدعم الكود القديم الذي يعامل الكائن كـ Map
  dynamic operator [](String key) {
    switch (key) {
      case 'Sura_No': return sura;
      case 'Aya_No': return aya;
      case 'Dominant_Concept': return dominantConcept;
      case 'Child_Concept': return childConcept;
      case 'Instance_ID': return instanceId;
      case 'Rhetorical_Function': return rhetoricalFunction;
      case 'Valence': return valence;
      case 'Verse_Text': return text;
      default: return rawData[key];
    }
  }
  
  /// خاصية للتوافق مع التحققات القديمة مثل .isNotEmpty
  bool get isNotEmpty => true;

  /// كائن فارغ لاستخدامه كقيمة افتراضية عند فشل البحث
  factory QuranInstance.empty() => QuranInstance(
    sura: 0, 
    aya: 0, 
    dominantConcept: 0, 
    rawChildConcept: '', 
    instanceId: -1, 
    rhetoricalFunction: 0, 
    valence: 0, 
    rawData: {}
  );

  bool get isEmpty => instanceId == -1;
}

class QuranDataLoader {
  static List<QuranInstance> allInstances = [];
  static List<dynamic> allRelations = [];
  static Map<int, String> surahNames = {};
  static Map<String, String> uthmaniTextMap = {};
  static Map<int, dynamic> surahsMap = {}; // مضاف لدعم الوصول للبيانات الكاملة
  
  static bool _isLoaded = false;

  static Future<void> loadInitialData() async {
    if (_isLoaded) return;

    try {
      debugPrint("🚀 بدء تحميل البيانات في الخلفية...");

      // تحميل النصوص العثمانية والسور
      final String uthmaniRes = await rootBundle.loadString('assets/data/quran-uthmani.json');
      final uthmaniData = await compute(_parseUthmaniData, uthmaniRes);
      surahNames = uthmaniData.surahNames;
      uthmaniTextMap = uthmaniData.textMap;
      surahsMap = uthmaniData.fullSurahs;

      // تحميل العلاقات - استخدام دالة وسيطة لتجنب تعارض توقيع json.decode مع compute
      final String relationsRes = await rootBundle.loadString('assets/data/Amthal-main/data/processed/relations.json');
      allRelations = await compute(_decodeJsonList, relationsRes);

      // تحميل الشواهد ومعالجتها
      final String instancesRes = await rootBundle.loadString('assets/data/Amthal-main/data/processed/instances.json');
      allInstances = await compute(_parseInstances, {
        'json': instancesRes,
        'textMap': uthmaniTextMap,
      });

      _isLoaded = true;
      debugPrint("✅ تم تحميل البيانات بنجاح: ${allInstances.length} شاهد، ${surahNames.length} سورة.");
    } catch (e) {
      debugPrint("❌ خطأ فادح أثناء تحميل البيانات: $e");
    }
  }

  /// دالة وسيطة لفك تشفير JSON لتجنب مشاكل التوقيع مع compute
  static List<dynamic> _decodeJsonList(String jsonString) {
    return json.decode(jsonString) as List<dynamic>;
  }

  static _UthmaniResult _parseUthmaniData(String jsonString) {
    final Map<String, dynamic> root = json.decode(jsonString);
    final Map<int, String> sNames = {};
    final Map<String, String> tMap = {};
    final Map<int, dynamic> fMap = {};

    dynamic surasSource = root['data']?['surahs'] ?? root['quran']?['sura'] ?? root['suras'] ?? root['sura'];

    if (surasSource is List) {
      for (var s in surasSource) {
        int sNum = int.tryParse(s['number']?.toString() ?? s['index']?.toString() ?? '0') ?? 0;
        if (sNum > 0) {
          String sName = s['name'] ?? s['name_arabic'] ?? 'سورة $sNum';
          sNames[sNum] = sName;
          
          List<Map<String, dynamic>> normalizedAyahs = [];
          dynamic ayasSource = s['ayahs'] ?? s['aya'] ?? s['verses'];
          if (ayasSource is List) {
            for (var a in ayasSource) {
              int aNum = int.tryParse(a['numberInSurah']?.toString() ?? a['number']?.toString() ?? a['index']?.toString() ?? '0') ?? 0;
              if (aNum > 0 && a['text'] != null) {
                tMap["$sNum:$aNum"] = a['text'];
                normalizedAyahs.add({
                  'numberInSurah': aNum,
                  'text': a['text'],
                });
              }
            }
          }
          
          fMap[sNum] = {
            'number': sNum,
            'name': sName,
            'ayahs': normalizedAyahs,
          };
        }
      }
    }
    return _UthmaniResult(sNames, tMap, fMap);
  }

  static List<QuranInstance> _parseInstances(Map<String, dynamic> params) {
    final List<dynamic> raw = json.decode(params['json']);
    final Map<String, String> tMap = params['textMap'];
    
    return raw.map((inst) {
      int s = inst['Sura_No'] ?? 0;
      int a = inst['Aya_No'] ?? 0;
      return QuranInstance(
        sura: s,
        aya: a,
        text: tMap["$s:$a"],
        dominantConcept: inst['Dominant_Concept'] ?? 0,
        rawChildConcept: inst['Child_Concept'] ?? 'Other',
        instanceId: inst['Instance_ID'] ?? 0,
        rhetoricalFunction: inst['Rhetorical_Function'] ?? 0,
        valence: inst['Valence'] ?? 0,
        rawData: inst is Map<String, dynamic> ? inst : Map<String, dynamic>.from(inst),
      );
    }).toList();
  }

  static String getSuraName(int number) => surahNames[number] ?? "سورة $number";
}

class _UthmaniResult {
  final Map<int, String> surahNames;
  final Map<String, String> textMap;
  final Map<int, dynamic> fullSurahs;
  _UthmaniResult(this.surahNames, this.textMap, this.fullSurahs);
}
