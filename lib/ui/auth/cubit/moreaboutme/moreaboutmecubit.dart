// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../component/apihelper/common.dart';
import '../../../../component/apihelper/normalmessage.dart';
import '../../../../component/apihelper/toster.dart';
import '../../../../component/commonfiles/shared_preferences.dart';
import '../../../AuthRepository/authrepository.dart';
import '../../../personalinformation/bio.dart';
import 'moreaboutmestate.dart';

class MoreAboutMeCubit extends Cubit<MoreAboutMeState> {
  MoreAboutMeCubit() : super(const MoreAboutMeState());

  void moreabout(
    BuildContext context,
    String exercise,
    String smoking,
    String drinking,
    String religion,
    String have_kids,
    String politic,
    String pet,
    String lang,
    String relationshiopstatus,
    String sunsign,
  ) async {
    AppUtils.keyboardHide(context);
    AuthRepository repo = AuthRepository();
    emit(state.copyWith(status: ApiState.isLoading));
    try {
      final response = await repo.moreabout(
        context,
        FormData.fromMap({
          "exercise": exercise,
          "smoking": smoking,
          "drinking": drinking,
          "religion": religion,
          "have_kids": have_kids,
          "politic": politic,
          "pet": pet,
          "languages": lang,
          "relationship_status": relationshiopstatus,
          "sun_sign": sunsign,
        }),
      );
      emit(state.copyWith(status: ApiState.normal));
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("MoreAbout", true);
      showToast(context, response);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BioScreen(),
          //gender: selectedButon,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ApiState.error));
      NormalMessage().normalerrorstate(context, e.toString());
    }
    // }
  }
}
