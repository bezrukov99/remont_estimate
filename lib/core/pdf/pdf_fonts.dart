import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;

/// TTF fonts with Cyrillic support for PDF export (Noto Sans).
abstract final class PdfFonts {
  static pw.Font? _regular;
  static pw.Font? _bold;

  static const _regularAsset = 'assets/fonts/NotoSans-Regular.ttf';
  static const _boldAsset = 'assets/fonts/NotoSans-Bold.ttf';

  static Future<void> ensureLoaded() async {
    if (_regular != null) {
      return;
    }
    final regularData = await rootBundle.load(_regularAsset);
    final boldData = await rootBundle.load(_boldAsset);
    _regular = pw.Font.ttf(regularData);
    _bold = pw.Font.ttf(boldData);
  }

  static pw.ThemeData theme() {
    final regular = _regular;
    final bold = _bold;
    if (regular == null || bold == null) {
      throw StateError('Call PdfFonts.ensureLoaded() before building PDF');
    }
    return pw.ThemeData.withFont(base: regular, bold: bold);
  }
}
