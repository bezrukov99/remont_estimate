import 'package:flutter/material.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/core/widgets/app_primary_button.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class EmptyRoomsState extends StatelessWidget {
  const EmptyRoomsState({super.key, required this.onAddRoom});

  final VoidCallback onAddRoom;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: context.palette.accentMuted,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.add_home_work_outlined,
              size: 44,
              color: context.palette.accent,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.noRoomsYet,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.noRoomsHint,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: AppPrimaryButton(
              label: l10n.addFirstRoom,
              icon: Icons.add,
              onPressed: onAddRoom,
            ),
          ),
        ],
      ),
    );
  }
}
