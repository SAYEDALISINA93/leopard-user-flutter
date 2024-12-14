// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
    apiKey: 'AIzaSyCSNEWOwQsQ8XgegBlFk4M0DJ_8opz5vik',
    appId: '1:723926195144:android:9085b1de7ff80c9874befd',
    messagingSenderId: '723926195144',
    projectId: 'leopard-user-105ff',
    storageBucket: 'leopard-user-105ff.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDoBJGyUedZA7ZihWNV0ACau6K5T3DliAI',
    appId: '1:723926195144:ios:768f56ec0da8435d74befd',
    messagingSenderId: '723926195144',
    projectId: 'leopard-user-105ff',
    storageBucket: 'leopard-user-105ff.firebasestorage.app',
    androidClientId: '723926195144-pki4os7fblvup63ovvq772bqpvukdnno.apps.googleusercontent.com',
    iosClientId: '723926195144-7iufs2d5l7acaba3ktspiion0d8o5q7j.apps.googleusercontent.com',
    iosBundleId: 'com.leopard.rider',
  );

}