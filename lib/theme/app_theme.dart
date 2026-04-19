import 'package:flutter/material.dart';

class AppTheme {
  static const Color bgDeep      = Color(0xFF080C14);
  static const Color bgSurface   = Color(0xFF0F1623);
  static const Color bgCard      = Color(0xFF161E2E);
  static const Color bgElevated  = Color(0xFF1C2638);
  static const Color accent      = Color(0xFF4FC3F7);
  static const Color accentDim   = Color(0xFF1A4A6B);
  static const Color textPrimary    = Color(0xFFE8F0FE);
  static const Color textSecondary  = Color(0xFF7B8FB0);
  static const Color textMuted      = Color(0xFF3D5070);
  static const Color divider        = Color(0xFF1C2638);

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgDeep,
    colorScheme: const ColorScheme.dark(
      primary: accent,
      secondary: accent,
      surface: bgSurface,
      onPrimary: bgDeep,
      onSecondary: bgDeep,
      onSurface: textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bgSurface,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    ),
    cardTheme: CardTheme(
      color: bgCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: divider, width: 1),
      ),
    ),
    dividerColor: divider,
    iconTheme: const IconThemeData(color: textSecondary),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: textPrimary, fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: textPrimary, fontSize: 22, fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: textPrimary, fontSize: 17, fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: textPrimary, fontSize: 15, fontWeight: FontWeight.w500,
      ),
      bodyLarge:  TextStyle(color: textPrimary, fontSize: 15),
      bodyMedium: TextStyle(color: textSecondary, fontSize: 13),
      labelSmall: TextStyle(color: textMuted, fontSize: 11, letterSpacing: 0.8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: bgDeep,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.5),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: bgElevated,
      contentTextStyle: const TextStyle(color: textPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
