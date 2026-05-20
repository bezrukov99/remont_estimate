import 'package:equatable/equatable.dart';
import 'package:remont_estimate/core/constants/material_photo_limits.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_unit.dart';

/// A single material line item linked to a [RoomModel].
class MaterialItemModel extends Equatable {
  const MaterialItemModel({
    required this.id,
    required this.roomId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    this.photoPaths = const [],
    this.dimensions,
    this.brand,
    this.article,
    this.store,
    this.isPurchased = false,
    this.purchasedAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String roomId;
  final String name;
  final List<String> photoPaths;
  final String? dimensions;
  final String? brand;
  final String? article;
  final String? store;
  final double quantity;
  final MaterialUnit unit;
  final double pricePerUnit;
  final bool isPurchased;
  final DateTime? purchasedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// First photo for list thumbnails (legacy single-photo UX).
  String? get primaryPhotoPath =>
      photoPaths.isNotEmpty ? photoPaths.first : null;

  /// Total line cost: quantity × price per unit.
  double get totalPrice => quantity * pricePerUnit;

  bool get hasPurchaseDetails =>
      _hasText(brand) || _hasText(article) || _hasText(store);

  static bool _hasText(String? value) =>
      value != null && value.trim().isNotEmpty;

  MaterialItemModel copyWith({
    String? id,
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
    bool? isPurchased,
    DateTime? purchasedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearPurchasedAt = false,
    bool clearPhotoPaths = false,
    bool clearDimensions = false,
    bool clearBrand = false,
    bool clearArticle = false,
    bool clearStore = false,
  }) {
    return MaterialItemModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      name: name ?? this.name,
      photoPaths: clearPhotoPaths
          ? const []
          : (photoPaths ?? this.photoPaths),
      dimensions: clearDimensions ? null : (dimensions ?? this.dimensions),
      brand: clearBrand ? null : (brand ?? this.brand),
      article: clearArticle ? null : (article ?? this.article),
      store: clearStore ? null : (store ?? this.store),
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      isPurchased: isPurchased ?? this.isPurchased,
      purchasedAt:
          clearPurchasedAt ? null : (purchasedAt ?? this.purchasedAt),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'name': name,
      'photoPaths': photoPaths,
      'dimensions': dimensions,
      'brand': brand,
      'article': article,
      'store': store,
      'quantity': quantity,
      'unit': unit.value,
      'pricePerUnit': pricePerUnit,
      'isPurchased': isPurchased,
      if (purchasedAt != null) 'purchasedAt': purchasedAt!.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory MaterialItemModel.fromJson(Map<String, dynamic> json) {
    return MaterialItemModel(
      id: json['id'] as String,
      roomId: json['roomId'] as String,
      name: json['name'] as String,
      photoPaths: _parsePhotoPaths(json),
      dimensions: json['dimensions'] as String?,
      brand: json['brand'] as String?,
      article: json['article'] as String?,
      store: json['store'] as String?,
      quantity: (json['quantity'] as num).toDouble(),
      unit: MaterialUnit.fromValue(json['unit'] as String?),
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      isPurchased: json['isPurchased'] as bool? ?? false,
      purchasedAt: json['purchasedAt'] != null
          ? DateTime.parse(json['purchasedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  static List<String> _parsePhotoPaths(Map<String, dynamic> json) {
    final raw = json['photoPaths'];
    if (raw is List) {
      return raw
          .whereType<String>()
          .where((p) => p.isNotEmpty)
          .take(MaterialPhotoLimits.maxPerMaterial)
          .toList();
    }
    final legacy = json['photoPath'] as String?;
    if (legacy != null && legacy.isNotEmpty) {
      return [legacy];
    }
    return const [];
  }

  @override
  List<Object?> get props => [
        id,
        roomId,
        name,
        photoPaths,
        dimensions,
        brand,
        article,
        store,
        quantity,
        unit,
        pricePerUnit,
        isPurchased,
        purchasedAt,
        createdAt,
        updatedAt,
      ];
}

/// Display order: active items first, purchased at the end.
int compareMaterialsForDisplay(MaterialItemModel a, MaterialItemModel b) {
  if (a.isPurchased != b.isPurchased) {
    return a.isPurchased ? 1 : -1;
  }

  if (a.isPurchased && b.isPurchased) {
    final aPurchased = a.purchasedAt ?? a.updatedAt ?? a.createdAt;
    final bPurchased = b.purchasedAt ?? b.updatedAt ?? b.createdAt;
    if (aPurchased != null && bPurchased != null) {
      return aPurchased.compareTo(bPurchased);
    }
  }

  final aCreated = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  final bCreated = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  return aCreated.compareTo(bCreated);
}
