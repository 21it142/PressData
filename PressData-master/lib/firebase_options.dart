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
    apiKey: 'AIzaSyCFDASdNLxNMtn6SJ5mesokcW3ICrkag10',
    appId: '1:335915757727:web:d51ac441e53b0b97c2b2aa',
    messagingSenderId: '335915757727',
    projectId: 'wavevisions-projects',
    authDomain: 'wavevisions-projects.firebaseapp.com',
    storageBucket: 'wavevisions-projects.appspot.com',
    measurementId: 'G-BM4GJ04VN2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCIhsUoAS5-csykwWMBhYkbVnF8G-lkoUM',
    appId: '1:335915757727:android:e2270e2608ce123cc2b2aa',
    messagingSenderId: '335915757727',
    projectId: 'wavevisions-projects',
    storageBucket: 'wavevisions-projects.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBrCRM3fDzknufKEwSYV-WRpmm2qOWtcnY',
    appId: '1:335915757727:ios:347f1fa0b4b86a8fc2b2aa',
    messagingSenderId: '335915757727',
    projectId: 'wavevisions-projects',
    storageBucket: 'wavevisions-projects.appspot.com',
    iosBundleId: 'com.example.pressdata',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBrCRM3fDzknufKEwSYV-WRpmm2qOWtcnY',
    appId: '1:335915757727:ios:347f1fa0b4b86a8fc2b2aa',
    messagingSenderId: '335915757727',
    projectId: 'wavevisions-projects',
    storageBucket: 'wavevisions-projects.appspot.com',
    iosBundleId: 'com.example.pressdata',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCFDASdNLxNMtn6SJ5mesokcW3ICrkag10',
    appId: '1:335915757727:web:b284e2bd50a96685c2b2aa',
    messagingSenderId: '335915757727',
    projectId: 'wavevisions-projects',
    authDomain: 'wavevisions-projects.firebaseapp.com',
    storageBucket: 'wavevisions-projects.appspot.com',
    measurementId: 'G-SP40TE7TTJ',
  );
}
