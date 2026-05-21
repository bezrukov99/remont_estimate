import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';

/// Resolves which estimate snapshot to keep when local and cloud differ.
abstract final class EstimateSyncLogic {
  /// True when [state] has user-created content beyond the empty bootstrap project.
  static bool hasUserData(EstimateState state) {
    for (final project in state.projects) {
      if (project.rooms.isNotEmpty || project.materials.isNotEmpty) {
        return true;
      }
      if (project.targetBudget != null) {
        return true;
      }
      if (project.name.trim().isNotEmpty &&
          project.name != 'My Renovation' &&
          project.name != 'Мой ремонт') {
        return true;
      }
    }
    return false;
  }

  static DateTime stateModifiedAt(EstimateState state) {
    var latest = state.lastModified ?? DateTime.fromMillisecondsSinceEpoch(0);
    for (final project in state.projects) {
      for (final material in project.materials) {
        final candidate = material.updatedAt ??
            material.createdAt ??
            material.purchasedAt;
        if (candidate != null && candidate.isAfter(latest)) {
          latest = candidate;
        }
      }
    }
    return latest;
  }

  /// Picks local or remote after sign-in / cloud fetch.
  static EstimateState resolveOnLogin({
    required EstimateState local,
    required EstimateState? remote,
  }) {
    if (remote == null) {
      return local;
    }
    if (!hasUserData(local)) {
      return remote;
    }
    if (!hasUserData(remote)) {
      return local;
    }
    final localAt = stateModifiedAt(local);
    final remoteAt = stateModifiedAt(remote);
    return remoteAt.isAfter(localAt) ? remote : local;
  }

  static int materialCount(EstimateState state) {
    return state.projects.fold<int>(
      0,
      (sum, p) => sum + p.materials.length,
    );
  }

  static EstimateState withUploadedPhotoPaths(
    EstimateState state,
    Map<String, String> localToRemote,
  ) {
    if (localToRemote.isEmpty) {
      return state;
    }
    final projects = state.projects.map((project) {
      final materials = project.materials.map((material) {
        final paths = material.photoPaths
            .map((p) => localToRemote[p] ?? p)
            .toList();
        if (_pathsEqual(paths, material.photoPaths)) {
          return material;
        }
        return material.copyWith(
          photoPaths: paths,
          updatedAt: DateTime.now(),
        );
      }).toList();
      return project.copyWith(materials: materials);
    }).toList();
    return state.copyWith(
      projects: projects,
      touchModified: true,
    );
  }

  static bool _pathsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }
}
