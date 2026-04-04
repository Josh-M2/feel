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
    caption:
        'Maintenance support is currently closed because the monthly target is considered reached.',
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
          subtitle: 'Content, notifications, widgets, support, and app info',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Your current preferences',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'A calm control center for how the app feels day to day',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'In this UI-first phase, these settings already update local state so the screens feel real before backend wiring begins.',
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
                          label: 'Notifications',
                          value: notificationsEnabled ? 'Enabled' : 'Off',
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
                subtitle:
                    'These are the most important adjustable experiences for V1.',
                icon: Icons.tune_rounded,
                child: Column(
                  children: <Widget>[
                    SettingsNavTile(
                      title: 'Content preferences',
                      subtitle:
                          'Choose verse categories and view translation scope for the UI-first phase.',
                      icon: Icons.auto_stories_outlined,
                      trailingLabel: '$categoryCount selected',
                      onTap: () =>
                          context.push(AppRoutes.settingsContentPreferences),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SettingsNavTile(
                      title: 'Notifications',
                      subtitle:
                          'Control daily reminders and your selected delivery time.',
                      icon: Icons.notifications_none_rounded,
                      trailingLabel: notificationsEnabled ? 'Enabled' : 'Off',
                      onTap: () =>
                          context.push(AppRoutes.settingsNotifications),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SettingsNavTile(
                      title: 'Widget preferences',
                      subtitle:
                          'Preview and adjust how the daily verse widget should look.',
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
                    'The widget is designed to stay aligned with the same daily assignment and daily-time rhythm as the app.',
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
                title: 'Support and transparency',
                subtitle: 'Maintenance support stays optional and transparent.',
                icon: Icons.favorite_border_rounded,
                child: Column(
                  children: <Widget>[
                    SettingsNavTile(
                      title: 'Support',
                      subtitle:
                          'Open the support hub for maintenance, transparency, and coffee state.',
                      icon: Icons.volunteer_activism_outlined,
                      trailingLabel: _supportStateLabel(bootstrap.supportState),
                      onTap: () => context.push(AppRoutes.settingsSupportHome),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SettingsNavTile(
                      title: 'Privacy',
                      subtitle:
                          'Review guest-first behavior and future sync/privacy information.',
                      icon: Icons.shield_outlined,
                      onTap: () => context.push(AppRoutes.settingsPrivacy),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SettingsNavTile(
                      title: 'About',
                      subtitle:
                          'Mission, app version, scripture source notes, and app philosophy.',
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
          subtitle: 'Category choices and content scope',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              SettingsInfoCard(
                title: 'Verse categories',
                subtitle:
                    'These preferences help shape which daily verse themes feel most relevant for the user.',
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
                      'At least one category stays selected so the daily verse flow always has a valid preference base.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Current selection preview',
                subtitle:
                    'A quick summary of the categories currently shaping the local UI-first experience.',
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
                title: 'Translation scope for V1',
                subtitle:
                    'This keeps the product aligned with your locked source rules during the UI-first phase.',
                icon: Icons.translate_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const <Widget>[
                        Chip(label: Text('Public-domain Bible source')),
                        Chip(label: Text('Mock translation preview')),
                        Chip(label: Text('NLT out of scope')),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'For now, this screen communicates scope clearly and keeps the UI ready for later allowed translation options without implying unsupported source choices.',
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
                title: 'Daily reminder',
                subtitle:
                    'Notifications stay optional and should never block core Bible usage.',
                icon: Icons.notifications_active_outlined,
                child: Column(
                  children: <Widget>[
                    _SettingsSwitchRow(
                      title: 'Enable daily verse reminders',
                      subtitle: enabled
                          ? 'Reminders are currently enabled in local app state.'
                          : 'Reminders are currently off in local app state.',
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
                    'This selected time will later align with both the in-app daily verse and the widget.',
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
                          ? 'The reminder time is active in your current local preferences.'
                          : 'You can still set a time now so the flow feels ready even before enabling reminders.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'V1 notification behavior',
                subtitle:
                    'This clarifies the intended user experience during the UI-first phase.',
                icon: Icons.info_outline_rounded,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _SettingsBullet(
                      text:
                          'Notification permission remains optional and skippable.',
                    ),
                    _SettingsBullet(
                      text:
                          'Daily verse timing should stay aligned across app, notification, and widget.',
                    ),
                    _SettingsBullet(
                      text:
                          'This screen currently updates local preview state only, not real OS notification delivery.',
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
          subtitle: 'Preview and display behavior',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              SettingsInfoCard(
                title: 'Widget preview',
                subtitle:
                    'This preview is driven by your local settings so the UI feels real before OS widget wiring exists.',
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
                subtitle:
                    'Keep the widget calm and readable with a small number of meaningful visual choices.',
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
                subtitle:
                    'These toggles control what appears in the widget preview.',
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
                      subtitle:
                          'Display a small “today” marker in the widget preview.',
                      value: bootstrap.widgetShowDate,
                      onChanged: bootstrap.setWidgetShowDate,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Alignment with daily verse timing',
                subtitle:
                    'The widget should remain tied to the same daily assignment logic as the app.',
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
                      'The real widget should update in step with the same daily verse timing used by the app and notifications.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'V1 widget scope',
                subtitle:
                    'This keeps the screen honest about what exists now and what comes later.',
                icon: Icons.info_outline_rounded,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _SettingsBullet(
                      text:
                          'This screen controls local preview state only in the UI-first phase.',
                    ),
                    _SettingsBullet(
                      text:
                          'Real home-screen widget installation and OS sync are still future work.',
                    ),
                    _SettingsBullet(
                      text:
                          'The preview is intentionally aligned to the same daily assignment concept used in the app.',
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
                    'The support flow should react meaningfully to the current preview state without pretending payment is already implemented.',
                icon: Icons.volunteer_activism_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SupportProgressCard(
                      statusLabel: metrics.statusLabel,
                      caption: metrics.caption,
                      currentAmount: metrics.currentAmount,
                      targetAmount: metrics.targetAmount,
                      supporterCount: metrics.supporterCount,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: bootstrap.toggleSupportState,
                        child: Text(
                          isOpen
                              ? 'Preview CLOSED state'
                              : 'Preview OPEN state',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Current support path',
                subtitle:
                    'This changes based on whether maintenance support is open or closed.',
                icon: Icons.account_tree_outlined,
                child: Column(
                  children: <Widget>[
                    if (isOpen)
                      SettingsNavTile(
                        title: 'Maintenance fund',
                        subtitle:
                            'This is the active optional support path while maintenance support is open.',
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
                            'This becomes the visible optional support path when maintenance support is closed.',
                        icon: Icons.coffee_outlined,
                        trailingLabel: 'VISIBLE',
                        onTap: () =>
                            context.push(AppRoutes.settingsSupportCoffee),
                      ),
                    const SizedBox(height: AppSpacing.md),
                    SettingsNavTile(
                      title: 'Support transparency',
                      subtitle:
                          'This page stays visible regardless of support state.',
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
                subtitle:
                    'These stay locked no matter which support state is active.',
                icon: Icons.rule_folder_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _SettingsBullet(
                      text:
                          'Support is optional and never tied to feature unlocks.',
                    ),
                    _SettingsBullet(
                      text:
                          'Maintenance support is visible only while the monthly target is open.',
                    ),
                    _SettingsBullet(
                      text:
                          'Transparency stays visible even when maintenance support is closed.',
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
                title: 'Current monthly preview',
                subtitle:
                    'This screen is always visible so users can understand the current support state clearly.',
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
                title: 'What this page should explain',
                subtitle: 'The purpose is transparency, not sales pressure.',
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
                          'What the monthly target represents at a high level.',
                    ),
                    _SettingsBullet(
                      text:
                          'Why coffee support appears only when maintenance support is closed.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'Current UI-first limitation',
                subtitle:
                    'This keeps the screen honest during the current phase.',
                icon: Icons.info_outline_rounded,
                child: Text(
                  'The figures shown here are local preview values for UI development. Real totals, processing, and verification are still future work.',
                  style: Theme.of(context).textTheme.bodyLarge,
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
                    ? 'Maintenance fund is available'
                    : 'Maintenance fund is currently closed',
                subtitle:
                    'This screen behaves like a real support surface, but remains honest that payment flow is not yet implemented.',
                icon: Icons.savings_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SupportProgressCard(
                      statusLabel: metrics.statusLabel,
                      caption: metrics.caption,
                      currentAmount: metrics.currentAmount,
                      targetAmount: metrics.targetAmount,
                      supporterCount: metrics.supporterCount,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isOpen ? () {} : null,
                        child: Text(
                          isOpen
                              ? 'Future maintenance support action'
                              : 'Maintenance support closed',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SettingsInfoCard(
                title: 'What support is for',
                subtitle:
                    'The messaging should stay practical and transparent.',
                icon: Icons.build_circle_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _SettingsBullet(
                      text:
                          'Support helps cover ongoing maintenance and core operating costs.',
                    ),
                    _SettingsBullet(
                      text:
                          'Support never unlocks app features or creates access tiers.',
                    ),
                    _SettingsBullet(
                      text:
                          'Once the monthly goal is considered reached, maintenance support should close.',
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
                        'When closed',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'When maintenance support is closed, the coffee route becomes the visible optional support path instead.',
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
      subtitle: 'Visible when maintenance support is closed',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          SettingsInfoCard(
            title: isOpen
                ? 'Coffee support should stay hidden in open state'
                : 'Coffee support is the visible optional path right now',
            subtitle:
                'This screen still exists in development so you can design the route early.',
            icon: Icons.coffee_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isOpen
                      ? 'In the real product, coffee support should not be the visible support path while maintenance support is open.'
                      : 'When maintenance support is closed, coffee support becomes the visible optional support route.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: !isOpen ? () {} : null,
                    child: Text(
                      isOpen
                          ? 'Coffee support hidden in live flow'
                          : 'Future coffee support action',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SettingsInfoCard(
            title: 'Why this route exists',
            subtitle:
                'It keeps the support system aligned with your locked state logic.',
            icon: Icons.info_outline_rounded,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SettingsBullet(
                  text:
                      'Coffee appears only when maintenance support is disabled or closed.',
                ),
                _SettingsBullet(
                  text:
                      'It stays optional and does not unlock product features.',
                ),
                _SettingsBullet(
                  text:
                      'The route can already be designed now without real payment integration.',
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
      subtitle: 'Guest-first and transparent',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          SettingsInfoCard(
            title: 'Current privacy posture',
            subtitle:
                'This screen stays honest about what exists in the UI-first phase.',
            icon: Icons.shield_outlined,
            child: Text(
              'The app is currently operating in a guest-first, local-preview phase. Real backend storage, cross-device sync, and final production privacy handling are not yet wired.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SettingsInfoCard(
            title: 'What is true right now',
            subtitle:
                'A simple explanation of the current phase without overclaiming.',
            icon: Icons.visibility_outlined,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SettingsBullet(
                  text: 'Core reading flows do not require forced login.',
                ),
                _SettingsBullet(
                  text:
                      'Current settings and preview states are local app state for UI development.',
                ),
                _SettingsBullet(
                  text:
                      'Real sync, persistence, and production privacy details will be finalized later.',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SettingsInfoCard(
            title: 'Future privacy scope',
            subtitle:
                'This helps the user understand where the product is going later.',
            icon: Icons.lock_outline_rounded,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SettingsBullet(
                  text:
                      'Optional account mode can later support synced bookmarks, notes, and preferences.',
                ),
                _SettingsBullet(
                  text:
                      'Privacy and sync behavior should remain transparent and never misleading.',
                ),
                _SettingsBullet(
                  text:
                      'Guest-first usage should remain possible without forcing account creation.',
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
      subtitle: 'Mission, scope, and current phase',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          SettingsInfoCard(
            title: 'Bible App V1',
            subtitle:
                'A calm, guest-first Bible experience with daily verses, reading flows, plans, saved reflections, and future widget support.',
            icon: Icons.auto_stories_rounded,
            child: Text(
              'This app is being shaped around a modern, cozy, and polished mobile experience that stays usable without forced login and keeps scripture central.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SettingsInfoCard(
            title: 'Locked V1 direction',
            subtitle:
                'A quick summary of what the product is intentionally aiming for.',
            icon: Icons.flag_outlined,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SettingsBullet(
                  text: 'Guest-first usage with optional login later for sync.',
                ),
                _SettingsBullet(
                  text:
                      'Daily personalized verse experience shaped by selected categories.',
                ),
                _SettingsBullet(
                  text:
                      'Optional support that stays transparent and never unlocks features.',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SettingsInfoCard(
            title: 'Source and scope notes',
            subtitle:
                'This keeps the screen aligned with the current build rules.',
            icon: Icons.menu_book_outlined,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SettingsBullet(
                  text: 'V1 uses a public-domain Bible source, not NLT.',
                ),
                _SettingsBullet(
                  text:
                      'LLM is support-only for explanation and reflection, not for choosing scripture truth.',
                ),
                _SettingsBullet(
                  text:
                      'The app is still in the UI/UX-first phase with dummy/local/mock state.',
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
