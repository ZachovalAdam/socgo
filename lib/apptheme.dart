import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Map<int, Color> brandingPrimaryLuminance = {
    50: Color.fromRGBO(224, 21, 59, .1),
    100: Color.fromRGBO(224, 21, 59, .2),
    200: Color.fromRGBO(224, 21, 59, .3),
    300: Color.fromRGBO(224, 21, 59, .4),
    400: Color.fromRGBO(224, 21, 59, .5),
    500: Color.fromRGBO(224, 21, 59, .6),
    600: Color.fromRGBO(224, 21, 59, .7),
    700: Color.fromRGBO(224, 21, 59, .8),
    800: Color.fromRGBO(224, 21, 59, .9),
    900: Color.fromRGBO(224, 21, 59, 1),
  };

  static const MaterialColor brandingPrimaryMaterial = MaterialColor(0xff3B84F0, brandingPrimaryLuminance);

  static const Color brandingPrimary = Color(0xffE0153B);

  static const Color brandingBackgroundDark = Color(0xff121212);

  static const Color brandingSurfaceLight = Color(0xffF8F9FE);
  static const Color brandingSurfaceDark = Color(0xff222020);

  static final ThemeData lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.white,
    dialogTheme: DialogTheme(
      backgroundColor: brandingSurfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
    ),
    accentColor: brandingPrimary,
    appBarTheme: const AppBarTheme(
      brightness: Brightness.light,
      color: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      elevation: 0,
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontWeight: FontWeight.w500, fontFamily: "Inter")),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0.0),
        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
        backgroundColor: MaterialStateProperty.all<Color>(brandingPrimary),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontFamily: "Inter")),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: brandingPrimary,
      //onPrimary: Colors.white,
      primaryVariant: brandingPrimary,
      secondary: Colors.blue.shade200,
      background: Colors.white,
    ),
    cardTheme: CardTheme(
      color: brandingSurfaceLight,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    cursorColor: Colors.black,
    dividerColor: const Color(0xffe9e9e9),
    fontFamily: 'Inter',
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(width: 0, color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(width: 0, color: Colors.transparent),
      ),
      contentPadding: EdgeInsets.all(15),
      labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 16.0),
      border: InputBorder.none,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
      ),
      fillColor: brandingSurfaceLight,
      filled: true,
    ),
    primarySwatch: brandingPrimaryMaterial,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: brandingSurfaceLight,
      actionTextColor: Colors.black,
      contentTextStyle: TextStyle(
        color: Colors.black,
      ),
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      headline4: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      headline5: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      headline6: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      subtitle1: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      subtitle2: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      caption: TextStyle(
        color: Color(0xff606060),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: brandingBackgroundDark,
    dialogTheme: DialogTheme(
      backgroundColor: brandingSurfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
    ),
    accentColor: brandingPrimary,
    appBarTheme: const AppBarTheme(
      brightness: Brightness.dark,
      color: brandingBackgroundDark,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: brandingBackgroundDark,
      selectedItemColor: Colors.white,
      unselectedItemColor: Color(0xFF424242),
      elevation: 0,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontWeight: FontWeight.w500, fontFamily: "Inter")),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0.0),
        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
        backgroundColor: MaterialStateProperty.all<Color>(brandingPrimary),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontFamily: "Inter")),
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: brandingPrimary,
      //onPrimary: Colors.white,
      primaryVariant: brandingPrimary,
      secondary: Colors.blue.shade200,
      background: brandingBackgroundDark,
    ),
    cardTheme: CardTheme(
      color: brandingSurfaceDark,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    cursorColor: Colors.white,
    dividerColor: const Color(0xff141414),
    fontFamily: 'Inter',
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(width: 0, color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(width: 0, color: Colors.transparent),
      ),
      contentPadding: EdgeInsets.all(15),
      labelStyle: TextStyle(color: Color(0xFFA4A4A4), fontSize: 16.0),
      border: InputBorder.none,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
      ),
      fillColor: brandingSurfaceDark,
      filled: true,
    ),
    primarySwatch: brandingPrimaryMaterial,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: brandingSurfaceDark,
      actionTextColor: Colors.white,
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headline4: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headline5: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headline6: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      subtitle1: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      subtitle2: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      caption: TextStyle(
        color: Color(0xff828282),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
