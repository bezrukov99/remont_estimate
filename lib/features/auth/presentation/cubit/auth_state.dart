import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  unknown,
  signedOut,
  signedIn,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isBusy = false,
    this.errorMessage,
  });

  final AuthStatus status;
  final User? user;
  final bool isBusy;
  final String? errorMessage;

  bool get isSignedIn => status == AuthStatus.signedIn && user != null;

  String? get displayLabel {
    final u = user;
    if (u == null) {
      return null;
    }
    if (u.displayName != null && u.displayName!.trim().isNotEmpty) {
      return u.displayName;
    }
    return u.email;
  }

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    bool? isBusy,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      isBusy: isBusy ?? this.isBusy,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, user?.uid, isBusy, errorMessage];
}
