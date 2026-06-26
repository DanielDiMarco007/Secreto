import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color background = Color(0xFF08080D);
  static const Color surface = Color(0xFF13131C);

  static const Color purple = Color(0xFF8B5CF6);
  static const Color purpleLight = Color(0xFFA855F7);

  static const Color text = Color(0xFFF5F5F5);
  static const Color subtitle = Color(0xFFBDBDBD);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.dark,

    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.dark(
      primary: purple,
      secondary: purpleLight,
      surface: surface,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: text,
      centerTitle: true,
      elevation: 0,
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 8,
      shadowColor: purple.withOpacity(0.25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: purple,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 58),
        elevation: 10,
        shadowColor: purple.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),

      hintStyle: const TextStyle(
        color: Colors.grey,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: purple.withOpacity(0.3),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: purpleLight,
          width: 2,
        ),
      ),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: text,
        fontWeight: FontWeight.bold,
        fontSize: 32,
        letterSpacing: 2,
      ),

      headlineMedium: TextStyle(
        color: text,
        fontWeight: FontWeight.bold,
      ),

      bodyLarge: TextStyle(
        color: text,
      ),

      bodyMedium: TextStyle(
        color: subtitle,
      ),
    ),
  );
}