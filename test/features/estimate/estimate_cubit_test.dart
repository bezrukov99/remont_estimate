import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_item_model.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_unit.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_cubit.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';

class _MockStorage implements Storage {
  final Map<String, dynamic> _store = {};

  @override
  dynamic read(String key) => _store[key];

  @override
  Future<void> write(String key, dynamic value) async {
    _store[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }

  @override
  Future<void> close() async {}
}

void main() {
  late EstimateCubit cubit;

  setUp(() {
    HydratedBloc.storage = _MockStorage();
    final fakeUuid = _FakeUuid();
    cubit = EstimateCubit(generateId: fakeUuid.v4);
  });

  tearDown(() => cubit.close());

  group('EstimateCubit', () {
    test('addRoom and addMaterial update totals', () {
      final room = cubit.addRoom(name: 'Kitchen');

      cubit.addMaterial(
        roomId: room.id,
        name: 'Tiles',
        quantity: 10,
        unit: MaterialUnit.squareMeters,
        pricePerUnit: 25,
      );

      expect(cubit.state.rooms, hasLength(1));
      expect(cubit.state.materials, hasLength(1));
      expect(cubit.state.totalMaterials, 250);
      expect(cubit.state.totalPurchased, 0);
      expect(cubit.state.subtotalForRoom(room.id), 250);
      expect(cubit.state.itemCountForRoom(room.id), 1);
    });

    test('setMaterialPurchased moves item to purchased state', () {
      final room = cubit.addRoom(name: 'Kitchen');
      final material = cubit.addMaterial(
        roomId: room.id,
        name: 'Paint',
        quantity: 2,
        unit: MaterialUnit.pieces,
        pricePerUnit: 15,
      );

      cubit.setMaterialPurchased(material.id, true);

      final updated = cubit.state.materialById(material.id)!;
      expect(updated.isPurchased, isTrue);
      expect(updated.purchasedAt, isNotNull);
      expect(cubit.state.totalMaterials, 30);
      expect(cubit.state.totalPurchased, 30);

      cubit.setMaterialPurchased(material.id, false);

      final restored = cubit.state.materialById(material.id)!;
      expect(restored.isPurchased, isFalse);
      expect(restored.purchasedAt, isNull);
    });

    test('materialsForRoom lists unpurchased before purchased', () {
      final room = cubit.addRoom(name: 'Bedroom');
      final first = cubit.addMaterial(
        roomId: room.id,
        name: 'First',
        quantity: 1,
        unit: MaterialUnit.pieces,
        pricePerUnit: 1,
      );
      cubit.addMaterial(
        roomId: room.id,
        name: 'Second',
        quantity: 1,
        unit: MaterialUnit.pieces,
        pricePerUnit: 2,
      );

      cubit.setMaterialPurchased(first.id, true);

      final ordered =
          cubit.state.materialsForRoom(room.id).map((m) => m.name).toList();
      expect(ordered, ['Second', 'First']);
    });

    test('deleteMaterials removes multiple items', () {
      final room = cubit.addRoom(name: 'Hall');
      final a = cubit.addMaterial(
        roomId: room.id,
        name: 'A',
        quantity: 1,
        unit: MaterialUnit.pieces,
        pricePerUnit: 10,
      );
      final b = cubit.addMaterial(
        roomId: room.id,
        name: 'B',
        quantity: 1,
        unit: MaterialUnit.pieces,
        pricePerUnit: 20,
      );
      cubit.addMaterial(
        roomId: room.id,
        name: 'C',
        quantity: 1,
        unit: MaterialUnit.pieces,
        pricePerUnit: 5,
      );

      cubit.deleteMaterials([a.id, b.id]);

      expect(cubit.state.materials, hasLength(1));
      expect(cubit.state.materials.single.name, 'C');
      expect(cubit.state.totalMaterials, 5);
      expect(cubit.state.totalPurchased, 0);
    });

    test('deleteRoom removes linked materials', () {
      final room = cubit.addRoom(name: 'Bath');
      cubit.addMaterial(
        roomId: room.id,
        name: 'Sink',
        quantity: 1,
        unit: MaterialUnit.pieces,
        pricePerUnit: 120,
      );

      cubit.deleteRoom(room.id);

      expect(cubit.state.rooms, isEmpty);
      expect(cubit.state.materials, isEmpty);
      expect(cubit.state.totalMaterials, 0);
      expect(cubit.state.totalPurchased, 0);
    });

    test('createProject switches active project', () {
      cubit.addRoom(name: 'Kitchen');
      final second = cubit.createProject(name: 'Country house');

      expect(cubit.state.projects, hasLength(2));
      expect(cubit.state.activeProjectId, second.id);
      expect(cubit.state.rooms, isEmpty);
      expect(cubit.state.projectName, 'Country house');

      cubit.switchProject(cubit.state.projects.first.id);
      expect(cubit.state.rooms, hasLength(1));
    });

    test('setTargetBudget and persistence round-trip', () {
      cubit.setTargetBudget(5000);
      final room = cubit.addRoom(name: 'Hall');
      cubit.addMaterial(
        roomId: room.id,
        name: 'Paint',
        quantity: 2,
        unit: MaterialUnit.pack,
        pricePerUnit: 40,
      );

      final json = cubit.toJson(cubit.state);
      final restored = EstimateState.fromJson(json!);

      expect(restored.targetBudget, 5000);
      expect(restored.totalMaterials, 80);
      expect(restored.totalPurchased, 0);
      expect(restored.rooms.first.name, 'Hall');
    });
  });

  group('MaterialItemModel', () {
    test('totalPrice is quantity * pricePerUnit', () {
      final material = MaterialItemModel(
        id: '1',
        roomId: 'r1',
        name: 'Laminate',
        quantity: 3.5,
        unit: MaterialUnit.squareMeters,
        pricePerUnit: 18.5,
      );

      expect(material.totalPrice, closeTo(64.75, 0.001));
    });

    test('copyWith clears optional fields', () {
      const material = MaterialItemModel(
        id: '1',
        roomId: 'r1',
        name: 'Door',
        quantity: 1,
        unit: MaterialUnit.pieces,
        pricePerUnit: 200,
        photoPaths: ['/tmp/door.jpg'],
        dimensions: '80x200',
      );

      final cleared =
          material.copyWith(clearPhotoPaths: true, clearDimensions: true);

      expect(cleared.photoPaths, isEmpty);
      expect(cleared.dimensions, isNull);
    });
  });
}

/// Deterministic IDs for predictable tests.
class _FakeUuid {
  int _counter = 0;

  String v4() {
    _counter++;
    return '00000000-0000-0000-0000-${_counter.toString().padLeft(12, '0')}';
  }
}
