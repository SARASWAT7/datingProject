import 'dart:developer';

import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/component/apihelper/connectivity_wrapper.dart';
import 'package:demoproject/ui/auth/model/logInresponse.dart';
import 'package:demoproject/ui/auth/model/verifyotpwithphoneresponse.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/model/socialmodel.dart';
import '../dashboard/home/repository/urlpath.dart';

class AuthRepository {
  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: UrlEndpoints.baseUrl,
  );
  Dio dio = Dio(_baseOptions);

  Future<LogInResponse> login(
    BuildContext context,
    String code,
    String phone,
    String latitude,
    String longitude,
    String deviceType,
    String fcmToken,
  ) async {
    return await ConnectivityWrapper.executeWithConnectivityCheck(
      context,
      () async {
        print("---------------------------------------------------");
        print("fcmToken$fcmToken");
        print("deviceType$deviceType"); 

          print("phone$phone");
          print("code$code");
          print("latitude$latitude");
          print("longitude$longitude");

        log(
          'alldataforlogin$code$phone $latitude $longitude $deviceType $fcmToken',
        ); // Log all variables
        
        final response = await dio.post(
          UrlEndpoints.login,
          data: {
            "isd": code,
            "phone": phone,
            "latitude": latitude,
            "longitude": longitude,
            "device_type": deviceType,
            "device_token": fcmToken,
          },
        );

        log(response.data.toString());
        return LogInResponse.fromJson(response.data);
      },
    ) ?? LogInResponse();
  }

  Future<LogInResponse> emailLogin(
    BuildContext context,
    String code,
    String email,
    String lati,
    String longi,
    String deviceType,
    String fcmToken,
  ) async {
    return await ConnectivityWrapper.executeWithConnectivityCheck(
      context,
      () async {
        print("fcmToken$fcmToken");

        log(
          'alldataforlogin$code$email $lati $longi $deviceType $fcmToken',
        ); // Log all variables
        
        final response = await dio.post(
          UrlEndpoints.login,
          data: {
            "isd": code,
            "email": email,
            "latitude": lati,
            "longitude": longi,
            "device_type": deviceType,
            "device_token": fcmToken,
          },
        );

        log(response.data.toString());
        return LogInResponse.fromJson(response.data);
      },
    ) ?? LogInResponse();
  }

  Future<VerifyOtpWithPhoneResponse> verifyotpwithphone(
    BuildContext context,
    String phone,
    String email,
    String otp,
    String verificationType,
  ) async {
    log("message $phone ytfjgug $otp");
    try {
      final response = await dio.post(
        UrlEndpoints.verifyOtpWithPhone,
        data: {
          "phone": phone,
          "email": email,
          "otp": otp,
          "verification_type": verificationType,
        },
      );
      print("qwertyuiop");
      print(response.data.toString());
      return VerifyOtpWithPhoneResponse.fromJson(response.data);
    } catch (error) {
      log("$error dfffcddffdfdf");
      DioException e = error as DioException;
      log(e.response?.data.toString() ?? "");
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<String> createaccount(
    BuildContext context,
    String firstName,
    String lastName,
    String dob,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? "";
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    print("pushkar token");
    log(token.toString());
    try {
      final response = await dio.post(
        UrlEndpoints.createaccount,
        data: {"first_name": firstName, "last_name": lastName, "dob": dob},
      );

      log(
        "${response.data.toString()}"
        " ${{"first_name": firstName, "last_name": lastName, "dob": dob}}",
      );
      return response.data["message"];
    } catch (error) {
      log(error.toString());
      DioException e = error as DioException;
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<String> addphoto(BuildContext context, List<String> images) async {
    log(images.toString());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List upload = [];
    for (int i = 0; i < images.length; i++) {
      upload.add(
        await MultipartFile.fromFile(
          images[i],
          filename: images[i].split('/').last,
        ),
      );
    }
    //var token = prefs.getString('token');
    var token = prefs.getString('token') ?? "";
    dio.options.headers['Content-Type'] =
        'multipart/form-data; boundary=<calculated when request is sent>';
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.post(
        UrlEndpoints.addphoto,
        data: FormData.fromMap({"file": upload}),
      );
      return response.data["message"];
    } catch (error) {
      if (error is DioException) {
        final errorMessage = error.response?.data['message'] ?? 'error';
        throw Exception(errorMessage);
      } else {
        throw Exception('error');
      }
    }
  }

  Future<String> basicinformation(BuildContext context, FormData form) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? "";
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    log(form.fields.toString());
    try {
      final response = await dio.post(
        UrlEndpoints.basicinformation,
        data: form,
      );
      log(response.data.toString());
      print('height');
      return response.data["message"];
    } catch (error) {
      // log(error.toString());
      DioException e = error as DioException;

      log(e.response?.data.toString() ?? "");
      log(e.response?.realUri.toString() ?? "");
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<String> moreabout(BuildContext context, FormData form) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? "";
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    print(form.fields.toString());
    try {
      final response = await dio.post(UrlEndpoints.moreabout, data: form);
      return response.data["message"];
    } catch (error) {
      DioException e = error as DioException;
      log(error.toString());
      log(e.response?.data.toString() ?? "");
      log(e.response?.realUri.toString() ?? "");
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<String> updatedata(BuildContext context, String bio) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? "";
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.post(
        UrlEndpoints.updatedata,
        data: {"bio": bio},
      );
      log(response.data.toString());
      return response.data["message"];
    } catch (error) {
      DioException e = error as DioException;
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<String> paasion(BuildContext context, List passions) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? "";
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.post(
        UrlEndpoints.updatedata,
        data: {"passions": passions, "is_completed": true},
      );

      log(response.data.toString());
      return response.data["message"];
    } catch (error) {
      DioException e = error as DioException;
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<SocialLoginResponse> socialLogin(
    String idToken,
    String lat,
    String long,
    String deviceType,
    String deviceToken,
  ) async {
    final Dio dio = Dio();

    try {
      final response = await dio.post(
         "https://www.lempiredating.com/api/v1/user/google-login",
        // "http://172.16.100.230:10061/api/v1/user/google-login",
        data: {
          'idToken': idToken,
          'latitude': lat,
          'longitude': long,
          'device_type': deviceType,
          'device_token': deviceToken,
        },
      );

      if (response.statusCode == 200) {
        print('Response Data: ${response.data}');
        return SocialLoginResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Login failed: ${response.statusCode} - ${response.data}',
        );
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error: ${e.response?.statusCode} - ${e.response?.data}');
        throw Exception(
          'Dio error: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        print('Dio error: ${e.message}');
        throw Exception('Dio error: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  ////////////////////apple////////////

  Future<SocialLoginResponse> appleLogin(
    String idToken,
    String deviceToken,
    String deviceType,
    String lat,
    String long,
  ) async {
    final Dio dio = Dio();

    try {
      final response = await dio.post(
        "https://www.lempiredating.com/api/v1/user/apple-login",

        // "http://172.16.100.196:10061/api/v1/user/apple-login",
        data: {
          'idToken': idToken,
          'latitude': lat,
          'longitude': long,
          'device_type': deviceType,
          'device_token': deviceToken,
        },
      );

      if (response.statusCode == 200) {
        print('Response Data: ${response.data}');
        return SocialLoginResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Login failed: ${response.statusCode} - ${response.data}',
        );
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error: ${e.response?.statusCode} - ${e.response?.data}');
        throw Exception(
          'Dio error: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        print('Dio error: ${e.message}');
        throw Exception('Dio error: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  // Future<SocialLoginResponse> appleLogin(String idToken, String devicetoken, String deviceType, String lat, String long) async {
  //   final Dio dio = Dio();
  //
  //   try {
  //     final response = await dio.post(
  //       UrlEndpoints.appleLogin,
  //       data: {
  //         'idToken': idToken,
  //         "latitude": lat,
  //         "longitude": long,
  //         "device_type": deviceType,
  //         "device_token": devicetoken,
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       return SocialLoginResponse.fromJson(response.data);
  //     } else {
  //       throw Exception('Login failed with status code: ${response.statusCode}');
  //     }
  //   } on DioError catch (e) {
  //     throw Exception('Dio error: ${e.response?.statusCode} - ${e.response?.data}');
  //     // if (e.type == DioErrorType.) {
  //     //   throw Exception('Dio error: ${e.response?.statusCode} - ${e.response?.data}');
  //     // } else {
  //     //   throw Exception('Unexpected Dio error: ${e.message}');
  //     // }
  //   } catch (e) {
  //     throw Exception('Unexpected error: $e');
  //   }
  // }
}
