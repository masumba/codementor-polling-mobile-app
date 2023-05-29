import 'package:flutter/material.dart';

/// Utility class to provide screen-related values and spacing widgets
class ScreenUtil {
  /// Constant widgets for horizontal spacing
  static const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
  static const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
  static const Widget horizontalSpaceNormal = SizedBox(width: 15.0);
  static const Widget horizontalSpaceMedium = SizedBox(width: 25.0);

  /// Constant widgets for vertical spacing
  static const Widget verticalSpaceTiny = SizedBox(height: 5.0);
  static const Widget verticalSpaceSmall = SizedBox(height: 10.0);
  static const Widget verticalSpaceNormal = SizedBox(height: 15.0);
  static const Widget verticalSpaceMedium = SizedBox(height: 25.0);
  static const Widget verticalSpaceLarge = SizedBox(height: 50.0);
  static const Widget verticalSpaceMassive = SizedBox(height: 120.0);

  /// Spaced divider widget, adds vertical spacing above and below the divider
  static Widget spacedDivider = Column(
    children: const <Widget>[
      verticalSpaceMedium,
      Divider(color: Colors.blueGrey, height: 5.0),
      verticalSpaceMedium,
    ],
  );

  /// Small spaced divider widget, doesn't add vertical spacing around the divider
  static Widget spacedDividerSmall = Column(
    children: const <Widget>[
      Divider(color: Colors.blueGrey),
    ],
  );

  static Widget divider({Color color = Colors.blueGrey}) => Column(
        children: <Widget>[
          Divider(color: color),
        ],
      );

  /// Returns a vertical space widget with a specific height
  static Widget verticalSpace(double height) => SizedBox(height: height);

  /// Returns the current screen padding, useful for layout calculations
  static EdgeInsets screenPadding(BuildContext context) =>
      MediaQuery.of(context).viewPadding;

  /// Returns the current screen width
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Returns the current screen height, optionally subtracting the height
  /// of the safe area and toolbar.
  static double screenHeight(
    BuildContext context, {
    bool withoutStatusSafeAreaAndToolbar = false,
    bool withoutSafeArea = false,
    bool withoutStatusBar = false,
    bool withoutStatusAndToolbar = false,
  }) {
    double resultHeight = MediaQuery.of(context).size.height;
    if (withoutSafeArea) {
      resultHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top -
          MediaQuery.of(context).viewPadding.bottom;
    }

    if (withoutStatusBar) {
      resultHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top;
    }
    if (withoutStatusAndToolbar) {
      resultHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top -
          kToolbarHeight;
    }
    if (withoutStatusSafeAreaAndToolbar) {
      resultHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewPadding.top -
          MediaQuery.of(context).viewPadding.bottom -
          kToolbarHeight;
    }

    return resultHeight;
  }

  /// Returns a fraction of the screen height, optionally subtracting a specific offset
  static double screenHeightFraction(BuildContext context,
          {int dividedBy = 1, double offsetBy = 0}) =>
      (screenHeight(context) - offsetBy) / dividedBy;

  /// Returns a fraction of the screen width, optionally subtracting a specific offset
  static double screenWidthFraction(BuildContext context,
          {int dividedBy = 1, double offsetBy = 0}) =>
      (screenWidth(context) - offsetBy) / dividedBy;

  /// Returns half the screen width
  static double halfScreenWidth(BuildContext context) =>
      screenWidthFraction(context, dividedBy: 2);

  /// Returns a third of the screen width
  static double thirdScreenWidth(BuildContext context) =>
      screenWidthFraction(context, dividedBy: 3);

  /// Returns the screen's aspect ratio
  static double screenAspectRatio(BuildContext context) =>
      MediaQuery.of(context).size.aspectRatio;
}
