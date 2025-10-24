// ignore_for_file: use_build_context_synchronously

import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../component/apihelper/normalmessage.dart';
import '../../../../component/apihelper/toster.dart';
import '../../../../component/commonfiles/shared_preferences.dart';
import '../../../AuthRepository/authrepository.dart';
import '../../verify.dart';
import '../login/loginstate.dart';

class LogInCubit extends Cubit<LogInState> {
  LogInCubit() : super(const LogInState());
  void phone(String phone) {
    emit(state.copyWith(phoneNumber: phone));
  }

  // void login(BuildContext context,String code, String phoneNumber) async {
  //   AppUtils.keyboardHide(context);
  //   if (phoneNumber.isEmpty) {
  //     NormalMessage().normalerrorstate(context, NormalMessage().phonetext);
  //   } else if (!NormalMessage()
  //       .phoneNumberRegex
  //       .hasMatch(phoneNumber.toString())) {
  //     NormalMessage().normalerrorstate(context, NormalMessage().phonenovalid);
  //   } else {
  //     AuthRepository repo = AuthRepository();
  //     emit(state.copyWith(status: ApiState.isLoading));
  //     try {
  //       final response =
  //           await repo.login(context,code, phoneNumber, "28.8768", "77.28","","");
  //       emit(state.copyWith(status: ApiState.normal));
  //       showToast(context, response.message.toString());
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (_) =>
  //                 VerifyScreen(code: code.toString(),phoneNUmber: phoneNumber.toString())),
  //       );
  //     } catch (e) {
  //       log(e.toString());
  //       emit(state.copyWith(status: ApiState.error));
  //       NormalMessage().normalerrorstate(context, e.toString());
  //     }
  //   }
  // }
}
