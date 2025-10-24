import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../component/apihelper/urls.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../reels/model/profilereelsresponse.dart';
import '../model/profileresponse.dart';

class UpdateProfileDataRepo {
  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: UrlEndpoints.baseUrl,
  );
  Dio dio = Dio(_baseOptions);

  Future<String> quotes(BuildContext context, Map<String, dynamic> data) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");

      final response = await dio.post(
        UrlEndpoints.updatedata,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: json.encode(data),
      );

      if (response.statusCode == 200) {
        final result = response.data;

        if (result is Map<String, dynamic> && result.containsKey('quote')) {
          return result['message'];
        }
        return 'Quotes updated successfully';
      } else {
        return 'Failed to update quotes. Status code: ${response.statusCode}';
      }
    } catch (e) {
      print('Error in quotes method: ${e.toString()}');
      return 'An error occurred: ${e.toString()}';
    }
  }

  //////////////update edit photos///////////////////

  Future<String> updateVerifyPhoto(String imagePhotoPath) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      MultipartFile file = await MultipartFile.fromFile(
        imagePhotoPath,
        filename: imagePhotoPath.split('/').last,
      );

      var token = prefs.getString('token');
      if (token == null) {
        throw "Authorization token not found.";
      }
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      dio.options.headers['Authorization'] = 'Bearer $token';

      FormData formData = FormData.fromMap({
        "file": file,
      });

      final response = await dio.post(
        UrlEndpoints.uploadProfile,
        data: formData,
      );

      if (response.data == null) {
        throw "Unexpected null response data";
      }
      return response.data["message"];
    } on DioError catch (e) {
      throw e.response?.data['message'] ?? "An error occurred during upload.";
    } catch (e) {
      print(
          "An unexpected error occurred: $e =======================================>");
      throw "An unexpected error occurred: ${e.toString()}";
    }
  }

  /////////////////////media////////////////////

  Future<String> addMedia(BuildContext context, List<String> imagePaths) async {
    log(imagePaths.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<MultipartFile> upload = [];

    for (int i = 0; i < imagePaths.length; i++) {
      upload.add(await MultipartFile.fromFile(
        imagePaths[i],
        filename: imagePaths[i].split('/').last,
      ));
    }

    var token = prefs.getString('token') ?? "";
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.post(UrlEndpoints.addphoto,
          data: FormData.fromMap({
            "file": upload,
          }));

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


  /////////////////////////uploadreels////////////////////////
  Future<String> addReels(BuildContext context, String videoPath, String caption) async {
    log(videoPath.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token') ?? "";
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      MultipartFile videoFile = await MultipartFile.fromFile(
        videoPath,
        filename: videoPath.split('/').last,
      );

      final response = await dio.post(
        UrlEndpoints.reelsUpload,
        data: FormData.fromMap({
          "video": videoFile,
          "caption": caption,
        }),
      );
      print("1234567890");
      print(response);

      return response.data["message"];
    } catch (error) {
      if (error is DioException) {
        final errorMessage = error.response?.data['message'] ?? 'An error occurred';
        throw Exception(errorMessage);
      } else {
        throw Exception('An unexpected error occurred');
      }
    }
  }


  ///////////////////moreaboutmerepoprofiledataupdate////////////

  Future<String> moreaboutmeProfile(FormData formData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.post(UrlEndpoints.updatedata, data: formData);
      return response.data['message'];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'An unknown error occurred';
    } catch (e) {
      throw 'An unknown error occurred: $e';
    }
  }

  //////////////showbio///////////
  Future<String> show(BuildContext context, Map<String, dynamic> data) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");

      if (token == null) {
        return 'Token not found';
      }

      final response = await dio.post(
        UrlEndpoints.updatedata,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: json.encode(data),
      );
      if (response.statusCode == 200) {
        final result = response.data;

        if (result is Map<String, dynamic> && result.containsKey('message')) {
          return result['message'];
        }
        return 'Show Profile updated successfully';
      } else {
        return 'Failed to Show Bio. Status code: ${response.statusCode}';
      }
    } catch (e) {
      print('Error in Show Bio method: ${e.toString()}');
      return 'An error occurred: ${e.toString()}';
    }
  }

  ////////////////////////////deletemedia////////////////////////

  Future<String> delete12(List<String> imageUrls) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? "";

    log("Deleting the following imagess: $imageUrls");

    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    log("${{
      'location_url': imageUrls,
    }}");
    try {
      final response = await dio.delete(UrlEndpoints.DeleteMedia, data: {
        'location_url':
            imageUrls, // Ensure this matches the backend expectation
      });
      log(response.data['message'].toString());
      return response.data["message"];
    } catch (error) {
      throw Exception(error.toString());

    }
  }
  /////////////////verificationrepo/////////////////


  Future<String> verification(String imagePhotoPath) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      MultipartFile file = await MultipartFile.fromFile(
        imagePhotoPath,
        filename: imagePhotoPath.split('/').last,
      );

      var token = prefs.getString('token');
      if (token == null) {
        throw "Authorization token not found.";
      }
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      dio.options.headers['Authorization'] = 'Bearer $token';

      FormData formData = FormData.fromMap({
        "file": file,
        "profile_verified": "yes",

      });

      final response = await dio.post(
        UrlEndpoints.verificationprofile,
        data: formData,
      );

      if (response.data == null) {
        throw "Unexpected null response data";
      }
      return response.data["message"];
    } on DioError catch (e) {
      throw e.response?.data['message'] ?? "An error occurred during upload.";
    } catch (e) {
      print(
          "An unexpected error occurred: $e =======================================>");
      throw "An unexpected error occurred: ${e.toString()}";
    }
  }




}
