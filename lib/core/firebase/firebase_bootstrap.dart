import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:remont_estimate/firebase_options.dart';

/// Initializes Firebase when the project is configured via FlutterFire.
abstract final class FirebaseBootstrap {
  static bool _initialized = false;

  static bool get isAvailable => DefaultFirebaseOptions.isConfigured;

  static bool get isInitialized => _initialized;

  static Future<bool> initialize() async {
    if (!isAvailable) {
      return false;
    }
    if (_initialized) {
      return true;
    }
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await GoogleSignIn.instance.initialize(
      serverClientId: DefaultFirebaseOptions.googleWebClientId,
    );
    _initialized = true;
    return true;
  }
}
