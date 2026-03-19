import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ijaaz_app/application/tajweed.dart';
import 'package:ijaaz_app/models/tajweed_rule.dart';
import 'package:ijaaz_app/models/tajweed_token.dart';
import 'package:ijaaz_app/application/settings_service.dart';
import 'package:ijaaz_app/application/quran_data_service.dart';
import 'package:ijaaz_app/l10n/app_localizations.dart';
import 'package:ijaaz_app/data/meta_data_juz.dart';
import 'package:ijaaz_app/data/page_data.dart';
import 'package:ijaaz_app/core/utils/arabic_number_converter.dart';
import 'rhetoric_analysis_page.dart';
import 'dart:math' as math;

Map<String, List<TajweedToken>> _computeTajweedBatch(List<Map<String, dynamic>> verses) {
  final Map<String, List<TajweedToken>> results = {};
  for (var v in verses) {
    if (v['type'] == 'verse') {
      results["${v['surahNum']}:${v['verseNum']}"] = Tajweed.tokenize(v['text'], v['surahNum'], v['verseNum']);
    }
  }
  return results;
}

final List<Map<String, String>> tafsirProviders = [
  {'id': 'ar-tafseer-al-saddi', 'name': 'تفسير السعدي'},
  {'id': 'ar-tafsir-ibn-kathir', 'name': 'تفسير ابن كثير'},
  {'id': 'ar-tafsir-al-tabari', 'name': 'تفسير الطبري'},
  {'id': 'ar-tafseer-al-qurtubi', 'name': 'تفسير القرطبي'},
  {'id': 'ar-tafsir-al-baghawi', 'name': 'تفسير البغوي'},
  {'id': 'ar-tafsir-al-wasit', 'name': 'تفسير الوسيط (طنطاوي)'},
  {'id': 'ar-tafseer-tanwir-al-miqbas', 'name': 'تنوير المقباس'},
];

class QuranDisplayPage extends StatefulWidget {
  final int pageNumber;
  const QuranDisplayPage({super.key, required this.pageNumber});

  @override
  State<QuranDisplayPage> createState() => _QuranDisplayPageState();
}

class _QuranDisplayPageState extends State<QuranDisplayPage> {
  late Future<Map<String, dynamic>> _pageDataFuture;
  final Set<String> _selectedVerseKeys = {};
  List<Map<String, dynamic>> _currentItems = [];
  static final Map<String, List<TajweedToken>> _globalTajweedCache = {};

  @override
  void initState() {
    super.initState();
    _pageDataFuture = _loadPageData();
  }

  Future<Map<String, dynamic>> _loadPageData() async {
    final quranService = QuranDataService();
    if (!quranService.isInitialized) await quranService.init();

    final pageInfo = pageData[widget.pageNumber - 1];
    List<Map<String, dynamic>> items = [];
    List<String> pageSurahNames = [];
    String juzNum = _getJuzNumberFromMetaData(widget.pageNumber);
    const basmalaText = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ";

    for (var section in pageInfo) {
      var surahData = quranService.surahsMap[section['surah']];
      if (surahData == null) continue;

      String sName = surahData['name'];
      if (!pageSurahNames.contains(sName)) pageSurahNames.add(sName);

      if (section['start'] == 1) {
        items.add({'type': 'header', 'text': surahData['name'], 'surahNumber': surahData['number'], 'ayahsCount': (surahData['ayahs'] as List).length});
        if (section['surah'] != 1 && section['surah'] != 9) items.add({'type': 'basmala', 'text': basmalaText});
      }

      for (int v = section['start']; v <= section['end']; v++) {
        var ayah = (surahData['ayahs'] as List).firstWhere((a) => a['numberInSurah'] == v);
        String text = ayah['text'];
        if (v == 1 && section['surah'] != 1) {
          final basRegex = RegExp(r'^بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ|^بِسْمِ [^ ]+ [^ ]+ [^ ]+');
          text = text.replaceFirst(basRegex, '').trim();
        }
        text = text.replaceAll(RegExp(r'[\u06DF\u06E0\u06E1]'), '').replaceAll(RegExp(r'[\u06dd\u0660-\u0669\s]+$'), '').trim();
        items.add({'type': 'verse', 'text': text, 'verseNum': v, 'surahNum': section['surah'], 'surahName': surahData['name']});
      }
    }

    final versesToProcess = items.where((it) => it['type'] == 'verse' && !_globalTajweedCache.containsKey("${it['surahNum']}:${it['verseNum']}")).toList();
    if (versesToProcess.isNotEmpty) {
      final results = await compute(_computeTajweedBatch, versesToProcess);
      _globalTajweedCache.addAll(results);
    }
    _currentItems = items;
    return {'items': items, 'surahName': pageSurahNames.join(" - "), 'juzNumber': juzNum};
  }

