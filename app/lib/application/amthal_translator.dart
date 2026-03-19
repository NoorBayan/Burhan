import 'package:ijaaz_app/application/settings_service.dart';

class AmthalTranslator {
  static const Map<String, String> _childConceptsAr = {
    "Straight Path": "الصراط المستقيم",
    "Misguidance": "الضلال",
    "Guidance": "الهداية",
    "Growth": "النماء",
    "Blockage": "الحجب",
    "Deception": "الخداع",
    "Corruption": "الفساد",
    "Certainty": "اليقين",
    "Secrecy": "الخفاء",
    "Blindness": "العمى",
    "Plotting": "المكر",
    "Transaction": "المعاملات",
    "Disbelief": "الكفر",
    "Perception": "الإدراك",
    "Punishment": "العذاب",
    "Authority": "السلطان",
    "Smiting": "الصعق",
    "Dwelling": "السكن",
    "Cosmic Creation": "الإبداع الكوني",
    "Fuel": "الوقود",
    "Rivers of Paradise": "أنهار الجنة",
    "Violation": "النقض",
    "Resurrection": "البعث",
    "Killing": "القتل",
    "Hell": "الجحيم",
    "Covering & Garment": "الغطاء واللباس",
    "Concealment": "الكتمان",
    "Heart": "القلب",
    "Destruction": "الهلاك",
    "Scale & Measure": "الميزان والكيل",
    "Sending Down": "الإنزال",
    "Other": "أخرى",
    "Curse": "اللعنة",
    "Might": "العزة",
    "Covenant": "الميثاق",
    "Turning Away": "الإعراض",
    "Revelation": "الوحي",
    "Hardness & Fragility": "الصلابة والهشاشة",
    "Earning": "الكسب",
    "Immersion": "الغوص",
    "Hand": "اليد",
    "Clarity": "التبيان",
    "Reward": "الثواب",
    "Submission": "الخضوع",
    "Following": "الاتباع",
    "Loss": "الخسران",
    "Spiritual Purity": "الطهارة الروحية",
    "Destination": "المصير",
    "Foundation": "الأساس",
    "Term": "الأجل",
    "Appearance & Adornment": "الزينة والمظهر",
    "Hope & Gratitude": "الرجاء والشكر",
    "Completion": "الإتمام",
    "Purity": "الطهارة",
    "Steadfastness": "الثبات",
    "Refuge": "الملاذ",
    "Faith": "الإيمان",
    "Path of God": "سبيل الله",
    "Earth's Revival": "إحياء الأرض",
    "Death of the Earth": "موت الأرض",
    "Cosmic Light": "النور الكوني",
    "Burning": "الاحتراق",
    "Servitude & Dependence": "العبودية والافتقار",
    "Kinship & Lineage": "القرابة والنسب",
    "Terror": "الرعب",
    "Covering": "الستر",
    "Boundaries": "الحدود",
    "Outpouring": "الإفاضة",
    "Containment": "الاحتواء",
    "Fire": "النار",
    "Provision & Enjoyment": "الرزق والمتاع",
    "Paradise": "الجنة",
    "Ransom": "الفدية",
    "Loan": "القرض",
    "Allegiance & Alliance": "الولاء والتحالف",
    "Elevation": "الرفعة",
    "Nullification": "الإبطال",
    "Nullification of Deeds": "إحباط الأعمال",
    "Scheme": "الكيد",
    "Food & Taste": "الطعام والذوق",
    "Creation": "الخلق",
    "Protection": "الحماية",
    "Social Interaction": "التفاعل الاجتماعي",
    "Spirit": "الروح",
    "Experience": "التجربة",
    "Inheritance & Share": "الإرث والنصيب",
    "Fabrication": "الافتراء",
    "Radiance": "الإشراق",
    "Recompense": "الجزاء",
    "Rage": "الغيظ",
    "Consumption": "الاستهلاك",
    "Removal & Alteration": "الإزالة والتبديل",
    "Purification": "التزكية",
    "Spiritual Sickness": "المرض الروحي",
    "Hospitality & Honor": "الضيافة والإكرام",
    "Taking": "الأخذ",
    "Justice & Measure": "العدل والقسط",
    "Injustice": "الظلم",
    "Self-Wronging": "ظلم النفس",
    "Awe": "الخشية",
    "Recompense & Reward": "الثواب والجزاء",
    "Marital Relations": "العلاقات الزوجية",
    "Establishment": "التمكين",
    "Loan & Debt": "القرض والدين",
    "Ordeal": "المحنة",
    "Earning & Deed": "الكسب والعمل",
    "Futility": "العبثية",
    "Night": "الليل",
    "Bestowal & Gifting": "العطاء والهبة",
    "Distress": "الكرب",
    "Mercy": "الرحمة",
    "Grief & Pain": "الحزن والألم",
    "Test": "الابتلاء",
    "Beings & Creatures": "الكائنات والمخلوقات",
    "Affliction": "المصيبة",
    "State & Condition": "الحال والشأن",
    "Avarice": "البخل",
    "Apocalypse": "الأهوال",
    "Deed": "العمل",
    "Time & Permanence": "الزمن والخلود",
    "Agonies": "السكرات",
    "Dissimulation": "النفاق",
    "Exchange & Substitution": "الاستبدال والتعويض",
    "Serenity & Contentment": "السكينة والرضا",
    "Humiliation": "المهانة",
    "Arrogance & Self-sufficiency": "الكبر والاستغناء",
    "Profit": "الربح",
    "Conflict & Enmity": "الصراع والعداوة",
    "Proximity & Distance": "القرب والبعد",
    "Light of Hereafter": "نور الآخرة",
  };

  static String translate(String concept) {
    bool isArabic = SettingsService().locale.languageCode == 'ar';
    if (!isArabic) return concept;
    return _childConceptsAr[concept] ?? concept;
  }

  // ترجمة المفاهيم الكبرى Dominant_Concept
  static Map<int, String> getMainConcepts() {
    bool isArabic = SettingsService().locale.languageCode == 'ar';
    return {
      6: isArabic ? 'الطريق والمنهج' : 'Path and Method',
      1: isArabic ? 'الخداع والمكر' : 'Deception and Plotting',
      2: isArabic ? 'النور والبصيرة' : 'Light and Insight',
      3: isArabic ? 'الظلمات والضلال' : 'Darkness and Misguidance',
      4: isArabic ? 'أحوال القلوب' : 'States of Hearts',
      5: isArabic ? 'الإيمان والكفر' : 'Faith and Disbelief',
      0: isArabic ? 'مفاهيم عامة' : 'General Concepts',
    };
  }

  // ترجمة الوظائف البلاغية Rhetorical_Function
  static Map<int, String> getRhetoricalFunctions() {
    bool isArabic = SettingsService().locale.languageCode == 'ar';
    return {
      1: isArabic ? 'وعد وتبشير' : 'Promise and Glad Tidings',
      2: isArabic ? 'وعيد وتحذير' : 'Warning and Threat',
      3: isArabic ? 'حجاج وإقناع' : 'Argumentation and Persuasion',
      4: isArabic ? 'تشريع وأحكام' : 'Legislation and Rulings',
    };
  }

  // ترجمة الشحنات الشعورية Valence
  static Map<int, String> getEmotionalValence() {
    bool isArabic = SettingsService().locale.languageCode == 'ar';
    return {
      1: isArabic ? 'نبرة إيجابية' : 'Positive Tone',
      2: isArabic ? 'نبرة تحذيرية' : 'Warning Tone',
      3: isArabic ? 'نبرة محايدة' : 'Neutral Tone',
    };
  }
}


