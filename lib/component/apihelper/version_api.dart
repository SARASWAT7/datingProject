import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:demoproject/component/apihelper/urls.dart';

class VersionApi {
  static const String versionCheckEndpoint = 'app/version-check';
  
  /// Get latest app version from backend
  static Future<Map<String, dynamic>> getLatestVersion() async {
    try {
      final response = await http.get(
        Uri.parse('${UrlEndpoints.baseUrl}$versionCheckEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch version: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching version: $e');
    }
  }
  
  /// Check if current version needs update
  static Future<bool> needsUpdate(String currentVersion) async {
    try {
      final versionData = await getLatestVersion();
      final latestVersion = versionData['latest_version'] ?? '';
      final forceUpdate = versionData['force_update'] ?? false;
      
      if (latestVersion.isEmpty) return false;
      
      // Compare versions
      return _isVersionNewer(latestVersion, currentVersion);
    } catch (e) {
      return false;
    }
  }
  
  /// Check if force update is required
  static Future<bool> isForceUpdateRequired(String currentVersion) async {
    try {
      final versionData = await getLatestVersion();
      final latestVersion = versionData['latest_version'] ?? '';
      final forceUpdate = versionData['force_update'] ?? false;
      
      if (latestVersion.isEmpty) return false;
      
      // Check if current version is in force update list
      final forceUpdateVersions = versionData['force_update_versions'] ?? [];
      if (forceUpdateVersions.contains(currentVersion)) {
        return true;
      }
      
      return forceUpdate && _isVersionNewer(latestVersion, currentVersion);
    } catch (e) {
      return false;
    }
  }
  
  /// Compare version strings
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
  
  /// Get update message from backend
  static Future<String> getUpdateMessage() async {
    try {
      final versionData = await getLatestVersion();
      return versionData['update_message'] ?? 'A new version is available. Please update to continue.';
    } catch (e) {
      return 'A new version is available. Please update to continue.';
    }
  }
  
  /// Get update features from backend
  static Future<List<String>> getUpdateFeatures() async {
    try {
      final versionData = await getLatestVersion();
      final features = versionData['update_features'] ?? [];
      return List<String>.from(features);
    } catch (e) {
      return [
        'Bug fixes and performance improvements',
        'Enhanced security features',
        'New user interface improvements',
      ];
    }
  }
}
