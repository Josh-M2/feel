import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final ThemeData base = ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ).copyWith(
            primary: AppColors.primary,
            secondary: AppColors.accent,
            surface: AppColors.surface,
            surfaceContainerHighest: AppColors.surfaceMuted,
            outline: AppColors.border,
            outlineVariant: AppColors.borderStrong,
            onSurface: AppColors.textPrimary,
            onSecondary: Colors.white,
          ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppTypography.textTheme(ThemeData.light().textTheme),
      dividerColor: AppColors.border,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentStrong,
          backgroundColor: AppColors.surfaceSecondary,
          side: const BorderSide(color: AppColors.borderStrong),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.3),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.surfaceInteractive,
        selectedColor: AppColors.surfacePrimary,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        labelStyle: base.textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceSoft,
        indicatorColor: AppColors.surfaceHighlight,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
          final bool selected = states.contains(WidgetState.selected);
          return base.textTheme.labelMedium?.copyWith(
            color: selected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((states) {
          final bool selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.primary : AppColors.textSecondary,
          );
        }),
      ),
    );
  }
}
