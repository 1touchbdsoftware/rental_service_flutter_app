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
  static ThemeData lightTheme = _materialTheme.light().copyWith(
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: lightScheme().onSurface, // Use light theme color
      ),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = _materialTheme.dark().copyWith(
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: darkScheme().onPrimary, // Use dark theme color
      ),
    ),
  );

  // You can also provide access to the other contrast modes if needed
  static ThemeData lightHighContrastTheme = _materialTheme.lightHighContrast();
  static ThemeData lightMediumContrastTheme = _materialTheme.lightMediumContrast();
  static ThemeData darkHighContrastTheme = _materialTheme.darkHighContrast();
  static ThemeData darkMediumContrastTheme = _materialTheme.darkMediumContrast();

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4c5c92),
      surfaceTint: Color(0xff4c5c92),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffdce1ff),
      onPrimaryContainer: Color(0xff344479),
      secondary: Color(0xff595e72),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffdee1f9),
      onSecondaryContainer: Color(0xff414659),
      tertiary: Color(0xff745470),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffd7f6),
      onTertiaryContainer: Color(0xff5b3d57),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff1a1b21),
      onSurfaceVariant: Color(0xff45464f),
      outline: Color(0xff767680),
      outlineVariant: Color(0xffc6c6d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffb5c4ff),
      primaryFixed: Color(0xffdce1ff),
      onPrimaryFixed: Color(0xff02174b),
      primaryFixedDim: Color(0xffb5c4ff),
      onPrimaryFixedVariant: Color(0xff344479),
      secondaryFixed: Color(0xffdee1f9),
      onSecondaryFixed: Color(0xff161b2c),
      secondaryFixedDim: Color(0xffc1c5dd),
      onSecondaryFixedVariant: Color(0xff414659),
      tertiaryFixed: Color(0xffffd7f6),
      onTertiaryFixed: Color(0xff2c122a),
      tertiaryFixedDim: Color(0xffe3badb),
      onTertiaryFixedVariant: Color(0xff5b3d57),
      surfaceDim: Color(0xffdad9e0),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f3fa),
      surfaceContainer: Color(0xffeeedf4),
      surfaceContainerHigh: Color(0xffe9e7ef),
      surfaceContainerHighest: Color(0xffe3e1e9),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb5c4ff),
      surfaceTint: Color(0xffb5c4ff),
      onPrimary: Color(0xff1c2d61),
      primaryContainer: Color(0xff344479),
      onPrimaryContainer: Color(0xffdce1ff),
      secondary: Color(0xffc1c5dd),
      onSecondary: Color(0xff2b3042),
      secondaryContainer: Color(0xff414659),
      onSecondaryContainer: Color(0xffdee1f9),
      tertiary: Color(0xffe3badb),
      onTertiary: Color(0xff432740),
      tertiaryContainer: Color(0xff5b3d57),
      onTertiaryContainer: Color(0xffffd7f6),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff121318),
      onSurface: Color(0xffe3e1e9),
      onSurfaceVariant: Color(0xffc6c6d0),
      outline: Color(0xff8f909a),
      outlineVariant: Color(0xff45464f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e1e9),
      inversePrimary: Color(0xff4c5c92),
      primaryFixed: Color(0xffdce1ff),
      onPrimaryFixed: Color(0xff02174b),
      primaryFixedDim: Color(0xffb5c4ff),
      onPrimaryFixedVariant: Color(0xff344479),
      secondaryFixed: Color(0xffdee1f9),
      onSecondaryFixed: Color(0xff161b2c),
      secondaryFixedDim: Color(0xffc1c5dd),
      onSecondaryFixedVariant: Color(0xff414659),
      tertiaryFixed: Color(0xffffd7f6),
      onTertiaryFixed: Color(0xff2c122a),
      tertiaryFixedDim: Color(0xffe3badb),
      onTertiaryFixedVariant: Color(0xff5b3d57),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff38393f),
      surfaceContainerLowest: Color(0xff0d0e13),
      surfaceContainerLow: Color(0xff1a1b21),
      surfaceContainer: Color(0xff1e1f25),
      surfaceContainerHigh: Color(0xff292a2f),
      surfaceContainerHighest: Color(0xff34343a),
    );
  }

}