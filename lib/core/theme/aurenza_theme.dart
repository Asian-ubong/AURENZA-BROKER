import 'package:flutter/material.dart';
import 'aurenza_colors.dart';
import 'aurenza_radius.dart';
import 'aurenza_typography.dart';

abstract final class AurenzaTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AurenzaColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AurenzaColors.forest,
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
}
