import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:remont_estimate/core/constants/storage_keys.dart';
import 'package:remont_estimate/core/constants/material_photo_limits.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_item_model.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_unit.dart';
import 'package:remont_estimate/features/estimate/domain/models/project_model.dart';
import 'package:remont_estimate/features/estimate/domain/models/room_model.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';
import 'package:uuid/uuid.dart';

/// Central state manager for projects, rooms, materials, and budget.
class EstimateCubit extends HydratedCubit<EstimateState> {
  EstimateCubit({String Function()? generateId})
      : _generateId = generateId ?? (() => const Uuid().v4()),
        super(EstimateState.createInitial(defaultProjectId: _bootstrapId(generateId))) {
    if (state.projects.isEmpty) {
      _ensureAtLeastOneProject();
    }
  }

  final String Function() _generateId;
  bool _preserveModifiedTimestamp = false;

  static String _bootstrapId(String Function()? generateId) {
    return generateId?.call() ?? 'bootstrap-project';
  }

  void _ensureAtLeastOneProject() {
    if (state.projects.isNotEmpty) {
      return;
    }
    final project = ProjectModel(
      id: _generateId(),
      name: 'My Renovation',
      createdAt: DateTime.now(),
    );
    emit(
      EstimateState(
        projects: [project],
        activeProjectId: project.id,
      ),
    );
  }

  void _emitUpdatedProject(ProjectModel Function(ProjectModel) update) {
    emit(state.updateActiveProject(update));
  }

  /// Applies cloud snapshot without bumping [EstimateState.lastModified].
  void replaceFromCloud(EstimateState cloudState) {
    _preserveModifiedTimestamp = true;
    emit(cloudState);
    _preserveModifiedTimestamp = false;
  }

  @override
  void emit(EstimateState state) {
    if (_preserveModifiedTimestamp) {
      super.emit(state);
      return;
    }
    super.emit(state.copyWith(touchModified: true));
  }

  // ——— Projects ———

  ProjectModel createProject({required String name}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Project name cannot be empty.');
    }

    final project = ProjectModel(
      id: _generateId(),
      name: trimmed,
      currencyCode: state.currencyCode,
      createdAt: DateTime.now(),
    );

