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
import 'package:demoproject/ui/dashboard/chat/design/chatroom.dart';
import 'package:demoproject/ui/dashboard/home/match/match.dart';
import 'package:demoproject/component/reuseable_widgets/bottomTabBar.dart';
import 'package:demoproject/ui/dashboard/chat/videocall/audiocallaccept.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class PushNotificationService2 {
  /// Navigate to appropriate screen based on notification type
  Future<void> _handleNotificationNavigation(Map<String, dynamic> data) async {
    try {
      final context = navigatorKey.currentState?.context;
      if (context == null) {
        log("⚠️ Navigation context is null, waiting...");
        await Future.delayed(Duration(milliseconds: 500));
        return _handleNotificationNavigation(data);
      }

      final type = data["type"]?.toString() ?? "";
      log("📱 Handling notification type: $type, data: $data");

      // Handle call notifications
      if (type == "call") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AudioCallAccept(
              userId: data["sender_firebase"]?.toString() ?? "",
              profileImage: data["profile_image"]?.toString() ?? "",
              name: data["sender_name"]?.toString() ?? "",
              channelName: data["channelName"]?.toString() ?? "",
              token: data["token"]?.toString() ?? "",
              userName: data["sender_name"]?.toString() ?? "",
            ),
          ),
        );
        return;
      }

      // Handle group notifications → Index 0 (Tour/Explore)
      if (type == "group" || type == "0" || data.containsKey("group_id")) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => BottomBar(currentIndex: 0), // Tour/Explore tab
          ),
          (route) => false,
        );
        return;
      }

      // Handle chat notifications (type "4" or chat-related) → Index 1 (Chat)
      if (type == "4" || type == "chat" || data.containsKey("chat_id") || data.containsKey("sender_id")) {
        // Navigate to chat tab first, then open specific chat if data available
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => BottomBar(currentIndex: 1), // Chat tab
          ),
          (route) => false,
        );

        // If we have chat-specific data, open the chat room
        final senderId = data["sender_id"]?.toString() ?? data["sender_firebase"]?.toString() ?? "";
        
        if (senderId.isNotEmpty) {
          await Future.delayed(Duration(milliseconds: 500)); // Wait for BottomBar to load
          
          try {
            final prefs = await SharedPreferences.getInstance();
            final chatToken = prefs.getString("chatToken") ?? "{}";
            final tokenData = jsonDecode(chatToken);
            
            Navigator.push(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  otherUserId: senderId,
                  userId: tokenData['userID']?.toString() ?? "",
                  profileImage: data["profile_image"]?.toString() ?? "",
                  userName: data["sender_name"]?.toString() ?? "User",
                  pageNavId: 0,
                  myImage: tokenData['profilePic']?.toString() ?? "",
                  name: tokenData['name']?.toString() ?? "",
                ),
              ),
            );
          } catch (e) {
            log("Error opening chat: $e");
          }
        }
        return;
      }

      // Handle match notifications → Show match screen
      if (type == "match" || type == "2" || data.containsKey("match_id")) {
        final matchId = data["match_id"]?.toString() ?? data["user_id"]?.toString() ?? "";
        if (matchId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MatchScreen1(userId: matchId),
            ),
          );
          return;
        }
      }

      // Handle like notifications (type "3") → Index 3 (Likes)
      if (type == "3" || type == "like" || data.containsKey("like_id")) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => BottomBar(currentIndex: 3), // Likes tab
          ),
          (route) => false,
        );
        return;
      }

      // Default: Navigate to home tab (index 2) if unknown type
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => BottomBar(currentIndex: 2), // Home tab
        ),
        (route) => false,
      );
    } catch (e) {
      log("❌ Navigation error: $e");
      // Fallback to home tab on any error
      final context = navigatorKey.currentState?.context;
      if (context != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => BottomBar(currentIndex: 2), // Home tab
          ),
          (route) => false,
        );
      }
    }
  }

  Future<void> setupInteractedMessage() async {
    try {
      // Firebase is already initialized in main.dart, so no need to call it here again.
      await FirebaseMessaging.instance.requestPermission();

      // Handle notification when app is opened from terminated state
      FirebaseMessaging.instance.getInitialMessage().then((remoteMessage) {
        if (remoteMessage != null) {
          log("📬 App opened from terminated state");
          log("NOT = ${jsonEncode(remoteMessage.data)}");
          _handleNotificationNavigation(remoteMessage.data);
        }
      });

      // Handle notification when app is in background and user taps notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) async {
        if (remoteMessage == null) {
          log("STATUS = OnMessageOpened Notification Not Received");
        } else {
          log("STATUS = OnMessageOpened Notification Received (App in background)");
          log("NOT = ${jsonEncode(remoteMessage.data)}");
          await _handleNotificationNavigation(remoteMessage.data);
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
          log("🔔 Local notification tapped: $message");

          try {
            // Parse payload (can be JSON string or direct data)
            Map<String, dynamic> notificationData = {};
            if (message.payload != null && message.payload!.isNotEmpty) {
              try {
                notificationData = jsonDecode(message.payload!) as Map<String, dynamic>;
              } catch (_) {
                // If payload is not JSON, treat it as a simple type
                notificationData = {"type": message.payload};
              }
              
              log("📬 Notification payload: $notificationData");
              await _handleNotificationNavigation(notificationData);
            } else {
              // No payload, go to home tab (index 2)
              final context = navigatorKey.currentState?.context;
              if (context != null) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BottomBar(currentIndex: 2), // Home tab
                  ),
                  (route) => false,
                );
              }
            }
          } catch (e) {
            log("❌ Error handling local notification: $e");
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

          // Include notification data in payload for navigation when tapped
          final payload = jsonEncode(remoteMessage.data);
          
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
            payload: payload, // Pass data as payload for navigation
          );
        }
      });
    } catch (e) {
      log("Error registering notification listeners: $e");
    }
  }
}
