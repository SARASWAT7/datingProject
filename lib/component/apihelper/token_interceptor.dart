import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demoproject/component/apihelper/crash_handler.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as dev;

class TokenInterceptor extends Interceptor {
  final String? token;
  final Dio _dio = Dio();

  TokenInterceptor({this.token});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      if (token != null && token!.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        dev.log('Added token to request: ${options.uri}');
      } else {
        dev.log('No token available for request: ${options.uri}');
      }
    } catch (e) {
      dev.log('Error adding token to request: $e');
      CrashHandler.recordError(e, null);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      // Log successful responses in debug mode
      if (kDebugMode) {
        dev.log('Response received: ${response.statusCode} for ${response.requestOptions.uri}');
      }
    } catch (e) {
      dev.log('Error in response handler: $e');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      dev.log('TokenInterceptor handling error: ${err.type} - ${err.message}');
      
      // Handle 401 Unauthorized errors
      if (err.response?.statusCode == 401) {
        dev.log('Unauthorized error detected, attempting token refresh');
        
        try {
          // Try to refresh token or get new token
          final newToken = await _refreshToken();
          if (newToken != null && newToken.isNotEmpty) {
            dev.log('Token refreshed successfully, retrying request');
            
            // Retry the original request with new token
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';
            
            try {
              final response = await _dio.fetch(options);
              dev.log('Request retry successful');
              handler.resolve(response);
              return;
            } catch (retryError) {
              dev.log('Request retry failed: $retryError');
              // If retry fails, we'll fall through to the original error
            }
          } else {
            dev.log('Token refresh failed - no valid token available');
            // Clear stored tokens and handle logout
            await _clearStoredTokens();
          }
        } catch (refreshError) {
          dev.log('Token refresh error: $refreshError');
          CrashHandler.recordError(refreshError, null);
          // Clear stored tokens on refresh failure
          await _clearStoredTokens();
        }
      } else if (err.response?.statusCode == 403) {
        dev.log('Forbidden error - insufficient permissions');
        // Handle 403 Forbidden errors
        await _clearStoredTokens();
      } else if (err.response?.statusCode == 422) {
        dev.log('Validation error: ${err.response?.data}');
        // Handle validation errors
      } else if (err.response?.statusCode == 500) {
        dev.log('Server error: ${err.response?.data}');
        // Handle server errors
      }
      
      // Record error to crashlytics
      CrashHandler.recordError(err, err.stackTrace);
      
    } catch (e) {
      dev.log('Error in TokenInterceptor onError: $e');
      CrashHandler.recordError(e, null);
    }
    
    super.onError(err, handler);
  }

  Future<String?> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('token');
      
      if (storedToken != null && storedToken.isNotEmpty) {
        dev.log('Found stored token, attempting refresh');
        
        // In a real app, you'd call a refresh token endpoint here
        // For now, we'll just return the stored token
        // TODO: Implement actual token refresh logic
        
        return storedToken;
      }
      
      dev.log('No stored token found');
      return null;
    } catch (e) {
      dev.log('Error refreshing token: $e');
      CrashHandler.recordError(e, null);
      return null;
    }
  }

  Future<void> _clearStoredTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      dev.log('Cleared stored tokens');
    } catch (e) {
      dev.log('Error clearing stored tokens: $e');
      CrashHandler.recordError(e, null);
    }
  }
}
