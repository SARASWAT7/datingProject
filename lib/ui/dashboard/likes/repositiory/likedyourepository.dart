import 'dart:developer';

import 'package:demoproject/component/apihelper/api_service.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/ui/auth/design/splash.dart';
import 'package:demoproject/ui/dashboard/home/repository/urlpath.dart';
import 'package:demoproject/ui/dashboard/likes/modal/likedyouresponse.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modal/youlikeresponse.dart';

class LikedYouRepository {
  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: UrlEndpoints.baseUrl,
  );
  Dio dio = Dio(_baseOptions);

  Future<LikedYouResponse> likedyou({int page = 1, int limit = 10}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString("token") ?? "";
    print("amit1234567890${token}");
    
    log("🏁 Starting likedyou API with pagination");
    log("📄 Page: $page, Limit: $limit");
    log("🌐 Liked You API - Full URL: ${UrlEndpoints.baseUrl}${UrlEndpoints.likedYouApi}?page=$page&limit=$limit");
    
    try {
      final response = await ApiService(token: token).sendRequest.get(
        UrlEndpoints.likedYouApi,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      log("✅ Liked You API - Response received successfully");
      log("📊 Response status: ${response.statusCode}");
      log("📊 Response data: ${response.data}");
      return LikedYouResponse.fromJson(response.data);
    } catch (e) {
      log("❌ Liked You API - Exception caught: $e");
      log("❌ Exception type: ${e.runtimeType}");
      if (e is DioException) {
        log("❌ Liked You API - DioException details:");
        log("❌ Status Code: ${e.response?.statusCode}");
        log("❌ Response Data: ${e.response?.data}");
        log("❌ Error Message: ${e.message}");
        throw ApiErrorHandler.getErrorMessage(e);
      } else {
        log("❌ Liked You API - Other Exception: $e");
        throw e.toString();
      }
    }
  }
  Future<YouLikedResponse> youLiked({int page = 1, int limit = 10}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";
    
    log("🏁 Starting youLiked API with pagination");
    log("📄 Page: $page, Limit: $limit");
    log("🌐 You Liked API - Full URL: ${UrlEndpoints.baseUrl}${UrlEndpoints.youliked}?page=$page&limit=$limit");

    try {
      final response = await ApiService(token: token).sendRequest.get(
        UrlEndpoints.youliked,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      
      log("✅ You Liked API - Response received successfully");
      log("📊 Response status: ${response.statusCode}");
      log("📊 Response data: ${response.data}");
      return YouLikedResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      log("❌ You Liked API - Exception caught: $e");
      log("❌ Exception type: ${e.runtimeType}");
      if (e is DioException) {
        log("❌ You Liked API - DioException details:");
        log("❌ Status Code: ${e.response?.statusCode}");
        log("❌ Response Data: ${e.response?.data}");
        log("❌ Error Message: ${e.message}");
        throw ApiErrorHandler.getErrorMessage(e);
      } else {
        log("❌ You Liked API - Other Exception: $e");
        throw e.toString();
      }
    }
  }




}
