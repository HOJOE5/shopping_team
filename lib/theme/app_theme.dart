import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lovelyTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFFFF0F5), // 연한 핑크
    primaryColor: const Color(0xFFFFC0CB),            // 메인 핑크
    fontFamily: 'Arial',
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Color(0xFF555555),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF666666),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFC0CB),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFFA6C9),
      foregroundColor: Colors.white,
    ),
  );
}
