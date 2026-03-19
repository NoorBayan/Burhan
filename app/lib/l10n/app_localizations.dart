import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('en'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'appTitle': 'إعجاز',
      'home': 'الرئيسية',
      'search': 'بحث',
      'bookmarks': 'المفضلة',
      'settings': 'الإعدادات',
      'juz': 'الأجزاء',
      'surahs': 'السور',
      'notes': 'الملاحظات',
      'rhetoric': 'البلاغة',
      'last_read': 'آخر ما قرأت',
      'continue_reading': 'متابعة القراءة',
      'theme': 'المظهر',
      'system': 'النظام',
      'light': 'فاتح',
      'dark': 'داكن',
      'reading_settings': 'إعدادات القراءة',
      'font_size': 'حجم الخط',
      'preview_text': 'معاينة النص',
      'basmala': 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
      'language': 'اللغة',
      'arabic': 'العربية',
      'english': 'English',
      'part': 'الجزء',
      'verse': 'آية',
      'verses': 'الآيات',
      'no_results': 'لا توجد نتائج',
      'search_hint': 'ابحث هنا...',
      'bookmarks_page_title': 'المفضلة',
      'notes_page_title': 'الملاحظات',
      'sunburst_map': 'الخريطة الشمسية للمفاهيم',
      'rhetoric_atlas': 'أطلس المفاهيم البلاغية',
      'style_analyzer': 'محلل الأسلوب البلاغي',
      'concept_graph': 'شبكة العلاقات المفهومية',
      'dashboard': 'لوحة التحكم والاستكشاف',
      'rhetoric_science': 'علم البيان',
      'simile': 'التشبيه',
      'metaphor': 'الاستعارة',
      'exploration_tools': 'أدوات الاستكشاف',
      'tajweed_prolonging': 'المدود',
      'tajweed_ghunna': 'الغنة',
      'tajweed_tafkhim': 'التفخيم',
      'tajweed_qalqala': 'القلقلة',
      'tajweed_tarqiq': 'الترقيق'
    },
    'en': {
      'appTitle': 'Ijaaz',
      'home': 'Home',
      'search': 'Search',
      'bookmarks': 'Bookmarks',
      'settings': 'Settings',
      'juz': 'Juz',
      'surahs': 'Surahs',
      'notes': 'Notes',
      'rhetoric': 'Rhetoric',
      'last_read': 'Last Read',
      'continue_reading': 'Continue Reading',
      'theme': 'Theme',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'reading_settings': 'Reading Settings',
      'font_size': 'Font Size',
      'preview_text': 'Preview Text',
      'basmala': 'In the name of Allah',
      'language': 'Language',
      'arabic': 'العربية',
      'english': 'English',
      'part': 'Part',
      'verse': 'Verse',
      'verses': 'Verses',
      'no_results': 'No Results',
      'search_hint': 'Search here...',
      'bookmarks_page_title': 'Bookmarks',
      'notes_page_title': 'Notes',
      'sunburst_map': 'Sunburst Map',
      'rhetoric_atlas': 'Rhetoric Atlas',
      'style_analyzer': 'Style Analyzer',
      'concept_graph': 'Concept Graph',
      'dashboard': 'Dashboard',
      'rhetoric_science': 'Rhetoric Science',
      'simile': 'Simile',
      'metaphor': 'Metaphor',
      'exploration_tools': 'Exploration Tools',
      'tajweed_prolonging': 'Prolonging',
      'tajweed_ghunna': 'Ghunna',
      'tajweed_tafkhim': 'Tafkhim',
      'tajweed_qalqala': 'Qalqala',
      'tajweed_tarqiq': 'Tarqiq'
    }
  };

  String _t(String key) => _localizedValues[locale.languageCode]?[key] ?? key;

  String get appTitle => _t('appTitle');
  String get home => _t('home');
  String get search => _t('search');
  String get bookmarks => _t('bookmarks');
  String get settings => _t('settings');
  String get juz => _t('juz');
  String get surahs => _t('surahs');
  String get notes => _t('notes');
  String get rhetoric => _t('rhetoric');
  String get last_read => _t('last_read');
  String get continue_reading => _t('continue_reading');
  String get theme => _t('theme');
  String get system => _t('system');
  String get light => _t('light');
  String get dark => _t('dark');
  String get reading_settings => _t('reading_settings');
  String get font_size => _t('font_size');
  String get preview_text => _t('preview_text');
  String get basmala => _t('basmala');
  String get language => _t('language');
  String get arabic => _t('arabic');
  String get english => _t('english');
  String get part => _t('part');
  String get verse => _t('verse');
  String get verses => _t('verses');
  String get no_results => _t('no_results');
  String get search_hint => _t('search_hint');
  String get bookmarks_page_title => _t('bookmarks_page_title');
  String get notes_page_title => _t('notes_page_title');
  String get sunburst_map => _t('sunburst_map');
  String get rhetoric_atlas => _t('rhetoric_atlas');
  String get style_analyzer => _t('style_analyzer');
  String get concept_graph => _t('concept_graph');
  String get dashboard => _t('dashboard');
  String get rhetoric_science => _t('rhetoric_science');
  String get simile => _t('simile');
  String get metaphor => _t('metaphor');
  String get exploration_tools => _t('exploration_tools');
  String get tajweed_prolonging => _t('tajweed_prolonging');
  String get tajweed_ghunna => _t('tajweed_ghunna');
  String get tajweed_tafkhim => _t('tajweed_tafkhim');
  String get tajweed_qalqala => _t('tajweed_qalqala');
  String get tajweed_tarqiq => _t('tajweed_tarqiq');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
