import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Builds stable export file paths under app documents.
abstract final class ExportPaths {
  static const _folderName = 'exports';

  /// Override for unit tests (e.g. system temp directory).
  static Directory? debugBaseDirectory;

  static Future<String> directory() async {
    final basePath = debugBaseDirectory?.path ??
        (await getApplicationDocumentsDirectory()).path;
    return '$basePath/$_folderName';
  }

  static Future<String> pdfPath(String projectName) async {
    final dir = await directory();
    return '$dir/${_fileName(projectName, 'pdf')}';
  }

  static Future<String> excelPath(String projectName) async {
    final dir = await directory();
    return '$dir/${_fileName(projectName, 'xlsx')}';
  }

  static String _fileName(String projectName, String extension) {
    final slug = projectName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final safeSlug = slug.isEmpty ? 'renovation' : slug;
    final stamp = DateTime.now().toIso8601String().split('T').first;
    return 'remont_${safeSlug}_$stamp.$extension';
  }
}
