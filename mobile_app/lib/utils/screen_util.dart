import 'package:flutter/material.dart';

class ScreenUtil {
  static const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
  static const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
  static const Widget horizontalSpaceNormal = SizedBox(width: 15.0);
  static const Widget horizontalSpaceMedium = SizedBox(width: 25.0);

  static const Widget verticalSpaceTiny = SizedBox(height: 5.0);
  static const Widget verticalSpaceSmall = SizedBox(height: 10.0);
  static const Widget verticalSpaceNormal = SizedBox(height: 15.0);
  static const Widget verticalSpaceMedium = SizedBox(height: 25.0);
  static const Widget verticalSpaceLarge = SizedBox(height: 50.0);
  static const Widget verticalSpaceMassive = SizedBox(height: 120.0);

  static Widget spacedDivider = Column(
    children: const <Widget>[
      verticalSpaceMedium,
      Divider(color: Colors.blueGrey, height: 5.0),
      verticalSpaceMedium,
    ],
  );

  static Widget spacedDividerSmall = Column(
    children: const <Widget>[
      Divider(color: Colors.blueGrey),
    ],
  );

  static Widget verticalSpace(double height) => SizedBox(height: height);

  static EdgeInsets screenPadding(BuildContext context) =>
      MediaQuery.of(context).viewPadding;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

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

  static double screenHeightFraction(BuildContext context,
          {int dividedBy = 1, double offsetBy = 0}) =>
      (screenHeight(context) - offsetBy) / dividedBy;

  static double screenWidthFraction(BuildContext context,
          {int dividedBy = 1, double offsetBy = 0}) =>
      (screenWidth(context) - offsetBy) / dividedBy;

  static double halfScreenWidth(BuildContext context) =>
      screenWidthFraction(context, dividedBy: 2);

  static double thirdScreenWidth(BuildContext context) =>
      screenWidthFraction(context, dividedBy: 3);

  static double screenAspectRatio(BuildContext context) =>
      MediaQuery.of(context).size.aspectRatio;
}
