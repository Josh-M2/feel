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

  String _routeWithOrigin(BuildContext context, String route) {
    final String? origin = _navigationOriginForContext(context);
    if (origin == null) {
      return route;
    }
    return '$route?origin=${Uri.encodeComponent(origin)}';
  }

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
            onPressed: () => context.push(
              _routeWithOrigin(context, AppRoutes.profileOverview),
            ),
          ),
          const SizedBox(width: 8),
          AppActionIconButton(
            icon: Icons.settings_outlined,
            tooltip: 'Settings',
            onPressed: () =>
                context.push(_routeWithOrigin(context, AppRoutes.settingsHome)),
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
    this.originRoute,
    this.fallbackRoute,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final String? originRoute;
  final String? fallbackRoute;

  Future<void> _handleBack(BuildContext context) async {
    final bool didPop = await Navigator.of(context).maybePop();
    if (!context.mounted || didPop) {
      return;
    }

    final String resolvedFallback =
        _safeOriginRoute(originRoute) ??
        fallbackRoute ??
        _inferFallbackRoute(context);
    final String currentPath = GoRouterState.of(context).uri.path;
    if (resolvedFallback != currentPath) {
      context.go(resolvedFallback);
    }
  }

  String _inferFallbackRoute(BuildContext context) {
    final String path = GoRouterState.of(context).uri.path;
    if (path.startsWith('/global_profile/') || path.startsWith('/auth/')) {
      return AppRoutes.profileOverview;
    }
    if (path.startsWith('/global_settings/')) {
      return path == AppRoutes.settingsHome
          ? AppRoutes.profileOverview
          : AppRoutes.settingsHome;
    }
    return AppRoutes.todayHome;
  }

  int _selectedTabIndex(BuildContext context) {
    final String candidate =
        _safeOriginRoute(originRoute) ??
        _safeOriginRoute(GoRouterState.of(context).uri.toString()) ??
        AppRoutes.todayHome;
    if (candidate.startsWith('/tab_read/')) {
      return 1;
    }
    if (candidate.startsWith('/tab_plans/')) {
      return 2;
    }
    if (candidate.startsWith('/tab_saved/')) {
      return 3;
    }
    return 0;
  }

  String _routeForTabIndex(int index) {
    final String? safeOrigin = _safeOriginRoute(originRoute);
    if (safeOrigin != null) {
      if (index == 0 && safeOrigin.startsWith('/tab_today/')) {
        return safeOrigin;
      }
      if (index == 1 && safeOrigin.startsWith('/tab_read/')) {
        return safeOrigin;
      }
      if (index == 2 && safeOrigin.startsWith('/tab_plans/')) {
        return safeOrigin;
      }
      if (index == 3 && safeOrigin.startsWith('/tab_saved/')) {
        return safeOrigin;
      }
    }

    switch (index) {
      case 1:
        return AppRoutes.readBooks;
      case 2:
        return AppRoutes.plansList;
      case 3:
        return AppRoutes.savedBookmarks;
      case 0:
      default:
        return AppRoutes.todayHome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const BackButtonIcon(),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => _handleBack(context),
        ),
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTabIndex(context),
        onDestinationSelected: (int index) {
          context.go(_routeForTabIndex(index));
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            selectedIcon: Icon(Icons.wb_sunny_rounded),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Read',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note_rounded),
            label: 'Plans',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}

String? _navigationOriginForContext(BuildContext context) {
  final GoRouterState state = GoRouterState.of(context);
  final String? origin = _safeOriginRoute(state.uri.queryParameters['origin']);
  if (origin != null) {
    return origin;
  }

  final String candidate = state.uri.toString();
  return _safeOriginRoute(candidate);
}

String? _safeOriginRoute(String? candidate) {
  final String raw = (candidate ?? '').trim();
  if (raw.isEmpty) {
    return null;
  }

  final Uri? uri = Uri.tryParse(raw);
  final String path = uri?.path ?? '';
  if (!_isSafeOriginPath(path)) {
    return null;
  }

  final String query = uri?.hasQuery == true ? '?${uri!.query}' : '';
  final String fragment = uri?.fragment.isNotEmpty == true
      ? '#${uri!.fragment}'
      : '';
  return '$path$query$fragment';
}

bool _isSafeOriginPath(String path) {
  if (path.isEmpty) {
    return false;
  }

  return !path.startsWith('/auth/') &&
      !path.startsWith('/global_profile/') &&
      !path.startsWith('/global_settings/');
}
