import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعجاز'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @bookmarks.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get bookmarks;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @rhetoric.
  ///
  /// In ar, this message translates to:
  /// **'البلاغة'**
  String get rhetoric;

  /// No description provided for @last_read.
  ///
  /// In ar, this message translates to:
  /// **'آخر ما قرأت'**
  String get last_read;

  /// No description provided for @continue_reading.
  ///
  /// In ar, this message translates to:
  /// **'متابعة من صفحة'**
  String get continue_reading;

  /// No description provided for @theme.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get dark;

  /// No description provided for @font_size.
  ///
  /// In ar, this message translates to:
  /// **'حجم الخط'**
  String get font_size;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @search_hint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن سورة، آية، أو صورة بلاغية...'**
  String get search_hint;

  /// No description provided for @concept_straight_path.
  ///
  /// In ar, this message translates to:
  /// **'الصراط المستقيم'**
  String get concept_straight_path;

  /// No description provided for @concept_deception.
  ///
  /// In ar, this message translates to:
  /// **'الخداع والوسوسة'**
  String get concept_deception;

  /// No description provided for @concept_light.
  ///
  /// In ar, this message translates to:
  /// **'النور والهدى'**
  String get concept_light;

  /// No description provided for @concept_darkness.
  ///
  /// In ar, this message translates to:
  /// **'الظلمات والضلال'**
  String get concept_darkness;

  /// No description provided for @concept_guidance.
  ///
  /// In ar, this message translates to:
  /// **'الهداية'**
  String get concept_guidance;

  /// No description provided for @concept_belief.
  ///
  /// In ar, this message translates to:
  /// **'الإيمان'**
  String get concept_belief;

  /// No description provided for @concept_disbelief.
  ///
  /// In ar, this message translates to:
  /// **'الكفر والضلال'**
  String get concept_disbelief;

  /// No description provided for @concept_heart.
  ///
  /// In ar, this message translates to:
  /// **'القلب والفؤاد'**
  String get concept_heart;

  /// No description provided for @concept_path.
  ///
  /// In ar, this message translates to:
  /// **'السبيل والطريق'**
  String get concept_path;

  /// No description provided for @concept_knowledge.
  ///
  /// In ar, this message translates to:
  /// **'العلم والمعرفة'**
  String get concept_knowledge;

  /// No description provided for @concept_truth.
  ///
  /// In ar, this message translates to:
  /// **'الحق والصدق'**
  String get concept_truth;

  /// No description provided for @concept_falsehood.
  ///
  /// In ar, this message translates to:
  /// **'الباطل والزيف'**
  String get concept_falsehood;

  /// No description provided for @concept_blindness.
  ///
  /// In ar, this message translates to:
  /// **'العمى عن الحق'**
  String get concept_blindness;

  /// No description provided for @concept_sight.
  ///
  /// In ar, this message translates to:
  /// **'البصيرة'**
  String get concept_sight;

  /// No description provided for @concept_life.
  ///
  /// In ar, this message translates to:
  /// **'الحياة المعنوية'**
  String get concept_life;

  /// No description provided for @concept_death.
  ///
  /// In ar, this message translates to:
  /// **'الموت القلبي'**
  String get concept_death;

  /// No description provided for @concept_success.
  ///
  /// In ar, this message translates to:
  /// **'الفلاح والنجاح'**
  String get concept_success;

  /// No description provided for @concept_loss.
  ///
  /// In ar, this message translates to:
  /// **'الخسران'**
  String get concept_loss;

  /// No description provided for @concept_misguidance.
  ///
  /// In ar, this message translates to:
  /// **'الضلالة'**
  String get concept_misguidance;

  /// No description provided for @concept_revelation.
  ///
  /// In ar, this message translates to:
  /// **'الوحي والرسالة'**
  String get concept_revelation;

  /// No description provided for @concept_certainty.
  ///
  /// In ar, this message translates to:
  /// **'اليقين'**
  String get concept_certainty;

  /// No description provided for @concept_doubt.
  ///
  /// In ar, this message translates to:
  /// **'الشك والريب'**
  String get concept_doubt;

  /// No description provided for @concept_ignorance.
  ///
  /// In ar, this message translates to:
  /// **'الجهل'**
  String get concept_ignorance;

  /// No description provided for @concept_sealing.
  ///
  /// In ar, this message translates to:
  /// **'الختم والطبع'**
  String get concept_sealing;

  /// No description provided for @concept_locking.
  ///
  /// In ar, this message translates to:
  /// **'الأقفال'**
  String get concept_locking;

  /// No description provided for @concept_rust.
  ///
  /// In ar, this message translates to:
  /// **'الرين'**
  String get concept_rust;

  /// No description provided for @concept_veil.
  ///
  /// In ar, this message translates to:
  /// **'الحجاب والغشاوة'**
  String get concept_veil;

  /// No description provided for @concept_sickness.
  ///
  /// In ar, this message translates to:
  /// **'المرض القلبي'**
  String get concept_sickness;

  /// No description provided for @concept_hardness.
  ///
  /// In ar, this message translates to:
  /// **'القسوة'**
  String get concept_hardness;

  /// No description provided for @concept_softness.
  ///
  /// In ar, this message translates to:
  /// **'اللين والخشوع'**
  String get concept_softness;

  /// No description provided for @concept_walking.
  ///
  /// In ar, this message translates to:
  /// **'السير على المنهج'**
  String get concept_walking;

  /// No description provided for @concept_stumbling.
  ///
  /// In ar, this message translates to:
  /// **'التعثر'**
  String get concept_stumbling;

  /// No description provided for @concept_standing.
  ///
  /// In ar, this message translates to:
  /// **'الحيرة والوقوف'**
  String get concept_standing;

  /// No description provided for @concept_turning_away.
  ///
  /// In ar, this message translates to:
  /// **'الإعراض'**
  String get concept_turning_away;

  /// No description provided for @concept_running.
  ///
  /// In ar, this message translates to:
  /// **'الفرار والهروب'**
  String get concept_running;

  /// No description provided for @concept_other.
  ///
  /// In ar, this message translates to:
  /// **'مفاهيم متنوعة'**
  String get concept_other;

  /// No description provided for @mainConcept_path.
  ///
  /// In ar, this message translates to:
  /// **'الطريق والمنهج'**
  String get mainConcept_path;

  /// No description provided for @mainConcept_deception.
  ///
  /// In ar, this message translates to:
  /// **'الخداع والمكر'**
  String get mainConcept_deception;

  /// No description provided for @mainConcept_light.
  ///
  /// In ar, this message translates to:
  /// **'النور والبصيرة'**
  String get mainConcept_light;

  /// No description provided for @mainConcept_darkness.
  ///
  /// In ar, this message translates to:
  /// **'الظلمات والضلال'**
  String get mainConcept_darkness;

  /// No description provided for @mainConcept_heart.
  ///
  /// In ar, this message translates to:
  /// **'أحوال القلوب'**
  String get mainConcept_heart;

  /// No description provided for @mainConcept_faith.
  ///
  /// In ar, this message translates to:
  /// **'الإيمان والكفر'**
  String get mainConcept_faith;

  /// No description provided for @mainConcept_general.
  ///
  /// In ar, this message translates to:
  /// **'مفاهيم عامة'**
  String get mainConcept_general;

  /// No description provided for @relation_contrast.
  ///
  /// In ar, this message translates to:
  /// **'تضاد ومقابلة'**
  String get relation_contrast;

  /// No description provided for @relation_similarity.
  ///
  /// In ar, this message translates to:
  /// **'تشابه وتماثل'**
  String get relation_similarity;

  /// No description provided for @relation_causality.
  ///
  /// In ar, this message translates to:
  /// **'سببية ونتيجة'**
  String get relation_causality;

  /// No description provided for @relation_correlation.
  ///
  /// In ar, this message translates to:
  /// **'ارتباط تلازمي'**
  String get relation_correlation;

  /// No description provided for @relation_complementary.
  ///
  /// In ar, this message translates to:
  /// **'تكامل دلالي'**
  String get relation_complementary;

  /// No description provided for @relation_manifestation.
  ///
  /// In ar, this message translates to:
  /// **'تجلي وظهور'**
  String get relation_manifestation;

  /// No description provided for @relation_reinforcement.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد وتعزيز'**
  String get relation_reinforcement;

  /// No description provided for @relation_consequence.
  ///
  /// In ar, this message translates to:
  /// **'مآل وعاقبة'**
  String get relation_consequence;

  /// No description provided for @function_promise.
  ///
  /// In ar, this message translates to:
  /// **'وعد وتبشير'**
  String get function_promise;

  /// No description provided for @function_threat.
  ///
  /// In ar, this message translates to:
  /// **'وعيد وتحذير'**
  String get function_threat;

  /// No description provided for @function_argument.
  ///
  /// In ar, this message translates to:
  /// **'حجاج وإقناع'**
  String get function_argument;

  /// No description provided for @function_legislation.
  ///
  /// In ar, this message translates to:
  /// **'تشريع وأحكام'**
  String get function_legislation;

  /// No description provided for @valence_positive.
  ///
  /// In ar, this message translates to:
  /// **'نبرة إيجابية'**
  String get valence_positive;

  /// No description provided for @valence_negative.
  ///
  /// In ar, this message translates to:
  /// **'نبرة تحذيرية'**
  String get valence_negative;

  /// No description provided for @juz.
  ///
  /// In ar, this message translates to:
  /// **'الأجزاء'**
  String get juz;

  /// No description provided for @surahs.
  ///
  /// In ar, this message translates to:
  /// **'السور'**
  String get surahs;

  /// No description provided for @notes.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات'**
  String get notes;

  /// No description provided for @rhetoric_science.
  ///
  /// In ar, this message translates to:
  /// **'علم البيان'**
  String get rhetoric_science;

  /// No description provided for @simile.
  ///
  /// In ar, this message translates to:
  /// **'التشبيه'**
  String get simile;

  /// No description provided for @metaphor.
  ///
  /// In ar, this message translates to:
  /// **'الاستعارة'**
  String get metaphor;

  /// No description provided for @exploration_tools.
  ///
  /// In ar, this message translates to:
  /// **'أدوات الاستكشاف'**
  String get exploration_tools;

  /// No description provided for @sunburst_map.
  ///
  /// In ar, this message translates to:
  /// **'الخريطة الشمسية للمفاهيم'**
  String get sunburst_map;

  /// No description provided for @rhetoric_atlas.
  ///
  /// In ar, this message translates to:
  /// **'أطلس المفاهيم البلاغية'**
  String get rhetoric_atlas;

  /// No description provided for @style_analyzer.
  ///
  /// In ar, this message translates to:
  /// **'محلل الأسلوب البلاغي'**
  String get style_analyzer;

  /// No description provided for @concept_graph.
  ///
  /// In ar, this message translates to:
  /// **'شبكة العلاقات المفهومية'**
  String get concept_graph;

  /// No description provided for @dashboard.
  ///
  /// In ar, this message translates to:
  /// **'لوحة التحكم والاستكشاف'**
  String get dashboard;

  /// No description provided for @reading_settings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات القراءة'**
  String get reading_settings;

  /// No description provided for @system.
  ///
  /// In ar, this message translates to:
  /// **'حسب النظام'**
  String get system;

  /// No description provided for @preview_text.
  ///
  /// In ar, this message translates to:
  /// **'نص المعاينة'**
  String get preview_text;

  /// No description provided for @basmala.
  ///
  /// In ar, this message translates to:
  /// **'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'**
  String get basmala;

  /// No description provided for @part.
  ///
  /// In ar, this message translates to:
  /// **'الجزء'**
  String get part;

  /// No description provided for @tajweed_prolonging.
  ///
  /// In ar, this message translates to:
  /// **'المدود'**
  String get tajweed_prolonging;

  /// No description provided for @tajweed_ghunna.
  ///
  /// In ar, this message translates to:
  /// **'الغنة'**
  String get tajweed_ghunna;

  /// No description provided for @tajweed_tafkhim.
  ///
  /// In ar, this message translates to:
  /// **'التفخيم'**
  String get tajweed_tafkhim;

  /// No description provided for @tajweed_qalqala.
  ///
  /// In ar, this message translates to:
  /// **'القلقلة'**
  String get tajweed_qalqala;

  /// No description provided for @tajweed_tarqiq.
  ///
  /// In ar, this message translates to:
  /// **'الترقيق'**
  String get tajweed_tarqiq;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
