import 'package:flutter/material.dart';

import '../../../../app/bootstrap/app_bootstrap_controller.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_screen_scaffold.dart';
import '../../../../shared/widgets/placeholder_content.dart';

class TodayHomeScreen extends StatelessWidget {
  const TodayHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TabScreenScaffold(
      title: 'Today',
      subtitle: 'Daily verse, reflection, and calm encouragement',
      body: PlaceholderContent(
        eyebrow: 'Today tab',
        title: 'Your daily verse home is ready',
        description:
            'This foundation is wired for the personalized daily verse flow, with UI-first placeholders and route-safe expansion later.',
        tags: const <String>[
          'Daily verse card',
          'Context',
          'AI support',
          'Share preview',
        ],
        actions: const <PlaceholderAction>[
          PlaceholderAction(
            label: 'Open verse detail',
            route: AppRoutes.todayVerseDetail,
          ),
          PlaceholderAction(
            label: 'Open verse context',
            route: AppRoutes.todayVerseContext,
          ),
          PlaceholderAction(
            label: 'Open AI explain',
            route: AppRoutes.todayVerseAiExplain,
          ),
          PlaceholderAction(
            label: 'Open share preview',
            route: AppRoutes.todaySharePreview,
          ),
        ],
        extraSection: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Mock daily verse preview',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                '"The Lord is near to all who call on Him..."',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Psalm 145:18',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        footerNote:
            'Later, this screen can read from a daily-assignment repository without changing the shell structure.',
      ),
    );
  }
}

class ReadBooksScreen extends StatelessWidget {
  const ReadBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TabScreenScaffold(
      title: 'Read',
      subtitle: 'Books, chapters, references, and resume flow',
      body: PlaceholderContent(
        eyebrow: 'Read tab',
        title: 'Scripture browsing foundation is wired',
        description:
            'The read flow is ready for book browsing, chapter reading, reference search, and continue-reading experiences.',
        tags: const <String>[
          'Books',
          'Chapter reading',
          'Reference search',
          'Continue reading',
        ],
        actions: const <PlaceholderAction>[
          PlaceholderAction(
            label: 'Open book detail',
            route: AppRoutes.readBookDetail,
          ),
          PlaceholderAction(
            label: 'Open chapter read',
            route: AppRoutes.readChapterRead,
          ),
          PlaceholderAction(
            label: 'Open reference search',
            route: AppRoutes.readReferenceSearch,
          ),
          PlaceholderAction(
            label: 'Open continue reading',
            route: AppRoutes.readContinueReading,
          ),
        ],
      ),
    );
  }
}

class PlansListScreen extends StatelessWidget {
  const PlansListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TabScreenScaffold(
      title: 'Plans',
      subtitle: 'Simple, supportive reading plans',
      body: PlaceholderContent(
        eyebrow: 'Plans tab',
        title: 'Reading-plan structure is ready',
        description:
            'This tab is prepared for plan discovery, day-by-day reading, and progress tracking with a gentle tone.',
        tags: const <String>[
          'Plan list',
          'Plan detail',
          'Daily read',
          'Progress',
        ],
        actions: const <PlaceholderAction>[
          PlaceholderAction(
            label: 'Open plan detail',
            route: AppRoutes.plansPlanDetail,
          ),
          PlaceholderAction(
            label: 'Open day read',
            route: AppRoutes.plansDayRead,
          ),
          PlaceholderAction(
            label: 'Open progress',
            route: AppRoutes.plansProgress,
          ),
        ],
      ),
    );
  }
}

class SavedBookmarksScreen extends StatelessWidget {
  const SavedBookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TabScreenScaffold(
      title: 'Saved',
      subtitle: 'Bookmarks, notes, reflections, and history',
      body: PlaceholderContent(
        eyebrow: 'Saved tab',
        title: 'Reflection-aware saved flows are prepared',
        description:
            'This area is ready for bookmarks, highlights, verse-linked notes, and reading history.',
        tags: const <String>['Bookmarks', 'Highlights', 'Notes', 'History'],
        actions: const <PlaceholderAction>[
          PlaceholderAction(
            label: 'Open highlights',
            route: AppRoutes.savedHighlights,
          ),
          PlaceholderAction(label: 'Open notes', route: AppRoutes.savedNotes),
          PlaceholderAction(
            label: 'Open history',
            route: AppRoutes.savedHistory,
          ),
        ],
      ),
    );
  }
}

class PlaceholderTabRouteScreen extends StatelessWidget {
  const PlaceholderTabRouteScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    this.tags = const <String>[],
    this.showBackButton = false,
  });

  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return TabScreenScaffold(
      title: title,
      subtitle: subtitle,
      showBackButton: showBackButton,
      body: PlaceholderContent(
        eyebrow: subtitle,
        title: title,
        description: description,
        tags: tags,
        footerNote:
            'This placeholder is intentionally lightweight so the real UI can be layered in without refactoring the app shell.',
      ),
    );
  }
}

