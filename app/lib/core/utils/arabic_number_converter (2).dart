// lib/presentation/pages/arabic_number_converter.dart
extension ArabicNumbers on int {
  String toArabicDigits() {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var str = toString();
    for (var i = 0; i < 10; i++) {
      str = str.replaceAll(english[i], arabic[i]);
    }
    return str;
  }
}

extension StringArabicNumbers on String {
  String toArabicDigits() {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var str = this;
    for (var i = 0; i < 10; i++) {
      str = str.replaceAll(english[i], arabic[i]);
    }
    return str;
  }
}