  String _getJuzNumberFromMetaData(int pageNum) {
    for (var entry in metaDataJuz.entries) {
      final value = entry.value;
      int start = _findPage(int.parse(value['fvk'].split(':')[0]), int.parse(value['fvk'].split(':')[1]));
      int end = _findPage(int.parse(value['lvk'].split(':')[0]), int.parse(value['lvk'].split(':')[1]));
      if (pageNum >= start && pageNum <= end) return value['jn'].toString();
    }
    return ((pageNum + 19) ~/ 20).toString();
  }

  int _findPage(int s, int a) {
    for (int i = 0; i < pageData.length; i++) {
      for (var sec in pageData[i]) { if (sec['surah'] == s && a >= sec['start'] && a <= sec['end']) return i + 1; }
    }
    return 1;
  }

  void _onVerseTapped(Map<String, dynamic> ayah) {
    final key = "${ayah['surahNum']}:${ayah['verseNum']}";
    setState(() {
      if (_selectedVerseKeys.contains(key)) _selectedVerseKeys.remove(key);
      else _selectedVerseKeys.add(key);
    });
  }

  List<Map<String, dynamic>> _getSelectedVersesData() {
    return _currentItems.where((it) => it['type'] == 'verse' && _selectedVerseKeys.contains("${it['surahNum']}:${it['verseNum']}")).toList();
  }

  void _handleBatchCopy() {
    final selected = _getSelectedVersesData();
    if (selected.isEmpty) return;
    String text = selected.map((v) => "${v['text']} [${v['surahName']}: ${v['verseNum'].toString().toArabicDigits()}]").join("\n");
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم نسخ الآيات المختارة")));
    setState(() => _selectedVerseKeys.clear());
  }

  void _handleBatchShare() {
    final selected = _getSelectedVersesData();
    if (selected.isEmpty) return;
    String text = selected.map((v) => "${v['text']} [${v['surahName']}: ${v['verseNum'].toString().toArabicDigits()}]").join("\n\n");
    Share.share("$text\n\nتمت المشاركة عبر تطبيق إعجاز");
    setState(() => _selectedVerseKeys.clear());
  }

  Future<void> _handleBatchBookmark() async {
    final selected = _getSelectedVersesData();
    if (selected.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    List<String> b = prefs.getStringList('quran_bookmarks') ?? [];
    for (var ayah in selected) {
      b.add(json.encode({'surahNum': ayah['surahNum'], 'verseNum': ayah['verseNum'], 'text': ayah['text'], 'surahName': ayah['surahName'], 'page': widget.pageNumber}));
    }
    await prefs.setStringList('quran_bookmarks', b);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تمت الإضافة للمفضلة")));
      setState(() => _selectedVerseKeys.clear());
    }
  }

