import 'package:flutter/material.dart';
import 'aurenza_colors.dart';
import 'aurenza_radius.dart';
import 'aurenza_typography.dart';

abstract final class AurenzaTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AurenzaColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AurenzaColors.forest,
        brightness: Brightness.light,
        primary: AurenzaColors.forest,
        secondary: AurenzaColors.gold,
        surface: AurenzaColors.surface,
        error: AurenzaColors.danger,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: AurenzaColors.background,
        foregroundColor: AurenzaColors.text,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AurenzaColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AurenzaRadius.lg),
          side: const BorderSide(color: AurenzaColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AurenzaColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AurenzaRadius.md),
          borderSide: const BorderSide(color: AurenzaColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AurenzaRadius.md),
          borderSide: const BorderSide(color: AurenzaColors.border),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: AurenzaTypography.display,
        titleLarge: AurenzaTypography.title,
        titleMedium: AurenzaTypography.section,
        bodyMedium: AurenzaTypography.body,
        bodySmall: AurenzaTypography.caption,
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AurenzaColors.green,
      brightness: Brightness.dark,
      primary: AurenzaColors.gold,
      secondary: AurenzaColors.goldSoft,
      surface: const Color(0xFF0B1713),
      error: AurenzaColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF06100C),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF06100C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF0B1713),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AurenzaRadius.lg),
          side: const BorderSide(color: Color(0xFF1B2A24)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0B1713),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AurenzaRadius.md),
          borderSide: const BorderSide(color: Color(0xFF1B2A24)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AurenzaRadius.md),
          borderSide: const BorderSide(color: Color(0xFF1B2A24)),
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: AurenzaTypography.display.copyWith(color: Colors.white),
        titleLarge: AurenzaTypography.title.copyWith(color: Colors.white),
        titleMedium: AurenzaTypography.section.copyWith(color: Colors.white),
        bodyMedium: AurenzaTypography.body.copyWith(color: Colors.white70),
        bodySmall: AurenzaTypography.caption.copyWith(color: Colors.white60),
      ),
    );
  }
}
