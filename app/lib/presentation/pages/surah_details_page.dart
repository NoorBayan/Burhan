import 'package:flutter/material.dart';
import 'package:ijaaz_app/application/tajweed.dart';
import 'package:ijaaz_app/models/tajweed_rule.dart';
import 'package:ijaaz_app/models/tajweed_token.dart';
import 'package:ijaaz_app/application/settings_service.dart';
import 'package:ijaaz_app/l10n/app_localizations.dart';
import 'package:ijaaz_app/data/surah_names_en.dart';

// دالة تحليل التجويد
List<TextSpan> getTajweed(String text, BuildContext context, double fontSize) {
  final List<TajweedToken> tokens = Tajweed.tokenize(text, 1, 1);
  return tokens.map((token) {
    final TajweedRule rule = token.rule;
    final color = rule.color(context);
    return TextSpan(
      text: token.text,
      style: TextStyle(
        color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
        fontFamily: 'UthmanicHafs',
        fontSize: fontSize,
      ),
    );
  }).toList();
}

class SurahDetailsPage extends StatelessWidget {
  final dynamic surah;

  // نص البسملة للمقارنة
  final String _basmalaText = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ";

  const SurahDetailsPage({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    final ayahs = surah['ayahs'] as List<dynamic>;
    final int surahNumber = surah['number'];

    final bool isCenteredPage = surahNumber == 1 || surahNumber == 2;
    final bool isFatiha = surahNumber == 1;

    bool hasBasmalaMerged = false;
    if (!isFatiha && surahNumber != 9) {
      String firstAyahText = ayahs[0]['text'];
      if (firstAyahText.startsWith("بِسْمِ")) {
        hasBasmalaMerged = true;
      }
    }

    // استخدام AnimatedBuilder للاستماع للتغييرات في الإعدادات
    return AnimatedBuilder(
      animation: SettingsService(),
      builder: (context, child) {
        final settings = SettingsService();
        final double fontSize = settings.fontSize;
        
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    children: [
                      Expanded(
                        child: isCenteredPage
                            ? Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                            child: _buildSurahContent(context, surahNumber, ayahs, hasBasmalaMerged, isCenteredPage, fontSize, settings.locale),
                          ),
                        )
                            : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                          child: _buildSurahContent(context, surahNumber, ayahs, hasBasmalaMerged, isCenteredPage, fontSize, settings.locale),
                        ),
                      ),
                      const TajweedLegendWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSurahContent(BuildContext context, int surahNumber, List<dynamic> ayahs, bool hasBasmalaMerged, bool isCentered, double fontSize, Locale locale) {
    // تحديد اسم السورة بناءً على اللغة
    String displaySurahName = surah['name'];
    if (locale.languageCode == 'en') {
      // المصفوفة تبدأ من 0 ورقم السورة يبدأ من 1
      displaySurahName = surahNamesEnglish[surahNumber - 1];
    }

    return Column(
      mainAxisAlignment: isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSurahHeader(displaySurahName, context),

        const SizedBox(height: 15),

        if (hasBasmalaMerged)
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'UthmanicHafs',
                  fontSize: fontSize + 2,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                children: getTajweed(_basmalaText, context, fontSize + 2),
              ),
            ),
          ),

        RichText(
          textAlign: isCentered ? TextAlign.center : TextAlign.justify,
          textDirection: TextDirection.rtl,
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'UthmanicHafs',
              fontSize: fontSize,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              height: 1.8,
            ),
            children: _buildAyatSpans(ayahs, context, hasBasmalaMerged, fontSize),
          ),
        ),
      ],
    );
  }

  Widget _buildSurahHeader(String surahName, BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/sura_header.png',
            fit: BoxFit.contain,
            width: double.infinity,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : null,
          ),
          Text(
            surahName,
            style: TextStyle(
              fontFamily: 'UthmanicHafs',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  List<InlineSpan> _buildAyatSpans(List<dynamic> ayahs, BuildContext context, bool stripBasmala, double fontSize) {
    List<InlineSpan> spans = [];
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    for (int i = 0; i < ayahs.length; i++) {
      var ayah = ayahs[i];
      String text = ayah['text'] ?? '';
      final verseNumber = ayah['numberInSurah'];

      if (i == 0 && stripBasmala) {
        if (text.startsWith(_basmalaText)) {
          text = text.substring(_basmalaText.length).trim();
        } else if (text.startsWith("بِسْمِ")) {
          text = text.replaceFirst(_basmalaText, "").trim();
        }
      }

      if (!(text.isEmpty && i == 0 && stripBasmala)) {
        spans.addAll(getTajweed(text, context, fontSize));
      }

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SizedBox(
              width: fontSize + 6,
              height: fontSize + 6,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).dividerColor, width: 1),
                    ),
                  ),
                  Text(
                    '$verseNumber',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize * 0.5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'UthmanicHafs',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return spans;
  }
}

class TajweedLegendWidget extends StatelessWidget {
  const TajweedLegendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;
    
    final List<Map<String, dynamic>> legendItems = [
      {'color': const Color(0xFFC23127), 'label': localizations.tajweed_prolonging},
      {'color': const Color(0xFF159346), 'label': localizations.tajweed_ghunna},
      {'color': const Color(0xFF054A96), 'label': localizations.tajweed_tafkhim},
      {'color': const Color(0xFF8A8A05), 'label': localizations.tajweed_qalqala},
      {'color': const Color(0xFFC1C1C1), 'label': localizations.tajweed_tarqiq},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12.0,
          children: legendItems.map((item) {
            return _buildLegendItem(
              context: context,
              color: item['color'] as Color,
              label: item['label'] as String,
              textColor: isDark ? Colors.white70 : Colors.black87,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLegendItem({required BuildContext context, required Color color, required String label, required Color textColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
