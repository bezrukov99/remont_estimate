import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

/// Share and save material photos to the device gallery.
abstract final class MaterialPhotoActions {
  static Future<void> share(String path) async {
    final file = File(path);
    if (!file.existsSync()) {
      throw StateError('Photo file not found');
    }

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(path, mimeType: 'image/jpeg', name: file.uri.pathSegments.last)],
      ),
    );
  }

  static Future<void> saveToGallery(String path) async {
    if (kIsWeb) {
      throw UnsupportedError('Gallery save is not supported on web');
    }

    final file = File(path);
    if (!file.existsSync()) {
      throw StateError('Photo file not found');
    }

    final hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      await Gal.requestAccess();
    }

    await Gal.putImage(path);
  }
}
