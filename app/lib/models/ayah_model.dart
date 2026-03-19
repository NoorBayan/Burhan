import 'dart:convert';

class Ayah {
  final int? instanceId;
  final int suraNo;
  final int ayaNo;
  final String verseText;
  final String? coreConceptPair; // مثل "نور/علم"
  final String? targetConcept;   // الهدف البلاغي (تشبيه، استعارة...)
  final String? emotionalCharge; // الشحنة العاطفية (إيجابي، سلبي)
  final dynamic dominantConcept; // الكود الرقمي للمفهوم

  Ayah({
    this.instanceId,
    required this.suraNo,
    required this.ayaNo,
    required this.verseText,
    this.coreConceptPair,
    this.targetConcept,
    this.emotionalCharge,
    this.dominantConcept,
  });

  // محول البيانات الذكي ليتوافق مع مختلف تسميات الجيسون
  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      instanceId: json['Instance_ID'] ?? json['id'],
      suraNo: json['Sura_No'] ?? 0,
      ayaNo: json['Aya_No'] ?? 0,
      // التأكد من جلب نص الآية سواء كان المفتاح Verse_Text أو vers_text
      verseText: json['Verse_Text'] ?? json['vers_text'] ?? '',
      coreConceptPair: json['Core_Concept_Pair'],
      targetConcept: json['Target_Concept'],
      emotionalCharge: json['Emotional_Charge'],
      dominantConcept: json['dominantConcept'] ?? json['Dominant_Concept'],
    );
  }

  // دالة مساعدة لتحويل الأرقام إلى أرقام عربية (للزخرفة)
  String get ayaNoArabic {
    const en = ['0','1','2','3','4','5','6','7','8','9'];
    const ar = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    String res = ayaNo.toString();
    for(int i=0; i<10; i++) res = res.replaceAll(en[i], ar[i]);
    return res;
  }
}

// موديل علاقات المفاهيم (المستخدم في الخريطة والرسوم البيانية)
class ConceptRelation {
  final int sourceCode;
  final String conceptName;
  final String? description;
  final List<String> relationsNames;
  final int count;

  ConceptRelation({
    required this.sourceCode,
    required this.conceptName,
    this.description,
    required this.relationsNames,
    required this.count,
  });

  factory ConceptRelation.fromJson(Map<String, dynamic> json) {
    return ConceptRelation(
      sourceCode: json['source_code'] ?? 0,
      conceptName: json['concept_name'] ?? 'مجهول',
      description: json['description'],
      relationsNames: List<String>.from(json['relations_names'] ?? []),
      count: json['count'] ?? 0,
    );
  }
}
