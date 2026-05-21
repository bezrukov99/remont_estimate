import 'dart:io';

import 'package:flutter/material.dart';
import 'package:remont_estimate/core/services/material_image_storage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:remont_estimate/core/services/material_photo_actions.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

/// Full-screen zoomable gallery for material photos.
class MaterialPhotoViewer extends StatefulWidget {
  const MaterialPhotoViewer({
    super.key,
    required this.paths,
    this.initialIndex = 0,
    this.onRemove,
  });

  final List<String> paths;
  final int initialIndex;
  final ValueChanged<String>? onRemove;

  static Future<void> show(
    BuildContext context, {
    required List<String> paths,
    int initialIndex = 0,
    ValueChanged<String>? onRemove,
  }) {
    final existing = MaterialImageStorage.existingPaths(paths);
    if (existing.isEmpty) {
      return Future.value();
    }

    final index = initialIndex.clamp(0, existing.length - 1);

    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => MaterialPhotoViewer(
          paths: existing,
          initialIndex: index,
          onRemove: onRemove,
        ),
      ),
    );
  }

  @override
  State<MaterialPhotoViewer> createState() => _MaterialPhotoViewerState();
}

class _MaterialPhotoViewerState extends State<MaterialPhotoViewer> {
  late final PageController _pageController;
  late int _currentIndex;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String get _currentPath => widget.paths[_currentIndex];

  void _showSnack(String text) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _runAction(Future<void> Function() action, String success) async {
    if (_busy) {
      return;
    }
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) {
        _showSnack(success);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        _showSnack(l10n.photoActionFailed(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _share() => _runAction(
        () => MaterialPhotoActions.share(_currentPath),
        AppLocalizations.of(context)!.photoShared,
      );

  Future<void> _saveToGallery() => _runAction(
        () => MaterialPhotoActions.saveToGallery(_currentPath),
        AppLocalizations.of(context)!.photoSavedToGallery,
      );

  void _remove() {
    widget.onRemove?.call(_currentPath);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        foregroundColor: Colors.white,
        elevation: 0,
        title: widget.paths.length > 1
            ? Text('${_currentIndex + 1} / ${widget.paths.length}')
            : null,
        actions: [
          if (_busy)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
            )
          else ...[
            IconButton(
              tooltip: l10n.saveToGallery,
              onPressed: _saveToGallery,
              icon: const Icon(Icons.download_outlined),
            ),
            IconButton(
              tooltip: l10n.share,
              onPressed: _share,
              icon: const Icon(Icons.share_outlined),
            ),
            if (widget.onRemove != null)
              IconButton(
                tooltip: l10n.removePhoto,
                onPressed: _remove,
                icon: Icon(Icons.delete_outline, color: context.palette.overBudget),
              ),
          ],
        ],
      ),
      body: PhotoViewGallery.builder(
        pageController: _pageController,
        itemCount: widget.paths.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        builder: (context, index) {
          final path = widget.paths[index];
          final ImageProvider<Object> provider =
              MaterialImageStorage.isRemoteUrl(path)
                  ? NetworkImage(path)
                  : FileImage(File(path));
          return PhotoViewGalleryPageOptions(
            imageProvider: provider,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
            heroAttributes: PhotoViewHeroAttributes(tag: path),
          );
        },
        loadingBuilder: (context, event) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}
