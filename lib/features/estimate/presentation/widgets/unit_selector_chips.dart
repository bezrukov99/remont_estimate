import 'package:flutter/material.dart';
import 'package:remont_estimate/core/l10n/material_unit_l10n.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_unit.dart';

class UnitSelectorChips extends StatelessWidget {
  const UnitSelectorChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final MaterialUnit selected;
  final ValueChanged<MaterialUnit> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: MaterialUnit.values.map((unit) {
        final isSelected = unit == selected;
        return FilterChip(
          selected: isSelected,
          showCheckmark: false,
          label: Text(unit.localizedLabel(context)),
          selectedColor: context.palette.accentMuted,
          side: BorderSide(
            color: isSelected ? context.palette.accent : context.palette.progressTrack,
          ),
          onSelected: (_) => onSelected(unit),
        );
      }).toList(),
    );
  }
}
