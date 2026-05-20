import 'dart:io';

import 'package:flutter/material.dart';
import 'package:remont_estimate/core/constants/material_photo_limits.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';
import 'package:remont_estimate/core/widgets/app_bottom_sheet.dart';
import 'package:remont_estimate/features/estimate/presentation/widgets/material_photo_viewer.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

class MaterialPhotoPicker extends StatelessWidget {
  const MaterialPhotoPicker({
    super.key,
    required this.photoPaths,
    required this.onPickCamera,
    required this.onPickGallery,
    required this.onRemovePath,
  });

  final List<String> photoPaths;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;
  final ValueChanged<String> onRemovePath;

  bool get _canAddMore =>
      photoPaths.length < MaterialPhotoLimits.maxPerMaterial;

  List<String> get _existingPaths => photoPaths
      .where((p) => p.isNotEmpty && File(p).existsSync())
      .toList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final max = MaterialPhotoLimits.maxPerMaterial;
    final items = _existingPaths;
    final itemCount = items.length + (_canAddMore ? 1 : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.materialPhotos,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Text(
              l10n.photosCount(items.length, max),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    color: context.palette.textTertiary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index < items.length) {
              final path = items[index];
              return _PhotoTile(
                path: path,
                onTap: () => MaterialPhotoViewer.show(
                  context,
                  paths: items,
                  initialIndex: index,
                  onRemove: onRemovePath,
                ),
              );
            }
            return _AddPhotoTile(
              onTap: () => _showSourceSheet(context),
            );
          },
        ),
        if (items.isEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.materialPhotosHint(max),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  color: context.palette.textSecondary,
                ),
          ),
        ],
      ],
    );
  }

  void _showSourceSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!_canAddMore) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.maxPhotosReached(MaterialPhotoLimits.maxPerMaterial)),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showRemontSheet<void>(
      context,
      child: AppSheetBody(
        title: l10n.tapToAddPhoto,
        children: [
          AppSheetListTile(
            icon: Icons.photo_camera_outlined,
            title: l10n.takePhoto,
            onTap: () {
              Navigator.pop(context);
              onPickCamera();
            },
          ),
          AppSheetListTile(
            icon: Icons.photo_library_outlined,
            title: l10n.chooseFromGallery,
            onTap: () {
              Navigator.pop(context);
              onPickGallery();
            },
          ),
        ],
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.path, required this.onTap});

  final String path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.palette.surfaceMuted,
      borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.palette.surfaceMuted,
      borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
        child: Center(
          child: Icon(
            Icons.add_a_photo_outlined,
            size: 28,
            color: context.palette.accent,
          ),
        ),
      ),
    );
  }
}
