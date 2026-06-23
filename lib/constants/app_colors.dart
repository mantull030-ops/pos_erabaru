import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1565C0); // Blue 800
  static const Color primaryLight = Color(0xFF5E92F3);
  static const Color primaryDark = Color(0xFF003C8F);

  // Secondary Colors
  static const Color secondary = Color(0xFF0288D1); // Light Blue 700
  static const Color secondaryLight = Color(0xFF5EB8FF);
  static const Color secondaryDark = Color(0xFF005B9F);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF141218);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1C1B1F);

  // Status Colors
  static const Color error = Color(0xFFB00020);
  static const Color errorDark = Color(0xFFCF6679);
  static const Color success = Color(0xFF2E7D32);
  static const Color successDark = Color(0xFF66BB6A);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF0288D1);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFAAAAAA);

  // Light Theme Color Scheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    secondary: secondary,
    onSecondary: Colors.white,
    error: error,
    onError: Colors.white,
    surface: surfaceLight,
    onSurface: textPrimaryLight,
  );

  // Dark Theme Color Scheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryLight,
    onPrimary: textPrimaryLight,
    secondary: secondaryLight,
    onSecondary: textPrimaryLight,
    error: errorDark,
    onError: textPrimaryLight,
    surface: surfaceDark,
    onSurface: textPrimaryDark,
  );
}
