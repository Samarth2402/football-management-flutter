import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: "AIzaSyAYgC0vcA51O97AM6S-fk6owudPddV71WM",
        authDomain: "football-management-3eede.firebaseapp.com",
        projectId: "football-management-3eede",
        storageBucket: "football-management-3eede.firebasestorage.app",
        messagingSenderId: "952482495630",
        appId: "1:952482495630:web:357d5f9ed74ccb88341ddf"
      );
    }
    return FirebaseOptions(
      apiKey: "AIzaSyAYgC0vcA51O97AM6S-fk6owudPddV71WM",
      authDomain: "football-management-3eede.firebaseapp.com",
      projectId: "football-management-3eede",
      storageBucket: "football-management-3eede.firebasestorage.app",
      messagingSenderId: "952482495630",
      appId: "1:952482495630:web:357d5f9ed74ccb88341ddf"
    );
  }
}
