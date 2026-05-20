import 'package:flutter/widgets.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_unit.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

extension MaterialUnitL10n on MaterialUnit {
  String localizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      MaterialUnit.pieces => l10n.unitPcs,
      MaterialUnit.squareMeters => l10n.unitSqm,
      MaterialUnit.pack => l10n.unitPack,
      MaterialUnit.meters => l10n.unitMeters,
      MaterialUnit.liters => l10n.unitLiters,
      MaterialUnit.kilograms => l10n.unitKg,
    };
  }
}
