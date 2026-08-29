import 'package:flutter/material.dart';

class OrenzaColors {
  OrenzaColors._();

  // AURENZA primary palette
  static const forest = Color(0xFF0B2419);
  static const forestGreen = Color(0xFF123B29);
  static const emerald = Color(0xFF1E8E5A);
  static const mint = Color(0xFF42D392);

  // Premium accent
  static const gold = Color(0xFFD4AF57);
  static const softGold = Color(0xFFE7CF8A);

  // Neutral system
  static const ivory = Color(0xFFF8F7F2);
  static const white = Color(0xFFFFFFFF);
  static const charcoal = Color(0xFF17211C);
  static const slate = Color(0xFF66736B);
  static const muted = Color(0xFF8A968F);
  static const border = Color(0xFFE2E6E1);

  // Status
  static const success = Color(0xFF198754);
  static const warning = Color(0xFFC28A00);
  static const danger = Color(0xFFB42318);

  static const successBackground = Color(0xFFEAF7EF);
  static const warningBackground = Color(0xFFFFF8E5);
  static const dangerBackground = Color(0xFFFFEFED);

  // Dark surfaces
  static const darkSurface = Color(0xFF081711);
  static const darkSurface2 = Color(0xFF0D2119);
  static const darkBorder = Color(0xFF1D3A2B);
}

class OrenzaTheme {
  OrenzaTheme._();

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: OrenzaColors.forestGreen,
      brightness: Brightness.light,
    ).copyWith(
      primary: OrenzaColors.forestGreen,
      secondary: OrenzaColors.gold,
      surface: OrenzaColors.white,
      error: OrenzaColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: OrenzaColors.ivory,

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

      dividerTheme: const DividerThemeData(
        color: OrenzaColors.border,
        thickness: 1,
        space: 1,
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

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: OrenzaColors.white,
        indicatorColor: OrenzaColors.softGold.withValues(alpha: .25),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: OrenzaColors.charcoal,
          fontWeight: FontWeight.w900,
        ),
        headlineMedium: TextStyle(
          color: OrenzaColors.charcoal,
          fontWeight: FontWeight.w800,
        ),
        headlineSmall: TextStyle(
          color: OrenzaColors.charcoal,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(
          color: OrenzaColors.charcoal,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: TextStyle(
          color: OrenzaColors.charcoal,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: OrenzaColors.charcoal,
        ),
        bodyMedium: TextStyle(
          color: OrenzaColors.slate,
        ),
      ),
    );
  }
}
