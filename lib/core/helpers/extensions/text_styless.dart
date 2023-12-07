import 'package:flutter/material.dart';

class TextStyless {
  static TextStyless? _instance;
  // Avoid self instance
  TextStyless._();
  static TextStyless get instance => _instance ??= TextStyless._();

  TextStyle get lightText => const TextStyle(color: Colors.white);

  TextStyle get boldText => lightText.copyWith(fontWeight: FontWeight.bold);

  TextStyle get title => boldText.copyWith(color: Colors.white, fontSize: 20);
}

extension TextStylessExtension on BuildContext {
  TextStyless get textStyless => TextStyless.instance;
}
