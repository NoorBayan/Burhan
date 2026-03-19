import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:ijaaz_app/presentation/pages/home_page.dart';
import 'package:ijaaz_app/application/settings_service.dart';
import 'package:ijaaz_app/application/quran_data_service.dart';
import 'package:ijaaz_app/l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // الحفاظ على شاشة البداية ظاهرة حتى ننتهي من التحميل
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  // تهيئة الإعدادات
  final settingsService = SettingsService();
  await settingsService.loadSettings();

  // تهيئة بيانات القرآن مسبقاً لسرعة فائقة
  await QuranDataService().init();
  
  // إزالة شاشة البداية بعد اكتمال التحميل
  FlutterNativeSplash.remove();
  
  runApp(
    ChangeNotifierProvider.value(
      value: settingsService,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsService>(
      builder: (context, settings, child) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: settings.locale,
          scrollBehavior: MyCustomScrollBehavior(),
          themeMode: settings.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: const Color(0xFF0F4C75),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0F4C75),
              primary: const Color(0xFF3282B8),
              secondary: const Color(0xFFBBE1FA),
              surface: Colors.white,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF4F7F6),
            fontFamily: 'Kitab',
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF1B262C),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            primaryColor: const Color(0xFF1B262C),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1B262C),
              primary: const Color(0xFF3282B8),
              secondary: const Color(0xFF0F4C75),
              surface: const Color(0xFF1B262C),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF1B262C),
            fontFamily: 'Kitab',
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Color(0xFF1B262C),
              foregroundColor: Colors.white,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
