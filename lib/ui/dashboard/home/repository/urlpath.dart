import 'dart:developer';
import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:dio/dio.dart';

class HomeUriPath {
  static String homeApi = "user/users";
}

class ApiErrorHandler {

  static String getErrorMessage(DioException error) {
    log("${error.response?.data} ${error.type} =======================++++++>");
    
    // Enhanced error handling with better user messages
    if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout - Please check your internet connection and try again';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return 'Request timeout - Server is taking too long to respond. Please try again';
    } else if (error.type == DioExceptionType.sendTimeout) {
      return 'Send timeout - Please check your internet connection and try again';
    } else if (error.type == DioExceptionType.badResponse) {
      // Handle different status codes
      final statusCode = error.response?.statusCode;
      switch (statusCode) {
        case 400:
          return error.response?.data['message'] ??
              error.response?.data.toString();
        case 401:
          return "Session expired. Please login again.";
        case 403:
          return "Access denied. Please check your permissions.";
        case 404:
          return "Service temporarily unavailable - Please try again later";
        case 422:
          return error.response?.data['message'] ?? 
              "Invalid data provided. Please check your input and try again.";
        case 500:
          return "Server error - Please try again in a few moments";
        case 502:
          return "Server temporarily unavailable - Please try again";
        case 503:
          return "Service temporarily unavailable - Please try again";
        case 504:
          return "Gateway timeout - Please try again";
        // Add more cases as needed
        default:
          return "Network error - Please check your internet connection and try again";
      }
    } else if (error.type == DioExceptionType.unknown) {
      // Handle specific unknown error cases
      if (error.message?.contains('Connection closed') == true) {
        return "Connection lost. Please check your internet connection and try again.";
      } else if (error.message?.contains('SocketException') == true) {
        return "Network error. Please check your internet connection and try again.";
      } else if (error.message?.contains('HandshakeException') == true) {
        return "SSL connection error. Please try again.";
      } else {
        return "Network error - Please check your internet connection and try again";
      }
    } else if (error.type == DioExceptionType.cancel) {
      return "Request cancelled - Please try again";
    } else {
      return "An unexpected error occurred - Please try again";
    }
  }

  // String elementValue = mySingleton.myElement;
  static String getHttpErrorMessage(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return 'Receive timeout';
    } else if (error.type == DioExceptionType.badResponse) {
      // Handle different status codes
      final statusCode = error.response?.statusCode;
      switch (statusCode) {
        case 400:
          return error.response!.data['message'];
        case 401:
          return NormalMessage().unauthenticatedError;
        case 403:
          return error.response!.data['message'];
        case 404:
          return "NO DATA FOUND";
        case 500:
          return NormalMessage().serverError;
        // Add more cases as needed
        default:
          return NormalMessage().serverError;
      }
    } else if (error.type == DioExceptionType.unknown) {
      return NormalMessage().serverError;
    } else {
      return NormalMessage().serverError;
    }
  }
}
