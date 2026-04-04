import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/bootstrap/app_bootstrap_controller.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_screen_scaffold.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_nav_tile.dart';

class ProfileOverviewScreen extends StatelessWidget {
  const ProfileOverviewScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  String get _modeLabel => bootstrap.isGuestMode ? 'GUEST' : 'ACCOUNT';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        return GlobalScreenScaffold(
          title: 'Profile',
          subtitle: 'Guest-first overview',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current profile mode',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      bootstrap.isGuestMode
                          ? 'You are using the app in guest-first mode'
                          : 'Your account mode is active',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Core Bible reading stays usable without forced login. Profile explains the current mode clearly and keeps future sync/account paths easy to understand.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        _SummaryPill(label: 'Mode', value: _modeLabel),
                        _SummaryPill(
                          label: 'Categories',
                          value: '${bootstrap.selectedCategories.length}',
                        ),
                        _SummaryPill(
                          label: 'Notifications',
                          value: bootstrap.notificationsEnabled ? 'On' : 'Off',
                        ),
                        _SummaryPill(
                          label: 'Daily time',
                          value: bootstrap.dailyNotificationLabel,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'Profile actions',
                subtitle:
                    'These routes help explain current app state and future optional account features.',
                icon: Icons.person_outline_rounded,
                child: Column(
                  children: <Widget>[
                    ProfileNavTile(
                      title: 'Auth status',
                      subtitle:
                          'See whether you are in guest mode and what an account can add later.',
                      icon: Icons.badge_outlined,
                      trailingLabel: _modeLabel,
                      onTap: () => context.push(AppRoutes.profileAuthStatus),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ProfileNavTile(
                      title: 'Data sync',
                      subtitle:
                          'Understand what stays local now and what can sync later with optional sign-in.',
                      icon: Icons.sync_outlined,
                      onTap: () => context.push(AppRoutes.profileDataSync),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ProfileNavTile(
                      title: 'Sign in',
                      subtitle:
                          'Future optional sign-in entry for cross-device sync.',
                      icon: Icons.login_rounded,
                      onTap: () => context.push(AppRoutes.profileSignIn),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ProfileNavTile(
                      title: 'Sign up',
                      subtitle:
                          'Future optional account creation path without blocking core app usage.',
                      icon: Icons.person_add_alt_1_rounded,
                      onTap: () => context.push(AppRoutes.profileSignUp),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ProfileNavTile(
                      title: 'Sign out',
                      subtitle:
                          'Polished placeholder for future account session sign-out behavior.',
                      icon: Icons.logout_rounded,
                      onTap: () => context.push(AppRoutes.profileSignOut),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'Why guest-first matters here',
                subtitle:
                    'This keeps the app aligned with your locked usage policy.',
                icon: Icons.favorite_border_rounded,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Users can complete core reading flows without being blocked by login prompts.',
                    ),
                    _ProfileBullet(
                      text:
                          'Profile makes the current mode understandable instead of hidden or confusing.',
                    ),
                    _ProfileBullet(
                      text:
                          'Optional account features can be introduced later without redesigning the shell.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AuthStatusScreen extends StatelessWidget {
  const AuthStatusScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        final bool isGuest = bootstrap.isGuestMode;

        return GlobalScreenScaffold(
          title: 'Auth status',
          subtitle: 'Current access mode and future account path',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              ProfileInfoCard(
                title: 'Current status',
                subtitle:
                    'This explains the current mode without pressuring the user into account creation.',
                icon: Icons.verified_user_outlined,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(AppRadii.xl),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(AppRadii.lg),
                          ),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(
                              isGuest
                                  ? Icons.person_outline_rounded
                                  : Icons.verified_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                isGuest
                                    ? 'Guest mode active'
                                    : 'Account mode active',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                isGuest
                                    ? 'You can keep using the core app without signing in.'
                                    : 'Account-based features can build on this later.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'What guest mode includes',
                subtitle:
                    'A transparent summary of what the user can already do right now.',
                icon: Icons.check_circle_outline_rounded,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Browse scripture, daily verse flows, plans, and saved-library UI without forced login.',
                    ),
                    _ProfileBullet(
                      text:
                          'Use local preferences like category choices and reminder time in the UI-first phase.',
                    ),
                    _ProfileBullet(
                      text:
                          'Keep the experience simple before deciding whether sync is needed.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'What optional account mode can add later',
                subtitle:
                    'This keeps the future value clear without turning it into a gate.',
                icon: Icons.cloud_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Cross-device sync for bookmarks, highlights, notes, and preferences.',
                    ),
                    _ProfileBullet(
                      text:
                          'Backup and recovery for saved reflections and reading state.',
                    ),
                    _ProfileBullet(
                      text:
                          'A smoother transition from guest use to persistent personal data later.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Future auth routes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push(AppRoutes.profileSignIn),
                        child: const Text('Open sign in'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push(AppRoutes.profileSignUp),
                        child: const Text('Open sign up'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DataSyncScreen extends StatelessWidget {
  const DataSyncScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        final bool isGuest = bootstrap.isGuestMode;

        return GlobalScreenScaffold(
          title: 'Data sync',
          subtitle: 'What is local now and what can sync later',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current sync mode',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      isGuest
                          ? 'Your current experience is local-first'
                          : 'Your current experience can later support sync',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      isGuest
                          ? 'In the current UI-first phase, your profile is not using real cross-device sync yet. This screen explains that clearly instead of pretending sync already exists.'
                          : 'This screen is structured for future sync status messaging once account-backed storage is added.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        _SummaryPill(
                          label: 'Mode',
                          value: isGuest ? 'Local-only' : 'Sync-ready',
                        ),
                        _SummaryPill(
                          label: 'Prefs',
                          value:
                              '${bootstrap.selectedCategories.length} categories',
                        ),
                        _SummaryPill(
                          label: 'Reminder',
                          value: bootstrap.dailyNotificationLabel,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'What is represented locally right now',
                subtitle:
                    'These are the kinds of states already present in the UI-first phase.',
                icon: Icons.phone_android_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Selected verse categories and daily reminder time.',
                    ),
                    _ProfileBullet(
                      text:
                          'Guest-first reading and settings flows across the app shell.',
                    ),
                    _ProfileBullet(
                      text:
                          'Saved-library UI structure that can later map to real local or remote storage.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'What sync can cover later',
                subtitle:
                    'These are the natural next-step benefits once optional account sync is added.',
                icon: Icons.sync_rounded,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Bookmarks, highlights, notes, and reading progress across devices.',
                    ),
                    _ProfileBullet(
                      text:
                          'Preferences and daily reminder settings that follow the user.',
                    ),
                    _ProfileBullet(
                      text:
                          'Backup and recovery for saved reflections and personal reading state.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Related routes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push(AppRoutes.profileAuthStatus),
                        child: const Text('Open auth status'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push(AppRoutes.profileSignIn),
                        child: const Text('Open sign in'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SignInPlaceholderScreen extends StatelessWidget {
  const SignInPlaceholderScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        return GlobalScreenScaffold(
          title: 'Sign in',
          subtitle: 'Optional future account entry point',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              _AuthHeroCard(
                eyebrow: 'Optional sign in',
                title: 'Signing in will stay optional',
                description:
                    'This polished placeholder explains the future sign-in path without interrupting guest-first Bible use. When real auth is added, this route can become the true entry point for cross-device sync.',
                icon: Icons.login_rounded,
                primaryLabel: 'Keep using guest mode',
                onPrimaryPressed: () => context.pop(),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'What sign in can add later',
                subtitle:
                    'These are the account benefits this route will eventually unlock.',
                icon: Icons.cloud_done_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Sync saved verses, notes, highlights, and reading progress across devices.',
                    ),
                    _ProfileBullet(
                      text:
                          'Keep preferences like categories, reminder time, and widget settings attached to the user.',
                    ),
                    _ProfileBullet(
                      text:
                          'Support backup and recovery without taking away guest-first usage.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'Current status today',
                subtitle:
                    'This keeps the route honest about the current implementation state.',
                icon: Icons.info_outline_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Real authentication is not connected yet in this phase. This screen exists to keep the flow coherent, reduce future routing churn, and make the guest-to-account journey easy to upgrade later.',
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        _SummaryPill(label: 'Mode', value: 'Guest-first'),
                        _SummaryPill(label: 'Sync', value: 'Future'),
                        _SummaryPill(label: 'Status', value: 'Placeholder'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Related routes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push(AppRoutes.profileDataSync),
                        child: const Text('Open data sync'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push(AppRoutes.profileSignUp),
                        child: const Text('Open sign up'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SignUpPlaceholderScreen extends StatelessWidget {
  const SignUpPlaceholderScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        return GlobalScreenScaffold(
          title: 'Sign up',
          subtitle: 'Optional future account creation path',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              _AuthHeroCard(
                eyebrow: 'Optional sign up',
                title: 'Account creation should never block core reading',
                description:
                    'This placeholder keeps the sign-up route feeling intentional and calm. When real auth is added, it can become the place where users choose to save their data across devices without losing guest-first freedom.',
                icon: Icons.person_add_alt_1_rounded,
                primaryLabel: 'Stay in guest mode',
                onPrimaryPressed: () => context.pop(),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'Why someone may choose to sign up later',
                subtitle:
                    'The value should stay clear without turning into pressure.',
                icon: Icons.star_border_rounded,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Preserve saved verses, reflections, highlights, and reading state beyond one device.',
                    ),
                    _ProfileBullet(
                      text:
                          'Make future reinstall or device change less stressful for the user.',
                    ),
                    _ProfileBullet(
                      text:
                          'Allow a gentle upgrade path from local-only use to account-backed sync.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'Current route status',
                subtitle:
                    'This keeps the UI polished while staying transparent about what is not built yet.',
                icon: Icons.lock_outline_rounded,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Real sign-up form submission, credential handling, and session creation are not active yet. This screen exists so the navigation and future profile flow are already stable.',
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        _SummaryPill(label: 'Guest access', value: 'Available'),
                        _SummaryPill(label: 'Real sign up', value: 'Later'),
                        _SummaryPill(label: 'Flow', value: 'Ready'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Related routes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push(AppRoutes.profileSignIn),
                        child: const Text('Open sign in'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push(AppRoutes.profileDataSync),
                        child: const Text('Open data sync'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SignOutPlaceholderScreen extends StatelessWidget {
  const SignOutPlaceholderScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        final bool isGuest = bootstrap.isGuestMode;

        return GlobalScreenScaffold(
          title: 'Sign out',
          subtitle: 'Future account session exit flow',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              _AuthHeroCard(
                eyebrow: 'Sign out preview',
                title: isGuest
                    ? 'There is no active account session to sign out of right now'
                    : 'Sign out flow will live here later',
                description: isGuest
                    ? 'Because the current build is guest-first and real authentication is not active yet, this route acts as a polished explanatory screen instead of a fake confirmation dialog.'
                    : 'When account mode is live, this route can confirm sign-out and explain what remains local versus what stays synced.',
                icon: Icons.logout_rounded,
                primaryLabel: 'Back to profile',
                onPrimaryPressed: () => context.pop(),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'How sign out should behave later',
                subtitle:
                    'The future sign-out experience should stay clear and non-destructive.',
                icon: Icons.exit_to_app_rounded,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Explain whether saved local data remains available after sign out.',
                    ),
                    _ProfileBullet(
                      text:
                          'Clarify what sync stops and what remains accessible in guest mode.',
                    ),
                    _ProfileBullet(
                      text:
                          'Never make sign out feel like losing access to the core Bible experience.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'Current route status',
                subtitle:
                    'This explains the current implementation honestly instead of simulating destructive actions.',
                icon: Icons.info_outline_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isGuest
                          ? 'You are currently in guest mode, so there is no signed-in session to end.'
                          : 'Real session clearing is not wired yet in this phase.',
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        _SummaryPill(
                          label: 'Mode',
                          value: isGuest ? 'Guest' : 'Account',
                        ),
                        _SummaryPill(label: 'Session clear', value: 'Later'),
                        _SummaryPill(label: 'Core app', value: 'Always usable'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Related routes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push(AppRoutes.profileOverview),
                        child: const Text('Open profile overview'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push(AppRoutes.profileAuthStatus),
                        child: const Text('Open auth status'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AuthHeroCard extends StatelessWidget {
  const _AuthHeroCard({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryLabel,
    required this.onPrimaryPressed,
  });

  final String eyebrow;
  final String title;
  final String description;
  final IconData icon;
  final String primaryLabel;
  final VoidCallback onPrimaryPressed;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            eyebrow.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppRadii.xl),
                ),
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: Icon(icon, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onPrimaryPressed,
              child: Text(primaryLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileBullet extends StatelessWidget {
  const _ProfileBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8, color: AppColors.accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
