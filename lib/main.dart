import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/app/dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';

late FirebaseMessaging messaging;
void registerNotification() async {
  // 1. Initialize the Firebase app
   
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  } else {
    print('User declined or has not accepted permission');
  }
}

String token = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();

    SharedPreferences shared = await SharedPreferences.getInstance();

  token = shared.getString("token") ?? "";

  print(token);
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBCMYhoJKuPUvFrNEHEGDgERb78RT7ugtM",
        authDomain: "food-app-7053e.firebaseapp.com",
        projectId: "food-app-7053e",
        storageBucket: "food-app-7053e.appspot.com",
        messagingSenderId: "827578873712",
        appId: "1:827578873712:android:8606a13e50dc9b950301b5"),
  );
  messaging = FirebaseMessaging.instance;

  registerNotification();

  

  runApp(MyApp());
}
