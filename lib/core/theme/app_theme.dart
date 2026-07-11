import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgTop,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: Color(0xFF0E2348),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: Colors.white70),
        actionsIconTheme: IconThemeData(color: Colors.white70),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: -1),
        displayMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5),
        headlineLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5),
        headlineMedium:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        headlineSmall:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
        titleMedium: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        titleSmall: TextStyle(
            color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 14),
        bodyLarge: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
        bodyMedium: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
        bodySmall: TextStyle(color: Colors.white54, fontSize: 12, height: 1.4),
        labelLarge: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        labelMedium: TextStyle(
            color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 12),
        labelSmall: TextStyle(
            color: Colors.white54, fontWeight: FontWeight.w500, fontSize: 11),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 15),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textMuted,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.07),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
              BorderSide(color: Colors.white.withValues(alpha: 0.12), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: Colors.white70),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.08),
        selectedColor: AppColors.primary.withValues(alpha: 0.3),
        labelStyle: const TextStyle(color: Colors.white, fontSize: 13),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.06),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.1),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A3A6B),
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF0D2040),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        contentTextStyle:
            const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF0D2040),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: Colors.white12,
      ),
    );
  }

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        fontFamily: 'Roboto',
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      );
}
