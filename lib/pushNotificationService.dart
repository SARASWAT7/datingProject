// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:demoproject/ui/dashboard/notification/notification.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// var globalCheckNavitaion = 0;
//
// class PushNotificationService2 {
//   Future<void> setupInteractedMessage() async {
//     await Firebase.initializeApp();
//     await FirebaseMessaging.instance.requestPermission();
//     // await FirebaseMessaging.instance.requestPermission();
//     FirebaseMessaging.onMessageOpenedApp
//         .listen((RemoteMessage? remoteMessage) async {
//       if (remoteMessage == null) {
//         log("STATUS = OnMessageOpened Notification Not Received");
//       } else {
//         log("STATUS = OnMessageOpened Notification Received");
//         log("NOT = ${jsonEncode(remoteMessage.data)}");
//
//         try {
//           // Redirect directly to EnergyScreen when a notification is clicked
//           navigatorKey.currentState!.pushAndRemoveUntil(
//             MaterialPageRoute(
//               builder: (context) => NotificationScreen(),
//             ),
//             (route) => false,
//           );
//         } catch (e) {
//           log("Navigation error: $e");
//         }
//       }
//     });
//
//     await _enableIOSNotifications();
//     await _registerNotificationListeners();
//   }
//
//   _enableIOSNotifications() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//             alert: true, badge: true, sound: true);
//   }
//
//   androidNotificationChannel() => const AndroidNotificationChannel(
//       'high_importance_channel', 'High Importance Notifications',
//       importance: Importance.high);
//
//   _registerNotificationListeners() async {
//     AndroidNotificationChannel channel = androidNotificationChannel();
//
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     flutterLocalNotificationsPlugin
//         .getNotificationAppLaunchDetails()
//         .then((notificationAppLaunchDetail) {
//       // log("@@ = ${notificationAppLaunchDetail?.payload}" ?? '');
//     });
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     var androidSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     var iOSSettings = const DarwinInitializationSettings(
//         requestSoundPermission: true,
//         requestAlertPermission: true,
//         requestBadgePermission: true);
//
//     var initSettings =
//         InitializationSettings(android: androidSettings, iOS: iOSSettings);
//
//     flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//
//     flutterLocalNotificationsPlugin.initialize(initSettings,
//         onDidReceiveNotificationResponse: (message) async {
//       log("onDidReceiveBackgroundNotificationResponse = $message");
//
//       if (message.payload != null) {
//         log("STATUS = onDidReceiveBackgroundNotificationResponse Received");
//         // CustomNavigator.pushReplacement(
//         //     context: navigatorKey.currentState!.context,
//         //     screen: const NotificationScreen(from: 'notification')
//         // );
//
//         navigatorKey.currentState!.push(
//             MaterialPageRoute(builder: (context) => NotificationScreen()));
//       } else {
//         log("STATUS = onDidReceiveBackgroundNotificationResponse Received");
//       }
//     });
//
//     FirebaseMessaging.onMessage.listen((remoteMessage) {
//       RemoteNotification? remoteNotification = remoteMessage.notification;
//       AndroidNotification? androidNotification =
//           remoteMessage.notification?.android;
//       AppleNotification? appleNotification = remoteMessage.notification?.apple;
//
//       log("STATUS = ${remoteMessage.notification?.title}");
//       log("Notification Data = ${remoteMessage.data}");
//
//       if (remoteNotification != null && androidNotification != null) {
//         // Log the received notification data
//         log("Received notification details:");
//         log("Remote Notification: ${remoteNotification.toString()}");
//         log("Android Notification: ${androidNotification.toString()}");
//
//         // Log each property of the remoteNotification
//         log("Remote Notification - Title: ${remoteNotification.title}");
//         log("Remote Notification - Body: ${remoteNotification.body}");
//         log("Remote Notification - Hash Code: ${remoteNotification.hashCode}");
//
//         log("Android Notification - Small Icon: ${androidNotification.smallIcon}");
//
//         log("Notification Channel - ID: ${channel.id}");
//         log("Notification Channel - Name: ${channel.name}");
//
//         flutterLocalNotificationsPlugin.show(
//             remoteNotification.hashCode,
//             remoteNotification.title,
//             remoteNotification.body,
//             NotificationDetails(
//                 android: AndroidNotificationDetails(channel.id, channel.name,
//                     icon: androidNotification.smallIcon,
//                     playSound: true,
//                     importance: Importance.high),
//                 iOS: const DarwinNotificationDetails(
//                     presentAlert: true,
//                     presentBadge: true,
//                     presentSound: true)));
//       }
//     });
//   }
// }
//
// import 'dart:convert';
// import 'dart:developer';
// import 'package:demoproject/ui/dashboard/notification/notification.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
// class PushNotificationService2 {
//   Future<void> setupInteractedMessage() async {
//     // Firebase is already initialized in main.dart, so no need to call it here again.
//     await FirebaseMessaging.instance.requestPermission();
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) async {
//       if (remoteMessage == null) {
//         log("STATUS = OnMessageOpened Notification Not Received");
//       } else {
//         log("STATUS = OnMessageOpened Notification Received");
//         log("NOT = ${jsonEncode(remoteMessage.data)}");
//
//         try {
//           // Redirect to the NotificationScreen when a notification is clicked
//           navigatorKey.currentState?.pushAndRemoveUntil(
//             MaterialPageRoute(
//               builder: (context) => NotificationScreen(),
//             ),
//                 (route) => false,
//           );
//         } catch (e) {
//           log("Navigation error: $e");
//         }
//       }
//     });
//
//     await _enableIOSNotifications();
//     await _registerNotificationListeners();
//   }
//
//   // Handle iOS notifications
//   _enableIOSNotifications() async {
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   // Define notification channel for Android
//   androidNotificationChannel() => const AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     importance: Importance.high,
//   );
//
//   // Register notification listeners
//   _registerNotificationListeners() async {
//     AndroidNotificationChannel channel = androidNotificationChannel();
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
//     // Initialize notification channel for Android
//     await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOSSettings = const DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//     );
//
//     var initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
//
//     // Initialize local notifications
//     await flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (message) async {
//         log("onDidReceiveBackgroundNotificationResponse = $message");
//
//         if (message.payload != null) {
//           log("STATUS = onDidReceiveBackgroundNotificationResponse Received");
//           navigatorKey.currentState?.push(
//             MaterialPageRoute(builder: (context) => NotificationScreen()),
//           );
//         } else {
//           log("No payload received in the background notification.");
//         }
//       },
//     );
//
//     // Listen to foreground messages
//     FirebaseMessaging.onMessage.listen((remoteMessage) {
//       RemoteNotification? remoteNotification = remoteMessage.notification;
//       AndroidNotification? androidNotification = remoteMessage.notification?.android;
//       AppleNotification? appleNotification = remoteMessage.notification?.apple;
//
//       log("STATUS = ${remoteMessage.notification?.title}");
//       log("Notification Data = ${remoteMessage.data}");
//
//       // Check if the notification is valid
//       if (remoteNotification != null && androidNotification != null) {
//         // Log the received notification data
//         log("Received notification details:");
//         log("Remote Notification: ${remoteNotification.toString()}");
//         log("Android Notification: ${androidNotification.toString()}");
//
//         // Show the local notification
//         flutterLocalNotificationsPlugin.show(
//           remoteNotification.hashCode,
//           remoteNotification.title,
//           remoteNotification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               icon: androidNotification.smallIcon,
//               playSound: true,
//               importance: Importance.high,
//             ),
//             iOS: const DarwinNotificationDetails(
//               presentAlert: true,
//               presentBadge: true,
//               presentSound: true,
//             ),
//           ),
//         );
//       }
//     });
//   }
// }
import 'dart:convert';
import 'dart:developer';
import 'package:demoproject/ui/dashboard/notification/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class PushNotificationService2 {
  Future<void> setupInteractedMessage() async {
    try {
      // Firebase is already initialized in main.dart, so no need to call it here again.
      await FirebaseMessaging.instance.requestPermission();

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) async {
        if (remoteMessage == null) {
          log("STATUS = OnMessageOpened Notification Not Received");
        } else {
          log("STATUS = OnMessageOpened Notification Received");
          log("NOT = ${jsonEncode(remoteMessage.data)}");

          try {
            // Redirect to the NotificationScreen when a notification is clicked
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => NotificationScreen(),
              ),
                  (route) => false,
            );
          } catch (e) {
            log("Navigation error: $e");
          }
        }
      });

      await _enableIOSNotifications();
      await _registerNotificationListeners();
    } catch (e) {
      log("Error setting up notifications: $e");
    }
  }

  // Handle iOS notifications
  _enableIOSNotifications() async {
    try {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      log("Error enabling iOS notifications: $e");
    }
  }

  // Define notification channel for Android
  androidNotificationChannel() => const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
  );

  // Register notification listeners
  _registerNotificationListeners() async {
    try {
      AndroidNotificationChannel channel = androidNotificationChannel();
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

      // Initialize notification channel for Android
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
      var iOSSettings = const DarwinInitializationSettings(
        requestSoundPermission: true,
        requestAlertPermission: true,
        requestBadgePermission: true,
      );

      var initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);

      // Initialize local notifications
      await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (message) async {
          log("onDidReceiveBackgroundNotificationResponse = $message");

          if (message.payload != null) {
            log("STATUS = onDidReceiveBackgroundNotificationResponse Received");
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => NotificationScreen()),
            );
          } else {
            log("No payload received in the background notification.");
          }
        },
      );

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen((remoteMessage) {
        RemoteNotification? remoteNotification = remoteMessage.notification;
        AndroidNotification? androidNotification = remoteMessage.notification?.android;

        log("STATUS = ${remoteMessage.notification?.title}");
        log("Notification Data = ${remoteMessage.data}");

        if (remoteNotification != null && androidNotification != null) {
          log("Received notification details:");
          log("Remote Notification: ${remoteNotification.toString()}");
          log("Android Notification: ${androidNotification.toString()}");

          flutterLocalNotificationsPlugin.show(
            remoteNotification.hashCode,
            remoteNotification.title,
            remoteNotification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: androidNotification.smallIcon,
                playSound: true,
                importance: Importance.high,
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
          );
        }
      });
    } catch (e) {
      log("Error registering notification listeners: $e");
    }
  }
}
