import 'dart:async';

import 'package:flutter/material.dart';

class AppReveal extends StatefulWidget {
  const AppReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 320),
    this.offsetY = 0.04,
    this.curve = Curves.easeOutCubic,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offsetY;
  final Curve curve;

  @override
  State<AppReveal> createState() => _AppRevealState();
}

class _AppRevealState extends State<AppReveal> {
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: widget.duration,
      curve: widget.curve,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : Offset(0, widget.offsetY),
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}
