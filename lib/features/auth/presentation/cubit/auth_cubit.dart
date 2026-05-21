import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remont_estimate/features/auth/data/auth_repository.dart';
import 'package:remont_estimate/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState()) {
    _subscription = _repository.authStateChanges().listen(_onUserChanged);
  }

  final AuthRepository _repository;
  StreamSubscription<User?>? _subscription;

  void _onUserChanged(User? user) {
    if (user == null) {
      emit(
        state.copyWith(
          status: AuthStatus.signedOut,
          clearUser: true,
          isBusy: false,
          clearError: true,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: AuthStatus.signedIn,
        user: user,
        isBusy: false,
        clearError: true,
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(isBusy: true, clearError: true));
    try {
      await _repository.signInWithGoogle();
    } on AuthCancelledException {
      emit(state.copyWith(isBusy: false));
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          isBusy: false,
          errorMessage: e.message ?? e.code,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isBusy: false, errorMessage: e.toString()));
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isBusy: true, clearError: true));
    try {
      await _repository.signInWithEmail(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          isBusy: false,
          errorMessage: e.message ?? e.code,
        ),
      );
    }
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isBusy: true, clearError: true));
    try {
      await _repository.registerWithEmail(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          isBusy: false,
          errorMessage: e.message ?? e.code,
        ),
      );
    }
  }

  /// Returns `true` if Firebase accepted the reset request.
  Future<bool> sendPasswordReset(String email) async {
    emit(state.copyWith(isBusy: true, clearError: true));
    try {
      await _repository.sendPasswordReset(email);
      emit(state.copyWith(isBusy: false, clearError: true));
      return true;
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(isBusy: false, errorMessage: e.code));
      return false;
    } catch (e) {
      emit(state.copyWith(isBusy: false, errorMessage: e.toString()));
      return false;
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(isBusy: true, clearError: true));
    await _repository.signOut();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
