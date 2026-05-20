import 'package:flutter/material.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';

/// Styled confirmation / input dialog.
Future<T?> showRemontDialog<T>(
  BuildContext context, {
  required String title,
  Widget? content,
  List<Widget>? actions,
}) {
  return showDialog<T>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (ctx) => AppDialog(
      title: title,
      content: content,
      actions: actions,
    ),
  );
}

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.content,
    this.actions,
  });

  final String title;
  final Widget? content;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.palette.surface,
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
            ),
            if (content != null) ...[
              const SizedBox(height: AppSpacing.md),
              content!,
            ],
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _spacedActions(actions!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _spacedActions(List<Widget> actions) {
    if (actions.length <= 1) {
      return actions;
    }
    final result = <Widget>[];
    for (var i = 0; i < actions.length; i++) {
      if (i > 0) {
        result.add(const SizedBox(width: AppSpacing.sm));
      }
      result.add(actions[i]);
    }
    return result;
  }
}

/// Text button styled for dialogs.
class AppDialogAction extends StatelessWidget {
  const AppDialogAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: context.palette.accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          ),
        ),
        child: Text(label),
      );
    }

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor:
            isDestructive ? Colors.redAccent : context.palette.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isDestructive ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
