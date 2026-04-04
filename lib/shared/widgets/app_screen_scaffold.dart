import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import 'app_action_icon_button.dart';

class TabScreenScaffold extends StatelessWidget {
  const TabScreenScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.showBackButton = false,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showBackButton ? const BackButton() : null,
        toolbarHeight: subtitle == null ? 68 : 84,
        titleSpacing: showBackButton ? null : 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(title),
            if (subtitle != null) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
        actions: <Widget>[
          AppActionIconButton(
            icon: Icons.person_outline_rounded,
            tooltip: 'Profile',
            onPressed: () => context.push(AppRoutes.profileOverview),
          ),
          const SizedBox(width: 8),
          AppActionIconButton(
            icon: Icons.settings_outlined,
            tooltip: 'Settings',
            onPressed: () => context.push(AppRoutes.settingsHome),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: body,
    );
  }
}

class GlobalScreenScaffold extends StatelessWidget {
  const GlobalScreenScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        toolbarHeight: subtitle == null ? 68 : 84,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(title),
            if (subtitle != null) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
      body: body,
    );
  }
}
