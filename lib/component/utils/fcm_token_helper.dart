import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Helper class for handling FCM token generation
/// Handles simulator and device differences
class FCMTokenHelper {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  /// Get FCM token with proper error handling for simulators and devices
  static Future<String?> getToken() async {
    try {
      // Request permission first
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      log('FCM Permission status: ${settings.authorizationStatus}');
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        
        String? token = await _messaging.getToken();
        log('FCM Token: $token');
        
        // Handle simulator case
        if (token == null) {
          if (kDebugMode) {
            log('Token is null - this might be running on iOS simulator');
            // For simulator, generate a mock token
            token = 'simulator_mock_token_${DateTime.now().millisecondsSinceEpoch}';
            log('Using mock token for simulator: $token');
          } else {
            log('Token is null on device - this might be a configuration issue');
            return null;
          }
        }
        
        return token;
      } else {
        log('FCM Notification permission not granted: ${settings.authorizationStatus}');
        return null;
      }
    } catch (e) {
      log('Error getting FCM token: $e');
      return null;
    }
  }
  
  /// Check if running on simulator
  static bool get isSimulator {
    return kDebugMode && defaultTargetPlatform == TargetPlatform.iOS;
  }
  
  /// Get token with retry mechanism
  static Future<String?> getTokenWithRetry({int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      String? token = await getToken();
      if (token != null) {
        return token;
      }
      
      if (i < maxRetries - 1) {
        log('Retrying FCM token generation... Attempt ${i + 2}/$maxRetries');
        await Future.delayed(Duration(seconds: 2));
      }
    }
    
    log('Failed to get FCM token after $maxRetries attempts');
    return null;
  }
  
  /// Subscribe to token refresh
  static void onTokenRefresh(Function(String) onNewToken) {
    _messaging.onTokenRefresh.listen((String token) {
      log('FCM Token refreshed: $token');
      onNewToken(token);
    });
  }
}
