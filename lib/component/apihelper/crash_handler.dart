import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashHandler {
  static bool _isInitialized = false;
  
  static void initialize() {
    if (_isInitialized) return;
    
    try {
      // Set up error handling for Flutter framework errors
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        if (kDebugMode) {
          print('Flutter Error: ${details.exception}');
          print('Stack trace: ${details.stack}');
        }
        // Pass all uncaught "fatal" errors from the framework to Crashlytics
        try {
          FirebaseCrashlytics.instance.recordFlutterFatalError(details);
        } catch (e) {
          if (kDebugMode) {
            print('Error recording Flutter fatal error: $e');
          }
        }
      };

      // Handle platform errors
      PlatformDispatcher.instance.onError = (error, stack) {
        if (kDebugMode) {
          print('Platform Error: $error');
          print('Stack trace: $stack');
        }
        // Pass all uncaught asynchronous errors to Crashlytics
        try {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        } catch (e) {
          if (kDebugMode) {
            print('Error recording platform error: $e');
          }
        }
        return true;
      };
      
      _isInitialized = true;
      if (kDebugMode) {
        print('✅ CrashHandler initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error initializing CrashHandler: $e');
      }
    }
  }

  static void recordError(dynamic error, StackTrace? stackTrace, {bool fatal = false}) {
    try {
      if (!_isInitialized) {
        if (kDebugMode) {
          print('⚠️ CrashHandler not initialized, cannot record error');
        }
        return;
      }
      
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: fatal);
      
      if (kDebugMode) {
        print('✅ Error recorded to Crashlytics: $error');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error recording crash: $e');
        print('Original error: $error');
      }
    }
  }

  static void setUserIdentifier(String userId) {
    try {
      if (!_isInitialized) {
        if (kDebugMode) {
          print('⚠️ CrashHandler not initialized, cannot set user identifier');
        }
        return;
      }
      
      FirebaseCrashlytics.instance.setUserIdentifier(userId);
      
      if (kDebugMode) {
        print('✅ User identifier set: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error setting user identifier: $e');
      }
    }
  }

  static void setCustomKey(String key, dynamic value) {
    try {
      if (!_isInitialized) {
        if (kDebugMode) {
          print('⚠️ CrashHandler not initialized, cannot set custom key');
        }
        return;
      }
      
      FirebaseCrashlytics.instance.setCustomKey(key, value);
      
      if (kDebugMode) {
        print('✅ Custom key set: $key = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error setting custom key: $e');
      }
    }
  }

  static void log(String message) {
    try {
      if (!_isInitialized) {
        if (kDebugMode) {
          print('⚠️ CrashHandler not initialized, cannot log message');
        }
        return;
      }
      
      FirebaseCrashlytics.instance.log(message);
      
      if (kDebugMode) {
        print('✅ Message logged to Crashlytics: $message');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error logging message: $e');
      }
    }
  }
}