    emit(
      state.copyWith(
        projects: [...state.projects, project],
        activeProjectId: project.id,
      ),
    );
    return project;
  }

  void switchProject(String projectId) {
    if (projectId == state.activeProjectId) {
      return;
    }
    if (!state.projects.any((p) => p.id == projectId)) {
      return;
    }
    emit(state.copyWith(activeProjectId: projectId));
  }

  bool canDeleteProject(String projectId) => state.projects.length > 1;

  void deleteProject(String projectId) {
    if (!canDeleteProject(projectId)) {
      return;
    }

    final remaining =
        state.projects.where((p) => p.id != projectId).toList();
    final newActiveId = state.activeProjectId == projectId
        ? remaining.first.id
        : state.activeProjectId;

    emit(
      state.copyWith(
        projects: remaining,
        activeProjectId: newActiveId,
      ),
    );
  }

  // ——— Active project & budget ———

  void setProjectName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed == state.projectName) {
      return;
    }
    _emitUpdatedProject((p) => p.copyWith(name: trimmed));
  }

  void setCurrencyCode(String code) {
    final trimmed = code.trim().toUpperCase();
    if (trimmed.isEmpty || trimmed == state.currencyCode) {
      return;
    }
    _emitUpdatedProject((p) => p.copyWith(currencyCode: trimmed));
  }

  void setTargetBudget(double? amount) {
    if (amount == state.targetBudget) {
      return;
    }
    if (amount == null || amount <= 0) {
      _emitUpdatedProject((p) => p.copyWith(clearTargetBudget: true));
      return;
    }
    _emitUpdatedProject((p) => p.copyWith(targetBudget: amount));
  }

  void clearTargetBudget() {
    if (state.targetBudget == null) {
      return;
    }
    _emitUpdatedProject((p) => p.copyWith(clearTargetBudget: true));
  }

  // ——— Rooms ———

  RoomModel addRoom({required String name}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Room name cannot be empty.');
    }

    final room = RoomModel(
      id: _generateId(),
      name: trimmed,
      sortOrder: state.rooms.length,
      createdAt: DateTime.now(),
    );

    _emitUpdatedProject((p) => p.copyWith(rooms: [...p.rooms, room]));
    return room;
  }

  void updateRoom({
    required String roomId,
    String? name,
    int? sortOrder,
  }) {
    final index = _roomIndex(roomId);
    if (index == -1) {
      return;
    }

    final current = state.rooms[index];
    final updated = current.copyWith(
      name: name?.trim().isEmpty == true ? current.name : name?.trim(),
      sortOrder: sortOrder,
    );

    final rooms = List<RoomModel>.from(state.rooms)..[index] = updated;
    _emitUpdatedProject((p) => p.copyWith(rooms: rooms));
  }

  void reorderRooms(List<String> orderedRoomIds) {
    if (orderedRoomIds.length != state.rooms.length) {
      return;
    }

    final roomsById = {for (final r in state.rooms) r.id: r};
    final reordered = <RoomModel>[];
    for (var i = 0; i < orderedRoomIds.length; i++) {
      final room = roomsById[orderedRoomIds[i]];
      if (room == null) {
        return;
      }
      reordered.add(room.copyWith(sortOrder: i));
    }

    _emitUpdatedProject((p) => p.copyWith(rooms: reordered));
  }

  void deleteRoom(String roomId) {
    _emitUpdatedProject(
      (p) => p.copyWith(
        rooms: p.rooms.where((r) => r.id != roomId).toList(),
        materials: p.materials.where((m) => m.roomId != roomId).toList(),
      ),
    );
  }

  // ——— Materials ———

  MaterialItemModel addMaterial({
    required String roomId,
    required String name,
    required double quantity,
    required MaterialUnit unit,
    required double pricePerUnit,
    List<String>? photoPaths,
    String? dimensions,
    String? brand,
    String? article,
    String? store,
  }) {
    _assertRoomExists(roomId);

    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Material name cannot be empty.');
    }
    if (quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity', 'Quantity must be > 0.');
    }
    if (pricePerUnit < 0) {
      throw ArgumentError.value(
        pricePerUnit,
        'pricePerUnit',
        'Price cannot be negative.',
      );
    }

    final now = DateTime.now();
    final material = MaterialItemModel(
      id: _generateId(),
      roomId: roomId,
      name: trimmed,
      quantity: quantity,
      unit: unit,
      pricePerUnit: pricePerUnit,
      photoPaths: _normalizePhotoPaths(photoPaths),
      dimensions: _optionalText(dimensions),
      brand: _optionalText(brand),
      article: _optionalText(article),
      store: _optionalText(store),
      createdAt: now,
      updatedAt: now,
    );

    _emitUpdatedProject((p) => p.copyWith(materials: [...p.materials, material]));
    return material;
  }

  void updateMaterial({
    required String materialId,
    String? roomId,
    String? name,
    List<String>? photoPaths,
    String? dimensions,
    String? brand,
    String? article,
    String? store,
    double? quantity,
    MaterialUnit? unit,
    double? pricePerUnit,
    bool clearPhotoPaths = false,
    bool clearDimensions = false,
    bool clearBrand = false,
    bool clearArticle = false,
    bool clearStore = false,
  }) {
    final index = _materialIndex(materialId);
    if (index == -1) {
      return;
    }

    final current = state.materials[index];
    final targetRoomId = roomId ?? current.roomId;
    _assertRoomExists(targetRoomId);

    if (quantity != null && quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity', 'Quantity must be > 0.');
    }
    if (pricePerUnit != null && pricePerUnit < 0) {
      throw ArgumentError.value(
        pricePerUnit,
        'pricePerUnit',
        'Price cannot be negative.',
      );
    }

    final updated = current.copyWith(
      roomId: roomId,
      name: name?.trim().isEmpty == true ? current.name : name?.trim(),
      photoPaths: photoPaths != null
          ? _normalizePhotoPaths(photoPaths)
          : null,
      dimensions: dimensions,
      quantity: quantity,
      unit: unit,
      pricePerUnit: pricePerUnit,
      clearPhotoPaths: clearPhotoPaths,
      clearDimensions: clearDimensions,
      brand: brand,
      article: article,
      store: store,
      clearBrand: clearBrand,
      clearArticle: clearArticle,
      clearStore: clearStore,
      updatedAt: DateTime.now(),
    );

    final materials = List<MaterialItemModel>.from(state.materials)
      ..[index] = updated;
    _emitUpdatedProject((p) => p.copyWith(materials: materials));
  }

  void setMaterialPurchased(String materialId, bool isPurchased) {
    final index = _materialIndex(materialId);
    if (index == -1) {
      return;
    }

    final now = DateTime.now();
    final updated = state.materials[index].copyWith(
      isPurchased: isPurchased,
      purchasedAt: isPurchased ? now : null,
      clearPurchasedAt: !isPurchased,
      updatedAt: now,
    );

    final materials = List<MaterialItemModel>.from(state.materials)
      ..[index] = updated;
    _emitUpdatedProject((p) => p.copyWith(materials: materials));
  }

  void deleteMaterial(String materialId) {
    deleteMaterials([materialId]);
  }

  void deleteMaterials(Iterable<String> materialIds) {
    final ids = materialIds.toSet();
    if (ids.isEmpty) {
      return;
    }
    _emitUpdatedProject(
      (p) => p.copyWith(
        materials: p.materials.where((m) => !ids.contains(m.id)).toList(),
      ),
    );
  }

  void moveMaterialToRoom({
    required String materialId,
    required String newRoomId,
  }) {
    updateMaterial(materialId: materialId, roomId: newRoomId);
  }

  /// Clears rooms, materials, and budget for the active project.
  void resetProject() {
    final active = state.activeProject;
    if (active == null) {
      return;
    }
    _emitUpdatedProject((p) => p.cleared());
  }

  /// All materials in a project (for photo cleanup on delete).
  Iterable<MaterialItemModel> materialsInProject(String projectId) {
    try {
      return state.projects
          .firstWhere((p) => p.id == projectId)
          .materials;
    } on StateError {
      return const [];
    }
  }

  // ——— Hydrated persistence ———

  @override
  String get storagePrefix => StorageKeys.estimateCubit;

  @override
  EstimateState? fromJson(Map<String, dynamic> json) {
    try {
      final loaded = EstimateState.fromJson(json);
      if (loaded.projects.isEmpty) {
        return EstimateState.createInitial(defaultProjectId: _generateId());
      }
      return loaded;
    } catch (_) {
      return EstimateState.createInitial(defaultProjectId: _generateId());
    }
  }

  @override
  Map<String, dynamic>? toJson(EstimateState state) => state.toJson();

  // ——— Helpers ———

  int _roomIndex(String roomId) =>
      state.rooms.indexWhere((r) => r.id == roomId);

  int _materialIndex(String materialId) =>
      state.materials.indexWhere((m) => m.id == materialId);

  void _assertRoomExists(String roomId) {
    if (_roomIndex(roomId) == -1) {
      throw StateError('Room with id "$roomId" does not exist.');
    }
  }

  static String? _optionalText(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static List<String> _normalizePhotoPaths(List<String>? paths) {
    if (paths == null || paths.isEmpty) {
      return const [];
    }
    return paths.take(MaterialPhotoLimits.maxPerMaterial).toList();
  }
}
