import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'app_skeleton.dart';

class AppPageLoader extends StatelessWidget {
  const AppPageLoader({
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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 24, color: AppColors.primary),
              const SizedBox(height: AppSpacing.lg),
              const AppSkeletonBlock(width: 160, height: 14),
              const SizedBox(height: AppSpacing.sm),
              const AppSkeletonBlock(width: 220, height: 12),
              const SizedBox(height: AppSpacing.xs),
              const AppSkeletonBlock(width: 180, height: 12),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.accentStrong,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
