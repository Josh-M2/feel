import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';

class AppComposeSheetResult {
  const AppComposeSheetResult({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

class AppComposeSheetConfig {
  const AppComposeSheetConfig({
    required this.title,
    required this.subtitle,
    required this.bodyLabel,
    required this.bodyHint,
    required this.submitLabel,
    this.leadingIcon = Icons.edit_note_rounded,
    this.titleLabel = 'Title',
    this.titleHint = '',
    this.initialTitle = '',
    this.initialBody = '',
    this.helperText,
    this.bodyMinLines = 7,
    this.bodyMaxLines = 10,
  });

  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final String titleLabel;
  final String titleHint;
  final String bodyLabel;
  final String bodyHint;
  final String submitLabel;
  final String initialTitle;
  final String initialBody;
  final String? helperText;
  final int bodyMinLines;
  final int bodyMaxLines;
}

Future<AppComposeSheetResult?> showAppComposeSheet(
  BuildContext context, {
  required AppComposeSheetConfig config,
}) {
  return showModalBottomSheet<AppComposeSheetResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      return _AppComposeSheet(config: config);
    },
  );
}

class _AppComposeSheet extends StatefulWidget {
  const _AppComposeSheet({required this.config});

  final AppComposeSheetConfig config;

  @override
  State<_AppComposeSheet> createState() => _AppComposeSheetState();
}

class _AppComposeSheetState extends State<_AppComposeSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.config.initialTitle);
    _bodyController = TextEditingController(text: widget.config.initialBody);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(AppRadii.lg),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          widget.config.leadingIcon,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.config.title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: AppColors.accentStrong,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            widget.config.subtitle,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.config.helperText != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.lg),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(AppRadii.xl),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        widget.config.helperText!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                TextField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: widget.config.titleLabel,
                    hintText: widget.config.titleHint,
                    filled: true,
                    fillColor: AppColors.surfaceSoft,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadii.xl),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _bodyController,
                  minLines: widget.config.bodyMinLines,
                  maxLines: widget.config.bodyMaxLines,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: widget.config.bodyLabel,
                    hintText: widget.config.bodyHint,
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: AppColors.surfaceSoft,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadii.xl),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
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
                        onPressed: () {
                          Navigator.of(context).pop(
                            AppComposeSheetResult(
                              title: _titleController.text,
                              body: _bodyController.text,
                            ),
                          );
                        },
                        child: Text(widget.config.submitLabel),
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
}
