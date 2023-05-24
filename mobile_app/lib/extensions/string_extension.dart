import 'package:flutter/material.dart';

/// Converts the provided [text] into Title Case format
/// e.g "hello world" becomes "Hello World"
///
/// If the text length is less than or equal to 1, the function
/// simply returns the uppercase of the text.
///
/// [text] : The string which needs to be converted to Title Case
String _convertToTitleCase(String text) {
  if (text.length <= 1) {
    return text.toUpperCase();
  }

  /// Split string into multiple words
  final List<String> words = text.split(' ');

  /// Capitalize first letter of each words
  final capitalizedWords = words.map((word) {
    final String firstLetter = word.substring(0, 1).toUpperCase();
    final String remainingLetters = word.substring(1);

    return '$firstLetter$remainingLetters';
  });

  /// Join/Merge all words back to one String
  return capitalizedWords.join(' ');
}

/// Extension on String Class, provides additional functions.
extension CapitalizedStringExtension on String {
  /// Returns the String in Title Case format using the function [_convertToTitleCase]
  String toTitleCase() {
    return _convertToTitleCase(this);
  }

  /// Converts a color represented as a hex string into a Color object.
  ///
  /// This method handles strings in the form "#FFFFFF" and "FFFFFF"
  /// and prefixes the color with "FF" opacity if the string does not contain opacity.
  ///
  /// [returns] : A Color object representation of the Hex color string.
  Color toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
