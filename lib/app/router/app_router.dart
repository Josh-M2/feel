import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../bootstrap/app_bootstrap_controller.dart';
import '../shell/main_tab_shell.dart';
import 'app_routes.dart';
import '../../features/foundation/presentation/screens/placeholder_screens.dart'
    hide
        TodayHomeScreen,
        ReadBooksScreen,
        PlansListScreen,
        SavedBookmarksScreen,
        SettingsHomeScreen,
        ProfileOverviewScreen,
        SupportMaintenanceFundScreen,
        SupportCoffeeScreen,
        SupportHomeScreen;
import '../../features/global_profile/presentation/screens/global_profile_screens.dart';
import '../../features/global_settings/presentation/screens/global_settings_screens.dart';
import '../../features/onboarding/presentation/screens/onboarding_screens.dart';
import '../../features/plans/domain/models/reading_plan.dart';
import '../../features/plans/presentation/screens/plans_screens.dart';
import '../../features/read/domain/models/read_book.dart';
import '../../features/read/presentation/screens/read_screens.dart';
import '../../features/saved/presentation/screens/saved_screens.dart';
import '../../features/today/presentation/screens/today_screens.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _todayNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'today',
);
final GlobalKey<NavigatorState> _readNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'read',
);
final GlobalKey<NavigatorState> _plansNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'plans',
);
final GlobalKey<NavigatorState> _savedNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'saved',
);

