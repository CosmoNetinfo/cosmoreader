import 'package:flutter/material.dart';
import 'cosmonet_colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: CosmonetColors.bgPrimary,
      colorScheme: const ColorScheme.dark(
        primary: CosmonetColors.accentBlue,
        secondary: CosmonetColors.accentPurple,
        surface: CosmonetColors.bgSecondary,
        error: CosmonetColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: CosmonetColors.textPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: CosmonetColors.bgElevated,
        foregroundColor: CosmonetColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: CosmonetColors.bgSecondary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: CosmonetColors.divider,
        thickness: 1,
        space: 1,
      ),
      textTheme: TextTheme(
        titleLarge: CosmonetTextStyles.titleLarge,
        titleMedium: CosmonetTextStyles.titleMedium,
        bodyLarge: CosmonetTextStyles.bodyLarge,
        bodyMedium: CosmonetTextStyles.bodyMedium,
        labelSmall: CosmonetTextStyles.labelSmall,
      ),
    );
  }
}
