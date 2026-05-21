import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:remont_estimate/core/services/material_image_storage.dart';
import 'package:remont_estimate/features/estimate/domain/models/material_item_model.dart';
import 'package:remont_estimate/features/estimate/domain/models/project_model.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';
import 'package:uuid/uuid.dart';

/// Uploads local material photos to Firebase Storage.
class PhotoCloudRepository {
  PhotoCloudRepository({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance,
        _uuid = const Uuid();

  final FirebaseStorage _storage;
  final Uuid _uuid;

  Future<Map<String, String>> uploadPendingPhotos({
    required String userId,
    required EstimateState state,
  }) async {
    final mapping = <String, String>{};
    for (final project in state.projects) {
      for (final material in project.materials) {
        for (final path in material.photoPaths) {
          if (MaterialImageStorage.isRemoteUrl(path)) {
            continue;
          }
          if (!File(path).existsSync()) {
            continue;
          }
          final url = await _uploadLocalFile(
            userId: userId,
            materialId: material.id,
            localPath: path,
          );
          mapping[path] = url;
        }
      }
    }
    return mapping;
  }

  Future<String> _uploadLocalFile({
    required String userId,
    required String materialId,
    required String localPath,
  }) async {
    final extension = MaterialImageStorage.extensionFromPath(localPath);
    final objectName = '${_uuid.v4()}$extension';
    final ref = _storage.ref('users/$userId/photos/$materialId/$objectName');
    await ref.putFile(File(localPath));
    return ref.getDownloadURL();
  }

  Future<void> deletePhotosForMaterial({
    required String userId,
    required String materialId,
  }) async {
    try {
      final ref = _storage.ref('users/$userId/photos/$materialId');
      final list = await ref.listAll();
      for (final item in list.items) {
        await item.delete();
      }
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return;
      }
      rethrow;
    }
  }

  static Iterable<MaterialItemModel> allMaterials(EstimateState state) sync* {
    for (final project in state.projects) {
      yield* project.materials;
    }
  }

  static Iterable<ProjectModel> allProjects(EstimateState state) sync* {
    yield* state.projects;
  }
}
