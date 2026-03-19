import 'package:flutter/material.dart';

enum TajweedRule {
  LAFZATULLAH(1,
      color: Colors.green, darkThemeColor: Color.fromRGBO(129, 199, 132, 1)),

  izhar(2,
      color: Color.fromARGB(255, 6, 176, 182),
      darkThemeColor: Color.fromARGB(255, 111, 240, 245)),

  ikhfaa(3,
      color: Color(0xFFB71C1C),
      darkThemeColor: Color.fromARGB(255, 250, 68, 68)),

  idghamWithGhunna(4, color: Color(0xFFF06292)),

  iqlab(5, color: Colors.blue),

  qalqala(6,
      color: Color.fromARGB(255, 123, 143, 10),
      darkThemeColor: Color.fromARGB(255, 214, 240, 70)),

  idghamWithoutGhunna(7, color: Colors.grey),

  ghunna(8, color: Colors.orange),

  prolonging(9,
      color: Color.fromARGB(255, 142, 100, 214),
      darkThemeColor: Color.fromARGB(255, 191, 165, 236)),

  alefTafreeq(10, color: Colors.grey),
  hamzatulWasli(11, color: Colors.grey),
  //marsoomKhilafLafzi(12, color: Colors.grey),

  none(100, color: null);

  const TajweedRule(this.priority,
      {required Color? color, Color? darkThemeColor})
      : _color = color,
        _darkThemeColor = darkThemeColor;

  final int priority;
  final Color? _color;
  final Color? _darkThemeColor;

  Color? color(BuildContext context) {
    if (_darkThemeColor == null) {
      return _color;
    }

    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return isDarkTheme ? _darkThemeColor : _color;
  }
}
