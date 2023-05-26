import 'package:flutter/services.dart';
import 'package:remove_emoji/remove_emoji.dart';

class EmojiRemoverInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else {
      try {
        final int selectionIndexFromTheRight =
            newValue.text.length - newValue.selection.end;
        var remove = RemoveEmoji();
        final newString = remove.removemoji(newValue.text, '', false);

        return TextEditingValue(
          text: newString,
          selection: TextSelection.collapsed(
              offset: newString.length - selectionIndexFromTheRight),
        );
      } catch (e) {
        return newValue;
      }
    }
  }
}
