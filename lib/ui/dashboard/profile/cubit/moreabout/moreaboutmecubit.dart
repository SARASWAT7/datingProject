import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../component/apihelper/toster.dart';
import '../../../../../component/commonfiles/shared_preferences.dart';
import '../../moreaboutme/moreAboutMe.dart';
import '../../repository/userData.dart';
import 'moreaboutmestate.dart';

class MoreAboutMeProfileCubit extends Cubit<MoreAboutMeProfileState> {
  final UpdateProfileDataRepo _repository;

  MoreAboutMeProfileCubit(this._repository)
      : super(MoreAboutMeProfileInitialState());

  Future<void> moreAboutMeProfile(BuildContext context, FormData formData) async {
    AppUtils.keyboardHide(context);
    try {
      emit(MoreAboutMeProfileLoading());
      String response = await _repository.moreaboutmeProfile(formData);
      emit(MoreAboutMeProfileSuccess(response));
      if (response == 'Profile updated successfully') {
      } else {
        showToast(context, response);
      }
    } catch (e) {
      emit(MoreAboutMeProfileError(e.toString()));
    }
  }
}
