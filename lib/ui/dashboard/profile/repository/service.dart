import 'dart:developer';

import 'package:demoproject/component/apihelper/api_service.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/component/commonfiles/shared_preferences.dart';
import 'package:demoproject/ui/auth/design/splash.dart';
import 'package:demoproject/ui/dashboard/home/repository/urlpath.dart';
import 'package:demoproject/ui/dashboard/profile/design/dataAndPrivacy.dart';
import 'package:demoproject/ui/dashboard/profile/model/contactusresponse.dart';
import 'package:demoproject/ui/dashboard/profile/model/dataprivacyresponse.dart';
import 'package:demoproject/ui/dashboard/profile/model/faqresponse.dart';
import 'package:demoproject/ui/dashboard/profile/model/feedbackresponse.dart';
import 'package:demoproject/ui/dashboard/profile/model/profileresponse.dart';
import 'package:demoproject/ui/dashboard/profile/repository/profileuri.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../reels/model/allreelsresponse.dart';
import '../../../reels/model/commentresponse.dart';
import '../../../reels/model/mycomment.dart';
import '../../../reels/model/profilereelsresponse.dart';
import '../../../reels/model/userprofiledata.dart';
import '../../../subscrption/model/getsubdaat.dart';

class CorettaUserProfileRepo {
  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: UrlEndpoints.baseUrl,
  );
  Dio dio = Dio(_baseOptions);

  Future<ProfileResponse> profile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    try {
      final response = await ApiService(token: token)
          .sendRequest
          .get(ProfileUriPath.getProfile);

      return ProfileResponse.fromJson(response.data);
    } catch (e) {
      DioException error = e as DioException;
      log("${e.response?.data.toString()}  ${e.response?.statusCode.toString()}=======================++++++>");
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }
  // //////////////media///////////////
  // Future<ProfileResponse> getmedia() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString('token') ?? "";
  //
  //   try {
  //     final response = await ApiService(token: token)
  //         .sendRequest
  //         .get(ProfileUriPath.getProfile);
  //
  //     return ProfileResponse.fromJson(response.data);
  //   } catch (e) {
  //     DioException error = e as DioException;
  //     log("${e.response?.data.toString()}  ${e.response?.statusCode.toString()}=======================++++++>");
  //     throw ApiErrorHandler.getErrorMessage(error);
  //   }
  // }
  //


  //////////////////////getmyreelsdata////////////////////

  Future<FaqResponse> faq() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    try {
      final response =
          await ApiService(token: token).sendRequest.get(ProfileUriPath.getFaq);

      return FaqResponse.fromJson(response.data);
    } catch (e) {
      log("$e=======================++++++>");
      DioException error = e as DioException;
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<DataPrivacyResponse> dataPrivacy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    try {
      final response = await ApiService(token: token)
          .sendRequest
          .get(ProfileUriPath.getDataPrivacy);

      return DataPrivacyResponse.fromJson(response.data);
    } catch (e) {
      log("$e=======================++++++>");
      DioException error = e as DioException;
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<FeedbackResponse> feedback(
      BuildContext context, String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? "";
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    log(token.toString());
    log(message.toString());
    try {
      final response =
          await dio.post(ProfileUriPath.feedback, data: {"message": message});

      log(response.data.toString());
      return FeedbackResponse.fromJson(response.data);
    } catch (error) {
      DioException e = error as DioException;

      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<ContactUsResponse> contactus(
      BuildContext context, String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? "";
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    log(token.toString());
    log(message.toString());
    try {
      final response =
          await dio.post(ProfileUriPath.contactus, data: {"message": message});

      log(response.data.toString());
      return ContactUsResponse.fromJson(response.data);
    } catch (error) {
      DioException e = error as DioException;

      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  ////////////////////////////////logoutapi///////////////////////////////////////


  Future<String> logout(String deviceToken) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.patch(
        UrlEndpoints.Logout,
        data: {
          'deviceToken': deviceToken,
        },
      );

      // Return message from API
      return response.data['message'];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'An error occurred';
    } catch (e) {
      throw 'An unknown error occurred: $e';
    }
  }

  ////////////////All Reels Work ///////////////////////////


  Future<ProfileReelsResponse> getMyReels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    try {
      final response = await ApiService(token: token)
          .sendRequest
          .get(UrlEndpoints.myReelsData);

      return ProfileReelsResponse.fromJson(response.data);
    } catch (e) {
      DioException error = e as DioException;
      log("${e.response?.data.toString()}  ${e.response?.statusCode.toString()}=======================++++++>");
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }
  Future<AllReelsResponse> getAllReels({required int pageNumber, required int pageSize}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    try {
      // Add both `pageNumber` and `pageSize` as query parameters
      final response = await ApiService(token: token)
          .sendRequest
          .get(
        UrlEndpoints.allReelsData,
        queryParameters: {
          'pageNumber': pageNumber,  // Use 'page' for pageNumber
          'pageSize': pageSize     // Use 'size' for pageSize
        },
      );

      return AllReelsResponse.fromJson(response.data);
    } catch (e) {
      DioException error = e as DioException;
      log("${e.response?.data.toString()}  ${e.response?.statusCode.toString()}=======================++++++>");
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  // Future<AllReelsResponse> getAllReels() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString('token') ?? "";
  //
  //   try {
  //     final response =
  //     await ApiService(token: token)
  //         .sendRequest
  //         .get(UrlEndpoints.allReelsData);
  //
  //     return AllReelsResponse.fromJson(response.data);
  //   } catch (e) {
  //     DioException error = e as DioException;
  //     log("${e.response?.data.toString()}  ${e.response?.statusCode.toString()}=======================++++++>");
  //     throw ApiErrorHandler.getErrorMessage(error);
  //   }
  // }


  Future<UserDataReelsResponse> getUserReels( String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    try {

      final response = await ApiService(token: token).sendRequest.get("${UrlEndpoints.userReelsData}$userId");

      return UserDataReelsResponse.fromJson(response.data);
    } catch (e) {
      DioException error = e as DioException;
      log("${e.response?.data.toString()}  ${e.response?.statusCode.toString()}=======================++++++>");
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }


  Future<GetCommentsResponse> getComment(String videoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    try {
      final response = await ApiService(token: token)
          .sendRequest
          .get("${UrlEndpoints.getComment}$videoId");

      return GetCommentsResponse.fromJson(response.data);
    } catch (e) {
      DioException error = e as DioException;
      log("${e.response?.data.toString()}  ${e.response?.statusCode.toString()}=======================++++++>");
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<MyCommentsResponse> sendComment(String videoId, String comment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    try {
      final response = await ApiService(token: token)
          .sendRequest
          .post("${UrlEndpoints.sendComment}$videoId", data: {'comment': comment});

      return MyCommentsResponse.fromJson(response.data);
    } catch (e) {
      DioException error = e as DioException;
      log("${e.response?.data.toString()}  ${e.response?.statusCode.toString()}=======================++++++>");
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }


  Future<String> sendLikes(String videoId, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    try {
      final response = await ApiService(token: token)
          .sendRequest
          .post(UrlEndpoints.sendLike, data: {
        'reel_id': videoId,
        'type': type,
      });

      return response.data['message'];
    } catch (e) {
      DioException error = e as DioException;
      log("${e.response?.data.toString()}  ${e.response?.statusCode.toString()}=======================++++++>");
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }


  ////////////////////Subscription//////////////////////////

Future<GetSubDataResponse> getSubscription() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

  try {
    final response =
    await ApiService(token: token).sendRequest.get(UrlEndpoints.getSub);

    return GetSubDataResponse.fromJson(response.data);
  } catch (e) {
    DioException error = e as DioException;
    log("${e.response?.data.toString()}  ${e.response?.statusCode.toString()}=======================++++++>");
    throw ApiErrorHandler.getErrorMessage(error);
  }
}


  Future<void> sendPurchaseDetails({
    required String transactionId,
    required String productId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    try {
      final response = await ApiService(token: token).sendRequest.post(
        UrlEndpoints.sendSub,
        data: {
          'subscriptions_type': productId,
          'inapp_txn_id': transactionId,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send purchase details to backend');
      }
    } catch (e) {
      DioException error = e as DioException;
      throw Exception(error.response?.data ?? 'Failed to send purchase details');
    }
  }
}





