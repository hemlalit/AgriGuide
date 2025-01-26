import 'package:flutter/material.dart';

class AppTheme {
  // Define custom colors
  static const Color primaryColor = Colors.green;
  static const Color secondaryColor = Colors.tealAccent;
  static const Color lightBackground = Colors.white;
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color darkInputFill = Color(0xFF263238);
  static const Color darkText = Colors.white;
  static const Color darkBtnColor = Color.fromARGB(255, 0, 130, 0);
  static const Color lightText = Colors.black;
  static const Color subtitleTextColorLight = Colors.black54;
  static const Color subtitleTextColorDark = Colors.white70;

  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(
      color: lightBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: lightText),
      titleTextStyle: TextStyle(
        color: lightText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: Colors.white,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w600, color: lightText),
      bodyMedium: TextStyle(fontSize: 16, color: lightText),
      bodySmall: TextStyle(fontSize: 14, color: subtitleTextColorLight),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryColor),
      ),
      filled: true,
      fillColor: Colors.green.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    scaffoldBackgroundColor: darkCardColor,
    appBarTheme: const AppBarTheme(
      color: darkCardColor,
      elevation: 0,
      iconTheme: IconThemeData(color: darkText),
      titleTextStyle: TextStyle(
        color: darkText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: darkCardColor,
    textTheme: const TextTheme(
      headlineLarge:
          TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: darkText),
      bodyMedium: TextStyle(fontSize: 16, color: darkText),
      bodySmall: TextStyle(fontSize: 14, color: subtitleTextColorDark),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: lightBackground),
      ),
      filled: true,
      fillColor: darkInputFill,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: darkBtnColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          )),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  );
}
