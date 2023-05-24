import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/constants/app_color.dart';
import 'package:mobile_app/extensions/string_extension.dart';

class AppTheme {
  static ThemeData defaultTheme() {
    return ThemeData.light().copyWith(
      primaryColor: AppColor.primaryColor.toColor(),
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.primaryColor.toColor(),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      iconTheme: IconThemeData(
        size: 25.0,
        color: AppColor.primaryColor.toColor(),
      ),
      textTheme:
          GoogleFonts.dmSansTextTheme().apply(displayColor: Colors.black),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // For Android
          statusBarIconBrightness: Brightness.dark,
          // For iOS.
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.white,
      ),
    );
  }
}