  void _handleBatchNote() {
    final selected = _getSelectedVersesData();
    if (selected.isEmpty) return;
    final ayah = selected.first;
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إضافة ملاحظة"),
        content: TextField(controller: controller, maxLines: 3, decoration: const InputDecoration(hintText: "اكتب ملاحظتك هنا...")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          TextButton(onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            List<String> notes = prefs.getStringList('quran_notes') ?? [];
            notes.add(json.encode({'surahNum': ayah['surahNum'], 'verseNum': ayah['verseNum'], 'note': controller.text, 'text': ayah['text']}));
            await prefs.setStringList('quran_notes', notes);
            if (mounted) { 
              Navigator.pop(context); 
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم حفظ الملاحظة بنجاح")));
              setState(() => _selectedVerseKeys.clear()); 
            }
          }, child: const Text("حفظ")),
        ],
      ),
    );
  }

  void _showSingleVerseOptions() {
    final selected = _getSelectedVersesData();
    if (selected.length != 1) return;
    final ayah = selected.first;
    final key = "${ayah['surahNum']}:${ayah['verseNum']}";
    final quranService = QuranDataService();

    bool hasBalaqah = quranService.simileVerses.containsKey(key) || quranService.metaphorVerses.containsKey(key);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionItem(context, Icons.menu_book_rounded, "التفسير", () { Navigator.pop(context); _showTafsirList(ayah); }),
                  if (hasBalaqah)
                    _buildOptionItem(context, Icons.auto_awesome, "البلاغة", () {
                      Navigator.pop(context);
                      RhetoricType? type;
                      if (quranService.simileVerses.containsKey(key)) type = RhetoricType.simile;
                      if (quranService.metaphorVerses.containsKey(key)) type = RhetoricType.metaphor;
                      if (type != null) Navigator.push(context, MaterialPageRoute(builder: (c) => RhetoricAnalysisPage(chapterNo: ayah['surahNum'], verseNo: ayah['verseNum'], type: type!)));
                    }),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showTafsirList(Map<String, dynamic> ayah) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Padding(padding: EdgeInsets.all(15), child: Text("اختر مفسراً (7 مراجع)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            Expanded(
              child: ListView.builder(
                itemCount: tafsirProviders.length,
                itemBuilder: (c, i) => ListTile(
                  title: Text(tafsirProviders[i]['name']!),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => _showTafsirContent(ayah, tafsirProviders[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTafsirContent(Map<String, dynamic> ayah, Map<String, String> provider) async {
    Navigator.pop(context);
    List<Map<String, dynamic>> surahAyahs = [];
    int initialIdx = 0;
    final quranService = QuranDataService();

    try {
      final String response = await rootBundle.loadString('assets/data/tafsir/${provider['id']}/${ayah['surahNum']}.json');
      final data = json.decode(response);
      final List tafsirList = data['ayahs'];
      final List quranList = quranService.surahsMap[ayah['surahNum']]['ayahs'];

      for (int i = 0; i < quranList.length; i++) {
        int vNum = quranList[i]['numberInSurah'];
        var t = tafsirList.firstWhere((e) => e['ayah'] == vNum, orElse: () => null);
        surahAyahs.add({'v': vNum, 'q': quranList[i]['text'], 't': t != null ? t['text'] : "تفسير غير متوفر", 'sNum': ayah['surahNum'], 'sName': ayah['surahName']});
        if (vNum == ayah['verseNum']) initialIdx = i;
      }
    } catch (e) { return; }

    if (!mounted) return;
    int currentIdx = initialIdx;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final item = surahAyahs[currentIdx];
          final key = "${item['sNum']}:${item['v']}";
          bool hasBalaqah = quranService.simileVerses.containsKey(key) || quranService.metaphorVerses.containsKey(key);

          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${item['sName']} : آية ${item['v'].toString().toArabicDigits()}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(provider['name']!, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12)),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Text(item['q'], textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Kitab', fontSize: 20, height: 1.8)),
                              if (hasBalaqah)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextButton.icon(
                                    icon: const Icon(Icons.auto_awesome, size: 16),
                                    label: const Text("التحليل البلاغي", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      RhetoricType? type;
                                      if (quranService.simileVerses.containsKey(key)) type = RhetoricType.simile;
                                      if (quranService.metaphorVerses.containsKey(key)) type = RhetoricType.metaphor;
                                      if (type != null) Navigator.push(context, MaterialPageRoute(builder: (c) => RhetoricAnalysisPage(chapterNo: item['sNum'], verseNo: item['v'], type: type!)));
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text("التفسير:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 10),
                        TafsirTextWidget(text: item['t']),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: currentIdx > 0 ? () => setModalState(() => currentIdx--) : null,
                        icon: const Icon(Icons.arrow_back_ios, size: 16),
                        label: const Text("السابق"),
                      ),
                      Text("${(currentIdx + 1).toString().toArabicDigits()} / ${surahAyahs.length.toString().toArabicDigits()}"),
                      ElevatedButton(
                        onPressed: currentIdx < surahAyahs.length - 1 ? () => setModalState(() => currentIdx++) : null,
                        child: const Row(children: [Text("التالي"), Icon(Icons.arrow_forward_ios, size: 16)]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isSpecialPage = widget.pageNumber == 1 || widget.pageNumber == 2;
    final bool hasSelection = _selectedVerseKeys.isNotEmpty;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF15202B) : const Color(0xFFFDFCF4),
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: _pageDataFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final data = snapshot.data!;
                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data['surahName'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
                        Text("${AppLocalizations.of(context)!.part} ${data['juzNumber'].toString().toArabicDigits()}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDark ? const Color(0xFFD4AF37).withOpacity(0.5) : const Color(0xFF7D5233).withOpacity(0.3),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            children: [
                              // Decorative Corners
                              _buildCorner(0, null, isDark, left: 0),
                              _buildCorner(0, null, isDark, right: 0),
                              _buildCorner(null, 0, isDark, left: 0),
                              _buildCorner(null, 0, isDark, right: 0),
                              
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 34),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          textAlign: isSpecialPage ? TextAlign.center : TextAlign.justify,
                                          textDirection: TextDirection.rtl,
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: isDark ? Colors.white : Colors.black,
                                              wordSpacing: 1.0,
                                              height: 1.8,
                                            ),
                                            children: _buildSpans(data['items'], context, SettingsService().fontSize),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(bottom: 2), child: Text(widget.pageNumber.toArabicDigits(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2), child: TajweedLegendBar()),
                ]);
              },
            ),
            
            if (hasSelection)
              Positioned(
                bottom: 60, left: 20, right: 20,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.surface,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(icon: const Icon(Icons.close, color: Colors.redAccent, size: 22), onPressed: () => setState(() => _selectedVerseKeys.clear())),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_selectedVerseKeys.length == 1)
                              IconButton(icon: const Icon(Icons.info_outline, color: Colors.blue, size: 22), onPressed: _showSingleVerseOptions),
                            IconButton(icon: const Icon(Icons.note_alt_outlined, color: Colors.teal, size: 22), onPressed: _handleBatchNote),
                            IconButton(icon: const Icon(Icons.bookmark_border, color: Colors.amber, size: 22), onPressed: _handleBatchBookmark),
                            IconButton(icon: const Icon(Icons.share_outlined, color: Colors.indigo, size: 22), onPressed: _handleBatchShare),
                            IconButton(icon: const Icon(Icons.copy_rounded, color: Colors.blueGrey, size: 22), onPressed: _handleBatchCopy),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text("${_selectedVerseKeys.length.toString().toArabicDigits()} آيات", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<InlineSpan> _buildSpans(List<dynamic> items, BuildContext context, double fontSize) {
    List<InlineSpan> spans = [];
    final quranService = QuranDataService();
    for (var it in items) {
      if (it['type'] == 'header') {
        spans.add(_buildSurahHeader(it['text'], it['surahNumber'], it['ayahsCount'], context));
      } else if (it['type'] == 'basmala') {
        spans.add(_buildBasmala(it['text'], context, fontSize));
      } else if (it['type'] == 'verse') {
        final key = "${it['surahNum']}:${it['verseNum']}";
        spans.addAll(_getTajweedSpans(it['text'], context, fontSize, _selectedVerseKeys.contains(key), () => _onVerseTapped(it), surah: it['surahNum'], ayah: it['verseNum']));
        spans.add(_buildVerseEndSymbol(it['verseNum'], fontSize, context, quranService.simileVerses.containsKey(key) || quranService.metaphorVerses.containsKey(key), it));
        spans.add(const TextSpan(text: " "));
      }
    }
    return spans;
  }

  List<TextSpan> _getTajweedSpans(String text, BuildContext context, double fontSize, bool sel, VoidCallback tap, {int surah = 1, int ayah = 1}) {
    final tokens = _globalTajweedCache["$surah:$ayah"] ?? [TajweedToken(TajweedRule.none, null, null, text, 0, text.length, null)];
    return tokens.map((token) => TextSpan(text: token.text, recognizer: TapGestureRecognizer()..onTap = tap, style: TextStyle(fontFamily: 'Kitab', fontSize: fontSize, color: token.rule.color(context) ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black), backgroundColor: sel ? Colors.blue.withOpacity(0.3) : null))).toList();
  }

  InlineSpan _buildSurahHeader(String name, int num, int count, BuildContext context) {
    return WidgetSpan(child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 10.0), child: Stack(alignment: Alignment.center, children: [
      Image.asset('assets/images/sura_header.png', fit: BoxFit.contain, height: 45),
      Text(name, style: const TextStyle(fontFamily: 'Kitab', fontSize: 18, fontWeight: FontWeight.bold)),
    ])));
  }

  InlineSpan _buildBasmala(String text, BuildContext context, double fontSize) {
    final cacheKey = "1:1_basmala";
    if (!_globalTajweedCache.containsKey(cacheKey)) _globalTajweedCache[cacheKey] = Tajweed.tokenize(text, 1, 1);
    return WidgetSpan(child: Center(child: Padding(padding: const EdgeInsets.only(bottom: 5.0), child: RichText(textAlign: TextAlign.center, text: TextSpan(children: _globalTajweedCache[cacheKey]!.map((t) => TextSpan(text: t.text, style: TextStyle(fontFamily: 'Kitab', fontSize: fontSize + 1, color: t.rule.color(context) ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)))).toList())))));
  }

  InlineSpan _buildVerseEndSymbol(int num, double fs, BuildContext context, bool bh, Map<String, dynamic> it) {
    final Color frameColor = Theme.of(context).brightness == Brightness.dark ? const Color(0xFFD4AF37) : const Color(0xFF7D5233);
    return WidgetSpan(alignment: PlaceholderAlignment.middle, child: GestureDetector(onTap: () => _onVerseTapped(it), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0), child: Stack(alignment: Alignment.center, children: [
      CustomPaint(size: Size(fs * 1.1, fs * 1.1), painter: AyahFramePainter(color: frameColor)),
      Text(num.toArabicDigits(), style: TextStyle(fontFamily: 'Kitab', fontSize: fs * 0.4, fontWeight: FontWeight.bold)),
      if (bh) Positioned(top: -fs * 0.3, child: Icon(Icons.auto_awesome, size: fs * 0.4, color: Theme.of(context).colorScheme.primary)),
    ]))));
  }

  Widget _buildCorner(double? top, double? bottom, bool isDark, {double? left, double? right}) {
    final color = isDark ? const Color(0xFFD4AF37).withOpacity(0.8) : const Color(0xFF7D5233).withOpacity(0.6);
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Icon(Icons.brightness_7_outlined, size: 12, color: color),
    );
  }
}

