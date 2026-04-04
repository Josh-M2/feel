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
                          'Review how sign-out should behave once optional account mode exists.',
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

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return GlobalScreenScaffold(
      title: 'Sign in',
      subtitle: 'Optional account access',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          ProfileInfoCard(
            title: 'Sign in is optional',
            subtitle:
                'This route is polished for the current phase, but real auth is not wired yet.',
            icon: Icons.login_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Signing in will later be used for cross-device sync, backup, and continuity of saved content. It should never block core Bible reading.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('Continue with future sign-in'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ProfileInfoCard(
            title: 'What sign in will add later',
            icon: Icons.cloud_outlined,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ProfileBullet(
                  text: 'Sync bookmarks, highlights, notes, and progress.',
                ),
                _ProfileBullet(text: 'Recover saved data across devices.'),
                _ProfileBullet(
                  text:
                      'Keep guest-first reading available even before sign-in.',
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
                  'Related profile routes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push(AppRoutes.profileSignUp),
                    child: const Text('Open sign up'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push(AppRoutes.profileDataSync),
                    child: const Text('Open data sync'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return GlobalScreenScaffold(
      title: 'Sign up',
      subtitle: 'Create an optional account later',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          ProfileInfoCard(
            title: 'Account creation is not required',
            subtitle:
                'This screen explains the future role of sign-up without turning it into a gate.',
            icon: Icons.person_add_alt_1_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'A future account will mainly support sync, backup, and device continuity. The app should still remain usable without forcing account creation.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('Continue with future sign-up'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ProfileInfoCard(
            title: 'Why this route exists now',
            icon: Icons.info_outline_rounded,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ProfileBullet(
                  text:
                      'It lets the future account flow feel intentional in the UI-first phase.',
                ),
                _ProfileBullet(
                  text:
                      'It prevents auth routes from feeling like missing pieces later.',
                ),
                _ProfileBullet(
                  text:
                      'It stays consistent with the guest-first policy already locked for V1.',
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
                  'Related profile routes',
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
                    onPressed: () => context.push(AppRoutes.profileAuthStatus),
                    child: const Text('Open auth status'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignOutScreen extends StatelessWidget {
  const SignOutScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    final bool isGuest = bootstrap.isGuestMode;

    return GlobalScreenScaffold(
      title: 'Sign out',
      subtitle: 'Future account exit behavior',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          ProfileInfoCard(
            title: isGuest ? 'No active account session' : 'Sign out preview',
            subtitle:
                'This screen stays honest about current limitations in the UI-first phase.',
            icon: Icons.logout_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isGuest
                      ? 'You are currently in guest mode, so there is no real account session to sign out from yet.'
                      : 'This is where sign-out confirmation and sync-aware messaging will live once real auth exists.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: Text(
                      isGuest
                          ? 'No active sign-out action yet'
                          : 'Future sign-out action',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ProfileInfoCard(
            title: 'Future sign-out behavior',
            icon: Icons.shield_outlined,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ProfileBullet(
                  text:
                      'Clarify what stays on-device and what remains synced remotely.',
                ),
                _ProfileBullet(
                  text:
                      'Allow users to return to guest-first reading without losing clarity.',
                ),
                _ProfileBullet(
                  text:
                      'Explain sync and saved-data expectations honestly before sign-out.',
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
                  'Related profile routes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push(AppRoutes.profileOverview),
                    child: const Text('Back to profile overview'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push(AppRoutes.profileDataSync),
                    child: const Text('Open data sync'),
                  ),
                ),
              ],
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
