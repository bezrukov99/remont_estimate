import 'dart:io';

import 'package:excel/excel.dart';
import 'package:remont_estimate/core/utils/currency_formatter.dart';
import 'package:remont_estimate/features/estimate/data/export/export_document_labels.dart';
import 'package:remont_estimate/features/estimate/data/export/export_paths.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_item_model.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';

/// Generates a formatted `.xlsx` estimate grouped by room with Excel formulas.
class EstimateExcelExporter {
  Future<File> export(
    EstimateState state,
    ExportDocumentLabels labels,
  ) async {
    final excel = Excel.createExcel();
    final defaultName = excel.getDefaultSheet();
    if (defaultName != null && defaultName != 'Estimate') {
      excel.rename(defaultName, 'Estimate');
    }
    final sheet = excel['Estimate'];

    _setColumnWidths(sheet);

    var row = 0;
    row = _writeSummary(sheet, state, labels, row);
    row += 1;

    final lineTotalRows = <int>[];

    for (final room in state.sortedRooms) {
      final materials = state.materialsForRoom(room.id);
      row = _writeRoomSection(
        sheet,
        room.name,
        materials,
        labels,
        row,
        lineTotalRows,
      );
      row += 1;
    }

    _writeGrandTotal(sheet, state, labels, row, lineTotalRows);

    final bytes = excel.encode();
    if (bytes == null) {
      throw StateError('Failed to encode Excel workbook.');
    }

    final path = await ExportPaths.excelPath(state.projectName);
    final dir = Directory(await ExportPaths.directory());
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  void _setColumnWidths(Sheet sheet) {
    const widths = [24.0, 14.0, 12.0, 14.0, 14.0, 8.0, 8.0, 12.0, 12.0, 18.0];
    for (var i = 0; i < widths.length; i++) {
      sheet.setColumnWidth(i, widths[i]);
    }
  }

  int _writeSummary(
    Sheet sheet,
    EstimateState state,
    ExportDocumentLabels labels,
    int row,
  ) {
    _setCell(
      sheet,
      col: 0,
      row: row,
      value: labels.renovationReport,
      bold: true,
      fontSize: 14,
    );
    row++;
    _setCell(
      sheet,
      col: 0,
      row: row,
      value: labels.projectName(state.projectName),
    );
    row++;
    _setCell(
      sheet,
      col: 0,
      row: row,
      value: labels.generated(DateTime.now()),
    );
    row++;
    _setCell(
      sheet,
      col: 0,
      row: row,
      value: labels.materialsTotal(
        CurrencyFormatter.format(state.totalMaterials, state.currencyCode),
      ),
      bold: true,
    );
    row++;
    _setCell(
      sheet,
      col: 0,
      row: row,
      value: labels.purchasedTotal(
        CurrencyFormatter.format(state.totalPurchased, state.currencyCode),
      ),
      bold: true,
    );
    row++;
    if (state.hasTargetBudget) {
      _setCell(
        sheet,
        col: 0,
        row: row,
        value: labels.targetBudget(
          CurrencyFormatter.format(state.targetBudget!, state.currencyCode),
        ),
      );
      row++;
    }
    return row;
  }

  int _writeRoomSection(
    Sheet sheet,
    String roomName,
    List<MaterialItemModel> materials,
    ExportDocumentLabels labels,
    int row,
    List<int> lineTotalRows,
  ) {
    _setCell(
      sheet,
      col: 0,
      row: row,
      value: roomName,
      bold: true,
      background: ExcelColor.grey200,
    );
    row++;

    final headers = labels.excelTableHeaders;
    for (var c = 0; c < headers.length; c++) {
      _setCell(
        sheet,
        col: c,
        row: row,
        value: headers[c],
        bold: true,
        background: ExcelColor.grey200,
      );
    }
    row++;

    if (materials.isEmpty) {
      _setCell(sheet, col: 0, row: row, value: labels.noMaterials);
      return row + 2;
    }

    final firstDataRow = row;
    for (final material in materials) {
      final excelRow = row + 1;
      _setCell(sheet, col: 0, row: row, value: material.name);
      _setCell(sheet, col: 1, row: row, value: material.brand ?? '-');
      _setCell(sheet, col: 2, row: row, value: material.article ?? '-');
      _setCell(sheet, col: 3, row: row, value: material.store ?? '-');
      _setCell(sheet, col: 4, row: row, value: material.dimensions ?? '-');
      _setCell(sheet, col: 5, row: row, value: _qtyText(material.quantity));
      _setCell(sheet, col: 6, row: row, value: labels.unitLabel(material.unit));
      _setCell(
        sheet,
        col: 7,
        row: row,
        value: material.pricePerUnit,
        isNumber: true,
      );
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row))
          .value = FormulaCellValue('=F$excelRow*H$excelRow');
      lineTotalRows.add(row);
      _setCell(
        sheet,
        col: 9,
        row: row,
        value: material.photoPaths.isEmpty
            ? '-'
            : labels.photoCount(material.photoPaths.length),
      );
      row++;
    }

    final lastDataRow = row - 1;
    _setCell(sheet, col: 7, row: row, value: labels.roomSubtotal, bold: true);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row))
        .value = FormulaCellValue(
      '=SUM(I${firstDataRow + 1}:I${lastDataRow + 1})',
    );
    row++;

    final purchasedSubtotal = materials
        .where((m) => m.isPurchased)
        .fold<double>(0, (s, m) => s + m.totalPrice);
    _setCell(sheet, col: 7, row: row, value: labels.grandTotalSpent, bold: true);
    _setCell(
      sheet,
      col: 8,
      row: row,
      value: purchasedSubtotal,
      isNumber: true,
      bold: true,
    );
    return row + 2;
  }

  void _writeGrandTotal(
    Sheet sheet,
    EstimateState state,
    ExportDocumentLabels labels,
    int row,
    List<int> lineTotalRows,
  ) {
    _setCell(
      sheet,
      col: 0,
      row: row,
      value: labels.grandTotal.toUpperCase(),
      bold: true,
      fontSize: 12,
    );
    if (lineTotalRows.isEmpty) {
      _setCell(
        sheet,
        col: 8,
        row: row,
        value: state.totalMaterials,
        isNumber: true,
        bold: true,
      );
    } else {
      final refs = lineTotalRows.map((r) => 'I${r + 1}').join('+');
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row))
          .value = FormulaCellValue('=$refs');
    }
    row++;
    _setCell(sheet, col: 7, row: row, value: labels.grandTotalSpent, bold: true);
    _setCell(
      sheet,
      col: 8,
      row: row,
      value: state.totalPurchased,
      isNumber: true,
      bold: true,
    );
  }

  void _setCell(
    Sheet sheet, {
    required int col,
    required int row,
    required Object? value,
    bool bold = false,
    int? fontSize,
    ExcelColor? background,
    bool isNumber = false,
  }) {
    final cell = sheet.cell(
      CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
    );

    final style = CellStyle(
      bold: bold,
      fontSize: fontSize,
      backgroundColorHex: background ?? ExcelColor.none,
      numberFormat: isNumber ? NumFormat.standard_2 : NumFormat.standard_0,
    );

    if (value is double) {
      cell
        ..value = DoubleCellValue(value)
        ..cellStyle = style;
      return;
    }

    cell
      ..value = TextCellValue(value?.toString() ?? '')
      ..cellStyle = style;
  }

  String _qtyText(double quantity) {
    if (quantity % 1 == 0) {
      return quantity.toInt().toString();
    }
    return quantity.toString();
  }
}
