import 'dart:io';

import 'package:flutter/material.dart';
import 'package:remont_estimate/core/l10n/material_unit_l10n.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/core/utils/currency_formatter.dart';
import 'package:remont_estimate/core/utils/material_details_formatter.dart';
import 'package:remont_estimate/core/widgets/rounded_card.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_item_model.dart';
import 'package:remont_estimate/features/estimate/presentation/widgets/material_photo_viewer.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class MaterialListTile extends StatelessWidget {
  const MaterialListTile({
    super.key,
    required this.material,
    required this.currencyCode,
    this.onTap,
    this.onLongPress,
    this.onPurchasedChanged,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  final MaterialItemModel material;
  final String currencyCode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onPurchasedChanged;
  final bool isSelectionMode;
  final bool isSelected;

  bool get _isPurchased => material.isPurchased;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.palette;
    final purchaseDetails = materialPurchaseDetailsLine(context, material);
    final photoPaths = material.photoPaths
        .where((p) => p.isNotEmpty && File(p).existsSync())
        .toList();
    final photoThumb = photoPaths.isEmpty
        ? null
        : _materialPhotoThumb(
            photoPaths.first,
            onTap: () => MaterialPhotoViewer.show(
              context,
              paths: photoPaths,
            ),
          );
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          decoration: _isPurchased ? TextDecoration.lineThrough : null,
          color: _isPurchased ? palette.textTertiary : palette.textPrimary,
        );
    final detailColor =
        _isPurchased ? palette.textTertiary : palette.textSecondary;

    return RoundedCard(
      onTap: onTap,
      onLongPress: onLongPress,
      color: _isPurchased
          ? palette.surfaceMuted
          : isSelected
              ? palette.accentMuted
              : null,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isSelectionMode) ...[
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? palette.accent : palette.textTertiary,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.sm),
          ] else if (onPurchasedChanged != null) ...[
            _RoundCheckbox(
              value: _isPurchased,
              onChanged: onPurchasedChanged!,
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          if (photoThumb != null) ...[
            Opacity(
              opacity: _isPurchased ? 0.55 : 1,
              child: photoThumb,
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.name,
                  style: titleStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (purchaseDetails != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    purchaseDetails,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          color: detailColor,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (material.dimensions != null &&
                    material.dimensions!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    material.dimensions!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          color: detailColor,
                        ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  '${material.quantity % 1 == 0 ? material.quantity.toInt() : material.quantity} ${material.unit.localizedLabel(context)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        color: palette.textTertiary,
                      ),
                ),
                if (_isPurchased) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.materialPurchased,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: palette.accent,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (!isSelectionMode) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              CurrencyFormatter.format(material.totalPrice, currencyCode),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _isPurchased
                        ? palette.textTertiary
                        : palette.accent,
                    decoration:
                        _isPurchased ? TextDecoration.lineThrough : null,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Circular purchased toggle inside the material card.
class _RoundCheckbox extends StatelessWidget {
  const _RoundCheckbox({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  static const _size = 24.0;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SizedBox(
      width: _size,
      height: _size,
      child: Checkbox(
        value: value,
        onChanged: (checked) => onChanged(checked ?? false),
        shape: const CircleBorder(),
        side: BorderSide(color: palette.textTertiary, width: 1.5),
        activeColor: palette.accent,
        checkColor: Colors.white,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

Widget? _materialPhotoThumb(String path, {required VoidCallback onTap}) {
  final file = File(path);
  if (!file.existsSync()) {
    return null;
  }

  const size = 56.0;
  final borderRadius = BorderRadius.circular(14);

  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: ClipRRect(
      borderRadius: borderRadius,
      child: Image.file(
        file,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    ),
  );
}
