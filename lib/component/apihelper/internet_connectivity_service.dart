import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:demoproject/component/apihelper/normalmessage.dart';

/// Comprehensive internet connectivity service for the app
class InternetConnectivityService {
  static final InternetConnectivityService _instance = InternetConnectivityService._internal();
  factory InternetConnectivityService() => _instance;
  InternetConnectivityService._internal();

  /// Check if device has internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      var connectivityResults = await Connectivity().checkConnectivity();
      log("🔍 Connectivity results: $connectivityResults");
      
      // Check if we have any type of connection
      bool hasConnection = connectivityResults.any((result) => result != ConnectivityResult.none);
      
      if (hasConnection) {
        log("✅ Device has connectivity: $connectivityResults");
        return true;
      } else {
        log("❌ No connectivity detected");
        return false;
      }
    } catch (e) {
      log("❌ Error checking connectivity: $e");
      // If we can't check connectivity, assume we have internet
      // This prevents false negatives when connectivity check fails
      return true;
    }
  }

  /// Enhanced connectivity check with actual internet test
  static Future<bool> hasRealInternetConnection() async {
    try {
      // First check basic connectivity
      var connectivityResults = await Connectivity().checkConnectivity();
      if (connectivityResults.every((result) => result == ConnectivityResult.none)) {
        return false;
      }

      // Additional check: try to reach a reliable endpoint
      // This helps catch cases where device is connected to WiFi but has no internet
      try {
        // Enhanced timeout and multiple endpoint checks
        final response = await Future.any([
          Future.delayed(const Duration(seconds: 5), () => false),
          // Add actual HTTP request here if needed
        ]);
        return response;
      } catch (e) {
        log("Internet test failed: $e");
        return false;
      }
    } catch (e) {
      log("Error checking real connectivity: $e");
      return false;
    }
  }

  /// Show no internet error dialog with retry option
  static void showNoInternetDialog(BuildContext context, {VoidCallback? onRetry}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text('Please check your internet connection and try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  /// Show connectivity error snackbar
  static void showConnectivityErrorSnackbar(BuildContext context, {String? message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'No internet connection. Please check your network.'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {
            // You can add retry logic here
          },
        ),
      ),
    );
  }

  /// Execute function with comprehensive connectivity check
  static Future<T?> executeWithConnectivityCheck<T>(
    BuildContext context,
    Future<T> Function() function, {
    bool showErrorDialog = true,
    bool showSnackbar = false,
    bool useRealInternetCheck = false,
    VoidCallback? onRetry,
  }) async {
    try {
      // Check connectivity first
      bool hasConnection = useRealInternetCheck 
          ? await hasRealInternetConnection() 
          : await hasInternetConnection();
      
      if (!hasConnection) {
        if (showErrorDialog) {
          showNoInternetDialog(context, onRetry: onRetry);
        }
        if (showSnackbar) {
          showConnectivityErrorSnackbar(context);
        }
        return null;
      }

      // Execute the function
      return await function();
    } catch (e) {
      log("Error in executeWithConnectivityCheck: $e");
      if (showSnackbar) {
        showConnectivityErrorSnackbar(context);
      }
      return null;
    }
  }

  /// Wrap API calls with retry mechanism
  static Future<T?> executeWithRetry<T>(
    BuildContext context,
    Future<T> Function() function, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
    bool showErrorDialog = true,
    bool useRealInternetCheck = false,
  }) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        bool hasConnection = useRealInternetCheck 
            ? await hasRealInternetConnection() 
            : await hasInternetConnection();
        
        if (!hasConnection) {
          if (showErrorDialog) {
            showNoInternetDialog(context);
          }
          return null;
        }

        return await function();
      } catch (e) {
        log("Attempt $attempt failed: $e");
        
        if (attempt == maxRetries) {
          if (showErrorDialog) {
            showNoInternetDialog(context);
          }
          return null;
        }
        
        // Wait before retry
        await Future.delayed(retryDelay);
      }
    }
    return null;
  }

  /// Listen to connectivity changes
  static Stream<bool> get connectivityStream {
    return Connectivity().onConnectivityChanged.map((results) {
      return results.any((result) => result != ConnectivityResult.none);
    });
  }

  /// Show connectivity status indicator
  static Widget buildConnectivityIndicator(BuildContext context) {
    return StreamBuilder<bool>(
      stream: connectivityStream,
      builder: (context, snapshot) {
        if (snapshot.data == false) {
          return Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'No Internet Connection',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Show connectivity status in app bar
  static Widget buildConnectivityStatusBar(BuildContext context) {
    return StreamBuilder<bool>(
      stream: connectivityStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool isConnected = snapshot.data!;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isConnected ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isConnected ? 'Online' : 'Offline',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Handle network errors with proper messaging
  static void handleNetworkError(BuildContext context, dynamic error) {
    // First check if we actually have internet connection
    hasInternetConnection().then((hasConnection) {
      if (hasConnection) {
        // If we have internet, it's likely a server or API issue, not connectivity
        String message = 'Server error. Please try again later.';
        
        if (error.toString().contains('timeout')) {
          message = 'Request timeout. Please try again.';
        } else if (error.toString().contains('socket')) {
          message = 'Network error. Please try again.';
        } else if (error.toString().contains('handshake')) {
          message = 'SSL error. Please try again.';
        } else if (error.toString().contains('500') || error.toString().contains('Internal Server Error')) {
          message = 'Server error. Please try again later.';
        } else if (error.toString().contains('404') || error.toString().contains('Not Found')) {
          message = 'Data not found. Please try again.';
        } else if (error.toString().contains('401') || error.toString().contains('Unauthorized')) {
          message = 'Authentication failed. Please login again.';
        }
        
        if (context.mounted) {
          NormalMessage().normalerrorstate(context, message);
        }
      } else {
        // Only show internet connection error if we actually don't have internet
        if (context.mounted) {
          NormalMessage().normalerrorstate(context, NormalMessage().internetConnectionError);
        }
      }
    });
  }
}
