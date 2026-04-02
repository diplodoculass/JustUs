// File generated manually from Firebase Console SDK configs.
// flutterfire configure alternative for manual setup.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAkLOIjT_mp8jj8ie4a6js6jUKHx2sHlWY',
    appId: '1:205236724512:web:858c03b1a3f9265afa2d45',
    messagingSenderId: '205236724512',
    projectId: 'justus-couples-app',
    authDomain: 'justus-couples-app.firebaseapp.com',
    storageBucket: 'justus-couples-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCHJuTv7J2LyzGeH2l8WBQeCPBbrwOCnc8',
    appId: '1:205236724512:android:75bd900134237973fa2d45',
    messagingSenderId: '205236724512',
    projectId: 'justus-couples-app',
    storageBucket: 'justus-couples-app.firebasestorage.app',
  );

  // Placeholder — create iOS app in Firebase Console and fill in
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'TODO_IOS_API_KEY',
    appId: 'TODO_IOS_APP_ID',
    messagingSenderId: '205236724512',
    projectId: 'justus-couples-app',
    storageBucket: 'justus-couples-app.firebasestorage.app',
    iosBundleId: 'com.justus.justUs',
  );
}
