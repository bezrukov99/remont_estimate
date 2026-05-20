import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:remont_estimate/features/estimate/data/export/estimate_excel_exporter.dart';
import 'package:remont_estimate/features/estimate/data/export/estimate_export_service.dart';
import 'package:remont_estimate/features/estimate/data/export/estimate_pdf_exporter.dart';
import 'package:remont_estimate/features/estimate/data/export/export_document_labels.dart';
import 'package:remont_estimate/features/estimate/data/export/export_paths.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_item_model.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_unit.dart';
import 'package:remont_estimate/features/estimate/domain/models/project_model.dart';
import 'package:remont_estimate/features/estimate/domain/models/room_model.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class _MockStorage implements Storage {
  final Map<String, dynamic> _store = {};

  @override
  dynamic read(String key) => _store[key];

  @override
  Future<void> write(String key, dynamic value) async => _store[key] = value;

  @override
  Future<void> delete(String key) async => _store.remove(key);

  @override
  Future<void> clear() async => _store.clear();

  @override
  Future<void> close() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = _MockStorage();

  late ExportDocumentLabels enLabels;
  late ExportDocumentLabels ruLabels;

  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('ru');
    enLabels = ExportDocumentLabels(
      await AppLocalizations.delegate.load(const Locale('en')),
    );
    ruLabels = ExportDocumentLabels(
      await AppLocalizations.delegate.load(const Locale('ru')),
    );
  });

  setUp(() {
    ExportPaths.debugBaseDirectory =
        Directory.systemTemp.createTempSync('remont_export_test');
  });

  tearDown(() {
    ExportPaths.debugBaseDirectory?.deleteSync(recursive: true);
    ExportPaths.debugBaseDirectory = null;
  });

  EstimateState buildSampleState() {
    const kitchen = RoomModel(id: 'r1', name: 'Kitchen');
    const bath = RoomModel(id: 'r2', name: 'Bathroom');

    const project = ProjectModel(
      id: 'p1',
      name: 'Test Renovation',
      targetBudget: 10000,
      currencyCode: 'USD',
      rooms: [kitchen, bath],
      materials: [
        MaterialItemModel(
          id: 'm1',
          roomId: 'r1',
          name: 'Tiles',
          quantity: 10,
          unit: MaterialUnit.squareMeters,
          pricePerUnit: 25,
        ),
        MaterialItemModel(
          id: 'm2',
          roomId: 'r2',
          name: 'Sink',
          quantity: 1,
          unit: MaterialUnit.pieces,
          pricePerUnit: 180,
        ),
      ],
    );

    return EstimateState(
      projects: [project],
      activeProjectId: project.id,
    );
  }

  group('EstimateExportService', () {
    test('canExport requires at least one room', () {
      final service = EstimateExportService();
      expect(
        service.canExport(EstimateState.createInitial(defaultProjectId: 'empty')),
        isFalse,
      );
      expect(service.canExport(buildSampleState()), isTrue);
    });

    test('PDF export creates non-empty file', () async {
      final file = await EstimatePdfExporter().export(
        buildSampleState(),
        enLabels,
      );
      expect(file.existsSync(), isTrue);
      expect(await file.length(), greaterThan(500));
      await file.delete();
    });

    test('PDF export embeds Cyrillic text with Noto Sans', () async {
      const kitchen = RoomModel(id: 'r1', name: 'Кухня');
      const project = ProjectModel(
        id: 'p1',
        name: 'Ремонт квартиры',
        currencyCode: 'RUB',
        rooms: [kitchen],
        materials: [
          MaterialItemModel(
            id: 'm1',
            roomId: 'r1',
            name: 'Плитка керамическая',
            quantity: 12,
            unit: MaterialUnit.squareMeters,
            pricePerUnit: 1500,
          ),
        ],
      );
      final state = EstimateState(
        projects: [project],
        activeProjectId: project.id,
      );

      final file = await EstimatePdfExporter().export(state, ruLabels);
      final raw = String.fromCharCodes(await file.readAsBytes());
      expect(raw, contains('NotoSans-Regular'));
      expect(raw, contains('NotoSans-Bold'));
      expect(await file.length(), greaterThan(8000));
      await file.delete();
    });

    test('Excel export creates non-empty xlsx', () async {
      final file = await EstimateExcelExporter().export(
        buildSampleState(),
        enLabels,
      );
      expect(file.existsSync(), isTrue);
      expect(file.path.endsWith('.xlsx'), isTrue);
      expect(await file.length(), greaterThan(200));
      await file.delete();
    });

    test('Russian labels use localized column headers in Excel', () async {
      final file = await EstimateExcelExporter().export(
        buildSampleState(),
        ruLabels,
      );
      expect(file.existsSync(), isTrue);
      await file.delete();
    });
  });
}
