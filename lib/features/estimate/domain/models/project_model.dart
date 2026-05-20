import 'package:equatable/equatable.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_item_model.dart';
import 'package:remont_estimate/features/estimate/domain/models/room_model.dart';

/// A renovation project (apartment, house, etc.) with its own budget and rooms.
class ProjectModel extends Equatable {
  const ProjectModel({
    required this.id,
    required this.name,
    this.targetBudget,
    this.rooms = const [],
    this.materials = const [],
    this.currencyCode = 'USD',
    this.createdAt,
  });

  final String id;
  final String name;
  final double? targetBudget;
  final List<RoomModel> rooms;
  final List<MaterialItemModel> materials;
  final String currencyCode;
  final DateTime? createdAt;

  /// Sum of all materials (planned estimate).
  double get totalMaterials => _sumPrices(materials);

  /// Sum of materials marked as purchased.
  double get totalPurchased =>
      _sumPrices(materials.where((m) => m.isPurchased));

  double get budgetProgress {
    final target = targetBudget;
    if (target == null || target <= 0) {
      return 0;
    }
    return (totalPurchased / target).clamp(0, double.infinity);
  }

  bool get hasTargetBudget => targetBudget != null && targetBudget! > 0;

  bool get isOverBudget =>
      hasTargetBudget && totalPurchased > (targetBudget ?? 0);

  static double _sumPrices(Iterable<MaterialItemModel> items) =>
      items.fold<double>(0, (sum, item) => sum + item.totalPrice);

  List<RoomModel> get sortedRooms {
    final copy = List<RoomModel>.from(rooms);
    copy.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return copy;
  }

  List<MaterialItemModel> materialsForRoom(String roomId) {
    final items = materials.where((m) => m.roomId == roomId).toList();
    items.sort(compareMaterialsForDisplay);
    return items;
  }

  int itemCountForRoom(String roomId) => materialsForRoom(roomId).length;

  double subtotalForRoom(String roomId) =>
      _sumPrices(materialsForRoom(roomId));

  double purchasedSubtotalForRoom(String roomId) => _sumPrices(
        materialsForRoom(roomId).where((m) => m.isPurchased),
      );

  RoomModel? roomById(String roomId) {
    try {
      return rooms.firstWhere((r) => r.id == roomId);
    } on StateError {
      return null;
    }
  }

  MaterialItemModel? materialById(String materialId) {
    try {
      return materials.firstWhere((m) => m.id == materialId);
    } on StateError {
      return null;
    }
  }

  ProjectModel copyWith({
    String? id,
    String? name,
    double? targetBudget,
    List<RoomModel>? rooms,
    List<MaterialItemModel>? materials,
    String? currencyCode,
    DateTime? createdAt,
    bool clearTargetBudget = false,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      targetBudget:
          clearTargetBudget ? null : (targetBudget ?? this.targetBudget),
      rooms: rooms ?? this.rooms,
      materials: materials ?? this.materials,
      currencyCode: currencyCode ?? this.currencyCode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Clears rooms, materials, and budget while keeping identity and currency.
  ProjectModel cleared() {
    return ProjectModel(
      id: id,
      name: name,
      currencyCode: currencyCode,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetBudget': targetBudget,
      'rooms': rooms.map((r) => r.toJson()).toList(),
      'materials': materials.map((m) => m.toJson()).toList(),
      'currencyCode': currencyCode,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'My Renovation',
      targetBudget: (json['targetBudget'] as num?)?.toDouble(),
      rooms: (json['rooms'] as List<dynamic>? ?? [])
          .map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      materials: (json['materials'] as List<dynamic>? ?? [])
          .map((e) => MaterialItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currencyCode: json['currencyCode'] as String? ?? 'USD',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        targetBudget,
        rooms,
        materials,
        currencyCode,
        createdAt,
      ];
}
