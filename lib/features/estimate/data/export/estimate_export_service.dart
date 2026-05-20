import 'dart:io';

import 'package:remont_estimate/features/estimate/data/export/estimate_excel_exporter.dart';
import 'package:remont_estimate/features/estimate/data/export/estimate_pdf_exporter.dart';
import 'package:remont_estimate/features/estimate/data/export/export_document_labels.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';

enum ExportFormat { pdf, excel }

/// Facade for generating and locating export files.
class EstimateExportService {
  EstimateExportService({
    EstimatePdfExporter? pdfExporter,
    EstimateExcelExporter? excelExporter,
  })  : _pdfExporter = pdfExporter ?? EstimatePdfExporter(),
        _excelExporter = excelExporter ?? EstimateExcelExporter();

  final EstimatePdfExporter _pdfExporter;
  final EstimateExcelExporter _excelExporter;

  Future<File> export(
    EstimateState state,
    ExportFormat format,
    ExportDocumentLabels labels,
  ) {
    switch (format) {
      case ExportFormat.pdf:
        return _pdfExporter.export(state, labels);
      case ExportFormat.excel:
        return _excelExporter.export(state, labels);
    }
  }

  bool canExport(EstimateState state) => state.rooms.isNotEmpty;
}
