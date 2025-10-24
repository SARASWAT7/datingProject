import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:demoproject/component/apihelper/crash_handler.dart';
import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:demoproject/component/apihelper/internet_connectivity_service.dart';
import 'dart:developer' as dev;
import 'dart:io';

class EnhancedErrorHandler {
  static void handleApiError(BuildContext context, dynamic error, {String? customMessage}) {
    try {
      dev.log('EnhancedErrorHandler handling error: $error');
      
      CrashHandler.recordError(error, null);
      
      String errorMessage = customMessage ?? _getErrorMessage(error);
      
      if (context.mounted) {
        _showErrorDialog(context, errorMessage);
      }
    } catch (e) {
      dev.log('Error in EnhancedErrorHandler: $e');
      if (context.mounted) {
        _showErrorDialog(context, "An unexpected error occurred. Please try again.");
      }
    }
  }
  
  static String _getErrorMessage(dynamic error) {
    if (error is DioException) {
      return _getDioErrorMessage(error);
    } else if (error is SocketException) {
      return "No internet connection. Please check your network and try again.";
    } else if (error is HttpException) {
      return "Network error. Please try again.";
    } else if (error is FormatException) {
      return "Data format error. Please try again.";
    } else if (error.toString().contains('Connection closed')) {
      return "Connection lost. Please check your internet connection and try again.";
    } else if (error.toString().contains('timeout')) {
      return "Request timeout. Please try again.";
    } else if (error.toString().contains('Session expired') ||
               error.toString().contains('Authentication failed') ||
               error.toString().contains('401')) {
      return "Session expired. Please login again.";
    } else if (error.toString().contains('Server error') ||
               error.toString().contains('500') ||
               error.toString().contains('502') ||
               error.toString().contains('503')) {
      return "Server error. Please try again later.";
    } else {
      return "An unexpected error occurred. Please try again.";
    }
  }
  
  static String _getDioErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout. Please check your internet connection and try again.";
      case DioExceptionType.receiveTimeout:
        return "Request timeout. Server is taking too long to respond. Please try again.";
      case DioExceptionType.sendTimeout:
        return "Send timeout. Please check your internet connection and try again.";
      case DioExceptionType.badResponse:
        return _getHttpErrorMessage(error);
      case DioExceptionType.cancel:
        return "Request cancelled. Please try again.";
      case DioExceptionType.unknown:
        return _getUnknownErrorMessage(error);
      default:
        return "Network error. Please try again.";
    }
  }
  
  static String _getHttpErrorMessage(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;
    
    switch (statusCode) {
      case 400:
        if (responseData is Map<String, dynamic> && responseData.containsKey('message')) {
          return responseData['message'].toString();
        }
        return "Bad request. Please check your input and try again.";
      case 401:
        return "Session expired. Please login again.";
      case 403:
        return "Access denied. Please check your permissions.";
      case 404:
        return "Service not found. Please try again later.";
      case 422:
        if (responseData is Map<String, dynamic> && responseData.containsKey('message')) {
          return responseData['message'].toString();
        }
        return "Invalid data provided. Please check your input and try again.";
      case 500:
        return "Server error. Please try again later.";
      case 502:
        return "Server temporarily unavailable. Please try again.";
      case 503:
        return "Service temporarily unavailable. Please try again.";
      case 504:
        return "Gateway timeout. Please try again.";
      default:
        return "Network error. Please check your internet connection and try again.";
    }
  }
  
  static String _getUnknownErrorMessage(DioException error) {
    final message = error.message?.toLowerCase() ?? '';
    
    if (message.contains('connection closed')) {
      return "Connection lost. Please check your internet connection and try again.";
    } else if (message.contains('socketexception')) {
      return "Network error. Please check your internet connection and try again.";
    } else if (message.contains('handshakeexception')) {
      return "SSL connection error. Please try again.";
    } else if (message.contains('timeout')) {
      return "Request timeout. Please try again.";
    } else {
      return "Network error. Please check your internet connection and try again.";
    }
  }
  
  static void _showErrorDialog(BuildContext context, String message) {
    try {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      dev.log('Error showing dialog: $e');
      // Fallback to snackbar if dialog fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
  
  // Handle authentication errors specifically
  static void handleAuthError(BuildContext context) {
    try {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Session Expired'),
            content: const Text('Your session has expired. Please login again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to login screen
                  // Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Login'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      dev.log('Error handling auth error: $e');
    }
  }
  
  // Handle network connectivity errors
  static void handleNetworkError(BuildContext context, dynamic error) {
    try {
      InternetConnectivityService.hasInternetConnection().then((hasConnection) {
        if (context.mounted) {
          if (hasConnection) {
            // We have internet, so it's likely a server issue
            String message = 'Server error. Please try again later.';
            
            if (error.toString().contains('timeout')) {
              message = 'Request timeout. Please try again.';
            } else if (error.toString().contains('Connection closed')) {
              message = 'Connection lost. Please try again.';
            }
            
            _showErrorDialog(context, message);
          } else {
            // No internet connection
            _showErrorDialog(context, 'No internet connection. Please check your network and try again.');
          }
        }
      });
    } catch (e) {
      dev.log('Error handling network error: $e');
      if (context.mounted) {
        _showErrorDialog(context, 'Network error. Please try again.');
      }
    }
  }
}
