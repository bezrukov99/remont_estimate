import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remont_estimate/core/firebase/firebase_bootstrap.dart';
import 'package:remont_estimate/core/sync/estimate_cloud_repository.dart';
import 'package:remont_estimate/core/sync/estimate_sync_logic.dart';
import 'package:remont_estimate/core/sync/photo_cloud_repository.dart';
import 'package:remont_estimate/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:remont_estimate/features/auth/presentation/cubit/auth_state.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_cubit.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';

enum CloudSyncStatus {
  idle,
  syncing,
  synced,
  error,
  unavailable,
}

class EstimateSyncState {
  const EstimateSyncState({
    this.status = CloudSyncStatus.idle,
    this.lastSyncedAt,
    this.errorMessage,
  });

  final CloudSyncStatus status;
  final DateTime? lastSyncedAt;
  final String? errorMessage;

  EstimateSyncState copyWith({
    CloudSyncStatus? status,
    DateTime? lastSyncedAt,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EstimateSyncState(
      status: status ?? this.status,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Syncs [EstimateCubit] with Firestore when the user is signed in.
class EstimateSyncCubit extends Cubit<EstimateSyncState> {
  EstimateSyncCubit({
    required AuthCubit authCubit,
    required EstimateCubit estimateCubit,
    EstimateCloudRepository? cloudRepository,
    PhotoCloudRepository? photoRepository,
  })  : _authCubit = authCubit,
        _estimateCubit = estimateCubit,
        _cloud = cloudRepository ?? EstimateCloudRepository(),
        _photos = photoRepository ?? PhotoCloudRepository(),
        super(const EstimateSyncState()) {
    if (!FirebaseBootstrap.isAvailable) {
      emit(
        const EstimateSyncState(status: CloudSyncStatus.unavailable),
      );
      return;
    }
    _authSub = _authCubit.stream.listen(_onAuthChanged);
    _estimateSub = _estimateCubit.stream.listen(_onEstimateChanged);
    _onAuthChanged(_authCubit.state);
  }

  final AuthCubit _authCubit;
  final EstimateCubit _estimateCubit;
  final EstimateCloudRepository _cloud;
  final PhotoCloudRepository _photos;

  StreamSubscription<AuthState>? _authSub;
  StreamSubscription<EstimateState>? _estimateSub;
  StreamSubscription<EstimateState?>? _cloudSub;
  Timer? _uploadDebounce;
  String? _userId;
  bool _applyingRemote = false;
  bool _initialMergeDone = false;
  EstimateState? _lastUploadedState;

  void _onAuthChanged(AuthState auth) {
    if (!auth.isSignedIn || auth.user == null) {
      _stopCloudListener();
      _userId = null;
      _initialMergeDone = false;
      emit(
        state.copyWith(
          status: CloudSyncStatus.unavailable,
          clearError: true,
        ),
      );
      return;
    }
    final uid = auth.user!.uid;
    if (_userId == uid) {
      return;
    }
    _userId = uid;
    _initialMergeDone = false;
    _startCloudListener(uid);
    unawaited(_performInitialMerge(uid));
  }

  void _startCloudListener(String userId) {
    _cloudSub?.cancel();
    _cloudSub = _cloud.watch(userId).listen((remote) {
      if (remote == null || !_initialMergeDone || _applyingRemote) {
        return;
      }
      final local = _estimateCubit.state;
      if (_lastUploadedState != null &&
          _statesEqual(_lastUploadedState!, remote)) {
        return;
      }
      final resolved = EstimateSyncLogic.resolveOnLogin(
        local: local,
        remote: remote,
      );
      if (_statesEqual(local, resolved)) {
        return;
      }
      _applyingRemote = true;
      _estimateCubit.replaceFromCloud(resolved);
      _applyingRemote = false;
      _lastUploadedState = resolved;
    }, onError: (Object e, _) {
      emit(
        state.copyWith(
          status: CloudSyncStatus.error,
          errorMessage: e.toString(),
        ),
      );
    });
  }

  void _stopCloudListener() {
    _cloudSub?.cancel();
    _cloudSub = null;
    _uploadDebounce?.cancel();
  }

  Future<void> _performInitialMerge(String userId) async {
    emit(state.copyWith(status: CloudSyncStatus.syncing, clearError: true));
    try {
      final remote = await _cloud.fetch(userId);
      final local = _estimateCubit.state;
      final resolved = EstimateSyncLogic.resolveOnLogin(
        local: local,
        remote: remote,
      );
      if (!_statesEqual(local, resolved)) {
        _applyingRemote = true;
        _estimateCubit.replaceFromCloud(resolved);
        _applyingRemote = false;
      }
      _initialMergeDone = true;
      await _pushToCloud(userId, _estimateCubit.state);
      emit(
        state.copyWith(
          status: CloudSyncStatus.synced,
          lastSyncedAt: DateTime.now(),
          clearError: true,
        ),
      );
    } catch (e) {
      _initialMergeDone = true;
      emit(
        state.copyWith(
          status: CloudSyncStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onEstimateChanged(EstimateState estimate) {
    if (_applyingRemote || _userId == null || !_initialMergeDone) {
      return;
    }
    _uploadDebounce?.cancel();
    _uploadDebounce = Timer(const Duration(seconds: 2), () {
      final uid = _userId;
      if (uid == null) {
        return;
      }
      unawaited(_pushToCloud(uid, _estimateCubit.state));
    });
  }

  Future<void> _pushToCloud(String userId, EstimateState estimate) async {
    emit(state.copyWith(status: CloudSyncStatus.syncing, clearError: true));
    try {
      final photoMapping = await _photos.uploadPendingPhotos(
        userId: userId,
        state: estimate,
      );
      var toSave = estimate;
      if (photoMapping.isNotEmpty) {
        toSave = EstimateSyncLogic.withUploadedPhotoPaths(
          estimate,
          photoMapping,
        );
        _applyingRemote = true;
        _estimateCubit.replaceFromCloud(toSave);
        _applyingRemote = false;
      }
      await _cloud.save(userId, toSave);
      _lastUploadedState = toSave;
      emit(
        state.copyWith(
          status: CloudSyncStatus.synced,
          lastSyncedAt: DateTime.now(),
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CloudSyncStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> pullNow() async {
    final uid = _userId;
    if (uid == null) {
      return;
    }
    emit(state.copyWith(status: CloudSyncStatus.syncing, clearError: true));
    try {
      final remote = await _cloud.fetch(uid);
      if (remote != null) {
        _applyingRemote = true;
        _estimateCubit.replaceFromCloud(remote);
        _applyingRemote = false;
        _lastUploadedState = remote;
      }
      emit(
        state.copyWith(
          status: CloudSyncStatus.synced,
          lastSyncedAt: DateTime.now(),
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CloudSyncStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  static bool _statesEqual(EstimateState a, EstimateState b) {
    return a.toJson().toString() == b.toJson().toString();
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    _estimateSub?.cancel();
    _cloudSub?.cancel();
    _uploadDebounce?.cancel();
    return super.close();
  }
}
