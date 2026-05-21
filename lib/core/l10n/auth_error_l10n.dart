import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:remont_estimate/l10n/app_localizations.dart';

String authErrorMessage(BuildContext context, FirebaseAuthException e) {
  final l10n = AppLocalizations.of(context)!;
  return switch (e.code) {
    'invalid-email' => l10n.authInvalidEmail,
    'user-not-found' => l10n.authUserNotFound,
    'wrong-password' => l10n.authWrongPassword,
    'email-already-in-use' => l10n.authEmailAlreadyInUse,
    'weak-password' => l10n.authWeakPassword,
    'too-many-requests' => l10n.authTooManyRequests,
    'network-request-failed' => l10n.authNetworkError,
    _ => e.message ?? e.code,
  };
}
