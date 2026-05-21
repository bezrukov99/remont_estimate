// Run `dart pub global activate flutterfire_cli && flutterfire configure`
// to replace placeholder values with your Firebase project config.
//
// ignore_for_file: lines_longer_than_80_chars

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Placeholder API key — replace via [flutterfire configure].
const String _kPlaceholderApiKey = 'CONFIGURE_ME';

class DefaultFirebaseOptions {
  static bool get isConfigured => currentPlatform.apiKey != _kPlaceholderApiKey;

  /// Web client ID (OAuth 2.0) — Firebase Console → Authentication → Google.
  /// Нужен для Google Sign-In + Firebase Auth на Android.
  static const String googleWebClientId =
      '666709576823-lhrs4i3m3u0rj57ec0sc2nudh6piuvtu.apps.googleusercontent.com';

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: _kPlaceholderApiKey,
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'remont-estimate',
    authDomain: 'remont-estimate.firebaseapp.com',
    storageBucket: 'remont-estimate.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA0LobIPzFV4UKvqFtY0kLFWkv-IT8K7lw',
    appId: '1:666709576823:android:d607f98b84c06f24f28a72',
    messagingSenderId: '666709576823',
    projectId: 'smetochka-22b83',
    storageBucket: 'smetochka-22b83.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCuwjTkNuAJaEmv7wzRcEWiMKfwmNLEpQU',
    appId: '1:666709576823:ios:b243742c34f9f3d6f28a72',
    messagingSenderId: '666709576823',
    projectId: 'smetochka-22b83',
    storageBucket: 'smetochka-22b83.firebasestorage.app',
    iosClientId: '666709576823-m829p74v33cs77q3i12sk1n5qk1sfc30.apps.googleusercontent.com',
    iosBundleId: 'com.remontestimate.remontEstimate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: _kPlaceholderApiKey,
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'remont-estimate',
    storageBucket: 'remont-estimate.appspot.com',
    iosBundleId: 'com.remontestimate.remontEstimate',
  );
}