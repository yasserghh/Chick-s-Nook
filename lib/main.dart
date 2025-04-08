import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodapp/app/dependency_injection.dart';
import 'package:foodapp/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'app/app.dart';

/*  //late FirebaseMessaging messaging;
void registerNotification() async {
  // 1. Initialize the Firebase app
   FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  ); 

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    print('token========>${await messaging.getToken()}');
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
 */
class NotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // Initialize Firebase Messaging
  static Future<void> initialize() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    // Initialization for Android and iOS
    var androidIni = AndroidInitializationSettings("ic_launcher");
    var iosIni = DarwinInitializationSettings();
    var ini = InitializationSettings(android: androidIni, iOS: iosIni);

    flutterLocalNotificationsPlugin.initialize(ini);

    flutterLocalNotificationsPlugin.initialize(ini);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Create an Android notification channel for Android 8.0 and above
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // name
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      // Create the channel on Android
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // On message received when the app is in the foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          print("===============>I recieve");
          // Show the notification
          flutterLocalNotificationsPlugin.show(
            0, // notification ID
            message.notification!.title,
            message.notification!.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel', // Channel ID
                'High Importance Notifications', // Channel Name
                channelDescription:
                    'This channel is used for important notifications.',
                importance: Importance.high,
              ),
            ),
          );
        }
      });

      // On message received when the app is in the background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.notification != null) {
          print("===============>I recieve");
          flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title,
            message.notification!.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                channelDescription:
                    'This channel is used for important notifications.',
                importance: Importance.high,
              ),
            ),
          );
        }
      });

      // Subscribe to a topic, e.g., 'notify'
      firebaseMessaging.subscribeToTopic('notify');
    }
  }

  // Show notification in the foreground
}

String token = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initialize();
  await initApp();

  SharedPreferences shared = await SharedPreferences.getInstance();

  token = shared.getString("token") ?? "";

  print(token);
  var fcmToken = await FirebaseMessaging.instance.getToken();
  print('===========>$fcmToken');
/*    await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBCMYhoJKuPUvFrNEHEGDgERb78RT7ugtM",
        authDomain: "food-app-7053e.firebaseapp.com",
        projectId: "food-app-7053e",
        storageBucket: "food-app-7053e.appspot.com",
        messagingSenderId: "827578873712",
        appId: "1:827578873712:android:8606a13e50dc9b950301b5"),
  );
 FirebaseMessaging messaging = FirebaseMessaging.instance;  */

  //registerNotification();

  runApp(MyApp());
}
