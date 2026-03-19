import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  
  factory SettingsService() {
    return _instance;
  }

  SettingsService._internal();

  static const String _keyFontSize = 'fontSize';
  static const String _keyThemeMode = 'themeMode';
  static const String _keyLocale = 'locale';
  static const String _keyTafsir = 'selectedTafsir';

  late SharedPreferences _prefs;
  double _fontSize = 22.0;
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('ar');
  String _selectedTafsirProvider = 'ar-tafseer-al-saddi';

  double get fontSize => _fontSize;
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  String get selectedTafsirProvider => _selectedTafsirProvider;

  final List<Map<String, String>> tafsirProviders = [
    {'id': 'ar-tafseer-al-saddi', 'name': 'تفسير السعدي'},
    {'id': 'ar-tafsir-ibn-kathir', 'name': 'تفسير ابن كثير'},
    {'id': 'ar-tafsir-al-tabari', 'name': 'تفسير الطبري'},
    {'id': 'ar-tafseer-al-qurtubi', 'name': 'تفسير القرطبي'},
    {'id': 'ar-tafsir-al-baghawi', 'name': 'تفسير البغوي'},
    {'id': 'ar-tafsir-al-wasit', 'name': 'الوسيط لطنطاوي'},
    {'id': 'ar-tafseer-tanwir-al-miqbas', 'name': 'تنوير المقباس'},
  ];

  Future<void> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _fontSize = _prefs.getDouble(_keyFontSize) ?? 22.0;
    
    int? themeIndex = _prefs.getInt(_keyThemeMode);
    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
    }

    String? localeCode = _prefs.getString(_keyLocale);
    if (localeCode != null) {
      _locale = Locale(localeCode);
    }

    _selectedTafsirProvider = _prefs.getString(_keyTafsir) ?? 'ar-tafseer-al-saddi';
    
    notifyListeners();
  }

  Future<void> updateFontSize(double newSize) async {
    _fontSize = newSize;
    await _prefs.setDouble(_keyFontSize, newSize);
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode newMode) async {
    _themeMode = newMode;
    await _prefs.setInt(_keyThemeMode, newMode.index);
    notifyListeners();
  }

  Future<void> updateLocale(Locale newLocale) async {
    if (newLocale == _locale) return;
    _locale = newLocale;
    await _prefs.setString(_keyLocale, newLocale.languageCode);
    notifyListeners();
  }

  Future<void> updateTafsir(String providerId) async {
    _selectedTafsirProvider = providerId;
    await _prefs.setString(_keyTafsir, providerId);
    notifyListeners();
  }
}
