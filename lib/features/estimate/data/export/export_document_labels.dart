import 'package:intl/intl.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_unit.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

/// Localized strings for PDF / Excel export documents.
class ExportDocumentLabels {
  ExportDocumentLabels(this.l10n);

  final AppLocalizations l10n;

  String get appTitle => l10n.appTitle;

  String get renovationReport => l10n.exportRenovationReport;

  String get budgetSummary => l10n.exportBudgetSummary;

  String get grandTotal => l10n.exportGrandTotal;

  String get grandTotalSpent => l10n.exportGrandTotalSpent;

  String get noMaterialsInRoom => l10n.exportNoMaterialsInRoom;

  String get noRoomsYet => l10n.exportNoRoomsYet;

  String get noMaterials => l10n.exportNoMaterials;

  String get roomSubtotal => l10n.exportRoomSubtotal;

  String get photoOnFile => l10n.exportPhotoOnFile;

  String projectName(String name) => l10n.exportProject(name);

  String generated(DateTime date) =>
      l10n.exportGenerated(formatDate(date));

  String materialsTotal(String amount) => l10n.exportMaterialsTotal(amount);

  String purchasedTotal(String amount) => l10n.exportPurchasedTotal(amount);

  String roomPurchased(String amount) => l10n.exportRoomPurchased(amount);

  String targetBudget(String amount) => l10n.exportTargetBudget(amount);

  String pageOf(int page, int total) => l10n.exportPageOf(page, total);

  String photoCount(int count) => l10n.exportPhotoCount(count);

  String photosExtra(int count) => l10n.exportPhotosExtra(count);

  List<String> get materialTableHeaders => [
        l10n.exportColMaterial,
        l10n.exportColBrand,
        l10n.exportColArticle,
        l10n.exportColStore,
        l10n.exportColDimensions,
        l10n.exportColQty,
        l10n.exportColUnit,
        l10n.exportColPrice,
        l10n.exportColTotal,
        l10n.exportColPhoto,
      ];

  List<String> get excelTableHeaders => [
        l10n.exportColMaterial,
        l10n.exportColBrand,
        l10n.exportColArticle,
        l10n.exportColStore,
        l10n.exportColDimensions,
        l10n.exportColQty,
        l10n.exportColUnit,
        l10n.exportColPricePerUnit,
        l10n.exportColTotal,
        l10n.exportColPhoto,
      ];

  String unitLabel(MaterialUnit unit) {
    return switch (unit) {
      MaterialUnit.pieces => l10n.unitPcs,
      MaterialUnit.squareMeters => l10n.unitSqm,
      MaterialUnit.pack => l10n.unitPack,
      MaterialUnit.meters => l10n.unitMeters,
      MaterialUnit.liters => l10n.unitLiters,
      MaterialUnit.kilograms => l10n.unitKg,
    };
  }

  String formatDate(DateTime date) {
    return DateFormat.yMMMd(l10n.localeName).format(date);
  }
}
