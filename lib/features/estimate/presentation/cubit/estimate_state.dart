import 'package:equatable/equatable.dart';
import 'package:remont_estimate/core/constants/storage_keys.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_item_model.dart';
import 'package:remont_estimate/features/estimate/domain/models/project_model.dart';
import 'package:remont_estimate/features/estimate/domain/models/room_model.dart';

/// Root state: multiple renovation projects with one active at a time.
class EstimateState extends Equatable {
  EstimateState({
    this.schemaVersion = StorageKeys.estimateStateSchemaVersion,
    List<ProjectModel>? projects,
    String? activeProjectId,
  })  : projects = projects ?? const [],
        activeProjectId = activeProjectId ??
            (projects?.isNotEmpty == true ? projects!.first.id : null);

  final int schemaVersion;
  final List<ProjectModel> projects;
  final String? activeProjectId;

  ProjectModel? get activeProject {
    if (activeProjectId == null || projects.isEmpty) {
      return null;
    }
    try {
      return projects.firstWhere((p) => p.id == activeProjectId);
    } on StateError {
      return projects.first;
    }
  }

  // ——— Delegates to active project (for existing UI / export) ———

  String get projectName => activeProject?.name ?? '';

  double? get targetBudget => activeProject?.targetBudget;

  List<RoomModel> get rooms => activeProject?.rooms ?? const [];
  List<MaterialItemModel> get materials => activeProject?.materials ?? const [];
  String get currencyCode => activeProject?.currencyCode ?? 'USD';

  double get totalMaterials => activeProject?.totalMaterials ?? 0;

  double get totalPurchased => activeProject?.totalPurchased ?? 0;

  double get budgetProgress => activeProject?.budgetProgress ?? 0;

  bool get hasTargetBudget => activeProject?.hasTargetBudget ?? false;

  bool get isOverBudget => activeProject?.isOverBudget ?? false;

  List<RoomModel> get sortedRooms => activeProject?.sortedRooms ?? const [];

  List<MaterialItemModel> materialsForRoom(String roomId) =>
      activeProject?.materialsForRoom(roomId) ?? const [];

  int itemCountForRoom(String roomId) =>
      activeProject?.itemCountForRoom(roomId) ?? 0;

  double subtotalForRoom(String roomId) =>
      activeProject?.subtotalForRoom(roomId) ?? 0;

  double purchasedSubtotalForRoom(String roomId) =>
      activeProject?.purchasedSubtotalForRoom(roomId) ?? 0;

  RoomModel? roomById(String roomId) => activeProject?.roomById(roomId);

  MaterialItemModel? materialById(String materialId) =>
      activeProject?.materialById(materialId);

  EstimateState copyWith({
    int? schemaVersion,
    List<ProjectModel>? projects,
    String? activeProjectId,
  }) {
    return EstimateState(
      schemaVersion: schemaVersion ?? this.schemaVersion,
      projects: projects ?? this.projects,
      activeProjectId: activeProjectId ?? this.activeProjectId,
    );
  }

  EstimateState updateActiveProject(ProjectModel Function(ProjectModel) update) {
    final active = activeProject;
    if (active == null) {
      return this;
    }
    final updated = update(active);
    return copyWith(
      projects: projects
          .map((p) => p.id == active.id ? updated : p)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'projects': projects.map((p) => p.toJson()).toList(),
      'activeProjectId': activeProjectId,
    };
  }

  factory EstimateState.fromJson(Map<String, dynamic> json) {
    final version = (json['schemaVersion'] as num?)?.toInt() ??
        StorageKeys.estimateStateSchemaVersion;

    if (json.containsKey('projects')) {
      final projects = (json['projects'] as List<dynamic>? ?? [])
          .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final activeId = json['activeProjectId'] as String?;
      return EstimateState(
        schemaVersion: version,
        projects: projects.isEmpty ? null : projects,
        activeProjectId: activeId,
      );
    }

    // Migrate legacy single-project storage (schema v1).
    final legacyProject = ProjectModel(
      id: json['projectId'] as String? ?? 'legacy-default',
      name: json['projectName'] as String? ?? 'My Renovation',
      targetBudget: (json['targetBudget'] as num?)?.toDouble(),
      rooms: (json['rooms'] as List<dynamic>? ?? [])
          .map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      materials: (json['materials'] as List<dynamic>? ?? [])
          .map((e) => MaterialItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currencyCode: json['currencyCode'] as String? ?? 'USD',
    );

    return EstimateState(
      schemaVersion: StorageKeys.estimateStateSchemaVersion,
      projects: [legacyProject],
      activeProjectId: legacyProject.id,
    );
  }

  static EstimateState createInitial({required String defaultProjectId}) {
    final project = ProjectModel(
      id: defaultProjectId,
      name: 'My Renovation',
      createdAt: DateTime.now(),
    );
    return EstimateState(
      projects: [project],
      activeProjectId: project.id,
    );
  }

  @override
  List<Object?> get props => [schemaVersion, projects, activeProjectId];
}
