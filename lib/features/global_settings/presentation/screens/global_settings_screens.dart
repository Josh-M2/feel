import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/bootstrap/app_bootstrap_controller.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_screen_scaffold.dart';
import '../widgets/settings_info_card.dart';
import '../widgets/settings_nav_tile.dart';
import '../widgets/support_progress_card.dart';
import '../widgets/widget_preview_card.dart';

String _widgetStyleLabel(WidgetPreviewStyle style) {
  switch (style) {
    case WidgetPreviewStyle.cozy:
      return 'Cozy';
    case WidgetPreviewStyle.minimal:
      return 'Minimal';
  }
}

String _primaryWidgetCategory(AppBootstrapController bootstrap) {
  final List<String> categories = bootstrap.selectedCategories;
  if (categories.isEmpty) return 'Guidance';
  return categories.first;
}

class _SupportPreviewMetrics {
  const _SupportPreviewMetrics({
    required this.statusLabel,
    required this.caption,
    required this.currentAmount,
    required this.targetAmount,
    required this.supporterCount,
  });

  final String statusLabel;
  final String caption;
  final double currentAmount;
  final double targetAmount;
  final int supporterCount;
}

_SupportPreviewMetrics _supportMetrics(SupportState state) {
  if (state == SupportState.open) {
    return const _SupportPreviewMetrics(
      statusLabel: 'OPEN',
      caption: 'Maintenance support is currently open this month.',
      currentAmount: 240,
      targetAmount: 500,
      supporterCount: 18,
    );
  }

  return const _SupportPreviewMetrics(
    statusLabel: 'CLOSED',
    caption: 'The monthly maintenance target has already been reached for now.',
    currentAmount: 500,
    targetAmount: 500,
    supporterCount: 26,
  );
}

class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  String _supportStateLabel(SupportState state) {
    return state == SupportState.open ? 'OPEN' : 'CLOSED';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        final int categoryCount = bootstrap.selectedCategories.length;
        final bool notificationsEnabled = bootstrap.notificationsEnabled;
        final String widgetCategory = _primaryWidgetCategory(bootstrap);
        final WidgetPreviewSample widgetSample = buildWidgetPreviewSample(
          widgetCategory,
        );

