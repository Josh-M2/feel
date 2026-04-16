import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';

class SettingsNavTile extends StatelessWidget {
  const SettingsNavTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.trailingLabel,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final String? trailingLabel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceInteractive,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, size: 20, color: AppColors.accentStrong),
          ),
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitle),
        ),
        trailing: trailingLabel == null
            ? const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.textSecondary,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    trailingLabel!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.accentStrong,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
      ),
    );
  }
}
