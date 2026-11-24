import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF3F4F6);
  static const Color primary = Color(0xFF111111);
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);

  // Acentos funcionales
  static const Color dropAccent = Color(0xFFFF4D1C);
  static const Color aiAccent = Color(0xFF6366F1);

  // Gris platinado
  static const Color platinumLight = Color(0xFFF0F2F5);
  static const Color platinum = Color(0xFFE2E6EC);
  static const Color platinumBorder = Color(0xFFD0D6DF);
  static const Color cardShadow = Color(0x14111827);
}

class AppTheme {
  static BoxDecoration platinumCardDecoration({
    double radius = 22,
    bool elevated = true,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: const LinearGradient(
        colors: [
          AppColors.platinumLight,
          AppColors.platinum,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: AppColors.platinumBorder,
        width: 1.1,
      ),
      boxShadow: elevated
          ? const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ]
          : null,
    );
  }

  static TextStyle editorialTitle({
    double fontSize = 36,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.bebasNeue(
      fontSize: fontSize,
      color: color,
      letterSpacing: 1.5,
      height: 1.0,
    );
  }

  static ThemeData get lightTheme {
    final gfTextTheme = GoogleFonts.plusJakartaSansTextTheme();
    final baseTextTheme = TextTheme(
      displayLarge: gfTextTheme.displayLarge,
      displayMedium: gfTextTheme.displayMedium,
      displaySmall: gfTextTheme.displaySmall,
      headlineLarge: gfTextTheme.headlineLarge,
      headlineMedium: gfTextTheme.headlineMedium,
      headlineSmall: gfTextTheme.headlineSmall,
      titleLarge: gfTextTheme.titleLarge,
      titleMedium: gfTextTheme.titleMedium,
      titleSmall: gfTextTheme.titleSmall,
      bodyLarge: gfTextTheme.bodyLarge,
      bodyMedium: gfTextTheme.bodyMedium,
      bodySmall: gfTextTheme.bodySmall,
      labelLarge: gfTextTheme.labelLarge,
      labelMedium: gfTextTheme.labelMedium,
      labelSmall: gfTextTheme.labelSmall,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.dropAccent,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 54),
          side: const BorderSide(color: AppColors.border, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
    );
  }
}
