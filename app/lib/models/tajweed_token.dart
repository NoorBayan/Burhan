import 'tajweed_rule.dart';
import 'tajweed_subrule.dart';

class TajweedToken implements Comparable<TajweedToken> {
  final TajweedRule rule;
  final TajweedSubrule? subrule;
  final int? subruleSubindex;

  final String? matchGroup;
  final String text;

  final int startIx;
  final int endIx;

  const TajweedToken(
      this.rule,
      this.subrule,
      this.subruleSubindex,
      this.text,
      this.startIx,
      this.endIx,
      this.matchGroup,
      );

  bool isRule() {
    return rule != TajweedRule.none;
  }

  bool isNotRule() {
    return rule == TajweedRule.none;
  }

  ///whether can break into parts after this rule
  ///for displaying in Tajweed view
  // bool get canBreakAfter =>
  //     text.endsWith(' ') &&
  //     text != ' ' &&
  //     (isNotRule() ||
  //         (rule == TajweedRule.iqlab ||
  //             rule == TajweedRule.qalqala ||
  //             (subrule != null &&
  //                 (subrule == TajweedSubrule.byTwo ||
  //                     subrule == TajweedSubrule.lin ||
  //                     subrule == TajweedSubrule.ivad ||
  //                     subrule == TajweedSubrule.muttasil))));
  bool get canBreakAfter => text.endsWith(' ');

  @override
  int compareTo(TajweedToken other) {
    if (startIx < other.startIx) {
      return -1;
    } else if (startIx > other.startIx) {
      return 1;
    }

    return 0;
  }

  @override
  String toString() {
    return 'TajweedToken{ from: $startIx to: $endIx group: $rule subrule: $subrule subindex: $subruleSubindex text: \'$text\' matchGroup: $matchGroup }';
  }
}
