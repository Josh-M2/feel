import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';

enum AppCardVariant { standard, primary, support, highlight, outline }

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
    this.variant = AppCardVariant.standard,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final AppCardVariant variant;

  Color _backgroundColor() {
    switch (variant) {
      case AppCardVariant.primary:
        return AppColors.surfacePrimary;
      case AppCardVariant.support:
        return AppColors.surfaceSupport;
      case AppCardVariant.highlight:
        return AppColors.surfaceHighlight;
      case AppCardVariant.outline:
        return AppColors.surfaceSecondary;
      case AppCardVariant.standard:
        return AppColors.surfaceSecondary;
    }
  }

  BorderSide _borderSide() {
    switch (variant) {
      case AppCardVariant.primary:
        return const BorderSide(color: AppColors.borderStrong);
      case AppCardVariant.support:
      case AppCardVariant.highlight:
        return const BorderSide(color: AppColors.border);
      case AppCardVariant.outline:
        return const BorderSide(color: AppColors.borderStrong);
      case AppCardVariant.standard:
        return const BorderSide(color: AppColors.border);
    }
  }

  List<BoxShadow> _shadows() {
    switch (variant) {
      case AppCardVariant.primary:
        return const <BoxShadow>[
          BoxShadow(
            color: Color(0x120F6FD0),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ];
      case AppCardVariant.standard:
      case AppCardVariant.support:
      case AppCardVariant.highlight:
        return const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A2B486D),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ];
      case AppCardVariant.outline:
        return const <BoxShadow>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(AppRadii.xl);

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: _backgroundColor(),
          borderRadius: borderRadius,
          border: Border.fromBorderSide(_borderSide()),
          boxShadow: _shadows(),
        ),
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