class ProfileOverviewScreen extends StatelessWidget {
  const ProfileOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalScreenScaffold(
      title: 'Profile',
      subtitle: 'Guest-first overview',
      body: PlaceholderContent(
        eyebrow: 'Global profile',
        title: 'Profile entry is globally accessible',
        description:
            'This route is mounted on the root navigator so opening Profile from any tab returns back to the exact originating screen.',
        tags: const <String>[
          'Guest-first',
          'Optional login later',
          'Cross-device sync later',
        ],
        actions: const <PlaceholderAction>[
          PlaceholderAction(
            label: 'Open auth status',
            route: AppRoutes.profileAuthStatus,
          ),
          PlaceholderAction(
            label: 'Open sign in',
            route: AppRoutes.profileSignIn,
          ),
          PlaceholderAction(
            label: 'Open sign up',
            route: AppRoutes.profileSignUp,
          ),
          PlaceholderAction(
            label: 'Open data sync',
            route: AppRoutes.profileDataSync,
          ),
          PlaceholderAction(
            label: 'Open sign out',
            route: AppRoutes.profileSignOut,
          ),
        ],
        extraSection: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Current mock status',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Guest mode active',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        final bool supportOpen = bootstrap.supportState == SupportState.open;

        return GlobalScreenScaffold(
          title: 'Settings',
          subtitle: 'Content, notifications, widgets, support, and app info',
          body: PlaceholderContent(
            eyebrow: 'Global settings',
            title: 'Settings home is globally accessible',
            description:
                'Like Profile, this screen sits on the root navigator so it can be opened from every tab without breaking tab stack state.',
            tags: <String>[
              'Content preferences',
              'Notifications',
              'Widget preferences',
              supportOpen ? 'Support open' : 'Support closed',
            ],
            actions: const <PlaceholderAction>[
              PlaceholderAction(
                label: 'Open content preferences',
                route: AppRoutes.settingsContentPreferences,
              ),
              PlaceholderAction(
                label: 'Open notifications',
                route: AppRoutes.settingsNotifications,
              ),
              PlaceholderAction(
                label: 'Open widget preferences',
                route: AppRoutes.settingsWidgetPreferences,
              ),
              PlaceholderAction(
                label: 'Open support home',
                route: AppRoutes.settingsSupportHome,
              ),
              PlaceholderAction(
                label: 'Open privacy',
                route: AppRoutes.settingsPrivacy,
              ),
              PlaceholderAction(
                label: 'Open about',
                route: AppRoutes.settingsAbout,
              ),
            ],
            extraSection: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Mock support-state preview',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    supportOpen
                        ? 'Maintenance Fund is OPEN'
                        : 'Maintenance Fund is CLOSED',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  OutlinedButton(
                    onPressed: bootstrap.toggleSupportState,
                    child: const Text('Toggle preview state'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SupportHomeScreen extends StatelessWidget {
  const SupportHomeScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        final bool supportOpen = bootstrap.supportState == SupportState.open;

        return GlobalScreenScaffold(
          title: 'Support',
          subtitle: 'Transparent and optional',
          body: PlaceholderContent(
            eyebrow: 'Support settings',
            title: supportOpen
                ? 'Maintenance support is currently open'
                : 'Maintenance support is currently closed',
            description: supportOpen
                ? 'When support is open, maintenance funding appears and coffee support stays hidden.'
                : 'When support is closed, maintenance funding is hidden/disabled and coffee support appears instead.',
            tags: <String>[
              supportOpen ? 'Maintenance OPEN' : 'Maintenance CLOSED',
              'Transparency always visible',
              'Optional support only',
            ],
            actions: <PlaceholderAction>[
              if (supportOpen)
                const PlaceholderAction(
                  label: 'Open maintenance fund page',
                  route: AppRoutes.settingsSupportMaintenanceFund,
                ),
              if (!supportOpen)
                const PlaceholderAction(
                  label: 'Open coffee support page',
                  route: AppRoutes.settingsSupportCoffee,
                ),
              const PlaceholderAction(
                label: 'Open transparency page',
                route: AppRoutes.settingsSupportTransparency,
              ),
            ],
            extraSection: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Preview state switch',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Use this local toggle while designing the support flow.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  OutlinedButton(
                    onPressed: bootstrap.toggleSupportState,
                    child: const Text('Toggle support preview'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SupportMaintenanceFundScreen extends StatelessWidget {
  const SupportMaintenanceFundScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        final bool supportOpen = bootstrap.supportState == SupportState.open;

        return GlobalScreenScaffold(
          title: 'Maintenance Fund',
          subtitle: 'Optional support',
          body: PlaceholderContent(
            eyebrow: 'Maintenance fund',
            title: supportOpen
                ? 'Maintenance fund entry is available'
                : 'Maintenance fund is currently closed',
            description: supportOpen
                ? 'This page is where the open-state maintenance support flow can be designed.'
                : 'This page remains reachable in development, but the real product should hide or disable it when closed.',
            tags: const <String>[
              'Optional support',
              'Transparent rules',
              'No feature unlocks',
            ],
          ),
        );
      },
    );
  }
}

class SupportCoffeeScreen extends StatelessWidget {
  const SupportCoffeeScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        final bool supportOpen = bootstrap.supportState == SupportState.open;

        return GlobalScreenScaffold(
          title: 'Buy Me a Coffee',
          subtitle: 'Shown only when maintenance support is closed',
          body: PlaceholderContent(
            eyebrow: 'Coffee support',
            title: supportOpen
                ? 'Coffee support should stay hidden in open state'
                : 'Coffee support is available in closed state',
            description: supportOpen
                ? 'This remains visible only in development right now so you can design the page early.'
                : 'This page becomes the visible optional support path when maintenance support is closed.',
            tags: const <String>[
              'Optional',
              'Secondary support path',
              'No feature unlocks',
            ],
          ),
        );
      },
    );
  }
}

class PlaceholderGlobalRouteScreen extends StatelessWidget {
  const PlaceholderGlobalRouteScreen({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return GlobalScreenScaffold(
      title: title,
      body: PlaceholderContent(
        eyebrow: 'Global route',
        title: title,
        description: description,
        footerNote:
            'This placeholder sits on the root navigator, so back returns to the exact prior in-tab screen or flow.',
      ),
    );
  }
}
