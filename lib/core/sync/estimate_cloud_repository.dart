import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:remont_estimate/features/estimate/presentation/cubit/estimate_state.dart';

/// Persists [EstimateState] JSON per user in Firestore.
class EstimateCloudRepository {
  EstimateCloudRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const _estimateDocId = 'main';

  DocumentReference<Map<String, dynamic>> _doc(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('data')
        .doc(_estimateDocId);
  }

  /// Ensures the Firestore client has a fresh auth token attached.
  Future<void> _ensureAuthReady(String userId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.uid != userId) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
        message: 'User is not signed in.',
      );
    }
    await user.getIdToken(true);
  }

  Stream<EstimateState?> watch(String userId) async* {
    await _ensureAuthReady(userId);
    yield* _doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      final data = snapshot.data();
      if (data == null) {
        return null;
      }
      final stateJson = data['state'] as Map<String, dynamic>?;
      if (stateJson == null) {
        return null;
      }
      try {
        return EstimateState.fromJson(stateJson);
      } catch (_) {
        return null;
      }
    });
  }

  Future<EstimateState?> fetch(String userId) async {
    await _ensureAuthReady(userId);
    final snapshot = await _doc(userId).get();
    if (!snapshot.exists) {
      return null;
    }
    final stateJson = snapshot.data()?['state'] as Map<String, dynamic>?;
    if (stateJson == null) {
      return null;
    }
    try {
      return EstimateState.fromJson(stateJson);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(String userId, EstimateState state) async {
    await _ensureAuthReady(userId);
    final modifiedAt = state.lastModified ?? DateTime.now();
    await _doc(userId).set(
      {
        'state': state.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
        'clientModifiedAt': modifiedAt.toIso8601String(),
      },
      SetOptions(merge: true),
    );
  }
}
