import 'package:equatable/equatable.dart';

/// A renovation zone (kitchen, bathroom, etc.).
class RoomModel extends Equatable {
  const RoomModel({
    required this.id,
    required this.name,
    this.sortOrder = 0,
    this.createdAt,
  });

  final String id;
  final String name;
  final int sortOrder;
  final DateTime? createdAt;

  RoomModel copyWith({
    String? id,
    String? name,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return RoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sortOrder': sortOrder,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as String,
      name: json['name'] as String,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, name, sortOrder, createdAt];
}
