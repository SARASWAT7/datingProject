import 'package:flutter/material.dart';
import 'package:demoproject/service/app_update_service.dart';
// import 'package:demoproject/service/in_app_update_service.dart';
import 'package:demoproject/ui/update/update_screen.dart';
import 'package:demoproject/ui/update/update_dialog.dart';
// import 'package:demoproject/ui/update/native_update_screen.dart';

class UpdateManager {
  static bool _isCheckingUpdate = false;
  
  /// Check for app updates and show appropriate UI
  static Future<void> checkForUpdates(BuildContext context, {
    bool showDialog = true,
    bool forceCheck = false,
  }) async {
    // Prevent multiple simultaneous checks
    if (_isCheckingUpdate) return;
    _isCheckingUpdate = true;
    
    try {
      // Check if update is available
      bool updateAvailable = await AppUpdateService.isUpdateAvailable();
      
      if (updateAvailable) {
        // Reset dismissal when new update is available
        await AppUpdateService.resetUpdateDismissal();
        
        if (showDialog) {
          await _showUpdateDialog(context);
        }
      } else if (forceCheck) {
        // Show no update available message
        _showNoUpdateMessage(context);
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      if (forceCheck) {
        _showErrorMessage(context, 'Failed to check for updates. Please try again later.');
      }
    } finally {
      _isCheckingUpdate = false;
    }
  }
  
  /// Show update dialog
  static Future<void> _showUpdateDialog(BuildContext context) async {
    // Check if user has dismissed the update
    bool shouldShow = await AppUpdateService.shouldShowUpdateDialog();
    
    if (shouldShow) {
      // Show as dialog for non-critical updates
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => UpdateDialog(
          isForceUpdate: false,
        ),
      );
    }
  }
  
  /// Show force update screen
  static Future<void> showForceUpdateScreen(BuildContext context) async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => UpdateScreen(
          isForceUpdate: true,
        ),
      ),
    );
  }
  
  /// Show no update available message
  static void _showNoUpdateMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('App Update'),
        content: Text('You are using the latest version of the app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  
  /// Show error message
  static void _showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  
  /// Check for critical updates (force update)
  static Future<void> checkForCriticalUpdates(BuildContext context) async {
    try {
      bool updateAvailable = await AppUpdateService.isUpdateAvailable();
      
      if (updateAvailable) {
        // Show force update screen
        showForceUpdateScreen(context);
      }
    } catch (e) {
      debugPrint('Error checking for critical updates: $e');
    }
  }
  
  /// Manual update check from settings
  static Future<void> manualUpdateCheck(BuildContext context) async {
    await checkForUpdates(context, showDialog: true, forceCheck: true);
  }
  
  /// Reset update dismissal (for testing)
  static Future<void> resetUpdateDismissal() async {
    await AppUpdateService.resetUpdateDismissal();
  }

  /// Check for native Android in-app updates
  // Native update methods temporarily disabled due to package compatibility
  // static Future<void> checkForNativeUpdates(BuildContext context) async {
  //   try {
  //     // Check for native Android updates first
  //     final hasNativeUpdate = await InAppUpdateService.checkForUpdate();
  //     
  //     if (hasNativeUpdate) {
  //       // Show native update screen
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => NativeUpdateScreen(),
  //         ),
  //       );
  //     } else {
  //       // Fallback to custom update system
  //       await checkForUpdates(context);
  //     }
  //   } catch (e) {
  //     // Fallback to custom update system if native update fails
  //     await checkForUpdates(context);
  //   }
  // }

  // /// Show native update screen directly
  // static void showNativeUpdateScreen(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => NativeUpdateScreen(),
  //     ),
  //   );
  // }
}
