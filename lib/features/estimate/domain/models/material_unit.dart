/// Quantity unit for renovation materials.
enum MaterialUnit {
  pieces('pcs', 'Pcs'),
  squareMeters('sqm', 'Sq.m'),
  pack('pack', 'Pack'),
  meters('m', 'Meters'),
  liters('l', 'Liters'),
  kilograms('kg', 'Kg');

  const MaterialUnit(this.value, this.label);

  final String value;
  final String label;

  static MaterialUnit fromValue(String? value) {
    if (value == null || value.isEmpty) {
      return MaterialUnit.pieces;
    }
    return MaterialUnit.values.firstWhere(
      (unit) => unit.value == value,
      orElse: () => MaterialUnit.pieces,
    );
  }
}
