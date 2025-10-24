// ignore_for_file: use_build_context_synchronously

import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../component/apihelper/common.dart';
import '../../../../component/apihelper/normalmessage.dart';
import '../../../../component/apihelper/toster.dart';
import '../../../../component/commonfiles/shared_preferences.dart';
import '../../../AuthRepository/authrepository.dart';
import '../../../personalinformation/getstarted.dart';
import '../../../personalinformation/passion.dart';
import 'updatedatastate.dart';

class UpdateDataCubit extends Cubit<UpdateDataState> {
  UpdateDataCubit() : super(const UpdateDataState());
  void bio(String description) {
    emit(state.copyWith(description: description));
  }

  void updatedata(BuildContext context, {Widget? nextPage}) async {
    AppUtils.keyboardHide(context);
    if (state.description.isEmpty) {
      NormalMessage().normalerrorstate(context, NormalMessage().bio);
    } else {
      AuthRepository repo = AuthRepository();
      emit(state.copyWith(status: ApiState.isLoading));
      try {
        final response = await repo.updatedata(context, state.description);
        emit(state.copyWith(status: ApiState.normal));
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("Bio", true);
        showToast(context, response);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage ?? PassionScreen()),
        );
      } catch (e) {
        log(e.toString());
        emit(state.copyWith(status: ApiState.error));
        NormalMessage().normalerrorstate(context, e.toString());
      }
    }
  }

  void paasion(BuildContext context, List passionList) async {
    AppUtils.keyboardHide(context);

    if (passionList.isEmpty) {
      NormalMessage().normalerrorstate(context, NormalMessage().passion);
    } else {
      AuthRepository repo = AuthRepository();
      emit(state.copyWith(status: ApiState.isLoading));

      try {
        final response = await repo.paasion(context, passionList);
        emit(state.copyWith(status: ApiState.normal));
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("Passion", true);

        showToast(context, response);
        Navigator.push(context, MaterialPageRoute(builder: (context) => GetStarted()));

      } catch (e) {
        log(e.toString());
        emit(state.copyWith(status: ApiState.error));
        NormalMessage().normalerrorstate(context, e.toString());
      }
    }
  }






}
