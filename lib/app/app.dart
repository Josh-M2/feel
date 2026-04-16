import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'bootstrap/app_bootstrap_controller.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class BibleApp extends StatefulWidget {
  const BibleApp({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  State<BibleApp> createState() => _BibleAppState();
}

class _BibleAppState extends State<BibleApp> {
  late final GoRouter _router;
  StreamSubscription<String>? _navigationSubscription;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(widget.bootstrap);
    _navigationSubscription = widget.bootstrap.navigationRequests.listen(
      (String route) {
        _router.go(route);
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String? queuedRoute = widget.bootstrap.consumeQueuedNavigationRoute();
      if (queuedRoute != null) {
        _router.go(queuedRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Feel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: _router,
    );
  }

  @override
  void dispose() {
    _navigationSubscription?.cancel();
    super.dispose();
  }
}
