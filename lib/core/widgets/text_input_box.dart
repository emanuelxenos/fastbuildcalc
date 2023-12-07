import 'package:flutter/material.dart';

class TextInputBox extends StatelessWidget {
  final TextEditingController? contoller;
  final String? labelText;
  final int? maxLengthNumber;
  final TextInputType? keyboardType;
  final ValueChanged? onChange;

  const TextInputBox({
    super.key,
    this.contoller,
    this.onChange,
    this.keyboardType,
    this.labelText,
    this.maxLengthNumber,
  });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    );
    return TextField(
      controller: contoller,
      onChanged: onChange,
      maxLength: maxLengthNumber,
      keyboardType: keyboardType ?? TextInputType.number,
      decoration: InputDecoration(
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        label: labelText == null ? const Text('') : Text(labelText!),
      ),
    );
  }
}
