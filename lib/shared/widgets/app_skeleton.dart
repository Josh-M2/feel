import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';

class AppSkeletonBlock extends StatefulWidget {
  const AppSkeletonBlock({
    super.key,
    required this.height,
    this.width,
    this.radius = AppRadii.md,
  });

  final double height;
  final double? width;
  final double radius;

  @override
  State<AppSkeletonBlock> createState() => _AppSkeletonBlockState();
}

class _AppSkeletonBlockState extends State<AppSkeletonBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  late final Animation<Color?> _color = ColorTween(
    begin: AppColors.surfaceMuted,
    end: AppColors.surfaceHighlight,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _color,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _color.value,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        );
      },
    );
  }
}
