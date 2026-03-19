import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:ijaaz_app/l10n/app_localizations.dart'; 
import 'package:ijaaz_app/application/settings_service.dart';
import 'package:ijaaz_app/data/surah_names_en.dart';
import 'package:ijaaz_app/data/surah_names_ar.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Map<String, dynamic>> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> notesJson = prefs.getStringList('quran_notes') ?? [];
      
      setState(() {
        _notes = notesJson
            .map((item) => json.decode(item) as Map<String, dynamic>)
            .toList()
            .reversed.toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteNote(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notesJson = prefs.getStringList('quran_notes') ?? [];
    if (index >= 0 && index < notesJson.length) {
      notesJson.removeAt(notesJson.length - 1 - index);
      await prefs.setStringList('quran_notes', notesJson);
      _loadNotes();
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
        title: Text(localizations.notes_page_title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
          : _notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.note_alt_rounded, size: 100, color: theme.colorScheme.primary.withOpacity(0.2)),
                      const SizedBox(height: 16),
                      Text(localizations.no_results, style: TextStyle(color: theme.hintColor, fontSize: 16)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final noteItem = _notes[index];
                    int surahNum = noteItem['surahNum'] ?? 1;
                    String surahName = isEn 
                        ? (surahNamesEnglish.length >= surahNum ? surahNamesEnglish[surahNum - 1] : "Surah $surahNum")
                        : (surahNamesArabic.length >= surahNum ? "سورة ${surahNamesArabic[surahNum - 1]}" : "سورة $surahNum");

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: isDark ? theme.colorScheme.surface : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      "$surahName • ${localizations.verse} ${noteItem['verseNum'] ?? ''}", 
                                      style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                  onPressed: () => _deleteNote(index),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.black26 : Colors.grey[50],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                noteItem['text'] ?? "", 
                                style: const TextStyle(fontFamily: 'Kitab', fontSize: 15, height: 1.5), 
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              noteItem['note'] ?? "", 
                              style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                _formatDate(noteItem['date']?.toString() ?? ""), 
                                style: TextStyle(color: theme.hintColor.withOpacity(0.5), fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return "";
    try {
      final date = DateTime.parse(isoDate);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return "";
    }
  }
}
