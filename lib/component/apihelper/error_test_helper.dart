import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:demoproject/component/apihelper/enhanced_error_handler.dart';
import 'package:demoproject/component/apihelper/api_service.dart';
import 'package:demoproject/component/apihelper/data_validator.dart';
import 'dart:developer' as dev;

class ErrorTestHelper {
  // Test all DioException types
  static Future<void> testDioExceptions(BuildContext context) async {
    dev.log('Testing DioException scenarios...');
    
    // Test connection timeout
    try {
      final dio = Dio();
      dio.options.connectTimeout = Duration(milliseconds: 1);
      await dio.get('https://httpstat.us/200?sleep=5000');
    } catch (e) {
      dev.log('Connection timeout test: $e');
      EnhancedErrorHandler.handleApiError(context, e);
    }
    
    // Test receive timeout
    try {
      final dio = Dio();
      dio.options.receiveTimeout = Duration(milliseconds: 1);
      await dio.get('https://httpstat.us/200?sleep=5000');
    } catch (e) {
      dev.log('Receive timeout test: $e');
      EnhancedErrorHandler.handleApiError(context, e);
    }
    
    // Test 401 Unauthorized
    try {
      final dio = Dio();
      await dio.get('https://httpstat.us/401');
    } catch (e) {
      dev.log('401 Unauthorized test: $e');
      EnhancedErrorHandler.handleApiError(context, e);
    }
    
    // Test 500 Server Error
    try {
      final dio = Dio();
      await dio.get('https://httpstat.us/500');
    } catch (e) {
      dev.log('500 Server Error test: $e');
      EnhancedErrorHandler.handleApiError(context, e);
    }
  }
  
  // Test data validation
  static void testDataValidation() {
    dev.log('Testing data validation...');
    
    // Test null data
    bool isValid = DataValidator.isValidResponse(null);
    dev.log('Null data validation: $isValid (should be false)');
    
    // Test empty string
    isValid = DataValidator.isValidResponse('');
    dev.log('Empty string validation: $isValid (should be false)');
    
    // Test valid map
    isValid = DataValidator.isValidResponse({'status': 'success'});
    dev.log('Valid map validation: $isValid (should be true)');
    
    // Test valid list
    isValid = DataValidator.isValidResponse([1, 2, 3]);
    dev.log('Valid list validation: $isValid (should be true)');
    
    // Test API response structure
    isValid = DataValidator.isValidApiResponse({'status': 'success', 'data': []});
    dev.log('Valid API response validation: $isValid (should be true)');
    
    // Test invalid API response
    isValid = DataValidator.isValidApiResponse({'invalid': 'structure'});
    dev.log('Invalid API response validation: $isValid (should be false)');
  }
  
  // Test safe data extraction
  static void testSafeDataExtraction() {
    dev.log('Testing safe data extraction...');
    
    // Test safe string
    String result = DataValidator.safeString(null);
    dev.log('Safe string from null: "$result" (should be empty)');
    
    result = DataValidator.safeString(123);
    dev.log('Safe string from int: "$result" (should be "123")');
    
    // Test safe int
    int intResult = DataValidator.safeInt('123');
    dev.log('Safe int from string: $intResult (should be 123)');
    
    intResult = DataValidator.safeInt('invalid');
    dev.log('Safe int from invalid string: $intResult (should be 0)');
    
    // Test safe bool
    bool boolResult = DataValidator.safeBool('true');
    dev.log('Safe bool from "true": $boolResult (should be true)');
    
    boolResult = DataValidator.safeBool('false');
    dev.log('Safe bool from "false": $boolResult (should be false)');
  }
  
  // Test API service with retry logic
  static Future<void> testApiServiceRetry() async {
    dev.log('Testing API service retry logic...');
    
    try {
      final apiService = ApiService();
      
      // This should fail and trigger retry logic
      final response = await apiService.requestWithRetry(
        'https://httpstat.us/500',
        maxRetries: 2,
      );
      
      dev.log('API service retry test response: ${response.statusCode}');
    } catch (e) {
      dev.log('API service retry test error: $e');
    }
  }
  
  // Test network connectivity scenarios
  static Future<void> testNetworkScenarios(BuildContext context) async {
    dev.log('Testing network scenarios...');
    
    // Test with invalid URL
    try {
      final dio = Dio();
      await dio.get('https://invalid-url-that-does-not-exist.com');
    } catch (e) {
      dev.log('Invalid URL test: $e');
      EnhancedErrorHandler.handleNetworkError(context, e);
    }
    
    // Test with malformed URL
    try {
      final dio = Dio();
      await dio.get('not-a-valid-url');
    } catch (e) {
      dev.log('Malformed URL test: $e');
      EnhancedErrorHandler.handleApiError(context, e);
    }
  }
  
  // Run all tests
  static Future<void> runAllTests(BuildContext context) async {
    dev.log('Starting comprehensive error handling tests...');
    
    testDataValidation();
    testSafeDataExtraction();
    await testDioExceptions(context);
    await testApiServiceRetry();
    await testNetworkScenarios(context);
    
    dev.log('All error handling tests completed.');
  }
}
