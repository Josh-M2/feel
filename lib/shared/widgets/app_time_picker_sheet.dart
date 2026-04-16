import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';

class QuickTimeOption {
  const QuickTimeOption({
    required this.label,
    required this.time,
  });

  final String label;
  final TimeOfDay time;
}

Future<TimeOfDay?> showAppTimePickerSheet(
  BuildContext context, {
  required TimeOfDay initialTime,
  String title = 'Choose a daily time',
  String subtitle = 'Pick the time that best matches your reading rhythm.',
  List<QuickTimeOption> quickOptions = const <QuickTimeOption>[
    QuickTimeOption(label: 'Early', time: TimeOfDay(hour: 6, minute: 30)),
    QuickTimeOption(label: 'Morning', time: TimeOfDay(hour: 7, minute: 0)),
    QuickTimeOption(label: 'Midday', time: TimeOfDay(hour: 12, minute: 15)),
    QuickTimeOption(label: 'Evening', time: TimeOfDay(hour: 20, minute: 0)),
  ],
}) {
  return showModalBottomSheet<TimeOfDay>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      return _AppTimePickerSheet(
        title: title,
        subtitle: subtitle,
        initialTime: initialTime,
        quickOptions: quickOptions,
      );
    },
  );
}

class _AppTimePickerSheet extends StatefulWidget {
  const _AppTimePickerSheet({
    required this.title,
    required this.subtitle,
    required this.initialTime,
    required this.quickOptions,
  });

  final String title;
  final String subtitle;
  final TimeOfDay initialTime;
  final List<QuickTimeOption> quickOptions;

  @override
  State<_AppTimePickerSheet> createState() => _AppTimePickerSheetState();
}

class _AppTimePickerSheetState extends State<_AppTimePickerSheet> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        12,
        12,
        mediaQuery.viewInsets.bottom + 12,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.borderStrong),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x140F6FD0),
              blurRadius: 28,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 46,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.borderStrong,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.accentStrong,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  widget.subtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadii.xl),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.schedule_rounded, color: AppColors.primary),
                        const SizedBox(width: AppSpacing.md),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Selected time',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              _labelFor(_selectedTime),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontSize: 30),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: widget.quickOptions.map((QuickTimeOption option) {
                    final bool selected = option.time.hour == _selectedTime.hour &&
                        option.time.minute == _selectedTime.minute;
                    return ChoiceChip(
                      label: Text('${option.label} · ${_labelFor(option.time)}'),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          _selectedTime = option.time;
                        });
                      },
                    );
                  }).toList(growable: false),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: 190,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: false,
                    initialDateTime: _dateTimeFor(_selectedTime),
                    onDateTimeChanged: (DateTime value) {
                      setState(() {
                        _selectedTime = TimeOfDay.fromDateTime(value);
                      });
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(_selectedTime),
                        child: const Text('Use this time'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime _dateTimeFor(TimeOfDay value) {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, value.hour, value.minute);
  }

  String _labelFor(TimeOfDay value) {
    final int hour = value.hourOfPeriod == 0 ? 12 : value.hourOfPeriod;
    final String minute = value.minute.toString().padLeft(2, '0');
    final String period = value.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
