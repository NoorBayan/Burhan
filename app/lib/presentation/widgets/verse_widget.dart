import 'package:flutter/material.dart';
import 'package:ijaaz_app/application/tajweed.dart';
import 'package:ijaaz_app/models/tajweed_rule.dart';
import 'package:ijaaz_app/models/tajweed_token.dart';

// A top-level function to get tajweed rules
List<TextSpan> getTajweedSpans(String text, BuildContext context, TextStyle baseStyle) {
  final List<TajweedToken> tokens = Tajweed.tokenize(text, 1, 1);
  return tokens.map((token) {
    final TajweedRule rule = token.rule;
    final color = rule.color(context) ?? baseStyle.color;
    return TextSpan(
      text: token.text,
      style: baseStyle.copyWith(color: color),
    );
  }).toList();
}

class VerseWidget extends StatelessWidget {
  final String text;
  final int verseNumber;
  final TextStyle textStyle;

  const VerseWidget({
    Key? key,
    required this.text,
    required this.verseNumber,
    this.textStyle = const TextStyle(fontSize: 22, color: Colors.black, height: 2.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tajweedSpans = getTajweedSpans(text, context, textStyle);

    final BoxDecoration verseDecoration = BoxDecoration(
      shape: BoxShape.circle,
      border: Border.fromBorderSide(
        BorderSide(color: Colors.amber.shade800, width: 1),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: RichText(
        textAlign: TextAlign.justify,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          style: textStyle.copyWith(fontFamily: 'UthmanicHafs'),
          children: [
            ...tajweedSpans,
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: verseDecoration,
                child: Text(
                  '$verseNumber',
                  style: TextStyle(
                    fontFamily: 'Kitab',
                    fontSize: 12,
                    color: Colors.amber.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
