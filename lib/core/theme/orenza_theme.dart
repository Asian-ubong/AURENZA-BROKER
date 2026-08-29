import 'package:flutter/material.dart';

class OrenzaColors {
  OrenzaColors._();

  static const forestGreen = Color(0xFF1B2E20);
  static const emerald = Color(0xFF4CAF50);
  static const gold = Color(0xFFC9A063);
  static const ivory = Color(0xFFFAF9F6);
  static const white = Color(0xFFFFFFFF);
  static const danger = Color(0xFFB80000);

  static const charcoal = Color(0xFF1A1A1A);
  static const slate = Color(0xFF68736B);
  static const border = Color(0xFFE4E1D9);

  static const successBackground = Color(0xFFEAF6EC);
  static const warningBackground = Color(0xFFF8F0DF);
  static const dangerBackground = Color(0xFFFBEAEA);
}

class OrenzaTheme {
  OrenzaTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: OrenzaColors.ivory,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: OrenzaColors.forestGreen,
            brightness: Brightness.light,
          ).copyWith(
            primary: OrenzaColors.forestGreen,
            secondary: OrenzaColors.gold,
            surface: OrenzaColors.white,
            error: OrenzaColors.danger,
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: OrenzaColors.ivory,
        foregroundColor: OrenzaColors.charcoal,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: OrenzaColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: OrenzaColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: OrenzaColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: OrenzaColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: OrenzaColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: OrenzaColors.forestGreen,
            width: 1.5,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: OrenzaColors.charcoal,
          fontWeight: FontWeight.w800,
        ),
        headlineMedium: TextStyle(
          color: OrenzaColors.charcoal,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(
          color: OrenzaColors.charcoal,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: OrenzaColors.charcoal,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(color: OrenzaColors.charcoal),
        bodyMedium: TextStyle(color: OrenzaColors.slate),
      ),
    );
  }
}
