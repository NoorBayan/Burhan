import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ijaaz_app/application/quran_data_service.dart';
import 'package:ijaaz_app/application/settings_service.dart';
import 'package:ijaaz_app/application/data_loader.dart';
import 'package:ijaaz_app/data/page_data.dart';
import 'quran_display_page.dart';

class QuranPageViewer extends StatefulWidget {
  final int initialPageNumber;
  const QuranPageViewer({Key? key, this.initialPageNumber = 1}) : super(key: key);

  @override
  _QuranPageViewerState createState() => _QuranPageViewerState();
}

class _QuranPageViewerState extends State<QuranPageViewer> {
  late PageController _pageController;
  final FocusNode _focusNode = FocusNode();
  int _currentPage = 1;
  String _currentSurahName = '';

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPageNumber;
    _pageController = PageController(initialPage: widget.initialPageNumber - 1);
    _updatePageMetadata(_currentPage);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  Future<void> _updatePageMetadata(int pageNum) async {
    final prefs = await SharedPreferences.getInstance();

    if (pageNum > 0 && pageNum <= pageData.length) {
      final firstSection = pageData[pageNum - 1].first;
      final surahNum = firstSection['surah'];
      final surahName = QuranDataLoader.getSuraName(surahNum); // <<<=== الآن هذا السطر سيعمل بنجاح

      await prefs.setInt('last_page_number', pageNum);
      await prefs.setInt('last_surah_number', surahNum);
      await prefs.setString('last_surah_name', surahName);

      if (mounted) {
        setState(() {
          _currentPage = pageNum;
          _currentSurahName = surahName;
        });
      }
    }
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 604,
            onPageChanged: _updatePageMetadata,
            allowImplicitScrolling: true,
            itemBuilder: (context, index) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: QuranDisplayPage(pageNumber: index + 1),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSettingsModal(BuildContext context, SettingsService settings) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return ChangeNotifierProvider.value(
          value: settings,
          child: Consumer<SettingsService>(
            builder: (context, currentSettings, _) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("إعدادات العرض", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text("الوضع الليلي"),
                      value: currentSettings.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        currentSettings.updateThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
