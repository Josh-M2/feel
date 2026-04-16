import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class TodayInfoCard extends StatelessWidget {
  const TodayInfoCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.support,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (icon != null) ...<Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(icon, size: 18, color: AppColors.accentStrong),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
          ],
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}
