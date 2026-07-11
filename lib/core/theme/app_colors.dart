import 'package:flutter/material.dart';

/// Central color palette. Every screen reads from here so dark/light theming
/// and rebrands happen in one place.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color accent = Color(0xFF60A5FA);

  // Dark background gradient
  static const Color bgTop = Color(0xFF06142B);
  static const Color bgBottom = Color(0xFF0E2348);
  static const Color splashBg = Color(0xFF0F172A);

  // Surfaces / glass
  static const Color dropdownSurface = Color(0xFF102040);

  static Color glassFill = Colors.white.withValues(alpha: 0.08);
  static Color glassBorder = Colors.white.withValues(alpha: 0.12);

  // Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textMuted = Colors.white54;

  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgTop, bgBottom],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
  );
}
