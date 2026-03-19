import 'package:ijaaz_app/models/tajweed_rule.dart';
import 'package:ijaaz_app/models/tajweed_subrule.dart';
import 'package:ijaaz_app/models/tajweed_token.dart';
import 'package:ijaaz_app/models/tajweed_word.dart';

class Tajweed {
  static const LAFZATULLAH_STR =
      r'(?<LAFZATULLAH>(\u0627|\u0671)?\u0644\p{M}*\u0644\u0651\p{M}*\u0647\p{M}*(' +
          smallHighLetters +
          r'?\u0020|$))';

  static const smallHighLetters =
      r'(\u06DA|\u06D6|\u06D7|\u06D8|\u06D9|\u06DB|\u06E2|\u06ED)';
  static const optionalSmallHighLetters = '$smallHighLetters?';
  static const smallHighLettersBetweenWords = smallHighLetters + r'?\u0020*';
  static const fathaKasraDammaWithoutTanvin = r'(\u064F|\u064E|\u0650)';

  static const fathaKasraDammaWithTanvin =
      r'(\u064B|\u064C|\u064D|\u08F0|\u08F1|\u08F2)';

  static const fathaKasraDammaWithOrWithoutTanvin = r'(' +
      fathaKasraDammaWithoutTanvin +
      r'|' +
      fathaKasraDammaWithTanvin +
      r')';

  static const shadda = r'\u0651';

  static const fathaKasraDammaWithTanvinWithOptionalShadda =
      r'(\u0651?' + fathaKasraDammaWithTanvin + r'\u0651?)';

  static const nonReadingCharactersAtEndOfWord =
      r'(\u0627|\u0648|\u0649|\u06E5)?'; //Alif, Ya or Vav

  static const higherOrLowerMeem = r'(\u06E2|\u06ED)';

  static const sukoonWithoutGrouping = r'\u0652|\u06E1|\u06DF';
  static const sukoon = '($sukoonWithoutGrouping)';
  static const optionalSukoon = r'(\u0652|\u06E1)?';
  static const noonWithOptionalSukoon = r'(\u0646' + optionalSukoon + r')';

  static const meemWithOptionalSukoon = r'(\u0645' + optionalSukoon + r')';

  static const throatLetters =
      r'(\u062D|\u062E|\u0639|\u063A|\u0627|\u0623|\u0625|\u0647)';
  static const throatLettersWithoutExtensionAlef =
      r'(\u062D|\u062E|\u0639|\u063A|\u0627\p{M}*\p{L}|\u0623|\u0625|\u0647)';

  static const ghunna = r'(?<ghunna>(\u0645|\u0646)\u0651\p{M}*)';

  static const ikhfaaLetters =
      r'(\u0638|\u0641|\u0642|\u0643|\u062A|\u062B|\u062C|\u062F|\u0630|\u0632|\u0633|\u0634|\u0635|\u0636|\u0637)\p{M}*';

  static const ikhfaa_noonSakinAndTanweens =
      r'((?<ikhfaa_noonSakinAndTanweens>' +
          noonWithOptionalSukoon +
          r'|(\p{L}' +
          fathaKasraDammaWithTanvinWithOptionalShadda +
          r'))' +
          nonReadingCharactersAtEndOfWord +
          smallHighLettersBetweenWords +
          ikhfaaLetters +
          r')';

  static const ikhfaa_meemSakin = r'(?<ikhfaa_meemSakin>' +
      meemWithOptionalSukoon +
      smallHighLettersBetweenWords +
      r'\u0628\p{M}*)';

  static const ikhfaa = '$ikhfaa_noonSakinAndTanweens|$ikhfaa_meemSakin';

  static const idghamWithGhunna_noonSakinAndTanweens =
      r'(?<idghamWithGhunna_noonSakinAndTanweens>(' +
          noonWithOptionalSukoon +
          r'|(\p{L}' +
          fathaKasraDammaWithTanvinWithOptionalShadda +
          nonReadingCharactersAtEndOfWord +
          r'))' +
          smallHighLettersBetweenWords +
          r'(\u064A|\u06CC|\u0645|\u0646|\u0648)\p{M}*)';

