import 'package:flutter/material.dart';
import '../../utils/my_color.dart';

ThemeData lightThemeData = ThemeData.light().copyWith(
  primaryColor: const Color.fromRGBO(81, 78, 183, 1),
  primaryColorDark: MyColor.primaryColor,
  secondaryHeaderColor: Colors.yellow,

  // Define the default brightness and colors.
  scaffoldBackgroundColor: MyColor.screenBgColor,

  colorScheme: ColorScheme.fromSeed(
    seedColor: MyColor.primaryColor,
    brightness: Brightness.light,
  ),

  drawerTheme: const DrawerThemeData(
    backgroundColor: MyColor.screenBgColor,
    surfaceTintColor: MyColor.transparentColor,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 57,
      fontWeight: FontWeight.bold,
      color: MyColor.titleColor,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 45,
      fontWeight: FontWeight.normal,
      color: MyColor.colorBlack,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: MyColor.colorBlack,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: MyColor.colorBlack,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: MyColor.colorBlack,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 41,
      fontWeight: FontWeight.normal,
      color: MyColor.colorBlack,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: MyColor.colorBlack,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 28,
      fontWeight: FontWeight.w500,
      color: MyColor.colorBlack,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: MyColor.colorBlack,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: MyColor.colorBlack,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: MyColor.colorBlack,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: MyColor.colorBlack,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: MyColor.colorBlack,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: MyColor.bodyText,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Noto-sans',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: MyColor.bodyText,
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: MyColor.primaryColor,
    selectionColor: MyColor.primaryColor,
    selectionHandleColor: MyColor.primaryColor,
  ),
  bannerTheme: MaterialBannerThemeData(
    backgroundColor: MyColor.primaryColor.withValues(alpha: .1),
  ),
  splashColor: MyColor.primaryColor,
  //Bottom Navbar
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: MyColor.colorWhite,
    selectedItemColor: MyColor.primaryColor,
    unselectedItemColor: MyColor.colorWhite,
  ),
  inputDecorationTheme: const InputDecorationTheme(),
);

String googleMapLightStyleJson = '''

''';
