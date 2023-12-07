import 'package:flutter/material.dart';
import 'package:xenoscalculadoram2/core/helpers/extensions/text_styless.dart';

class TextEditable extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  // final VoidCallback onChange;
  const TextEditable({
    super.key,
    this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(1),
        fillColor: Color(0xff7437bc),
      ),
      style: context.textStyless.lightText,
    );
  }
}
