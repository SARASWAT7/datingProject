import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUpdateService {
  static const String _versionCheckUrl = 'https://play.google.com/store/apps/details?id=com.dating.corretta';
  static const String _apiVersionUrl = 'http://localhost:8080/test_backend_response.json';
  
  // Check if update is available
  static Future<bool> isUpdateAvailable() async {
    try {
      // Get current app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      
      // Get latest version from your API
      String latestVersion = await _getLatestVersionFromAPI();
      
      if (latestVersion.isEmpty) {
        return false;
      }
      
      // Compare versions
      return _isVersionNewer(latestVersion, currentVersion);
    } catch (e) {
      debugPrint('Error checking update: $e');
      return false;
    }
  }
  
  // Get latest version from your backend API
  static Future<String> _getLatestVersionFromAPI() async {
    try {
      final response = await http.get(
        Uri.parse(_apiVersionUrl),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['latest_version'] ?? '';
        }
      }
    } catch (e) {
      debugPrint('Error fetching version from API: $e');
    }
    
    // Fallback: Check from Play Store (for production)
    return await _getVersionFromPlayStore();
  }
  
  // Fallback method to get version from Play Store
  static Future<String> _getVersionFromPlayStore() async {
    try {
      final response = await http.get(Uri.parse(_versionCheckUrl))
          .timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        // Parse HTML to extract version (this is a simplified approach)
        String body = response.body;
        RegExp versionRegex = RegExp(r'Current Version</div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb">([0-9.]+)');
        Match? match = versionRegex.firstMatch(body);
        return match?.group(1) ?? '';
      }
    } catch (e) {
      debugPrint('Error fetching version from Play Store: $e');
    }
    return '';
  }
  
  // Compare version strings
  static bool _isVersionNewer(String latestVersion, String currentVersion) {
    List<int> latest = latestVersion.split('.').map(int.parse).toList();
    List<int> current = currentVersion.split('.').map(int.parse).toList();
    
    // Pad with zeros if lengths differ
    while (latest.length < current.length) latest.add(0);
    while (current.length < latest.length) current.add(0);
    
    for (int i = 0; i < latest.length; i++) {
      if (latest[i] > current[i]) return true;
      if (latest[i] < current[i]) return false;
    }
    return false;
  }
  
  // Launch app store for update
  static Future<void> launchAppStore() async {
    try {
      String url;
      if (Platform.isAndroid) {
        url = 'https://play.google.com/store/apps/details?id=com.dating.corretta';
      } else if (Platform.isIOS) {
        url = 'https://apps.apple.com/app/id[YOUR_APP_ID]'; // Replace with your actual App Store ID
      } else {
        return;
      }
      
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching app store: $e');
    }
  }
  
  // Check if user has dismissed update
  static Future<bool> hasUserDismissedUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('update_dismissed') ?? false;
  }
  
  // Mark update as dismissed
  static Future<void> dismissUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('update_dismissed', true);
  }
  
  // Reset update dismissal (call this when new version is available)
  static Future<void> resetUpdateDismissal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('update_dismissed');
  }
  
  // Force update check (ignore dismissal)
  static Future<bool> shouldShowUpdateDialog() async {
    bool updateAvailable = await isUpdateAvailable();
    bool dismissed = await hasUserDismissedUpdate();
    
    return updateAvailable && !dismissed;
  }
  
  // Get current app version
  static Future<String> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
  
  // Get app name
  static Future<String> getAppName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }
}