        return GlobalScreenScaffold(
          title: 'Settings',
          subtitle: 'Content, reminders, widgets, support, and app info',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Your preferences',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'A calm place to shape how the app feels day to day',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Adjust reading themes, reminders, widget style, and support information in one place.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        _SummaryPill(
                          label: 'Categories',
                          value: '$categoryCount selected',
                        ),
                        _SummaryPill(
                          label: 'Daily time',
                          value: bootstrap.dailyNotificationLabel,
                        ),
                        _SummaryPill(
                          label: 'Reminders',
                          value: notificationsEnabled ? 'On' : 'Off',
                        ),
                        _SummaryPill(
                          label: 'Support',
                          value: _supportStateLabel(bootstrap.supportState),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Core settings',
                subtitle: 'The main places to shape your reading experience.',
                icon: Icons.tune_rounded,
                child: Column(
                  children: <Widget>[
                    SettingsNavTile(
                      title: 'Content preferences',
                      subtitle:
                          'Choose the verse categories you want to see most often.',
                      icon: Icons.auto_stories_outlined,
                      trailingLabel: '$categoryCount selected',
                      onTap: () =>
                          context.push(AppRoutes.settingsContentPreferences),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SettingsNavTile(
                      title: 'Notifications',
                      subtitle:
                          'Choose whether reminders are on and when they appear.',
                      icon: Icons.notifications_none_rounded,
                      trailingLabel: notificationsEnabled ? 'On' : 'Off',
                      onTap: () =>
                          context.push(AppRoutes.settingsNotifications),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SettingsNavTile(
                      title: 'Widget preferences',
                      subtitle:
                          'Choose how the daily verse looks on the widget.',
                      icon: Icons.widgets_outlined,
                      trailingLabel: _widgetStyleLabel(
                        bootstrap.widgetPreviewStyle,
                      ),
                      onTap: () =>
                          context.push(AppRoutes.settingsWidgetPreferences),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Widget preview',
                subtitle:
                    'A simple look at how the daily verse can appear on the widget.',
                icon: Icons.widgets_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    WidgetPreviewCard(
                      sample: widgetSample,
                      categoryLabel: widgetCategory,
                      updateTimeLabel: bootstrap.dailyNotificationLabel,
                      style: bootstrap.widgetPreviewStyle,
                      showReference: bootstrap.widgetShowReference,
                      showCategory: bootstrap.widgetShowCategory,
                      showDate: bootstrap.widgetShowDate,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push(AppRoutes.settingsWidgetPreferences),
                        child: const Text('Open widget preferences'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Support and information',
                subtitle:
                    'Support stays optional, and important app information stays easy to find.',
                icon: Icons.favorite_border_rounded,
                child: Column(
                  children: <Widget>[
                    SettingsNavTile(
                      title: 'Support',
                      subtitle:
                          'See support availability, transparency, and coffee support.',
                      icon: Icons.volunteer_activism_outlined,
                      trailingLabel: _supportStateLabel(bootstrap.supportState),
                      onTap: () => context.push(AppRoutes.settingsSupportHome),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SettingsNavTile(
                      title: 'Privacy',
                      subtitle:
                          'Read how the app handles guest use and optional account features.',
                      icon: Icons.shield_outlined,
                      onTap: () => context.push(AppRoutes.settingsPrivacy),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SettingsNavTile(
                      title: 'About',
                      subtitle:
                          'Read the mission, direction, and heart behind the app.',
                      icon: Icons.info_outline_rounded,
                      onTap: () => context.push(AppRoutes.settingsAbout),
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

class ContentPreferencesScreen extends StatelessWidget {
  const ContentPreferencesScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        final List<String> selected = bootstrap.selectedCategories;

        return GlobalScreenScaffold(
          title: 'Content preferences',
          subtitle: 'Category choices and reading focus',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              SettingsInfoCard(
                title: 'Verse categories',
                subtitle:
                    'Choose the themes you would like to see more often in daily reading.',
                icon: Icons.local_offer_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: bootstrap.availableCategories.map((category) {
                        final bool isSelected = selected.contains(category);

                        return FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) => bootstrap.toggleCategory(category),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Keep at least one category selected so daily reading always has a direction to draw from.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Current selection',
                subtitle:
                    'A quick view of the themes guiding your reading right now.',
                icon: Icons.visibility_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selected
                          .map((item) => Chip(label: Text(item)))
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      '${selected.length} categories selected',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Reading source',
                subtitle:
                    'A simple note about the reading source used throughout the app.',
                icon: Icons.translate_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const <Widget>[
                        Chip(label: Text('Public-domain Bible source')),
                        Chip(label: Text('KJV reading style')),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'This helps keep daily reading and chapter reading consistent.',
                      style: Theme.of(context).textTheme.bodyLarge,
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

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: bootstrap.dailyNotificationTime,
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
        final bool enabled = bootstrap.notificationsEnabled;

        return GlobalScreenScaffold(
          title: 'Notifications',
          subtitle: 'Daily verse reminders and timing',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              SettingsInfoCard(
                title: 'Daily reminders',
                subtitle:
                    'Choose whether daily reminders are part of your reading rhythm.',
                icon: Icons.notifications_active_outlined,
                child: Column(
                  children: <Widget>[
                    _SettingsSwitchRow(
                      title: 'Enable daily verse reminders',
                      subtitle: enabled
                          ? 'Daily reminders are currently on.'
                          : 'Daily reminders are currently off.',
                      value: enabled,
                      onChanged: bootstrap.setNotificationsEnabled,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Reminder time',
                subtitle:
                    'Choose the time that best fits your usual reading rhythm.',
                icon: Icons.schedule_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(AppRadii.xl),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Selected time',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    bootstrap.dailyNotificationLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontSize: 30,
                                          color: AppColors.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () => _pickTime(context),
                              child: const Text('Change'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      enabled
                          ? 'This time will be used for your daily reminder.'
                          : 'You can still choose a time now and turn reminders on whenever you are ready.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'How reminders fit in',
                subtitle:
                    'A gentle reminder flow works best when it supports reading rather than interrupting it.',
                icon: Icons.info_outline_rounded,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _SettingsBullet(
                      text:
                          'Reminders should make it easier to return to scripture, not create pressure.',
                    ),
                    _SettingsBullet(
                      text:
                          'Daily timing works best when it matches your natural reading rhythm.',
                    ),
                    _SettingsBullet(
                      text:
                          'The daily verse and the reminder time are designed to stay aligned.',
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

class WidgetPreferencesScreen extends StatelessWidget {
  const WidgetPreferencesScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        final String widgetCategory = _primaryWidgetCategory(bootstrap);
        final WidgetPreviewSample widgetSample = buildWidgetPreviewSample(
          widgetCategory,
        );

        return GlobalScreenScaffold(
          title: 'Widget preferences',
          subtitle: 'Style and display choices',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              SettingsInfoCard(
                title: 'Widget preview',
                subtitle:
                    'See how the daily verse can look with your current widget settings.',
                icon: Icons.widgets_outlined,
                child: WidgetPreviewCard(
                  sample: widgetSample,
                  categoryLabel: widgetCategory,
                  updateTimeLabel: bootstrap.dailyNotificationLabel,
                  style: bootstrap.widgetPreviewStyle,
                  showReference: bootstrap.widgetShowReference,
                  showCategory: bootstrap.widgetShowCategory,
                  showDate: bootstrap.widgetShowDate,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Display style',
                subtitle: 'Choose the look that feels most readable to you.',
                icon: Icons.palette_outlined,
                child: SegmentedButton<WidgetPreviewStyle>(
                  showSelectedIcon: false,
                  segments: const <ButtonSegment<WidgetPreviewStyle>>[
                    ButtonSegment<WidgetPreviewStyle>(
                      value: WidgetPreviewStyle.cozy,
                      icon: Icon(Icons.wb_incandescent_outlined),
                      label: Text('Cozy'),
                    ),
                    ButtonSegment<WidgetPreviewStyle>(
                      value: WidgetPreviewStyle.minimal,
                      icon: Icon(Icons.crop_square_rounded),
                      label: Text('Minimal'),
                    ),
                  ],
                  selected: <WidgetPreviewStyle>{bootstrap.widgetPreviewStyle},
                  onSelectionChanged: (Set<WidgetPreviewStyle> selection) {
                    bootstrap.setWidgetPreviewStyle(selection.first);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Display elements',
                subtitle: 'Choose which details appear alongside the verse.',
                icon: Icons.view_compact_alt_outlined,
                child: Column(
                  children: <Widget>[
                    _SettingsSwitchRow(
                      title: 'Show verse reference',
                      subtitle:
                          'Display the scripture reference below the verse text.',
                      value: bootstrap.widgetShowReference,
                      onChanged: bootstrap.setWidgetShowReference,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _SettingsSwitchRow(
                      title: 'Show category label',
                      subtitle:
                          'Display the selected theme category at the top of the widget.',
                      value: bootstrap.widgetShowCategory,
                      onChanged: bootstrap.setWidgetShowCategory,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _SettingsSwitchRow(
                      title: 'Show date marker',
                      subtitle: 'Display a small “today” marker in the widget.',
                      value: bootstrap.widgetShowDate,
                      onChanged: bootstrap.setWidgetShowDate,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Daily timing',
                subtitle:
                    'The widget follows the same daily reading rhythm used by the rest of the app.',
                icon: Icons.schedule_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(AppRadii.xl),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Current update time',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    bootstrap.dailyNotificationLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontSize: 30,
                                          color: AppColors.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () =>
                                  context.push(AppRoutes.settingsNotifications),
                              child: const Text('Edit time'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Keeping the widget in step with your daily reminder makes it easier to return to the same verse throughout the day.',
                      style: Theme.of(context).textTheme.bodyMedium,
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

class SupportHomeScreen extends StatelessWidget {
  const SupportHomeScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        final bool isOpen = bootstrap.supportState == SupportState.open;
        final _SupportPreviewMetrics metrics = _supportMetrics(
          bootstrap.supportState,
        );

        return GlobalScreenScaffold(
          title: 'Support',
          subtitle: 'Transparent and optional',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              SettingsInfoCard(
                title: isOpen
                    ? 'Maintenance support is currently open'
                    : 'Maintenance support is currently closed',
                subtitle:
                    'Support remains optional and never changes what the app unlocks.',
                icon: Icons.volunteer_activism_outlined,
                child: SupportProgressCard(
                  statusLabel: metrics.statusLabel,
                  caption: metrics.caption,
                  currentAmount: metrics.currentAmount,
                  targetAmount: metrics.targetAmount,
                  supporterCount: metrics.supporterCount,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Current support path',
                subtitle:
                    'Support visibility changes depending on whether the monthly maintenance goal is open or closed.',
                icon: Icons.account_tree_outlined,
                child: Column(
                  children: <Widget>[
                    if (isOpen)
                      SettingsNavTile(
                        title: 'Maintenance fund',
                        subtitle:
                            'This is the current support path while maintenance support is open.',
                        icon: Icons.savings_outlined,
                        trailingLabel: 'OPEN',
                        onTap: () => context.push(
                          AppRoutes.settingsSupportMaintenanceFund,
                        ),
                      )
                    else
                      SettingsNavTile(
                        title: 'Buy me a coffee',
                        subtitle:
                            'This becomes the visible support path when the maintenance goal has been reached.',
                        icon: Icons.coffee_outlined,
                        trailingLabel: 'AVAILABLE',
                        onTap: () =>
                            context.push(AppRoutes.settingsSupportCoffee),
                      ),
                    const SizedBox(height: AppSpacing.md),
                    SettingsNavTile(
                      title: 'Support transparency',
                      subtitle:
                          'This page stays available so the current support state is always easy to understand.',
                      icon: Icons.receipt_long_outlined,
                      trailingLabel: 'ALWAYS',
                      onTap: () =>
                          context.push(AppRoutes.settingsSupportTransparency),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Support rules',
                subtitle: 'The support flow stays simple and transparent.',
                icon: Icons.rule_folder_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _SettingsBullet(
                      text:
                          'Support is optional and never tied to feature access.',
                    ),
                    _SettingsBullet(
                      text:
                          'Maintenance support is visible only while the monthly target is open.',
                    ),
                    _SettingsBullet(
                      text:
                          'Transparency stays visible whether support is open or closed.',
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

class SupportTransparencyScreen extends StatelessWidget {
  const SupportTransparencyScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        final _SupportPreviewMetrics metrics = _supportMetrics(
          bootstrap.supportState,
        );

        return GlobalScreenScaffold(
          title: 'Support transparency',
          subtitle: 'Always visible',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              SettingsInfoCard(
                title: 'Current monthly support view',
                subtitle: 'A simple summary of the current support state.',
                icon: Icons.receipt_long_outlined,
                child: SupportProgressCard(
                  statusLabel: metrics.statusLabel,
                  caption: metrics.caption,
                  currentAmount: metrics.currentAmount,
                  targetAmount: metrics.targetAmount,
                  supporterCount: metrics.supporterCount,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'What this page explains',
                subtitle:
                    'Transparency is here to make the support flow easy to understand.',
                icon: Icons.visibility_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _SettingsBullet(
                      text:
                          'Whether maintenance support is currently open or closed.',
                    ),
                    _SettingsBullet(
                      text:
                          'How the monthly target affects support visibility.',
                    ),
                    _SettingsBullet(
                      text:
                          'Why coffee support is shown only when the maintenance goal has already been reached.',
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

class SupportMaintenanceFundScreen extends StatelessWidget {
  const SupportMaintenanceFundScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bootstrap,
      builder: (context, _) {
        final bool isOpen = bootstrap.supportState == SupportState.open;
        final _SupportPreviewMetrics metrics = _supportMetrics(
          bootstrap.supportState,
        );

        return GlobalScreenScaffold(
          title: 'Maintenance fund',
          subtitle: 'Optional support',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              SettingsInfoCard(
                title: isOpen
                    ? 'Maintenance support is available'
                    : 'Maintenance support is currently closed',
                subtitle:
                    'This support path opens and closes with the monthly maintenance target.',
                icon: Icons.savings_outlined,
                child: SupportProgressCard(
                  statusLabel: metrics.statusLabel,
                  caption: metrics.caption,
                  currentAmount: metrics.currentAmount,
                  targetAmount: metrics.targetAmount,
                  supporterCount: metrics.supporterCount,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'What this support helps with',
                subtitle:
                    'The focus is on maintaining the app rather than creating access tiers.',
                icon: Icons.build_circle_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _SettingsBullet(
                      text:
                          'Support helps cover ongoing maintenance and core operating costs.',
                    ),
                    _SettingsBullet(
                      text: 'Support never unlocks extra product features.',
                    ),
                    _SettingsBullet(
                      text:
                          'When the monthly target is reached, this support path closes for the rest of the cycle.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (!isOpen)
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'When it is closed',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'When the maintenance goal has already been reached, coffee support becomes the visible support path instead.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              context.push(AppRoutes.settingsSupportCoffee),
                          child: const Text('Open coffee support'),
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

class SupportCoffeeScreen extends StatelessWidget {
  const SupportCoffeeScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    final bool isOpen = bootstrap.supportState == SupportState.open;

    return GlobalScreenScaffold(
      title: 'Buy me a coffee',
      subtitle: 'A simple way to show appreciation',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          SettingsInfoCard(
            title: isOpen
                ? 'Coffee support appears after maintenance support closes'
                : 'Coffee support is currently available',
            subtitle:
                'This support path is shown once the monthly maintenance goal has already been reached.',
            icon: Icons.coffee_outlined,
            child: Text(
              isOpen
                  ? 'Maintenance support is the current visible path right now.'
                  : 'Coffee support is a lighter, optional way to show appreciation once maintenance support is closed.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SettingsInfoCard(
            title: 'How it fits in',
            subtitle:
                'Coffee support stays simple and never changes what the app gives to the reader.',
            icon: Icons.info_outline_rounded,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SettingsBullet(
                  text:
                      'Coffee support appears only when maintenance support is closed.',
                ),
                _SettingsBullet(
                  text:
                      'It stays optional and does not unlock product features.',
                ),
                _SettingsBullet(
                  text:
                      'It is simply a small way to support the app after the monthly maintenance target has been met.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return GlobalScreenScaffold(
      title: 'Privacy',
      subtitle: 'Guest-first and straightforward',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          SettingsInfoCard(
            title: 'A simple privacy posture',
            subtitle:
                'The app is designed to stay readable, usable, and respectful of the person using it.',
            icon: Icons.shield_outlined,
            child: Text(
              'You can use the core reading experience without being forced into account creation first.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SettingsInfoCard(
            title: 'What matters most here',
            subtitle:
                'A simple picture of how the app is meant to feel in everyday use.',
            icon: Icons.visibility_outlined,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SettingsBullet(
                  text: 'Core reading stays available without forcing sign-in.',
                ),
                _SettingsBullet(
                  text:
                      'Settings and reading flows are designed to stay clear and easy to manage.',
                ),
                _SettingsBullet(
                  text:
                      'Optional account features are there for continuity, not as a gate to scripture.',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SettingsInfoCard(
            title: 'Account features later on',
            subtitle:
                'Optional account features are meant to support continuity and backup.',
            icon: Icons.lock_outline_rounded,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SettingsBullet(
                  text:
                      'Carry bookmarks, highlights, notes, and preferences more easily across devices.',
                ),
                _SettingsBullet(
                  text:
                      'Keep the guest-first experience available even when account features are added.',
                ),
                _SettingsBullet(
                  text:
                      'Make the app easier to return to without making it harder to begin.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return GlobalScreenScaffold(
      title: 'About',
      subtitle: 'Mission, direction, and heart',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          SettingsInfoCard(
            title: 'Bible App',
            subtitle:
                'A calm, guest-first Bible experience with daily verses, reading flows, plans, saved reflections, and widget support.',
            icon: Icons.auto_stories_rounded,
            child: Text(
              'The app is shaped to feel warm, clear, and approachable while keeping scripture central.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SettingsInfoCard(
            title: 'Core direction',
            subtitle: 'A short summary of what the app is built around.',
            icon: Icons.flag_outlined,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SettingsBullet(
                  text:
                      'Guest-first reading with optional account features later on.',
                ),
                _SettingsBullet(
                  text:
                      'Daily verses shaped by selected categories and a calm reading rhythm.',
                ),
                _SettingsBullet(
                  text:
                      'Optional support that stays transparent and never changes what the app unlocks.',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SettingsInfoCard(
            title: 'Reading source and scope',
            subtitle:
                'A quick note about the reading direction used in this version.',
            icon: Icons.menu_book_outlined,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SettingsBullet(
                  text: 'This version uses a public-domain Bible source.',
                ),
                _SettingsBullet(
                  text:
                      'AI is used to support explanation and reflection, while scripture stays central.',
                ),
                _SettingsBullet(
                  text:
                      'The app is designed to be simple, readable, and easy to return to each day.',
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

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Switch.adaptive(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _SettingsBullet extends StatelessWidget {
  const _SettingsBullet({required this.text});

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
