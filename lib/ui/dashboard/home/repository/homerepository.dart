import 'dart:developer';

import 'package:demoproject/component/apihelper/api_service.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/component/apihelper/data_validator.dart';
import 'package:demoproject/component/apihelper/crash_handler.dart';
import 'package:demoproject/ui/auth/design/splash.dart';
import 'package:demoproject/ui/dashboard/home/model/LikeDislikeResponse.dart';
import 'package:demoproject/ui/dashboard/home/model/homeresponse.dart';
import 'package:demoproject/ui/dashboard/home/repository/urlpath.dart';
import 'package:demoproject/ui/dashboard/live/cubit/liveresponse.dart';
import 'package:demoproject/ui/match/model/agreedisagreeresponse.dart';
import 'package:demoproject/ui/match/model/firebaseiduser.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../match/model/getuserbyidmodel.dart';
import '../../notification/deleteallmodel.dart';
import '../../notification/notimodel.dart';
import '../../notification/userdelete.dart';

class HomeRepository {
  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: UrlEndpoints.baseUrl,
  );
  Dio dio = Dio(_baseOptions);
  Future<HomeResponse> homePageApi({int page = 1, int limit = 20}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      token = pref.getString("token") ?? "";

      log(
        "Making home page API call with token: ${token.isNotEmpty ? 'Present' : 'Missing'}",
      );
      log("📄 Home API - Page: $page, Limit: $limit");
      log("📄 Home API - Query Parameters: page=$page, limit=$limit");
      log(
        "📄 Home API - Full URL will be: ${UrlEndpoints.baseUrl}${HomeUriPath.homeApi}?page=$page&limit=$limit",
      );

      // Use the enhanced API service with retry logic
      final response = await ApiService(token: token).requestWithRetry(
        HomeUriPath.homeApi,
        queryParameters: {'page': page, 'limit': limit},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      log("📄 Home API - Response received for page $page");
      log("📄 Home API - Response status: ${response.statusCode}");
      if (response.data != null && response.data is Map) {
        final data = response.data as Map;
        if (data.containsKey('result') && data['result'] is Map) {
          final result = data['result'] as Map;
          if (result.containsKey('users') && result['users'] is List) {
            final users = result['users'] as List;
            log("📄 Home API - Users in response: ${users.length}");
            if (users.isNotEmpty) {
              log("📄 Home API - First user ID: ${users.first['id'] ?? 'N/A'}");
              log("📄 Home API - Last user ID: ${users.last['id'] ?? 'N/A'}");
            }
          }
        }
      }

      if (response.data == null) {
        throw Exception("No data received from server");
      }

      log("Home API response received: ${response.statusCode}");
      log("Response data: ${response.data}");

      // Validate response data before parsing
      if (!DataValidator.isValidResponse(response.data)) {
        throw Exception("Invalid response data from server");
      }

      if (!DataValidator.isValidApiResponse(response.data)) {
        throw Exception("Invalid API response structure");
      }

      try {
        return HomeResponse.fromJson(response.data);
      } catch (parseError) {
        log("Error parsing HomeResponse: $parseError");
        CrashHandler.recordError(parseError, null);
        throw Exception("Failed to parse server response. Please try again.");
      }
    } catch (e) {
      log("Home API error: $e");

      if (e is DioException) {
        // Handle specific DioException types
        if (e.response?.statusCode == 401) {
          log("Unauthorized access - token may be invalid");
          throw Exception("Session expired. Please login again.");
        } else if (e.response?.statusCode == 403) {
          log("Forbidden access");
          throw Exception("Access denied. Please check your permissions.");
        } else if (e.response?.statusCode == 404) {
          log("API endpoint not found");
          throw Exception(
            "Service temporarily unavailable. Please try again later.",
          );
        } else if (e.response?.statusCode == 500) {
          log("Server error");
          throw Exception("Server error. Please try again later.");
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          log("Timeout error: ${e.type}");
          throw Exception(
            "Request timeout. Please check your internet connection and try again.",
          );
        } else if (e.type == DioExceptionType.unknown) {
          log("Unknown error: ${e.message}");
          if (e.message?.contains('Connection closed') == true) {
            throw Exception(
              "Connection lost. Please check your internet connection and try again.",
            );
          } else {
            throw Exception(
              "Network error. Please check your internet connection and try again.",
            );
          }
        } else {
          log("Other DioException: ${e.type} - ${e.message}");
          throw Exception("Network error. Please try again.");
        }
      } else {
        log("Non-DioException error: $e");
        throw Exception("An unexpected error occurred. Please try again.");
      }
    }
  }

  Future<HomeResponse> filter(Map<String, dynamic> data) async {
    // log("message ========================================>");
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString("token") ?? "";
    try {
      final response = await ApiService(
        token: token,
      ).sendRequest.post(UrlEndpoints.filterApi, data: data);

      // log("${response.data} ========================================>");
      return HomeResponse.fromJson(response.data);
    } catch (e) {
      log("${e} ========================================>");
      DioException error = e as DioException;
      log(error.response?.data.toString() ?? "sds");
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<LikeDislikeResponse> likeDislikeApi(
    String userId,
    String type,
    String token,
    String likeUserName,
  ) async {
    try {
      print("$userId $type $token$likeUserName");
      final response = await ApiService(token: token).sendRequest.post(
        UrlEndpoints.likeDislike,
        data: {
          "liked_user_id": userId,
          "type": type,
          "liked_user_name": likeUserName,
        },
      );
      return LikeDislikeResponse.fromJson(response.data);
    } catch (e) {
      DioException error = e as DioException;
      log(error.response?.data.toString() ?? "sds");
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  ///////////////////addintro///////////////////////////

  Future<String> addIntro(String userId, String introtext) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token');

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.post(
        UrlEndpoints.addIntro,
        data: {"receiver_user_id": userId, "message": introtext},
      );

      print(
        response.data['message'] + " hello $userId",
      ); // Assuming 'message' is part of the response
      return response
          .data['message']; // Return the 'message' field from the response
    } on DioError catch (e) {
      print(e.response!.data.toString() + " response.data hello $userId");
      throw e.response!.data['message'];
    } catch (e) {
      print("Error: $e");
      throw e.toString();
    }
  }
  ///////////////itsmatchuser////////////

  // Future<IItsMatchResponse> getMatches() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString('token');
  //
  //   dio.options.headers['content-Type'] = 'application/json';
  //   dio.options.headers['Authorization'] = 'Bearer $token';
  //   try {
  //     final response = await dio.get(UrlEndpoints.itsmatch);
  //
  //     return IItsMatchResponse.fromJson(response.data);
  //   } on DioError catch (e) {
  //     throw e.response!.data['message'];
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  //////////getuserbyid/////////////

  Future<GetUserByUserIDModel> userbyid(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.get("${UrlEndpoints.getuser}$userId");

      return GetUserByUserIDModel.fromJson(response.data);
    } on DioError catch (e) {
      print("object error ${e.response?.data} $userId");
      throw e.response!.data['message'];
    } catch (e) {
      print("object error $e");
      throw e.toString();
    }
  }

  Future<String> getDeviceToken() async {
    try {
      final response = await FirebaseMessaging.instance.getToken();
      return response ?? "no token";
    } catch (e) {
      return "no token";
    }
  }

  Future<String> devicetoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    final device_token = await getDeviceToken();
    try {
      await dio.patch(
        UrlEndpoints.deviceTokenUpdate,
        data: {"device_token": device_token},
      );

      return "success";
    } on DioError catch (e) {
      throw e.response!.data['message'];
    } catch (e) {
      print("object error $e");
      throw e.toString();
    }
  }

  /////////////////userdatabyidonly//////////////\

  Future<GetUserByUserIDModel> byid(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.get("${UrlEndpoints.getuser}$id");

      return GetUserByUserIDModel.fromJson(response.data);
    } on DioError catch (e) {
      print("object error ${e.response?.data} $id");
      throw e.response!.data['message'];
    } catch (e) {
      print("object error $e");
      throw e.toString();
    }
  }

  /////////////////AGREEDISAGREE/////////////////////////

  Future<AgreeDisagreeResponse> fetchAgreeDisagree(String userId) async {
    print("111111111111");
    print(userId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.get("${UrlEndpoints.agreedisagree}$userId");
      print("stayfocused");
      print(response);
      return AgreeDisagreeResponse.fromJson(response.data);
    } on DioError catch (e) {
      throw e.response!.data['message'];
    } catch (e) {
      throw e.toString();
    }
  }

  //////////////////get id by firebase token \\\\\\\\\\\\\\\

  Future<GetUserFireBaseId> byidFireBase(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.get("${UrlEndpoints.getFirebaseId}$id");
      log(response.data.toString());
      return GetUserFireBaseId.fromJson(response.data);
    } on DioError catch (e) {
      print("object error ${e.response?.data} $id");
      throw e.response!.data['message'];
    } catch (e) {
      print("object error $e");
      throw e.toString();
    }
  }

  /////////////////////////online user///////////

  Future<String> onlinestatus(bool bio) async {
    print("amit1234$bio");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.post(
        UrlEndpoints.updatedata,
        data: {"is_online": bio},
      );
      return response.data['message'];
    } on DioError catch (e) {
      throw e.response!.data['message'];
    } catch (e) {
      throw e.toString();
    }
  }

  ///////////////Liveusers/////////////////
  Future<LiveResponse> getLiveData({int page = 1, int limit = 20}) async {
    log("🏁 Starting getLiveData in HomeRepository with pagination");
    log("📄 Page: $page, Limit: $limit");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    log("🔑 LIVE API TOKEN: $token");
    log("🔑 LIVE API TOKEN LENGTH: ${token.length}");
    log("🔑 LIVE API TOKEN IS EMPTY: ${token.isEmpty}");
    log(
      "🌐 Live API - Full URL: ${UrlEndpoints.baseUrl}${UrlEndpoints.Liveuser}?page=$page&limit=$limit",
    );

    try {
      log("📡 Making API call to get live users with pagination...");
      final response = await ApiService(token: token).sendRequest.get(
        UrlEndpoints.Liveuser,
        queryParameters: {'page': page, 'limit': limit},
      );

      log("✅ Live API - Response received successfully");
      log("📊 Response status: ${response.statusCode}");
      log("📊 Response data type: ${response.data.runtimeType}");
      log("📊 Response data: ${response.data}");

      log("🔄 Parsing response to LiveResponse...");
      final liveResponse = LiveResponse.fromJson(response.data);
      log("✅ Successfully parsed LiveResponse");
      log("📊 Parsed users count: ${liveResponse.result?.users?.length}");

      return liveResponse;
    } catch (e) {
      log("❌ Live API - Exception caught: $e");
      log("❌ Exception type: ${e.runtimeType}");
      if (e is DioException) {
        log("❌ Live API - DioException details:");
        log("❌ Status Code: ${e.response?.statusCode}");
        log("❌ Response Data: ${e.response?.data}");
        log("❌ Error Message: ${e.message}");
        throw ApiErrorHandler.getErrorMessage(e);
      } else {
        log("❌ Live API - Other Exception: $e");
        throw e.toString();
      }
    }
  }

  //////////////////notificationdataList/////////////////

  Future<NotificationResponse> getAllNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    try {
      final response = await ApiService(
        token: token,
      ).sendRequest.get(UrlEndpoints.allNotification);

      return NotificationResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        log(
          "${e.response?.data.toString()}  ${e.response?.statusCode.toString()}=======================++++++>",
        );
        throw ApiErrorHandler.getErrorMessage(e);
      } else {
        log("$e=======================++++++>");
        throw ApiErrorHandler.getErrorMessage(e as DioException);
      }
    }
  }
  //////////////deleteNotificationBy Id///////////////////

  Future<NotificationDeleteResponse> delNotiByid(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.delete("${UrlEndpoints.deleteNoitByid}$id");

      return NotificationDeleteResponse.fromJson(response.data);
    } on DioError catch (e) {
      print("object error ${e.response?.data} $id");
      throw e.response!.data['message'];
    } catch (e) {
      print("object error $e");
      throw e.toString();
    }
  }
  /////////////////deleteallnotification////////////

  Future<AllNotificationDeleteResponse> delNotiall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.delete("${UrlEndpoints.deleteNoitall}");
      return AllNotificationDeleteResponse.fromJson(response.data);
    } on DioError catch (e) {
      print("object error ${e.response?.data}");
      throw e.response?.data['message'] ?? 'Error occurred';
    } catch (e) {
      print("object error $e");
      throw e.toString();
    }
  }

  ////////////////////block and repot,spam///////////////

  Future<String> reportblock(
    String userid,
    String type,
    String messages,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.post(
        UrlEndpoints.BLOCK,
        data: {"opponent_user_id": userid, "type": type, "message": messages},
      );
      return response.data['message'];
    } on DioError catch (e) {
      throw e.response!.data['message'];
    } catch (e) {
      throw e.toString();
    }
  }
}
