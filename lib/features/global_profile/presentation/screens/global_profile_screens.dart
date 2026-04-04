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
                      'Current mode',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      bootstrap.isGuestMode
                          ? 'You are using the app in guest mode'
                          : 'Your account mode is active',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Core reading stays available without requiring a sign-in.',
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
                title: 'Profile options',
                subtitle:
                    'Manage how this device is being used and learn about optional account features.',
                icon: Icons.person_outline_rounded,
                child: Column(
                  children: <Widget>[
                    ProfileNavTile(
                      title: 'Auth status',
                      subtitle:
                          'See whether you are currently using guest mode or account mode.',
                      icon: Icons.badge_outlined,
                      trailingLabel: _modeLabel,
                      onTap: () => context.push(AppRoutes.profileAuthStatus),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ProfileNavTile(
                      title: 'Data sync',
                      subtitle:
                          'Understand what stays on this device and what account features can add later.',
                      icon: Icons.sync_outlined,
                      onTap: () => context.push(AppRoutes.profileDataSync),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ProfileNavTile(
                      title: 'Sign in',
                      subtitle:
                          'Learn about optional sign-in for backup and continuity.',
                      icon: Icons.login_rounded,
                      onTap: () => context.push(AppRoutes.profileSignIn),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ProfileNavTile(
                      title: 'Sign up',
                      subtitle:
                          'See how an account can help if you want sync later on.',
                      icon: Icons.person_add_alt_1_rounded,
                      onTap: () => context.push(AppRoutes.profileSignUp),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ProfileNavTile(
                      title: 'Sign out',
                      subtitle:
                          'Review how the app handles account and guest use on this device.',
                      icon: Icons.logout_rounded,
                      onTap: () => context.push(AppRoutes.profileSignOut),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'Why guest-first matters',
                subtitle:
                    'The app is designed to stay simple and welcoming from the first open.',
                icon: Icons.favorite_border_rounded,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'You can read, reflect, and explore plans without being blocked by login prompts.',
                    ),
                    _ProfileBullet(
                      text:
                          'Optional account features can be added later without changing the core reading flow.',
                    ),
                    _ProfileBullet(
                      text:
                          'The experience stays calm and usable whether you sign in or not.',
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
          subtitle: 'Current access mode',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              ProfileInfoCard(
                title: 'Current status',
                subtitle:
                    'A simple view of how this device is being used right now.',
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
                                    ? 'You can keep using the app normally without signing in.'
                                    : 'Account features can help with continuity across devices.',
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
                title: 'Guest mode includes',
                subtitle:
                    'A clear summary of what is already available without an account.',
                icon: Icons.check_circle_outline_rounded,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Browse daily verses, reading plans, saved items, and settings without interruption.',
                    ),
                    _ProfileBullet(
                      text:
                          'Use category preferences and reminder time on this device.',
                    ),
                    _ProfileBullet(
                      text:
                          'Keep the experience simple while you decide whether sync matters to you.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'Optional account features',
                subtitle:
                    'An account is there for continuity, not as a gate to reading.',
                icon: Icons.cloud_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Sync bookmarks, highlights, notes, and preferences across devices.',
                    ),
                    _ProfileBullet(
                      text:
                          'Keep your reading life easier to restore when you change devices.',
                    ),
                    _ProfileBullet(
                      text:
                          'Add continuity without taking away the guest-first experience.',
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
                      'Related profile pages',
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
          subtitle: 'This device and future account sync',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Current sync view',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      isGuest
                          ? 'Your reading setup is currently tied to this device'
                          : 'Your account can support continuity across devices',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Bookmarks, notes, and preferences are easiest to keep together when the app can follow you from one device to another.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        _SummaryPill(
                          label: 'Mode',
                          value: isGuest ? 'On this device' : 'Account-ready',
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
                title: 'What stays close at hand',
                subtitle:
                    'A simple picture of the things that matter most in day-to-day use.',
                icon: Icons.phone_android_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Category choices and reminder timing on this device.',
                    ),
                    _ProfileBullet(
                      text:
                          'Saved verses, highlights, and notes you return to most.',
                    ),
                    _ProfileBullet(
                      text:
                          'A reading flow that stays available even without signing in.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ProfileInfoCard(
                title: 'What account features can add',
                subtitle:
                    'A simple picture of the continuity an account can support.',
                icon: Icons.sync_rounded,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ProfileBullet(
                      text:
                          'Carry bookmarks, notes, and progress across devices.',
                    ),
                    _ProfileBullet(
                      text:
                          'Make it easier to return to your reading life after changing phones.',
                    ),
                    _ProfileBullet(
                      text:
                          'Keep the guest-first flow available while adding backup and continuity later.',
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
                      'Related profile pages',
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
                'You can keep using the app without interruption even if you never sign in.',
            icon: Icons.login_rounded,
            child: Text(
              'Sign in is mainly for people who want continuity, backup, and easier movement between devices.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ProfileInfoCard(
            title: 'Why people sign in',
            icon: Icons.cloud_outlined,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ProfileBullet(
                  text:
                      'Keep bookmarks, highlights, notes, and preferences together.',
                ),
                _ProfileBullet(
                  text:
                      'Make it easier to return to your reading life on another device.',
                ),
                _ProfileBullet(
                  text:
                      'Add continuity without replacing the guest-first experience.',
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
                  'Related profile pages',
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
      subtitle: 'Create an optional account',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          ProfileInfoCard(
            title: 'An account is not required',
            subtitle:
                'Reading stays open and available whether you create an account or not.',
            icon: Icons.person_add_alt_1_rounded,
            child: Text(
              'An account is simply there for people who want their saved reading life to travel more easily with them.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ProfileInfoCard(
            title: 'What an account can help with',
            icon: Icons.info_outline_rounded,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ProfileBullet(
                  text:
                      'Keep bookmarks, highlights, notes, and progress connected across devices.',
                ),
                _ProfileBullet(
                  text:
                      'Make it easier to come back to your saved reflections later on.',
                ),
                _ProfileBullet(
                  text:
                      'Support continuity while keeping the app welcoming to guest users.',
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
                  'Related profile pages',
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
      subtitle: 'Account and guest use on this device',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          ProfileInfoCard(
            title: isGuest
                ? 'You are already in guest mode'
                : 'Signed-in access',
            subtitle:
                'A simple explanation of how the app handles account and guest use.',
            icon: Icons.logout_rounded,
            child: Text(
              isGuest
                  ? 'There is no account session to end right now, so you can simply keep reading in guest mode.'
                  : 'Signing out should always leave the app calm, clear, and easy to keep using.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ProfileInfoCard(
            title: 'What matters most here',
            icon: Icons.shield_outlined,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ProfileBullet(
                  text:
                      'The app should remain easy to use even after leaving account mode.',
                ),
                _ProfileBullet(
                  text: 'Guest-first reading should stay available and clear.',
                ),
                _ProfileBullet(
                  text:
                      'Saved content and continuity should be explained simply and honestly.',
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
                  'Related profile pages',
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
