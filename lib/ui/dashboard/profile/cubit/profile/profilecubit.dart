// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:demoproject/component/alert_box.dart';
import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/profile/profilestate.dart';
import 'package:demoproject/ui/dashboard/profile/repository/service.dart';
import 'package:demoproject/ui/dashboard/profile/repository/userData.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../component/apihelper/api_service.dart';
import '../../../../../component/apihelper/toster.dart';
import '../../../../../component/apihelper/urls.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());
  CorettaUserProfileRepo repo = CorettaUserProfileRepo();

  void getprofile(BuildContext context) async {

    try {
      emit(state.copyWith(status: ApiState.isLoading));
      final response = await repo.profile();
      emit(state.copyWith(status: ApiState.success, profileResponse: response));

    } catch (e) {
      print("$e=======================++++++>");
      emit(state.copyWith(status: ApiState.error));
      NormalMessage.instance.normalerrorstate(context, e.toString());
    }
  }

  void updatePhotoList(String s) {
    emit(state.copyWith(status: ApiState.isLoading));
    log(s);
    List<String> data = state.selectedPhoto ?? [];
    if (data.contains(s)) {
      data.remove(s);
    } else {
      data.add(s);
    }
    emit(state.copyWith(selectedPhoto: data, status: ApiState.normal));
  }

  void deleteSelectedImages(BuildContext context) {}
  void deleteupdate(bool isDelete) {
    emit(state.copyWith(isDelete: isDelete));
  }

  void deleteMedia(BuildContext context) async {
    UpdateProfileDataRepo repo = UpdateProfileDataRepo();

    emit(state.copyWith(status: ApiState.isLoading));

    try {
      final response = await repo.delete12(state.selectedPhoto ?? []);

      getprofile(context);
      showToast(context, response);
      emit(state.copyWith(
          status: ApiState.normal, selectedPhoto: [], isDelete: false));

      // showToast(context, response);
      // return true;
    } catch (e) {
      getprofile(context);
      print("Error during media deletion: $e");

      emit(state.copyWith(
          status: ApiState.error, selectedPhoto: [], isDelete: false));
      throw e;

    }
  }


  logoutApi(BuildContext context,String deviceToken) async {
    try {
      emit(state.copyWith(status: ApiState.isLoading));
      final response = await repo.logout(deviceToken);
      emit(state.copyWith(status: ApiState.success));
      NormalMessage.instance.normalerrorstate(context, response);
    } catch (e) {
      print("$e=======================++++++>");
      emit(state.copyWith(status: ApiState.error));

      String errorMessage = e is DioException
          ? e.response?.data['message'] ?? 'An unknown error occurred'
          : 'An unknown error occurred';

      NormalMessage.instance.normalerrorstate(context, errorMessage);
    }
  }

  // logoutApi(BuildContext context, String deviceToken) async {
  //   try {
  //     emit(state.copyWith(status: ApiState.isLoading));
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var token = prefs.getString('token'); // Get the user's token for authentication
  //
  //     dio.options.headers['Content-Type'] = 'application/json';
  //     dio.options.headers['Authorization'] = 'Bearer $token'; // Pass the auth token
  //
  //     final response = await dio.patch(
  //       UrlEndpoints.Logout,
  //       data: {
  //         'deviceToken': deviceToken,
  //       },
  //     );
  //
  //     // Handle response
  //     emit(state.copyWith(status: ApiState.success));
  //     NormalMessage.instance.normalerrorstate(context, response.data['message']);
  //   } catch (e) {
  //     print("$e=======================++++++>");
  //     emit(state.copyWith(status: ApiState.error));
  //
  //     String errorMessage = e is DioException
  //         ? e.response?.data['message'] ?? 'An unknown error occurred'
  //         : 'An unknown error occurred';
  //
  //     NormalMessage.instance.normalerrorstate(context, errorMessage);
  //   }
  // }



}
