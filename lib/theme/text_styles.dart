import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cosmonet_colors.dart';

class CosmonetTextStyles {
  static TextStyle get titleLarge => GoogleFonts.exo2(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: CosmonetColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.exo2(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: CosmonetColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.firaSans(
        fontSize: 16,
        color: CosmonetColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.firaSans(
        fontSize: 14,
        color: CosmonetColors.textSecondary,
      );

  static TextStyle get labelSmall => GoogleFonts.firaSans(
        fontSize: 12,
        color: CosmonetColors.textSecondary,
      );

  static TextStyle get codeStyle => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        color: CosmonetColors.accentCyan,
      );
}
