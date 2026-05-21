import 'dart:io';

import 'package:flutter/material.dart';
import 'package:remont_estimate/core/services/material_image_storage.dart';

/// Thumbnail or tile image for a material photo (local file or cloud URL).
class MaterialPhotoImage extends StatelessWidget {
  const MaterialPhotoImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    if (MaterialImageStorage.isRemoteUrl(path)) {
      return Image.network(
        path,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (_, _, _) => const _BrokenImage(),
      );
    }
    return Image.file(
      File(path),
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, _, _) => const _BrokenImage(),
    );
  }
}

class _BrokenImage extends StatelessWidget {
  const _BrokenImage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.broken_image_outlined),
    );
  }
}
