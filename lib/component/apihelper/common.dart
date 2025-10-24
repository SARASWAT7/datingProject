import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'normalmessage.dart';

class CommonMessageAndFuntion {
  CommonMessageAndFuntion._();

  static final CommonMessageAndFuntion _instance = CommonMessageAndFuntion._();

  factory CommonMessageAndFuntion() {
    return _instance;
  }

  static CommonMessageAndFuntion get instance => _instance;

  /// Password should have,
  /// at least an upper case letter
  /// at least a lower case letter
  /// at least a digit
  /// at least a special character [@#$%^&+=]
  /// length of at least 4
  /// no white space allowed
  bool isValidPassword(
    String? inputString, {
    bool isRequired = false,
  }) {
    bool isInputStringValid = false;

    if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
      isInputStringValid = true;
    }

    if (inputString != null && inputString.isNotEmpty) {
      const pattern =
          r'^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,16}$';

      final regExp = RegExp(pattern);

      isInputStringValid = regExp.hasMatch(inputString);
    }

    return isInputStringValid;
  }
}

class ApiErrorHandler {
  static Future<String> getErrorMessage(
      DioException error, BuildContext context) async {
    bool helper = await Helper.hasInternetConnection();

    log("message");

    if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return 'Receive timeout';
    } else if (error.type == DioExceptionType.badResponse) {
      final statusCode = error.response?.statusCode;
      switch (statusCode) {
        case 400:
          return error.response?.data['message'] ??
              error.response?.data.toString();
        case 401:
          return NormalMessage().unauthenticatedError;
        case 403:
          return error.response?.data['message'] ??
              error.response?.data.toString();
        case 404:
          return error.response?.data['message'].toString() ?? "";
        case 500:
          return helper
              ? NormalMessage().serverError
              : NormalMessage().internetConnectionError;
        // Add more cases as needed
        default:
          return helper
              ? NormalMessage().serverError
              : NormalMessage().internetConnectionError;
      }
    } else if (error.type == DioExceptionType.unknown) {
      return helper
          ? NormalMessage().serverError
          : NormalMessage().internetConnectionError;
    } else {
      return helper
          ? NormalMessage().serverError
          : NormalMessage().internetConnectionError;
    }
  }
}

enum ApiState { isLoading, normal, success, error, isError }

class Helper {
  Future<bool> check() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet) {
        return true;
      }
      return false;
    } catch (e) {
      log("Error checking connectivity: $e");
      return false;
    }
  }

  /// Enhanced connectivity check with better error handling
  static Future<bool> hasInternetConnection() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      log("Error checking connectivity: $e");
      return false;
    }
  }

  /// Show internet connection error dialog
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No internet connection. Please check your network.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return null;
      }

      // Execute the function
      return await function();
    } catch (e) {
      log("Error in executeWithConnectivityCheck: $e");
      if (showSnackbar) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet connection. Please check your network.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return null;
    }
  }
}
