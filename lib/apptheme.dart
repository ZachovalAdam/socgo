import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color brandingPrimary = Color(0xff3B84F0);
  static const Color brandingPrimaryAlt = Color(0xff3B84F0);

  static const Color brandingSurfaceLight = Color(0xfff5f5f5);
  static const Color brandingSurfaceDark = Color(0xff1b1b1b);

  static final ThemeData lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.white,
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.white,
      elevation: 0.0,
    ),
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
      selectedItemColor: brandingPrimary,
      unselectedItemColor: Colors.black,
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(fontWeight: FontWeight.w500)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0.0),
        shape: MaterialStateProperty.all<OutlinedBorder>(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)))),
        backgroundColor: MaterialStateProperty.all<Color>(brandingPrimary),
        textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: brandingPrimary,
      //onPrimary: Colors.white,
      primaryVariant: brandingPrimary,
      secondary: Colors.blue.shade200,
    ),
    cardTheme: CardTheme(
      color: brandingSurfaceLight,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    dividerColor: const Color(0xffe9e9e9),
    fontFamily: 'Inter',
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: Color(0xffe9e9e9), width: 2)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: brandingPrimary, width: 2)),
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
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
        color: Color(0xff8d8d8d),
        fontSize: 14,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.black,
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.black,
      elevation: 0.0,
    ),
    appBarTheme: const AppBarTheme(
      brightness: Brightness.dark,
      color: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: brandingPrimary,
      unselectedItemColor: Colors.white,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(fontWeight: FontWeight.w500)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0.0),
        shape: MaterialStateProperty.all<OutlinedBorder>(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)))),
        backgroundColor: MaterialStateProperty.all<Color>(brandingPrimary),
        textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: brandingPrimary,
      //onPrimary: Colors.white,
      primaryVariant: brandingPrimary,
      secondary: Colors.blue.shade200,
    ),
    cardTheme: CardTheme(
      color: brandingSurfaceDark,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    dividerColor: const Color(0xff141414),
    fontFamily: 'Inter',
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: Color(0xff141414), width: 2)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: brandingPrimary, width: 2)),
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
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
        color: Color(0xff8d8d8d),
        fontSize: 14,
      ),
    ),
  );
}
