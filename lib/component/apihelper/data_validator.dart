import 'dart:developer' as dev;

class DataValidator {
  // Validate API response data
  static bool isValidResponse(dynamic data) {
    try {
      if (data == null) {
        dev.log('DataValidator: Response data is null');
        return false;
      }
      
      if (data is Map<String, dynamic>) {
        return true;
      } else if (data is List) {
        return true;
      } else if (data is String) {
        return data.isNotEmpty;
      } else {
        dev.log('DataValidator: Unexpected data type: ${data.runtimeType}');
        return false;
      }
    } catch (e) {
      dev.log('DataValidator: Error validating response: $e');
      return false;
    }
  }
  
  // Validate user data
  static bool isValidUserData(Map<String, dynamic>? userData) {
    try {
      if (userData == null) {
        dev.log('DataValidator: User data is null');
        return false;
      }
      
      // Check for required fields
      if (!userData.containsKey('id') || userData['id'] == null) {
        dev.log('DataValidator: Missing user ID');
        return false;
      }
      
      if (!userData.containsKey('name') || userData['name'] == null) {
        dev.log('DataValidator: Missing user name');
        return false;
      }
      
      return true;
    } catch (e) {
      dev.log('DataValidator: Error validating user data: $e');
      return false;
    }
  }
  
  // Validate API response structure
  static bool isValidApiResponse(Map<String, dynamic>? response) {
    try {
      if (response == null) {
        dev.log('DataValidator: API response is null');
        return false;
      }
      
      // Check for common API response structure
      if (response.containsKey('status') || 
          response.containsKey('success') ||
          response.containsKey('data') ||
          response.containsKey('result')) {
        return true;
      }
      
      dev.log('DataValidator: Invalid API response structure');
      return false;
    } catch (e) {
      dev.log('DataValidator: Error validating API response: $e');
      return false;
    }
  }
  
  // Safe string extraction
  static String safeString(dynamic value, {String defaultValue = ''}) {
    try {
      if (value == null) return defaultValue;
      if (value is String) return value;
      return value.toString();
    } catch (e) {
      dev.log('DataValidator: Error extracting string: $e');
      return defaultValue;
    }
  }
  
  // Safe int extraction
  static int safeInt(dynamic value, {int defaultValue = 0}) {
    try {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      if (value is double) return value.toInt();
      return defaultValue;
    } catch (e) {
      dev.log('DataValidator: Error extracting int: $e');
      return defaultValue;
    }
  }
  
  // Safe double extraction
  static double safeDouble(dynamic value, {double defaultValue = 0.0}) {
    try {
      if (value == null) return defaultValue;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? defaultValue;
      return defaultValue;
    } catch (e) {
      dev.log('DataValidator: Error extracting double: $e');
      return defaultValue;
    }
  }
  
  // Safe bool extraction
  static bool safeBool(dynamic value, {bool defaultValue = false}) {
    try {
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      if (value is int) return value != 0;
      return defaultValue;
    } catch (e) {
      dev.log('DataValidator: Error extracting bool: $e');
      return defaultValue;
    }
  }
  
  // Safe list extraction
  static List<T> safeList<T>(dynamic value, {List<T> defaultValue = const []}) {
    try {
      if (value == null) return defaultValue;
      if (value is List) {
        return value.cast<T>();
      }
      return defaultValue;
    } catch (e) {
      dev.log('DataValidator: Error extracting list: $e');
      return defaultValue;
    }
  }
  
  // Safe map extraction
  static Map<String, dynamic> safeMap(dynamic value, {Map<String, dynamic> defaultValue = const {}}) {
    try {
      if (value == null) return defaultValue;
      if (value is Map<String, dynamic>) return value;
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
      return defaultValue;
    } catch (e) {
      dev.log('DataValidator: Error extracting map: $e');
      return defaultValue;
    }
  }
  
  // Validate email format
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }
  
  // Validate phone number format
  static bool isValidPhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    final phoneRegex = RegExp(r'^\+?[0-9]{6,15}$');
    return phoneRegex.hasMatch(phone);
  }
  
  // Validate URL format
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Check if data is not null and not empty
  static bool isNotEmpty(dynamic value) {
    if (value == null) return false;
    if (value is String) return value.isNotEmpty;
    if (value is List) return value.isNotEmpty;
    if (value is Map) return value.isNotEmpty;
    return true;
  }
  
  // Validate required fields in a map
  static List<String> validateRequiredFields(Map<String, dynamic> data, List<String> requiredFields) {
    List<String> missingFields = [];
    
    for (String field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null || data[field] == '') {
        missingFields.add(field);
      }
    }
    
    return missingFields;
  }
}
