import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Persists material photos under the app documents directory.
abstract final class MaterialImageStorage {
  static const _folderName = 'material_images';
  static const _uuid = Uuid();

  static bool isRemoteUrl(String path) =>
      path.startsWith('http://') || path.startsWith('https://');

  static bool isDisplayable(String path) {
    if (path.isEmpty) {
      return false;
    }
    if (isRemoteUrl(path)) {
      return true;
    }
    return File(path).existsSync();
  }

  static List<String> existingPaths(Iterable<String> paths) {
    return paths.where(isDisplayable).toList();
  }

  static Future<Directory> _imagesDirectory() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/$_folderName');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Copies [file] into app storage and returns the absolute path.
  static Future<String> persistFromPicker(XFile file) async {
    final dir = await _imagesDirectory();
    final extension = _extensionFromPath(file.path);
    final targetPath = '${dir.path}/${_uuid.v4()}$extension';
    await File(file.path).copy(targetPath);
    return targetPath;
  }

  /// Deletes a file if it lives inside our material images folder.
  static Future<void> deleteIfOwned(String? path) async {
    if (path == null || path.isEmpty || isRemoteUrl(path)) {
      return;
    }
    final dir = await _imagesDirectory();
    if (!path.startsWith(dir.path)) {
      return;
    }
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }
  }

  static Future<void> deleteAllIfOwned(Iterable<String> paths) async {
    for (final path in paths) {
      await deleteIfOwned(path);
    }
  }

  static String extensionFromPath(String path) => _extensionFromPath(path);

  static String _extensionFromPath(String path) {
    final dot = path.lastIndexOf('.');
    if (dot == -1 || dot == path.length - 1) {
      return '.jpg';
    }
    final ext = path.substring(dot).toLowerCase();
    const allowed = {'.jpg', '.jpeg', '.png', '.webp', '.heic'};
    return allowed.contains(ext) ? ext : '.jpg';
  }
}
