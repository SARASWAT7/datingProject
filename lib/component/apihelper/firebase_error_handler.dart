import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer' as dev;

class FirebaseErrorHandler {
  static bool _isInitialized = false;
  
  /// Initialize Firebase with comprehensive error handling
  static Future<bool> initializeFirebase() async {
    if (_isInitialized) return true;
    
    try {
      dev.log('🔥 Initializing Firebase...');
      
      // Initialize Firebase Core
      await Firebase.initializeApp();
      dev.log('✅ Firebase Core initialized');
      
      // Initialize Crashlytics
      await _initializeCrashlytics();
      
      // Initialize Firebase Messaging
      await _initializeMessaging();
      
      // Initialize Firebase Auth
      await _initializeAuth();
      
      // Initialize Firestore
      await _initializeFirestore();
      
      // Initialize Firebase Storage
      await _initializeStorage();
      
      _isInitialized = true;
      dev.log('✅ Firebase fully initialized');
      return true;
      
    } catch (e, stackTrace) {
      dev.log('❌ Firebase initialization failed: $e');
      dev.log('Stack trace: $stackTrace');
      
      // Record the error to Crashlytics if possible
      try {
        FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: true);
      } catch (crashlyticsError) {
        dev.log('❌ Failed to record Firebase init error to Crashlytics: $crashlyticsError');
      }
      
      return false;
    }
  }
  
  /// Initialize Firebase Crashlytics with error handling
  static Future<void> _initializeCrashlytics() async {
    try {
      // Set up Flutter error handling
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        dev.log('Flutter Error: ${details.exception}');
        dev.log('Stack trace: ${details.stack}');
        
        // Record to Crashlytics
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };
      
      // Set up platform error handling
      PlatformDispatcher.instance.onError = (error, stack) {
        dev.log('Platform Error: $error');
        dev.log('Stack trace: $stack');
        
        // Record to Crashlytics
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      
      dev.log('✅ Firebase Crashlytics initialized');
    } catch (e) {
      dev.log('❌ Failed to initialize Crashlytics: $e');
      rethrow;
    }
  }
  
  /// Initialize Firebase Messaging with error handling
  static Future<void> _initializeMessaging() async {
    try {
      final messaging = FirebaseMessaging.instance;
      
      // Request permission
      await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      // Get FCM token
      final token = await messaging.getToken();
      if (token != null) {
        dev.log('✅ FCM Token: $token');
      }
      
      dev.log('✅ Firebase Messaging initialized');
    } catch (e) {
      dev.log('❌ Failed to initialize Firebase Messaging: $e');
      // Don't rethrow - messaging is not critical for app functionality
    }
  }
  
  /// Initialize Firebase Auth with error handling
  static Future<void> _initializeAuth() async {
    try {
      final auth = FirebaseAuth.instance;
      
      // Listen to auth state changes
      auth.authStateChanges().listen((User? user) {
        if (user != null) {
          dev.log('✅ User signed in: ${user.uid}');
          // Set user identifier in Crashlytics
          FirebaseCrashlytics.instance.setUserIdentifier(user.uid);
        } else {
          dev.log('✅ User signed out');
        }
      });
      
      dev.log('✅ Firebase Auth initialized');
    } catch (e) {
      dev.log('❌ Failed to initialize Firebase Auth: $e');
      // Don't rethrow - auth is not critical for app functionality
    }
  }
  
  /// Initialize Firestore with error handling
  static Future<void> _initializeFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      
      // Configure Firestore settings
      firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      
      dev.log('✅ Firestore initialized');
    } catch (e) {
      dev.log('❌ Failed to initialize Firestore: $e');
      // Don't rethrow - Firestore is not critical for app functionality
    }
  }
  
  /// Initialize Firebase Storage with error handling
  static Future<void> _initializeStorage() async {
    try {
      final storage = FirebaseStorage.instance;
      
      // Configure storage settings
      storage.setMaxUploadRetryTime(const Duration(seconds: 30));
      storage.setMaxDownloadRetryTime(const Duration(seconds: 30));
      
      dev.log('✅ Firebase Storage initialized');
    } catch (e) {
      dev.log('❌ Failed to initialize Firebase Storage: $e');
      // Don't rethrow - Storage is not critical for app functionality
    }
  }
  
  /// Record error to Crashlytics with comprehensive error handling
  static void recordError(dynamic error, StackTrace? stackTrace, {bool fatal = false}) {
    try {
      if (!_isInitialized) {
        dev.log('⚠️ Firebase not initialized, cannot record error');
        return;
      }
      
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: fatal);
      dev.log('✅ Error recorded to Crashlytics: $error');
    } catch (e) {
      dev.log('❌ Failed to record error to Crashlytics: $e');
    }
  }
  
  /// Set user identifier in Crashlytics
  static void setUserIdentifier(String userId) {
    try {
      if (!_isInitialized) {
        dev.log('⚠️ Firebase not initialized, cannot set user identifier');
        return;
      }
      
      FirebaseCrashlytics.instance.setUserIdentifier(userId);
      dev.log('✅ User identifier set: $userId');
    } catch (e) {
      dev.log('❌ Failed to set user identifier: $e');
    }
  }
  
  /// Set custom key in Crashlytics
  static void setCustomKey(String key, dynamic value) {
    try {
      if (!_isInitialized) {
        dev.log('⚠️ Firebase not initialized, cannot set custom key');
        return;
      }
      
      FirebaseCrashlytics.instance.setCustomKey(key, value);
      dev.log('✅ Custom key set: $key = $value');
    } catch (e) {
      dev.log('❌ Failed to set custom key: $e');
    }
  }
  
  /// Log message to Crashlytics
  static void log(String message) {
    try {
      if (!_isInitialized) {
        dev.log('⚠️ Firebase not initialized, cannot log message');
        return;
      }
      
      FirebaseCrashlytics.instance.log(message);
      dev.log('✅ Message logged to Crashlytics: $message');
    } catch (e) {
      dev.log('❌ Failed to log message: $e');
    }
  }
  
  /// Check if Firebase is properly initialized
  static bool get isInitialized => _isInitialized;
}
