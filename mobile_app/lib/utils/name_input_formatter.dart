import 'package:flutter/services.dart';

class NameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      TextEditingValue textEditingValue = newValue.copyWith(
        text: newValue.text.replaceAll(RegExp(r"\s+"), ' ').trim(),
      );

      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;

      if (selectionIndexFromTheRight < 0) {
        selectionIndexFromTheRight = 0;
      }

      return TextEditingValue(
        text: textEditingValue.text,
        selection: TextSelection.collapsed(
          offset: textEditingValue.text.length - selectionIndexFromTheRight,
        ),
      );
    }

    return newValue;
  }
}
