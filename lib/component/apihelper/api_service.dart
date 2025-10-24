
import 'package:demoproject/component/apihelper/token_interceptor.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/component/apihelper/crash_handler.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as dev;
import 'dart:io';

class ApiService {
  final Dio _dio = Dio();

  ApiService._internal() {
    _dio.options.baseUrl = UrlEndpoints.baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 30);
    _dio.options.receiveTimeout = Duration(seconds: 30);
    _dio.options.sendTimeout = Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Add error interceptor for better error handling
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) {
        _handleDioError(error);
        handler.next(error);
      },
    ));
    
    // Add logging interceptor only in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ));
    }
  }

  static final ApiService _instance = ApiService._internal();

  _addTokenInterceptor({String? params}) {
    // Remove existing token interceptor
    _dio.interceptors.removeWhere((interceptor) => interceptor is TokenInterceptor);
    
    // Add new token interceptor
    if (params != null && params.isNotEmpty) {
      _dio.interceptors.add(TokenInterceptor(token: params));
    }
  }

  factory ApiService({String? token}) {
    _instance._addTokenInterceptor(params: token);
    return _instance;
  }

  Dio get sendRequest => _dio;

  // Enhanced method with comprehensive retry logic
  Future<Response> requestWithRetry(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    int maxRetries = 3,
  }) async {
    int retryCount = 0;
    DioException? lastError;
    
    while (retryCount <= maxRetries) {
      try {
        final response = await _dio.request(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        );
        
        return response;
        
      } catch (e) {
        lastError = e is DioException ? e : null;
        
        if (e is DioException) {
          // Handle different types of errors
          if (e.response?.statusCode == 401) {
            // Unauthorized - try to refresh token or handle auth
            if (retryCount < maxRetries) {
              retryCount++;
              await Future.delayed(Duration(seconds: 2 * retryCount));
              continue;
            } else {
              // Max retries reached for auth error
              throw DioException(
                requestOptions: e.requestOptions,
                error: "Authentication failed. Please login again.",
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: e.requestOptions,
                  statusCode: 401,
                  data: {"message": "Authentication failed. Please login again."},
                ),
              );
            }
          } else if (e.type == DioExceptionType.connectionTimeout ||
                     e.type == DioExceptionType.receiveTimeout ||
                     e.type == DioExceptionType.sendTimeout) {
            // Timeout errors - retry with exponential backoff
            if (retryCount < maxRetries) {
              retryCount++;
              await Future.delayed(Duration(seconds: 2 * retryCount));
              continue;
            }
          } else if (e.type == DioExceptionType.unknown) {
            // Network errors - check if it's a connection issue
            if (e.error is SocketException || 
                e.error is HttpException ||
                e.message?.contains('Connection closed') == true) {
              if (retryCount < maxRetries) {
                retryCount++;
                await Future.delayed(Duration(seconds: 3 * retryCount));
                continue;
              }
            }
          }
        }
        
        // If we reach here, don't retry
        break;
      }
    }
    
    // If we have a last error, throw it
    if (lastError != null) {
      throw lastError;
    }
    
    throw DioException(
      requestOptions: RequestOptions(path: path),
      error: "Request failed after $maxRetries retries",
      type: DioExceptionType.unknown,
    );
  }

  // Handle Dio errors with proper logging and crash reporting
  void _handleDioError(DioException error) {
    try {
      // Log error details
      dev.log('DioException: ${error.type} - ${error.message}');
      
      // Record to crashlytics for monitoring
      CrashHandler.recordError(error, error.stackTrace);
      
      // Log additional context
      if (error.response != null) {
        dev.log('Response status: ${error.response?.statusCode}');
        dev.log('Response data: ${error.response?.data}');
      }
      
      // Handle specific error types
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          dev.log('Connection timeout to ${error.requestOptions.uri}');
          break;
        case DioExceptionType.receiveTimeout:
          dev.log('Receive timeout for ${error.requestOptions.uri}');
          break;
        case DioExceptionType.sendTimeout:
          dev.log('Send timeout for ${error.requestOptions.uri}');
          break;
        case DioExceptionType.badResponse:
          dev.log('Bad response: ${error.response?.statusCode}');
          break;
        case DioExceptionType.cancel:
          dev.log('Request cancelled for ${error.requestOptions.uri}');
          break;
        case DioExceptionType.badCertificate:
          dev.log('Bad certificate error for ${error.requestOptions.uri}');
          break;
        case DioExceptionType.connectionError:
          dev.log('Connection error for ${error.requestOptions.uri}');
          break;
        case DioExceptionType.unknown:
          dev.log('Unknown error: ${error.message}');
          break;
      }
    } catch (e) {
      dev.log('Error in _handleDioError: $e');
    }
  }

  // Safe API call wrapper with comprehensive error handling
  Future<Response?> safeRequest(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await requestWithRetry(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      dev.log('Safe request failed: $e');
      return null;
    }
  }
}