class AyahFramePainter extends CustomPainter {
  final Color color;
  AyahFramePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius * 0.7, paint);
    final path = Path();
    for (int i = 0; i < 8; i++) {
      double angle = (i * 45) * math.pi / 180;
      double nextAngle = ((i + 1) * 45) * math.pi / 180;
      double midAngle = (angle + nextAngle) / 2;
      if (i == 0) path.moveTo(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      else path.lineTo(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      path.quadraticBezierTo(center.dx + radius * 0.8 * math.cos(midAngle), center.dy + radius * 0.8 * math.sin(midAngle), center.dx + radius * math.cos(nextAngle), center.dy + radius * math.sin(nextAngle));
    }
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(AyahFramePainter oldDelegate) => false;
}

class TajweedLegendBar extends StatelessWidget {
  const TajweedLegendBar({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Map<String, dynamic>> rules = [
      {'label': 'لفظ الجلالة', 'rule': TajweedRule.LAFZATULLAH},
      {'label': 'إظهار', 'rule': TajweedRule.izhar},
      {'label': 'إخفاء', 'rule': TajweedRule.ikhfaa},
      {'label': 'إدغام بغنة', 'rule': TajweedRule.idghamWithGhunna},
      {'label': 'إقلاب', 'rule': TajweedRule.iqlab},
      {'label': 'قلقلة', 'rule': TajweedRule.qalqala},
      {'label': 'إدغام بلا غنة', 'rule': TajweedRule.idghamWithoutGhunna},
      {'label': 'غنن', 'rule': TajweedRule.ghunna},
      {'label': 'المدود', 'rule': TajweedRule.prolonging},
    ];
    return Container(padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02), borderRadius: BorderRadius.circular(10)), child: Center(child: Wrap(alignment: WrapAlignment.center, spacing: 8.0, runSpacing: 4.0, children: rules.map((r) => Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 6, height: 6, decoration: BoxDecoration(color: (r['rule'] as TajweedRule).color(context), shape: BoxShape.circle)), const SizedBox(width: 3), Text(r['label'] as String, style: TextStyle(fontSize: 8, color: isDark ? Colors.white54 : Colors.grey[700], fontFamily: 'Kitab'))])).toList())));
  }
}

class TafsirTextWidget extends StatefulWidget {
  final String text;
  const TafsirTextWidget({super.key, required this.text});
  @override
  State<TafsirTextWidget> createState() => _TafsirTextWidgetState();
}

class _TafsirTextWidgetState extends State<TafsirTextWidget> {
  bool ex = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final tp = TextPainter(text: TextSpan(text: widget.text, style: const TextStyle(fontSize: 17, height: 1.8, fontFamily: 'Kitab')), maxLines: 4, textDirection: TextDirection.rtl)..layout(maxWidth: constraints.maxWidth);
      bool canEx = tp.didExceedMaxLines;
      return Column(children: [
        Text(widget.text, maxLines: ex ? null : 4, overflow: ex ? TextOverflow.visible : TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, height: 1.8, fontFamily: 'Kitab'), textAlign: TextAlign.justify, textDirection: TextDirection.rtl),
        if (canEx) Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: () => setState(() => ex = !ex), child: Text(ex ? "إغلاق" : "قراءة المزيد...", style: const TextStyle(fontSize: 14)))),
      ]);
    });
  }
}