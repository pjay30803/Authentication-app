import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4_opkd6XjmnmTWmybFn6n-OGCEArwZz0',
    appId: '1:193642477607:android:d313ff1c9a4f1fe10b3602',
    messagingSenderId: '193642477607',
    projectId: 'authentication-app-a8c49',
    storageBucket: 'authentication-app-a8c49.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCpGZPpkQUILX8ygNdvsmJMBYyAPm2OCbM',
    appId: '1:193642477607:ios:e17ee3cbb28fa8660b3602',
    messagingSenderId: '193642477607',
    projectId: 'authentication-app-a8c49',
    storageBucket: 'authentication-app-a8c49.firebasestorage.app',
    iosBundleId: 'com.example.authenticationApp',
  );
}

