import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Map<int, Color> brandingPrimaryLuminance = {
    50: Color.fromRGBO(59, 132, 240, .1),
    100: Color.fromRGBO(59, 132, 240, .2),
    200: Color.fromRGBO(59, 132, 240, .3),
    300: Color.fromRGBO(59, 132, 240, .4),
    400: Color.fromRGBO(59, 132, 240, .5),
    500: Color.fromRGBO(59, 132, 240, .6),
    600: Color.fromRGBO(59, 132, 240, .7),
    700: Color.fromRGBO(59, 132, 240, .8),
    800: Color.fromRGBO(59, 132, 240, .9),
    90: Color.fromRGBO(59, 132, 240, 1),
  };

  static const MaterialColor brandingPrimaryMaterial = MaterialColor(0xff3B84F0, brandingPrimaryLuminance);

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
        textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontWeight: FontWeight.w500)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0.0),
        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
        backgroundColor: MaterialStateProperty.all<Color>(brandingPrimary),
        textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
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
    dividerColor: const Color(0xffe9e9e9),
    fontFamily: 'Inter',
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4)), borderSide: BorderSide(color: Color(0xffe9e9e9), width: 2)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4)), borderSide: BorderSide(color: brandingPrimary, width: 2)),
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
      ),
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
    scaffoldBackgroundColor: Colors.black,
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.black,
      elevation: 0.0,
    ),
    accentColor: brandingPrimary,
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
      selectedItemColor: Colors.white,
      unselectedItemColor: Color(0xFF424242),
      elevation: 0,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontWeight: FontWeight.w500)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0.0),
        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
        backgroundColor: MaterialStateProperty.all<Color>(brandingPrimary),
        textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: brandingPrimary,
      //onPrimary: Colors.white,
      primaryVariant: brandingPrimary,
      secondary: Colors.blue.shade200,
      background: Colors.black,
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
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4)), borderSide: BorderSide(color: Color(0xff141414), width: 2)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4)), borderSide: BorderSide(color: brandingPrimary, width: 2)),
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
      ),
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
