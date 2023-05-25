import 'package:flutter/material.dart';

class SharedStyleUtil {
  static BoxDecoration fieldDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(5), color: Colors.grey[200]);

  static BoxDecoration disabledFieldDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(5), color: Colors.grey[100]);
// Field Variables
  static const double fieldHeight = 55;
  static const double smallFieldHeight = 40;
  static const double inputFieldBottomMargin = 30;
  static const double inputFieldSmallBottomMargin = 0;
  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(horizontal: 15);
  static const EdgeInsets largeFieldPadding =
      EdgeInsets.symmetric(horizontal: 15, vertical: 15);

// Text Variables
  static const TextStyle buttonTitleTextStyle =
      TextStyle(fontWeight: FontWeight.w700, color: Colors.white);

  static const TextStyle appBarTitleTextStyle =
      TextStyle(fontWeight: FontWeight.w700, color: Colors.black);
  static const TextStyle appBarSubTitleTextStyle =
      TextStyle(fontWeight: FontWeight.w400, color: Colors.black87);
}