  static const idghamWithGhunna_meemSakin = r'(?<idghamWithGhunna_meemSakin>(' +
      meemWithOptionalSukoon +
      smallHighLettersBetweenWords +
      r'\u0645\p{M}*\u0651\p{M}*))';

  static const idghamWithGhunna =
      '$idghamWithGhunna_noonSakinAndTanweens|$idghamWithGhunna_meemSakin';

  static const idghamWithoutGhunna_noonSakinAndTanweens =
      r'((?<idghamWithoutGhunna_noonSakinAndTanweens>((\u0646(\u0652|\u06E1)?)|\p{L}' +
          fathaKasraDammaWithTanvinWithOptionalShadda +
          nonReadingCharactersAtEndOfWord +
          r'))' +
          smallHighLettersBetweenWords +
          r'(\u0644|\u0631)\p{M}*)';

  static const idghamWithoutGhunna_shamsiyya =
      r'((\u0627|\u0671)(?<idghamWithoutGhunna_shamsiyya>\u0644)\p{L}\u0651\p{M}*)';

  static const idghamWithoutGhunna_misleyn =
      r'(?<idghamWithoutGhunna_misleyn>(?:(?!\u0645)(\p{L})))\u0020*\2\u0651'; //exclude (meem) as it has its own rule.

  static const idghamWithoutGhunna_mutajaniseyn_1 =
      r'(?<idghamWithoutGhunna_mutajaniseyn_1>[\u0637\u062F\u062A]' +
          optionalSukoon +
          optionalSmallHighLetters +
          r')\u0020*(?!\1)([\u0637\u062F\u062A]' +
          shadda +
          r')';
  static const idghamWithoutGhunna_mutajaniseyn_2 =
      r'(?<idghamWithoutGhunna_mutajaniseyn_2>[\u0638\u0630\u062B]' +
          optionalSukoon +
          optionalSmallHighLetters +
          r')\u0020*(?!\1)([\u0638\u0630\u062B]' +
          shadda +
          r')';
  static const idghamWithoutGhunna_mutajaniseyn_3 =
      r'(?<idghamWithoutGhunna_mutajaniseyn_3>[\u0628\u0645]' +
          optionalSukoon +
          optionalSmallHighLetters +
          r')\u0020*(?!\1)([\u0628\u0645]' +
          shadda +
          r')';

  static const idghamWithoutGhunna_mutagaribeyn_1 =
      r'(?<idghamWithoutGhunna_mutagaribeyn_1>[\u0642\u0643]' +
          optionalSukoon +
          optionalSmallHighLetters +
          r')\u0020*(?!\1)([\u0642\u0643]' +
          shadda +
          r')';
  static const idghamWithoutGhunna_mutagaribeyn_2 =
      r'(?<idghamWithoutGhunna_mutagaribeyn_2>[\u0646\u0644\u0631]' +
          optionalSukoon +
          optionalSmallHighLetters +
          r')\u0020*(?!\1)([\u0646\u0644\u0631]' +
          shadda +
          r')';

  static const idghamWithoutGhunna =
      '$idghamWithoutGhunna_noonSakinAndTanweens|$idghamWithoutGhunna_shamsiyya';

  static const iqlab_noonSakinAndTanweens =
      r'(?<iqlab_noonSakinAndTanweens>\p{L}\p{M}*(\u06E2|\u06ED))';

  static const izhar_noonSakinAndTanweens = r'((?<izhar_noonSakinAndTanweens>' +
      noonWithOptionalSukoon +
      r'|(\p{L}' +
      fathaKasraDammaWithTanvin +
      r'))\u0020*?' +
      throatLettersWithoutExtensionAlef +
      r')';

