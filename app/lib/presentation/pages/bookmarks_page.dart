import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:ijaaz_app/l10n/app_localizations.dart'; 
import 'package:ijaaz_app/presentation/pages/quran_page_viewer.dart';
import 'package:ijaaz_app/application/settings_service.dart';
import 'package:ijaaz_app/data/surah_names_en.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<Map<String, dynamic>> _bookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookmarksJson = prefs.getStringList('quran_bookmarks') ?? [];
    
    setState(() {
      _bookmarks = bookmarksJson
          .map((item) => json.decode(item) as Map<String, dynamic>)
          .toList()
          .reversed.toList();
      _isLoading = false;
    });
  }

  Future<void> _deleteBookmark(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarksJson = prefs.getStringList('quran_bookmarks') ?? [];
    if (index >= 0 && index < bookmarksJson.length) {
      bookmarksJson.removeAt(bookmarksJson.length - 1 - index);
      await prefs.setStringList('quran_bookmarks', bookmarksJson);
      _loadBookmarks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEn = SettingsService().locale.languageCode == 'en';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(localizations.bookmarks_page_title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
          : _bookmarks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_border_rounded, size: 100, color: theme.colorScheme.primary.withOpacity(0.2)),
                      const SizedBox(height: 16),
                      Text(localizations.no_results, style: TextStyle(color: theme.hintColor, fontSize: 16)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = _bookmarks[index];
                    String surahName = isEn 
                        ? (surahNamesEnglish.length >= bookmark['surahNum'] ? surahNamesEnglish[bookmark['surahNum'] - 1] : "Surah ${bookmark['surahNum']}")
                        : (bookmark['surahName'] ?? "سورة ${bookmark['surahNum']}");

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? theme.colorScheme.surface : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => QuranPageViewer(initialPageNumber: bookmark['page'] ?? 1)));
                        },
                        title: Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  "$surahName • ${localizations.verse} ${bookmark['verseNum']}",
                                  style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text("${localizations.continue_reading} ${bookmark['page'] ?? ''}", style: TextStyle(color: theme.hintColor, fontSize: 10)),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            bookmark['text'] ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontFamily: 'Kitab', fontSize: 17, height: 1.6),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
                          onPressed: () => _deleteNote(index),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _deleteNote(int index) {
    _deleteBookmark(index);
  }
}
