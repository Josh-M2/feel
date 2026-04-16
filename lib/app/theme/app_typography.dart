import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextTheme textTheme(TextTheme base) {
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.1,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.18,
        letterSpacing: -0.4,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.1,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: AppColors.textPrimary,
        height: 1.45,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
        height: 1.45,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
      bodySmall: base.bodySmall?.copyWith(
        color: AppColors.textSecondary,
        height: 1.35,
      ),
    );
  }
}
