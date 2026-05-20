import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:remont_estimate/core/pdf/pdf_fonts.dart';
import 'package:remont_estimate/core/utils/currency_formatter.dart';
import 'package:remont_estimate/features/estimate/data/export/export_document_labels.dart';
import 'package:remont_estimate/features/estimate/data/export/export_paths.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_item_model.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';

/// Generates a clean A4 PDF grouped by rooms with totals and photo thumbnails.
class EstimatePdfExporter {
  static final _accent = PdfColor.fromHex('#7A9E7E');
  static final _headerBg = PdfColor.fromHex('#E8F0E9');
  static final _textMuted = PdfColor.fromHex('#636E72');

  Future<File> export(
    EstimateState state,
    ExportDocumentLabels labels,
  ) async {
    await PdfFonts.ensureLoaded();

    final doc = pw.Document(
      title: state.projectName,
      author: labels.appTitle,
    );

    doc.addPage(
      pw.MultiPage(
        theme: PdfFonts.theme(),
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (_) => _pageHeader(state, labels),
        footer: (ctx) => _pageFooter(ctx, labels),
        build: (context) => [
          _summaryBlock(state, labels),
          pw.SizedBox(height: 20),
          ..._roomSections(state, labels),
          pw.SizedBox(height: 12),
          _grandTotalBlock(state, labels),
        ],
      ),
    );

    final bytes = await doc.save();
    final path = await ExportPaths.pdfPath(state.projectName);
    final dir = Directory(await ExportPaths.directory());
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  pw.Widget _pageHeader(EstimateState state, ExportDocumentLabels labels) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            labels.appTitle,
            style: pw.TextStyle(
              fontSize: 10,
              color: _accent,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            state.projectName,
            style: pw.TextStyle(fontSize: 10, color: _textMuted),
          ),
        ],
      ),
    );
  }

  pw.Widget _pageFooter(pw.Context context, ExportDocumentLabels labels) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 8),
      child: pw.Text(
        labels.pageOf(context.pageNumber, context.pagesCount),
        style: pw.TextStyle(fontSize: 9, color: _textMuted),
      ),
    );
  }

  pw.Widget _summaryBlock(EstimateState state, ExportDocumentLabels labels) {
    final children = <pw.Widget>[
      pw.Text(
        labels.budgetSummary,
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        labels.materialsTotal(
          CurrencyFormatter.format(state.totalMaterials, state.currencyCode),
        ),
        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 4),
      pw.Text(
        labels.purchasedTotal(
          CurrencyFormatter.format(state.totalPurchased, state.currencyCode),
        ),
        style: const pw.TextStyle(fontSize: 12),
      ),
    ];

    if (state.hasTargetBudget) {
      children.addAll([
        pw.SizedBox(height: 4),
        pw.Text(
          labels.targetBudget(
            CurrencyFormatter.format(state.targetBudget!, state.currencyCode),
          ),
          style: const pw.TextStyle(fontSize: 11),
        ),
        pw.SizedBox(height: 6),
        pw.ClipRRect(
          horizontalRadius: 4,
          verticalRadius: 4,
          child: pw.LinearProgressIndicator(
            value: state.budgetProgress.clamp(0, 1).toDouble(),
            valueColor: state.isOverBudget ? PdfColors.orange800 : _accent,
            backgroundColor: PdfColors.grey300,
          ),
        ),
      ]);
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: _headerBg,
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  List<pw.Widget> _roomSections(
    EstimateState state,
    ExportDocumentLabels labels,
  ) {
    final widgets = <pw.Widget>[];

    for (final room in state.sortedRooms) {
      final materials = state.materialsForRoom(room.id);
      final subtotal = state.subtotalForRoom(room.id);
      final purchasedSubtotal = state.purchasedSubtotalForRoom(room.id);

      widgets.add(
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: pw.BoxDecoration(
                  color: _accent,
                  borderRadius: const pw.BorderRadius.vertical(
                    top: pw.Radius.circular(8),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        room.name,
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          CurrencyFormatter.format(
                            subtotal,
                            state.currencyCode,
                          ),
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        if (purchasedSubtotal > 0)
                          pw.Text(
                            labels.roomPurchased(
                              CurrencyFormatter.format(
                                purchasedSubtotal,
                                state.currencyCode,
                              ),
                            ),
                            style: const pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 9,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (materials.isEmpty)
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.vertical(
                      bottom: pw.Radius.circular(8),
                    ),
                  ),
                  child: pw.Text(
                    labels.noMaterialsInRoom,
                    style: pw.TextStyle(color: _textMuted, fontSize: 10),
                  ),
                )
              else
                _materialsTable(state, materials, labels),
            ],
          ),
        ),
      );
    }

    if (state.rooms.isEmpty) {
      widgets.add(
        pw.Text(
          labels.noRoomsYet,
          style: pw.TextStyle(color: _textMuted),
        ),
      );
    }

    return widgets;
  }

  pw.Widget _materialsTable(
    EstimateState state,
    List<MaterialItemModel> materials,
    ExportDocumentLabels labels,
  ) {
    final headers = labels.materialTableHeaders;

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.2),
        1: const pw.FlexColumnWidth(1.2),
        2: const pw.FlexColumnWidth(1.1),
        3: const pw.FlexColumnWidth(1.2),
        4: const pw.FlexColumnWidth(1.2),
        5: const pw.FlexColumnWidth(0.7),
        6: const pw.FlexColumnWidth(0.7),
        7: const pw.FlexColumnWidth(0.9),
        8: const pw.FlexColumnWidth(0.9),
        9: const pw.FlexColumnWidth(0.8),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: headers.map(_th).toList(),
        ),
        ...materials.map((m) => _materialRow(state, m, labels)),
      ],
    );
  }

  pw.TableRow _materialRow(
    EstimateState state,
    MaterialItemModel material,
    ExportDocumentLabels labels,
  ) {
    final qty = material.quantity % 1 == 0
        ? material.quantity.toInt().toString()
        : material.quantity.toStringAsFixed(1);

    return pw.TableRow(
      children: [
        _td(material.name),
        _td(material.brand ?? '-'),
        _td(material.article ?? '-'),
        _td(material.store ?? '-'),
        _td(material.dimensions ?? '-'),
        _td(qty),
        _td(labels.unitLabel(material.unit)),
        _td(material.pricePerUnit.toStringAsFixed(2)),
        _td(
          CurrencyFormatter.format(material.totalPrice, state.currencyCode),
          bold: true,
        ),
        _tdPhoto(material.primaryPhotoPath, material.photoPaths.length, labels),
      ],
    );
  }

  pw.Widget _tdPhoto(
    String? path,
    int totalPhotos,
    ExportDocumentLabels labels,
  ) {
    final image = _loadImage(path);
    if (image != null) {
      final extra = totalPhotos > 1
          ? ' ${labels.photosExtra(totalPhotos - 1)}'
          : '';
      return pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Column(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Image(image, width: 36, height: 36, fit: pw.BoxFit.cover),
            if (extra.isNotEmpty)
              pw.Text(extra, style: const pw.TextStyle(fontSize: 8)),
          ],
        ),
      );
    }
    if (path != null && path.isNotEmpty) {
      return _td(labels.photoOnFile);
    }
    return _td('-');
  }

  pw.MemoryImage? _loadImage(String? path) {
    if (path == null || path.isEmpty) {
      return null;
    }
    final file = File(path);
    if (!file.existsSync()) {
      return null;
    }
    try {
      final bytes = file.readAsBytesSync();
      if (bytes.length > 3 * 1024 * 1024) {
        return null;
      }
      return pw.MemoryImage(bytes);
    } catch (_) {
      return null;
    }
  }

  pw.Widget _grandTotalBlock(
    EstimateState state,
    ExportDocumentLabels labels,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _accent, width: 1.5),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                labels.grandTotal,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                CurrencyFormatter.format(
                  state.totalMaterials,
                  state.currencyCode,
                ),
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: _accent,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                labels.grandTotalSpent,
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                CurrencyFormatter.format(
                  state.totalPurchased,
                  state.currencyCode,
                ),
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _th(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _td(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
