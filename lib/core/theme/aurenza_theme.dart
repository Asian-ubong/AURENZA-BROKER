import 'package:flutter/material.dart';
import 'aurenza_colors.dart';
import 'aurenza_radius.dart';
import 'aurenza_typography.dart';

abstract final class AurenzaTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AurenzaColors.forest,
      brightness: Brightness.light,
    ).copyWith(
      primary: AurenzaColors.forest,
      onPrimary: Colors.white,
      secondary: AurenzaColors.gold,
      onSecondary: AurenzaColors.text,
      surface: AurenzaColors.surface,
      onSurface: AurenzaColors.text,
      error: AurenzaColors.danger,
      onError: Colors.white,
      outline: AurenzaColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: AurenzaColors.background,
      fontFamily: 'Roboto',
      visualDensity: VisualDensity.standard,
      dividerColor: AurenzaColors.border,
      disabledColor: AurenzaColors.muted,
      appBarTheme: AppBarTheme(
        backgroundColor: AurenzaColors.background,
        foregroundColor: AurenzaColors.text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AurenzaTypography.title.copyWith(color: AurenzaColors.text),
      ),
      cardTheme: CardThemeData(
        color: AurenzaColors.surface,
        surfaceTintColor: Colors.transparent,
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
        labelStyle: const TextStyle(color: AurenzaColors.muted),
        hintStyle: const TextStyle(color: AurenzaColors.muted),
        prefixIconColor: AurenzaColors.muted,
        suffixIconColor: AurenzaColors.muted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AurenzaRadius.md),
          borderSide: const BorderSide(color: AurenzaColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AurenzaRadius.md),
          borderSide: const BorderSide(color: AurenzaColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AurenzaRadius.md),
          borderSide: const BorderSide(color: AurenzaColors.forest, width: 1.5),
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: AurenzaTypography.display.copyWith(color: AurenzaColors.text),
        titleLarge: AurenzaTypography.title.copyWith(color: AurenzaColors.text),
        titleMedium: AurenzaTypography.section.copyWith(color: AurenzaColors.text),
        bodyLarge: AurenzaTypography.body.copyWith(color: AurenzaColors.text),
        bodyMedium: AurenzaTypography.body.copyWith(color: AurenzaColors.text),
        bodySmall: AurenzaTypography.caption.copyWith(color: AurenzaColors.muted),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AurenzaColors.forest,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AurenzaColors.forest,
          side: const BorderSide(color: AurenzaColors.forest),
          minimumSize: const Size(48, 48),
        ),
      ),
    );
  }

  static ThemeData dark() {
    const background = Color(0xFF06100C);
    const surface = Color(0xFF0B1713);
    const elevated = Color(0xFF10221B);
    const border = Color(0xFF294238);
    const text = Color(0xFFF4F8F6);
    const muted = Color(0xFFB8C6C0);

    final scheme = ColorScheme.fromSeed(
      seedColor: AurenzaColors.green,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AurenzaColors.goldSoft,
      onPrimary: const Color(0xFF1B1A08),
      secondary: AurenzaColors.green,
      onSecondary: Colors.white,
      surface: surface,
      onSurface: text,
      error: const Color(0xFFFF7777),
      onError: const Color(0xFF2A0000),
      outline: border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      visualDensity: VisualDensity.standard,
      dividerColor: border,
      disabledColor: muted,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AurenzaRadius.lg),
          side: const BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: elevated,
        labelStyle: const TextStyle(color: muted),
        hintStyle: const TextStyle(color: muted),
        prefixIconColor: muted,
        suffixIconColor: muted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AurenzaRadius.md),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AurenzaRadius.md),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AurenzaRadius.md),
          borderSide: const BorderSide(color: AurenzaColors.goldSoft, width: 1.5),
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: AurenzaTypography.display.copyWith(color: text),
        titleLarge: AurenzaTypography.title.copyWith(color: text),
        titleMedium: AurenzaTypography.section.copyWith(color: text),
        bodyLarge: AurenzaTypography.body.copyWith(color: text),
        bodyMedium: AurenzaTypography.body.copyWith(color: text),
        bodySmall: AurenzaTypography.caption.copyWith(color: muted),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AurenzaColors.goldSoft,
          foregroundColor: const Color(0xFF1B1A08),
          minimumSize: const Size(48, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AurenzaColors.goldSoft,
          side: const BorderSide(color: AurenzaColors.goldSoft),
          minimumSize: const Size(48, 48),
        ),
      ),
    );
  }
}