GoRouter createAppRouter(AppBootstrapController bootstrap) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: bootstrap,
    redirect: (context, state) {
      final String path = state.uri.path;
      final bool isOnboardingRoute =
          path == AppRoutes.splash || path.startsWith('/onboarding/');
      final bool isAppRoute =
          path.startsWith('/tab_') || path.startsWith('/global_');

      if (!bootstrap.onboardingCompleted) {
        if (isOnboardingRoute) return null;
        if (isAppRoute) return AppRoutes.onboardingWelcome;
      }

      if (bootstrap.onboardingCompleted && path.startsWith('/onboarding/')) {
        return AppRoutes.todayHome;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => SplashScreen(bootstrap: bootstrap),
      ),

      GoRoute(
        path: AppRoutes.onboardingWelcome,
        builder: (context, state) => WelcomeScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        path: AppRoutes.onboardingVersePreferences,
        builder: (context, state) =>
            VersePreferencesScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        path: AppRoutes.onboardingDailyNotificationTime,
        builder: (context, state) =>
            DailyNotificationTimeScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        path: AppRoutes.onboardingNotificationPermission,
        builder: (context, state) =>
            NotificationPermissionScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        path: AppRoutes.onboardingFinish,
        builder: (context, state) => FinishScreen(bootstrap: bootstrap),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainTabShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _todayNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.todayHome,
                builder: (context, state) => const TodayHomeScreen(),
              ),
              GoRoute(
                path: AppRoutes.todayVerseDetail,
                builder: (context, state) => const TodayVerseDetailScreen(),
              ),
              GoRoute(
                path: AppRoutes.todayVerseContext,
                builder: (context, state) => const TodayVerseContextScreen(),
              ),
              GoRoute(
                path: AppRoutes.todayVerseAiExplain,
                builder: (context, state) => const TodayVerseAiExplainScreen(),
              ),
              GoRoute(
                path: AppRoutes.todaySharePreview,
                builder: (context, state) => const TodaySharePreviewScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _readNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.readBooks,
                builder: (context, state) => const ReadBooksScreen(),
              ),
              GoRoute(
                path: AppRoutes.readBookDetail,
                builder: (context, state) {
                  final ReadBookRouteArgs? args =
                      state.extra is ReadBookRouteArgs
                      ? state.extra as ReadBookRouteArgs
                      : null;

                  return ReadBookDetailScreen(bookId: args?.bookId);
                },
              ),
              GoRoute(
                path: AppRoutes.readChapterRead,
                builder: (context, state) {
                  final ChapterReadRouteArgs? args =
                      state.extra is ChapterReadRouteArgs
                      ? state.extra as ChapterReadRouteArgs
                      : null;

                  return ChapterReadScreen(
                    bookId: args?.bookId,
                    chapterNumber: args?.chapterNumber,
                  );
                },
              ),
              GoRoute(
                path: AppRoutes.readReferenceSearch,
                builder: (context, state) => const PlaceholderTabRouteScreen(
                  title: 'Reference search',
                  subtitle: 'Read',
                  description:
                      'Search by verse reference first in V1, with a clean input flow and calm result presentation.',
                  tags: <String>[
                    'Reference search',
                    'Direct lookup',
                    'Fast access',
                  ],
                  showBackButton: true,
                ),
              ),
              GoRoute(
                path: AppRoutes.readContinueReading,
                builder: (context, state) => const PlaceholderTabRouteScreen(
                  title: 'Continue reading',
                  subtitle: 'Read',
                  description:
                      'A simple entry back into the user’s most recent reading context and chapter flow.',
                  tags: <String>[
                    'Resume context',
                    'Progress cue',
                    'Lightweight memory',
                  ],
                  showBackButton: true,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _plansNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.plansList,
                builder: (context, state) => const PlansListScreen(),
              ),
              GoRoute(
                path: AppRoutes.plansPlanDetail,
                builder: (context, state) {
                  final PlanDetailRouteArgs? args =
                      state.extra is PlanDetailRouteArgs
                      ? state.extra as PlanDetailRouteArgs
                      : null;

                  return PlanDetailScreen(planId: args?.planId);
                },
              ),
              GoRoute(
                path: AppRoutes.plansDayRead,
                builder: (context, state) {
                  final PlanDayReadRouteArgs? args =
                      state.extra is PlanDayReadRouteArgs
                      ? state.extra as PlanDayReadRouteArgs
                      : null;

                  return PlanDayReadScreen(
                    planId: args?.planId,
                    dayNumber: args?.dayNumber,
                  );
                },
              ),
              GoRoute(
                path: AppRoutes.plansProgress,
                builder: (context, state) => const PlansProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _savedNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.savedBookmarks,
                builder: (context, state) => const SavedBookmarksScreen(),
              ),
              GoRoute(
                path: AppRoutes.savedHighlights,
                builder: (context, state) => const SavedHighlightsScreen(),
              ),
              GoRoute(
                path: AppRoutes.savedNotes,
                builder: (context, state) => const SavedNotesScreen(),
              ),
              GoRoute(
                path: AppRoutes.savedHistory,
                builder: (context, state) => const SavedHistoryScreen(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.profileOverview,
        builder: (context, state) =>
            ProfileOverviewScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.profileAuthStatus,
        builder: (context, state) => AuthStatusScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.profileSignIn,
        builder: (context, state) => SignInScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.profileSignUp,
        builder: (context, state) => SignUpScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.profileDataSync,
        builder: (context, state) => DataSyncScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.profileSignOut,
        builder: (context, state) => SignOutScreen(bootstrap: bootstrap),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.settingsHome,
        builder: (context, state) => SettingsHomeScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.settingsContentPreferences,
        builder: (context, state) =>
            ContentPreferencesScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.settingsNotifications,
        builder: (context, state) =>
            NotificationsSettingsScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.settingsWidgetPreferences,
        builder: (context, state) =>
            WidgetPreferencesScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.settingsSupportHome,
        builder: (context, state) => SupportHomeScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.settingsSupportMaintenanceFund,
        builder: (context, state) =>
            SupportMaintenanceFundScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.settingsSupportTransparency,
        builder: (context, state) =>
            SupportTransparencyScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.settingsSupportCoffee,
        builder: (context, state) => SupportCoffeeScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.settingsPrivacy,
        builder: (context, state) => PrivacyScreen(bootstrap: bootstrap),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.settingsAbout,
        builder: (context, state) => AboutScreen(bootstrap: bootstrap),
      ),
    ],
  );
}
