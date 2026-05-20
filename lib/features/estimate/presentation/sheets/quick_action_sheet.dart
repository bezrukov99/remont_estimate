import 'package:flutter/material.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/core/widgets/app_bottom_sheet.dart';
import 'package:remont_estimate/features/estimate/presentation/sheets/add_room_sheet.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class QuickActionSheet extends StatelessWidget {
  const QuickActionSheet({
    super.key,
    required this.onAddMaterial,
  });

  final VoidCallback onAddMaterial;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onAddMaterial,
  }) {
    return showRemontSheet<void>(
      context,
      child: QuickActionSheet(onAddMaterial: onAddMaterial),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppSheetBody(
      title: l10n.quickAdd,
      children: [
        _ActionTile(
          icon: Icons.inventory_2_outlined,
          title: l10n.addMaterial,
          subtitle: l10n.addMaterialSubtitle,
          color: context.palette.accent,
          onTap: () {
            Navigator.pop(context);
            onAddMaterial();
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        _ActionTile(
          icon: Icons.add_home_work_outlined,
          title: l10n.addRoom,
          subtitle: l10n.addRoomSubtitle,
          color: const Color(0xFF6C8EBF),
          onTap: () {
            Navigator.pop(context);
            AddRoomSheet.show(context);
          },
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.palette.surfaceMuted,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: context.palette.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
