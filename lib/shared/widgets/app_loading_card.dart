import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';
import 'app_card.dart';
import 'app_skeleton.dart';

class AppLoadingCard extends StatelessWidget {
  const AppLoadingCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.hourglass_top_rounded,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.outline,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(AppRadii.lg),
              border: Border.all(color: AppColors.border),
            ),
            child: const SizedBox(
              width: 52,
              height: 52,
              child: Center(
                child: AppSkeletonBlock(
                  width: 24,
                  height: 24,
                  radius: AppRadii.pill,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    const Expanded(child: AppSkeletonBlock(height: 18)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                const AppSkeletonBlock(height: 12),
                const SizedBox(height: AppSpacing.xs),
                FractionallySizedBox(
                  widthFactor: 0.76,
                  child: const AppSkeletonBlock(height: 12),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.accentStrong,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
