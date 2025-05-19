import 'package:flutter/material.dart';
import 'package:rental_service/core/theme/theme.dart';


class AppTheme {
  // Define your text theme if you want to customize it
  static final TextTheme _textTheme = const TextTheme(
    displayLarge: TextStyle(fontSize: 96, fontWeight: FontWeight.w300),
    displayMedium: TextStyle(fontSize: 60, fontWeight: FontWeight.w300),
    displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.w400),
    headlineMedium: TextStyle(fontSize: 34, fontWeight: FontWeight.w400),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
  );

  // Create an instance of MaterialTheme
  static final MaterialTheme _materialTheme = MaterialTheme(_textTheme);

  // Light theme
  static ThemeData lightTheme = _materialTheme.light();

  // Dark theme
  static ThemeData darkTheme = _materialTheme.dark();

  // You can also provide access to the other contrast modes if needed
  static ThemeData lightHighContrastTheme = _materialTheme.lightHighContrast();
  static ThemeData lightMediumContrastTheme = _materialTheme.lightMediumContrast();
  static ThemeData darkHighContrastTheme = _materialTheme.darkHighContrast();
  static ThemeData darkMediumContrastTheme = _materialTheme.darkMediumContrast();
}