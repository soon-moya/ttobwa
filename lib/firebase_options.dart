import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDq1_5wVz8h5_5Kw_5wVz8h5_5Kw_5wVz8',
    authDomain: 'i-tium-schedule.firebaseapp.com',
    projectId: 'i-tium-schedule',
    storageBucket: 'i-tium-schedule.firebasestorage.app',
    messagingSenderId: '946381463407',
    appId: '1:946381463407:web:9c760b3f30d7d60145129a',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDq1_5wVz8h5_5Kw_5wVz8h5_5Kw_5wVz8',
    appId: '1:946381463407:android:9c760b3f30d7d60145129a',
    messagingSenderId: '946381463407',
    projectId: 'i-tium-schedule',
    storageBucket: 'i-tium-schedule.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDq1_5wVz8h5_5Kw_5wVz8h5_5Kw_5wVz8',
    appId: '1:946381463407:ios:9c760b3f30d7d60145129a',
    messagingSenderId: '946381463407',
    projectId: 'i-tium-schedule',
    storageBucket: 'i-tium-schedule.firebasestorage.app',
  );

  static FirebaseOptions get currentPlatform {
    return android;
  }
}