  static const qalqala =
      r'(?<qalqala>((\u0642|\u0637|\u0628|\u062C|\u062F)\u0651?(\u0652|\u06E1|(' +
          fathaKasraDammaWithOrWithoutTanvin +
          r'?' +
          smallHighLetters +
          r'?' +
          r')$)))';

  static const followingExtensionByTwo =
      '$smallHighLetters?' r'((?!(\p{M}|\u0020\u0671)))';
  //Aleef
  static const prolonging_byTwo_1_1 =
      r'(\u064E(?<prolonging_byTwo_1_1>\u0627)' +
          followingExtensionByTwo +
          r')';
  //Tatweel + Aleef
  static const prolonging_byTwo_1_2 =
      r'(\u064E(?<prolonging_byTwo_1_2>\p{L}\u0670)' +
          followingExtensionByTwo +
          r')';

  //Alef with word joiners
  static const prolonging_byTwo_1_3 =
      r'(\u064E(?<prolonging_byTwo_1_3>\u200A?\u0670\u2060?)' +
          followingExtensionByTwo +
          r')';

  //Vav
  static const prolonging_byTwo_2 =
      r'(\u064F(?<prolonging_byTwo_2>(\u0648|\u06E5))' +
          followingExtensionByTwo +
          r')';

  //Ye
  static const prolonging_byTwo_3_1 =
      r'(\u0650(?<prolonging_byTwo_3_1>(\u064A|\u06CC|\u06E6|\u06E7))' +
          followingExtensionByTwo +
          r')';
  //Tatweel + small high Ye. Surat Al Baqara 61. (ٱلنَّبِیِّـۧنَ)
  static const prolonging_byTwo_3_2 =
      r'((?<prolonging_byTwo_3_2>\u0640\u06E7)' +
          followingExtensionByTwo +
          r')';
  static const prolonging_byTwo_3 =
      '$prolonging_byTwo_3_1|$prolonging_byTwo_3_2';

  static const prolonging_lin =
      r'(\u064E(?<prolonging_lin>(\u0648|\u06E5\u064A|\u06CC)' +
          optionalSukoon +
          r')\p{L}\p{M}*' +
          smallHighLetters +
          r'?$)';

  static const prolonging_ivad =
      r'((\u064B|\u08F0|\u0654\u06E2|\u064E\u06E2)(?<prolonging_ivad>\u0627' +
          smallHighLetters +
          r'?)($|\u0020))';

  static const extensionByTwo =
      '$prolonging_byTwo_1_1|$prolonging_byTwo_1_2|$prolonging_byTwo_1_3|$prolonging_byTwo_2|$prolonging_byTwo_3|$prolonging_lin|$prolonging_ivad';

  static const maddLetters =
      r'(\p{L}?\u200A?\u0670|\u0627|\u0622|\u0648|\u06E5|\u064A|\u06CC|\u06E6|\u06E7)';
  static const hamza = r'\u0621';
  static const hamzaVariations =
      r'(\u0621|\u0623|\u0624|\u0625|\u0626|\u0649\u0655|\u0648\u0654|\u0627\u0654|\u0654|\u0655)';

  static const prolonging_muttasil = r'((?<prolonging_muttasil>' +
      maddLetters +
      r'\u2060?\u06E4?)'
          r'\u0640?'
          '$hamzaVariations[^$sukoonWithoutGrouping]' //burada sukun gelerse uzatma olur ya yox. mes: Beqere 72
          r')';

  static const prolonging_munfasil_1 = r'((?<prolonging_munfasil_1>' +
      maddLetters +
      r'\u06E4?' +
      smallHighLetters +
      r'?)(\u0627' +
      sukoon +
      r')?\u0020' +
      hamzaVariations +
      r')';

  static const prolonging_munfasil_2 =
      r'((?<prolonging_munfasil_2>' + maddLetters + r'\u06E4)$)';

  static const prolonging_munfasil =
      '$prolonging_munfasil_1|$prolonging_munfasil_2';

