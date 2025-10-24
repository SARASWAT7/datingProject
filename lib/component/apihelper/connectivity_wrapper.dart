import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityWrapper {
  static final ConnectivityWrapper _instance = ConnectivityWrapper._internal();
  factory ConnectivityWrapper() => _instance;
  ConnectivityWrapper._internal();

  /// Check if device has internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      log("Error checking connectivity: $e");
      return false;
    }
  }

  /// Show no internet error dialog
  static void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text('Please check your internet connection and try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show connectivity error snackbar
  static void showConnectivityErrorSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection. Please check your network.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// Execute function with connectivity check
  static Future<T?> executeWithConnectivityCheck<T>(
    BuildContext context,
    Future<T> Function() function, {
    bool showErrorDialog = true,
    bool showSnackbar = false,
  }) async {
    try {
      // Check connectivity first
      bool hasConnection = await hasInternetConnection();
      if (!hasConnection) {
        if (showErrorDialog) {
          showNoInternetDialog(context);
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
  }) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        bool hasConnection = await hasInternetConnection();
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
    return Connectivity().onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }

  /// Show connectivity status in app
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
}
