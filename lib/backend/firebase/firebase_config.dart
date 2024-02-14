import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAOfJWVDSs5apPVq3VVTa6VcQHHk_mpGpQ",
            authDomain: "mtb1-ypveq5.firebaseapp.com",
            projectId: "mtb1-ypveq5",
            storageBucket: "mtb1-ypveq5.appspot.com",
            messagingSenderId: "1053353645877",
            appId: "1:1053353645877:web:475310d05cb12b0c1c5e7c"));
  } else {
    await Firebase.initializeApp();
  }
}
