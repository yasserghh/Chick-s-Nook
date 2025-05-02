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

  static Future<void> initialize() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var androidIni = AndroidInitializationSettings("ic_launcher");
    var iosIni = DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
    var ini = InitializationSettings(android: androidIni, iOS: iosIni);

    flutterLocalNotificationsPlugin.initialize(ini);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // ✅ Wait for APNs token
      String? apnsToken;
      int retries = 0;
      while (apnsToken == null && retries < 5) {
        try {
          apnsToken = await firebaseMessaging.getAPNSToken();
          if (apnsToken == null) {
            await Future.delayed(Duration(seconds: 1));
          }
        } catch (e) {
          print("❌ Error getting APNs token: $e");
          break;
        }
        retries++;
      }

      print("📱 APNs Token: $apnsToken");

      try {
        String? fcmToken = await firebaseMessaging.getToken();
        print("📦 FCM Token: $fcmToken");
        await firebaseMessaging.subscribeToTopic('notify');
      } catch (e) {
        print("❌ Error getting FCM token or subscribing: $e");
      }

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );
  await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
    ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);


      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
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
              iOS: DarwinNotificationDetails(
  presentAlert: true,
  presentBadge: true,
  presentSound: true,
),

            ),
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.notification != null) {
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
              iOS: DarwinNotificationDetails(
  presentAlert: true,
  presentBadge: true,
  presentSound: true,
),
            ),
          );
        }
      });
    }
  }
}


String token = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    await NotificationService.initialize();
  } catch (e) {
    print("❌ NotificationService failed to initialize: $e");
  }

  await initApp();

  SharedPreferences shared = await SharedPreferences.getInstance();
  token = shared.getString("token") ?? "";
  print("🔐 Local token: $token");

  runApp(MyApp());
}

