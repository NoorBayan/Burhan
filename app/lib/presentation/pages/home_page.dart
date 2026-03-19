import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ijaaz_app/presentation/pages/juz_list_page.dart';
import 'package:ijaaz_app/presentation/pages/surah_list_page.dart';
import 'package:ijaaz_app/presentation/pages/bookmarks_page.dart';
import 'package:ijaaz_app/presentation/pages/notes_page.dart';
import 'package:ijaaz_app/presentation/pages/settings_page.dart';
import 'package:ijaaz_app/presentation/pages/comprehensive_search_page.dart';
import 'package:ijaaz_app/presentation/pages/concepts_sunburst_page.dart';
import 'package:ijaaz_app/presentation/pages/concepts_map_page.dart';
import 'package:ijaaz_app/presentation/pages/concept_graph_page.dart';
import 'package:ijaaz_app/presentation/pages/dashboard_page.dart';
import 'package:ijaaz_app/presentation/pages/rhetoric_list_page.dart';
import 'package:ijaaz_app/presentation/pages/quran_page_viewer.dart';
import 'package:ijaaz_app/presentation/pages/quran_style_analyzer_page.dart';
import 'package:ijaaz_app/l10n/app_localizations.dart';
import 'package:ijaaz_app/data/surah_names_ar.dart';
import 'package:ijaaz_app/data/surah_names_en.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;
  String _lastSurahName = ""; // Fallback
  int _lastSurahNumber = 0;
  int _lastPageNumber = 1;

  @override
  void initState() {
    super.initState();
    _loadLastRead();
  }

  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastSurahNumber = prefs.getInt('last_surah_number') ?? 0;
      _lastSurahName = prefs.getString('last_surah_name') ?? "";
      _lastPageNumber = prefs.getInt('last_page_number') ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    String lastSurahDisplay = "";
    if (_lastSurahNumber > 0 && _lastSurahNumber <= 114) {
      lastSurahDisplay = localizations.locale.languageCode == 'ar'
          ? surahNamesArabic[_lastSurahNumber - 1]
          : surahNamesEnglish[_lastSurahNumber - 1];
      
      // Add "Surah" prefix for Arabic if missing
      if (localizations.locale.languageCode == 'ar' && !lastSurahDisplay.startsWith('سورة')) {
         lastSurahDisplay = "سورة $lastSurahDisplay";
      }
    } else if (_lastSurahName.isNotEmpty) {
      lastSurahDisplay = _lastSurahName;
    } else {
      lastSurahDisplay = localizations.locale.languageCode == 'ar' ? "سورة الفاتحة" : "Surah Al-Fatiha";
    }

    final List<Widget> _widgetOptions = <Widget>[
      MainContent(
        lastSurahName: lastSurahDisplay,
        lastPageNumber: _lastPageNumber,
        onRefreshRequest: _loadLastRead,
      ),
      const ComprehensiveSearchPage(),
      const BookmarksPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: _widgetOptions.elementAt(_bottomNavIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: localizations.home),
          BottomNavigationBarItem(icon: const Icon(Icons.search), label: localizations.search),
          BottomNavigationBarItem(icon: const Icon(Icons.bookmark), label: localizations.bookmarks),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: localizations.settings),
        ],
        currentIndex: _bottomNavIndex,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _bottomNavIndex = index);
          if (index == 0) _loadLastRead();
        },
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  final String lastSurahName;
  final int lastPageNumber;
  final VoidCallback onRefreshRequest;

  const MainContent({Key? key, required this.lastSurahName, required this.lastPageNumber, required this.onRefreshRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final localizations = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                expandedHeight: 240.0, // زيادة الارتفاع لترك مساحة للبطاقة
                backgroundColor: theme.colorScheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin, // الحفاظ على العناصر عند التمرير
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0), // إزاحة للأعلى
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(localizations.appTitle, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 15),
                            _buildLastReadCard(context, size, localizations),
                            const SizedBox(height: 25), // مسافة إضافية أسفل البطاقة قبل التبويبات
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  tabs: [
                    Tab(text: localizations.juz),
                    Tab(text: localizations.surahs),
                    Tab(text: localizations.bookmarks),
                    Tab(text: localizations.notes),
                    Tab(text: localizations.rhetoric),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: [
              JuzListPage(onJuzOpened: onRefreshRequest),
              SurahListPage(onSurahOpened: onRefreshRequest),
              const BookmarksPage(),
              const NotesPage(),
              const RhetoricExplorerTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastReadCard(BuildContext context, Size size, AppLocalizations localizations) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (c) => QuranPageViewer(initialPageNumber: lastPageNumber)));
        onRefreshRequest();
      },
      child: Container(
        width: size.width * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12), // جعل البطاقة أكثر شفافية وأناقة
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.menu_book, color: Color(0xFF2c5f7f), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(localizations.last_read, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  Text(lastSurahName, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold, fontFamily: 'Kitab')),
                  Text("${localizations.continue_reading} $lastPageNumber", style: const TextStyle(color: Colors.white60, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
          ],
        ),
      ),
    );
  }
}

class RhetoricExplorerTab extends StatelessWidget {
  const RhetoricExplorerTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(localizations.rhetoric_science, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildRhetoricTypeCard(context, localizations.simile, Icons.compare_arrows, Colors.blue, 'تشبيه')),
            const SizedBox(width: 12),
            Expanded(child: _buildRhetoricTypeCard(context, localizations.metaphor, Icons.auto_awesome, Colors.orange, 'استعارة')),
          ],
        ),
        const SizedBox(height: 32),
        Text(localizations.exploration_tools, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildActionCard(context, localizations.sunburst_map, Icons.pie_chart, Colors.amber, const ConceptsSunburstPage()),
        _buildActionCard(context, localizations.rhetoric_atlas, Icons.map, Colors.green, const ConceptsMapPage()),
        _buildActionCard(context, localizations.style_analyzer, Icons.analytics, Colors.redAccent, const QuranStyleAnalyzerPage()),
        _buildActionCard(context, localizations.concept_graph, Icons.hub, Colors.purple, const ConceptGraphPage()),
        _buildActionCard(context, localizations.dashboard, Icons.dashboard, Colors.teal, const DashboardPage()),
      ],
    );
  }

  Widget _buildRhetoricTypeCard(BuildContext context, String title, IconData icon, Color color, String type) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => RhetoricListPage(rhetoricType: type))),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => page)),
      ),
    );
  }
}
