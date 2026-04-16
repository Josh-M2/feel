import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';

class AppActionIconButton extends StatelessWidget {
  const AppActionIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(AppRadii.lg);

    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: AppColors.surfaceInteractive,
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surfaceInteractive,
            borderRadius: borderRadius,
            border: Border.all(color: AppColors.border),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0D2B486D),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onPressed,
            child: SizedBox(
              width: 42,
              height: 42,
              child: Icon(icon, color: AppColors.accentStrong, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
