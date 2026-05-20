import 'package:flutter_test/flutter_test.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_item_model.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_unit.dart';

void main() {
  group('Material form calculations', () {
    test('total price equals quantity times price per unit', () {
      const material = MaterialItemModel(
        id: '1',
        roomId: 'r1',
        name: 'Tiles',
        quantity: 12.5,
        unit: MaterialUnit.squareMeters,
        pricePerUnit: 28,
      );

      expect(material.totalPrice, 350);
    });

    test('MaterialUnit labels are user-facing', () {
      expect(MaterialUnit.pieces.label, 'Pcs');
      expect(MaterialUnit.squareMeters.label, 'Sq.m');
    });
  });
}
