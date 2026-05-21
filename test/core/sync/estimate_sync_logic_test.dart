import 'package:flutter_test/flutter_test.dart';
import 'package:remont_estimate/core/sync/estimate_sync_logic.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_item_model.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_unit.dart';
import 'package:remont_estimate/features/estimate/domain/models/project_model.dart';
import 'package:remont_estimate/features/estimate/domain/models/room_model.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';

void main() {
  group('EstimateSyncLogic', () {
    test('resolveOnLogin prefers remote when it is newer', () {
      final local = _stateWithMaterial(
        modified: DateTime(2024, 1, 1),
        materialUpdated: DateTime(2024, 1, 1),
      );
      final remote = _stateWithMaterial(
        modified: DateTime(2025, 1, 1),
        materialUpdated: DateTime(2025, 1, 1),
        projectName: 'Cloud project',
      );

      final resolved = EstimateSyncLogic.resolveOnLogin(
        local: local,
        remote: remote,
      );

      expect(resolved.projectName, 'Cloud project');
    });

    test('resolveOnLogin uploads local when cloud is empty', () {
      final local = _stateWithMaterial(
        modified: DateTime(2025, 1, 1),
        materialUpdated: DateTime(2025, 1, 1),
      );

      final resolved = EstimateSyncLogic.resolveOnLogin(
        local: local,
        remote: null,
      );

      expect(resolved, local);
    });

    test('hasUserData detects rooms', () {
      final empty = EstimateState.createInitial(defaultProjectId: 'p1');
      expect(EstimateSyncLogic.hasUserData(empty), isFalse);

      final withRoom = empty.copyWith(
        projects: [
          ProjectModel(
            id: 'p1',
            name: 'My Renovation',
            rooms: [RoomModel(id: 'r1', name: 'Kitchen')],
            createdAt: DateTime.now(),
          ),
        ],
      );
      expect(EstimateSyncLogic.hasUserData(withRoom), isTrue);
    });
  });
}

EstimateState _stateWithMaterial({
  required DateTime modified,
  required DateTime materialUpdated,
  String projectName = 'Local',
}) {
  const roomId = 'room-1';
  return EstimateState(
    projects: [
      ProjectModel(
        id: 'p1',
        name: projectName,
        rooms: [RoomModel(id: roomId, name: 'Kitchen')],
        materials: [
          MaterialItemModel(
            id: 'm1',
            roomId: roomId,
            name: 'Tile',
            quantity: 1,
            unit: MaterialUnit.pieces,
            pricePerUnit: 10,
            updatedAt: materialUpdated,
          ),
        ],
        createdAt: DateTime(2020),
      ),
    ],
    activeProjectId: 'p1',
    lastModified: modified,
  );
}
