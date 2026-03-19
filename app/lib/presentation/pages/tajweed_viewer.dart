import 'package:flutter/material.dart';
import 'package:ijaaz_app/application/quran_data_service.dart';
import 'package:ijaaz_app/application/tajweed.dart';
import 'package:ijaaz_app/models/tajweed_token.dart';
import 'package:ijaaz_app/core/utils/arabic_number_converter.dart';

class TokenizedAya {
  final List<TajweedToken> tokens;
  final int verseNum;
  TokenizedAya(this.tokens, this.verseNum);
}

class TajweedViewer extends StatefulWidget {
  const TajweedViewer({super.key});

  @override
  State<TajweedViewer> createState() => _TajweedViewerState();
}

class _TajweedViewerState extends State<TajweedViewer> {
  final int loadOnly = 50;
  late Future<List<TokenizedAya>> _loader;

  @override
  void initState() {
    super.initState();
    _loader = loadAyasFromJSON();
  }

  Future<List<TokenizedAya>> loadAyasFromJSON() async {
    try {
      final quranService = QuranDataService();
      if (!quranService.isInitialized) {
        await quranService.init();
      }

      final surahData = quranService.surahsMap[2];
      if (surahData == null) return [];

      final List ayahs = surahData['ayahs'];
      final result = <TokenizedAya>[];

      for (int i = 0; i < ayahs.length && i < loadOnly; i++) {
        final String text = ayahs[i]['text'];
        final int verseNum = ayahs[i]['numberInSurah'];
        final ayaTokens = Tajweed.tokenize(text, 2, verseNum);
        result.add(TokenizedAya(ayaTokens, verseNum));
      }
      return result;
    } catch (e) {
      debugPrint("Error loading ayas from JSON: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF15202B) : const Color(0xFFFDFCF4),
      appBar: AppBar(
        title: const Text('معاين التجويد الملون', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<TokenizedAya>>(
        future: _loader,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("خطأ في التحميل: ${snapshot.error}", textAlign: TextAlign.center));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد بيانات متاحة'));
          }

          final data = snapshot.data!;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final aya = data[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.brown.withOpacity(0.03),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: isDark ? Colors.white10 : Colors.brown.withOpacity(0.1)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          ...aya.tokens.map((token) => TextSpan(
                            text: token.text,
                            style: TextStyle(
                              fontFamily: 'UthmanicHafs', 
                              fontSize: 24,
                              height: 1.8, 
                              color: token.rule.color(context) ?? (isDark ? Colors.white : Colors.black),
                            ),
                          )),
                          TextSpan(
                            text: ' ﴿${aya.verseNum.toString().toArabicDigits()}﴾ ',
                            style: TextStyle(
                              fontFamily: 'UthmanicHafs',
                              fontSize: 22,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