  static const prolonging_lazim_1 = r'((?<prolonging_lazim_1>' +
      maddLetters +
      r'\u06E4?)\p{L}' +
      shadda +
      r')';

  static const prolonging_lazim_2 =
      r'(\u0621\u064E(?<prolonging_lazim_2>\u0627\u06E4)\u0644(\u06E1|\u0652))';

  static const prolonging_lazim_3 = r'(?<prolonging_lazim_3>\p{L}\u06E4)';

  static const extensionBySix = '$prolonging_lazim_1|$prolonging_lazim_2';

  static const alefTafreeq = r'(((\u0648|\u06E5)\p{M}*)(?<alefTafreeq>\u0627' +
      sukoon +
      smallHighLetters +
      r'?))';

  static const hamzatulWasli = r'([^^](?<hamzatulWasli>\u0671))';

  static const allRulesStr = [
    LAFZATULLAH_STR,
    izhar_noonSakinAndTanweens,
    ikhfaa,
    idghamWithGhunna,
    iqlab_noonSakinAndTanweens,
    qalqala,
    ghunna,
    idghamWithoutGhunna,
    idghamWithoutGhunna_misleyn,
    idghamWithoutGhunna_mutajaniseyn_1,
    idghamWithoutGhunna_mutajaniseyn_2,
    idghamWithoutGhunna_mutajaniseyn_3,
    idghamWithoutGhunna_mutagaribeyn_1,
    idghamWithoutGhunna_mutagaribeyn_2,
    prolonging_muttasil,
    prolonging_munfasil,
    extensionBySix,
    extensionByTwo,
    alefTafreeq,
    hamzatulWasli,
  ];

  static final List<RegExp> _cachedRegExps = allRulesStr.map((s) => RegExp(s, unicode: true)).toList();
  static final RegExp _muqattaRegExp = RegExp(prolonging_lazim_3, unicode: true);

  static List<TajweedWord> tokenizeAsWords(String AyaText, int sura, int aya) {
    return tokensToWords(tokenize(AyaText, sura, aya));
  }

  static List<TajweedToken> tokenize(String AyaText, int sura, int aya) {
    List<TajweedToken> results = [];
    for (var regexp in _cachedRegExps) {
      results.addAll(tokenizeByRule(regexp, AyaText));
    }

    final muqattaEnd = isMuqattaAya(sura, aya);
    if (muqattaEnd > -1) {
      results.addAll(tokenizeByRule(
        _muqattaRegExp,
        muqattaEnd == 0 ? AyaText : AyaText.substring(0, muqattaEnd),
      ));
    }

    removeIdghamIfNecessary(AyaText, sura, aya, results);

    if (results.isEmpty) {
      return [TajweedToken(TajweedRule.none, null, null, AyaText, 0, AyaText.length, null)];
    }

    results.sort();

    bool hasDeletions = true;
    while (hasDeletions) {
      hasDeletions = false;
      for (int i = results.length - 1; i > 0; --i) {
        final item = results[i];
        final prevItem = results[i - 1];
        if (prevItem.endIx > item.startIx) {
          if (item.rule.priority < prevItem.rule.priority) results.removeAt(i - 1);
          else results.removeAt(i);
          hasDeletions = true;
        }
      }
    }

    List<TajweedToken> nonTajweed = [];
    if (results.first.startIx > 0) {
      nonTajweed.add(TajweedToken(TajweedRule.none, null, null, AyaText.substring(0, results.first.startIx), 0, results.first.startIx, null));
    }
    for (int i = 0; i < results.length - 1; ++i) {
      if (results[i+1].startIx - results[i].endIx > 0) {
        nonTajweed.add(TajweedToken(TajweedRule.none, null, null, AyaText.substring(results[i].endIx, results[i+1].startIx), results[i].endIx, results[i+1].startIx, null));
      }
    }
    if (results.last.endIx < AyaText.length) {
      nonTajweed.add(TajweedToken(TajweedRule.none, null, null, AyaText.substring(results.last.endIx), results.last.endIx, AyaText.length, null));
    }

    if (nonTajweed.isNotEmpty) { results.addAll(nonTajweed); results.sort(); }
    return results;
  }

