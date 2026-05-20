import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remont_estimate/features/estimate/data/export/estimate_export_service.dart';
import 'package:share_plus/share_plus.dart';

/// Opens or shares exported documents on device.
abstract final class ExportFileOpener {
  static const _openTimeout = Duration(seconds: 12);

  static String mimeTypeFor(ExportFormat format) => switch (format) {
        ExportFormat.pdf => 'application/pdf',
        ExportFormat.excel =>
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      };

  /// Copies to app cache so FileProvider and share targets can read the file.
  static Future<File> prepareShareableCopy(File source) async {
    final cacheDir = await getTemporaryDirectory();
    final exportsDir = Directory('${cacheDir.path}/exports');
    if (!exportsDir.existsSync()) {
      await exportsDir.create(recursive: true);
    }
    final dest = File('${exportsDir.path}/${source.uri.pathSegments.last}');
    if (dest.path != source.path) {
      await source.copy(dest.path);
    }
    return dest;
  }

  static Future<OpenResult> open(File file, ExportFormat format) async {
    final shareable = await prepareShareableCopy(file);
    final mime = mimeTypeFor(format);

    try {
      return await OpenFile.open(shareable.path, type: mime).timeout(
        _openTimeout,
        onTimeout: () => OpenResult(
          type: ResultType.error,
          message: 'timeout',
        ),
      );
    } catch (e) {
      return OpenResult(type: ResultType.error, message: e.toString());
    }
  }

  static Future<void> share(
    File file,
    ExportFormat format, {
    required String subject,
  }) async {
    final shareable = await prepareShareableCopy(file);
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(
            shareable.path,
            mimeType: mimeTypeFor(format),
            name: shareable.uri.pathSegments.last,
          ),
        ],
        subject: subject,
      ),
    );
  }

  /// Opens with a viewer app; falls back to system share sheet if no handler.
  static Future<String?> openWithFallback(
    File file,
    ExportFormat format, {
    required String openFailedMessage,
  }) async {
    final result = await open(file, format);
    if (result.type == ResultType.done) {
      return null;
    }

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await share(file, format, subject: openFailedMessage);
      return null;
    }

    return result.message.isNotEmpty ? result.message : openFailedMessage;
  }
}
