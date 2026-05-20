import 'package:flutter/widgets.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_item_model.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

/// Formats brand, article, and store for list cards.
String? materialPurchaseDetailsLine(
  BuildContext context,
  MaterialItemModel material,
) {
  if (!material.hasPurchaseDetails) {
    return null;
  }

  final l10n = AppLocalizations.of(context)!;
  final parts = <String>[];

  final brand = material.brand?.trim();
  final article = material.article?.trim();
  final store = material.store?.trim();

  if (brand != null && brand.isNotEmpty) {
    parts.add(brand);
  }
  if (article != null && article.isNotEmpty) {
    parts.add('${l10n.materialArticleShort} $article');
  }
  if (store != null && store.isNotEmpty) {
    parts.add(store);
  }

  return parts.join(' · ');
}
