import 'dart:developer';

import 'package:demoproject/component/apihelper/api_service.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/ui/auth/design/splash.dart';
import 'package:demoproject/ui/dashboard/explore/model/exploremodel.dart';
import 'package:demoproject/ui/dashboard/home/repository/urlpath.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExploreRepository {
  Future<ExploreResponse> explore() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString("token") ?? "";
    try {
      final response = await ApiService(token: token).sendRequest.get(
            UrlEndpoints.exploreApi,
          );

      log("${response.data} ==================> hello");
      return ExploreResponse.fromJson(response.data);
    } catch (e) {
      log("${e} DIV");
      DioException error = e as DioException;
      log(error.response?.data.toString() ?? "sds");
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }
}
