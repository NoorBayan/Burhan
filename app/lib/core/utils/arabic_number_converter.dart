extension ArabicNumberConverter on Object {
  static const Map<String, String> _arabicDigits = <String, String>{
    '0': '\u0660',
    '1': '\u0661',
    '2': '\u0662',
    '3': '\u0663',
    '4': '\u0664',
    '5': '\u0665',
    '6': '\u0666',
    '7': '\u0667',
    '8': '\u0668',
    '9': '\u0669',
  };

  String toArabicDigits() {
    final String str = toString();
    final StringBuffer sb = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      sb.write(_arabicDigits[str[i]] ?? str[i]);
    }
    return sb.toString();
  }
}