  static List<TajweedWord> tokensToWords(List<TajweedToken> tokens) {
    final space = RegExp('\u0020', unicode: true);
    final list = <TajweedToken>[];
    for (final token in tokens) {
      final parts = token.text.split(space);
      var atIx = token.startIx;
      for (int i = 0; i < parts.length; ++i) {
        var part = parts[i];
        list.add(TajweedToken(token.rule, token.subrule, token.subruleSubindex, part, atIx, atIx + part.length, token.matchGroup));
        if (i < parts.length - 1) {
          list.add(TajweedToken(TajweedRule.none, null, null, ' ', atIx + part.length, atIx + part.length + 1, null));
          atIx += part.length + 1;
        } else { atIx += part.length; }
      }
    }
    final results = <TajweedWord>[];
    var word = TajweedWord();
    for (final token in list) {
      if (token.text == '\u0020') { results.add(word); word = TajweedWord(); }
      else { word.tokens.add(token); }
    }
    if (word.tokens.isNotEmpty) results.add(word);
    return results;
  }

  static List<TajweedToken> tokenizeByRule(RegExp regexp, String Aya) {
    final results = <TajweedToken>[];
    var matches = regexp.allMatches(Aya);
    for (final m in matches) {
      for (final groupName in m.groupNames) {
        final groupValue = m.namedGroup(groupName);
        if (groupValue == null) continue;
        var matchStart = m.start;
        var matchEnd = m.start + groupValue.length;
        if (["ikhfaa_meemSakin","izhar_gamariyya","idghamWithoutGhunna_shamsiyya","prolonging_byTwo_1_1","prolonging_byTwo_1_2","prolonging_byTwo_1_3","prolonging_byTwo_2","prolonging_byTwo_3_1","prolonging_lin","prolonging_ivad","prolonging_lazim_2","alefTafreeq","hamzatulWasli","marsoomKhilafLafzi"].contains(groupName)) {
          final lastPartIx = Aya.substring(m.start, m.end).indexOf(groupValue);
          matchStart = m.start + lastPartIx;
          matchEnd = matchStart + groupValue.length;
        }
        final groupNameParts = groupName.split('_');
        results.add(TajweedToken(
          TajweedRule.values.byName(groupNameParts[0]),
          groupNameParts.length > 1 ? TajweedSubrule.values.byName(groupNameParts[1]) : null,
          groupNameParts.length > 2 ? int.parse(groupNameParts[2]) : null,
          Aya.substring(matchStart, matchEnd), matchStart, matchEnd, groupName,
        ));
        break;
      }
    }
    return results;
  }

  static void removeIdghamIfNecessary(String AyaText, int sura, int aya, List<TajweedToken> tokens) {
    final dunya = RegExp(r'\u062F\u0651?\u064F\u0646\u06E1\u06CC\u064E\u0627', unicode: true);
    var dunyaIndex = AyaText.indexOf(dunya);
    while (dunyaIndex != -1) {
      tokens.removeWhere((t) => t.rule == TajweedRule.idghamWithGhunna && t.startIx > dunyaIndex && t.startIx < dunyaIndex + 10);
      dunyaIndex = AyaText.indexOf(dunya, dunyaIndex + 1);
    }
  }

  static int isMuqattaAya(int sura, int aya) {
    if (aya != 1) return -1;
    switch (sura) {
      case 2: case 3: case 7: case 19: case 20: case 26: case 28: case 29: case 30: case 31: case 32: case 36: case 40: case 41: case 42: case 43: case 44: case 45: case 46: return 0;
      case 10: case 11: case 12: return 6;
      case 13: return 8;
      case 14: case 15: return 6;
      case 27: return 5;
      case 38: case 50: case 68: return 4;
      default: return -1;
    }
  }
}
