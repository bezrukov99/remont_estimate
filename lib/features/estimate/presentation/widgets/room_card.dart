import 'package:flutter/material.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/core/utils/currency_formatter.dart';
import 'package:remont_estimate/core/widgets/rounded_card.dart';
import 'package:remont_estimate/features/estimate/domain/models/room_model.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({
    super.key,
    required this.room,
    required this.itemCount,
    required this.subtotal,
    required this.currencyCode,
    required this.onTap,
  });

  final RoomModel room;
  final int itemCount;
  final double subtotal;
  final String currencyCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.palette;

    return RoundedCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      radius: AppSpacing.buttonRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            room.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  letterSpacing: -0.3,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            itemCount == 0
                ? l10n.noMaterialsYet
                : l10n.itemsCount(itemCount),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  height: 1.2,
                  color: palette.textSecondary,
                ),
          ),
          const Spacer(),
          Text(
            CurrencyFormatter.compact(subtotal, currencyCode),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: palette.accent,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
          ),
        ],
      ),
    );
  }
}
