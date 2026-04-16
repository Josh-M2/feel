import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/bootstrap/app_bootstrap_controller.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_time_picker_sheet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      context.go(
        widget.bootstrap.onboardingCompleted
            ? AppRoutes.todayHome
            : AppRoutes.onboardingWelcome,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppCard(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.auto_stories_rounded,
                  size: 48,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Feel',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Calm, guest-first scripture reading with a modern cozy shell.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return _OnboardingScaffold(
      title: 'Start with a calmer daily Bible rhythm',
      subtitle:
          'Choose verse themes, set a daily time, and keep everything guest-first for now.',
      stepLabel: 'Welcome',
      body: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'What this starter supports',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            const _Bullet(
              text: 'UI/UX-first foundation with dummy local state',
            ),
            const _Bullet(
              text: 'Daily verse preferences and notification time',
            ),
            const _Bullet(text: 'Guest-first usage with optional login later'),
            const _Bullet(text: 'Rounded, soft, reusable component direction'),
          ],
        ),
      ),
      primaryLabel: 'Start onboarding',
      onPrimaryPressed: () =>
          context.push(AppRoutes.onboardingVersePreferences),
    );
  }
}

class VersePreferencesScreen extends StatelessWidget {
  const VersePreferencesScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        return _OnboardingScaffold(
          title: 'Pick the verse themes you want most',
          subtitle:
              'You can change these later in settings. At least one stays selected.',
          stepLabel: 'Step 1 of 4',
          body: AppCard(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: bootstrap.availableCategories.map((String category) {
                final bool isSelected = bootstrap.selectedCategories.contains(
                  category,
                );

                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) => bootstrap.toggleCategory(category),
                );
              }).toList(),
            ),
          ),
          secondaryLabel: 'Back',
          onSecondaryPressed: context.pop,
          primaryLabel: 'Next',
          onPrimaryPressed: () =>
              context.push(AppRoutes.onboardingDailyNotificationTime),
        );
      },
    );
  }
}

class DailyNotificationTimeScreen extends StatelessWidget {
  const DailyNotificationTimeScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showAppTimePickerSheet(
      context,
      initialTime: bootstrap.dailyNotificationTime,
      title: 'Choose your daily rhythm',
      subtitle:
          'Pick one clear time for your daily verse, reminders, and future widget alignment.',
    );

    if (picked != null) {
      bootstrap.setDailyNotificationTime(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        return _OnboardingScaffold(
          title: 'Choose your daily verse reminder time',
          subtitle:
              'This is also the time reminders and the future widget will align with for the daily assignment.',
          stepLabel: 'Step 2 of 4',
          body: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Selected time',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  bootstrap.dailyNotificationLabel,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.tonal(
                  onPressed: () => _pickTime(context),
                  child: const Text('Adjust time'),
                ),
              ],
            ),
          ),
          secondaryLabel: 'Back',
          onSecondaryPressed: context.pop,
          primaryLabel: 'Next',
          onPrimaryPressed: () =>
              context.push(AppRoutes.onboardingNotificationPermission),
        );
      },
    );
  }
}

class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return _OnboardingScaffold(
      title: 'Notifications are optional',
      subtitle:
          'Skipping is allowed. If you enable them, this device will schedule a real daily reminder.',
      stepLabel: 'Step 3 of 4',
      body: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Enable daily verse reminders',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'This will later trigger the same daily assignment used in-app and in the widget.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  await bootstrap.setNotificationsEnabled(true);
                  if (context.mounted) {
                    context.push(AppRoutes.onboardingFinish);
                  }
                },
                child: const Text('Enable reminders'),
              ),
            ),
          ],
        ),
      ),
      primaryLabel: 'Skip for now',
      onPrimaryPressed: () {
        bootstrap.setNotificationsEnabled(false);
        context.push(AppRoutes.onboardingFinish);
      },
      secondaryLabel: 'Back',
      onSecondaryPressed: context.pop,
    );
  }
}

class FinishScreen extends StatelessWidget {
  const FinishScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        return _OnboardingScaffold(
          title: 'Your starter setup is ready',
          subtitle:
              'You can change all of this later in settings, and login still remains optional.',
          stepLabel: 'Step 4 of 4',
          body: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Selected categories',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: bootstrap.selectedCategories
                      .map((String item) => Chip(label: Text(item)))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Daily time',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(bootstrap.dailyNotificationLabel),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  bootstrap.notificationsEnabled
                      ? 'Enabled'
                      : 'Skipped for now',
                ),
              ],
            ),
          ),
          secondaryLabel: 'Back',
          onSecondaryPressed: context.pop,
          primaryLabel: 'Enter app',
          onPrimaryPressed: () {
            bootstrap.completeOnboarding();
            context.go(AppRoutes.todayHome);
          },
        );
      },
    );
  }
}

class _OnboardingScaffold extends StatelessWidget {
  const _OnboardingScaffold({
    required this.title,
    required this.subtitle,
    required this.stepLabel,
    required this.body,
    this.primaryLabel,
    this.secondaryLabel,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  final String title;
  final String subtitle;
  final String stepLabel;
  final Widget body;
  final String? primaryLabel;
  final String? secondaryLabel;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: <Widget>[
            if (secondaryLabel != null && primaryLabel == null) ...<Widget>[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onSecondaryPressed,
                  child: Text(secondaryLabel!),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Text(
              stepLabel.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontSize: 30),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.xl),
            body,
            const SizedBox(height: AppSpacing.xl),
            if (primaryLabel != null)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onPrimaryPressed,
                  child: Text(primaryLabel!),
                ),
              ),
            if (secondaryLabel != null && primaryLabel != null) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onSecondaryPressed,
                  child: Text(secondaryLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

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
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
