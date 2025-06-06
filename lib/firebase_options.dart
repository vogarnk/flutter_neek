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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB3FkgqW6rY5zhLrilnQiZvW07z77GgpxM',
    appId: '1:574190047123:web:5bad1d92cb75f880822266',
    messagingSenderId: '574190047123',
    projectId: 'neek-mobile',
    authDomain: 'neek-mobile.firebaseapp.com',
    storageBucket: 'neek-mobile.firebasestorage.app',
    measurementId: 'G-QLS1J32JPX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDf2ZoHq0mN-H2stSuCUi9UNw67ILucGbY',
    appId: '1:574190047123:android:0618a360e40ac452822266',
    messagingSenderId: '574190047123',
    projectId: 'neek-mobile',
    storageBucket: 'neek-mobile.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBvswWtQJcTftHJQ48y9e2PiPZsmCsNEcM',
    appId: '1:574190047123:ios:9e61c41c1305f0ee822266',
    messagingSenderId: '574190047123',
    projectId: 'neek-mobile',
    storageBucket: 'neek-mobile.firebasestorage.app',
    iosBundleId: 'com.neek.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBvswWtQJcTftHJQ48y9e2PiPZsmCsNEcM',
    appId: '1:574190047123:ios:9e61c41c1305f0ee822266',
    messagingSenderId: '574190047123',
    projectId: 'neek-mobile',
    storageBucket: 'neek-mobile.firebasestorage.app',
    iosBundleId: 'com.neek.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB3FkgqW6rY5zhLrilnQiZvW07z77GgpxM',
    appId: '1:574190047123:web:d7c45b959a9072d3822266',
    messagingSenderId: '574190047123',
    projectId: 'neek-mobile',
    authDomain: 'neek-mobile.firebaseapp.com',
    storageBucket: 'neek-mobile.firebasestorage.app',
    measurementId: 'G-HDTLJ907QX',
  );
}
