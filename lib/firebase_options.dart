// Manuell erstellt (statt via `flutterfire configure`).
// Nur Web ist aktuell konfiguriert; iOS/Android/Windows folgen, wenn
// die jeweiligen Apps in der Firebase Console registriert sind.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'Firebase ist fuer diese Plattform noch nicht konfiguriert. '
          'Registriere die App in der Firebase Console und ergaenze hier.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAA-HeVhmJ9A9aWrqEFBtBJjvwZ_zGc5vQ',
    authDomain: 'dogmatch-ai.firebaseapp.com',
    projectId: 'dogmatch-ai',
    storageBucket: 'dogmatch-ai.firebasestorage.app',
    messagingSenderId: '692520666511',
    appId: '1:692520666511:web:6fbaa1068944f6a20277fa',
  );
}
