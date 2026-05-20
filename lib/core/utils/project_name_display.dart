import 'package:flutter/widgets.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

/// Legacy English default stored before localization.
const _legacyDefaultProjectNames = {'My Renovation', 'Мой ремонт'};

String displayProjectName(BuildContext context, String storedName) {
  final trimmed = storedName.trim();
  if (trimmed.isEmpty || _legacyDefaultProjectNames.contains(trimmed)) {
    return AppLocalizations.of(context)!.defaultProjectName;
  }
  return trimmed;
}
