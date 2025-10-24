// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../component/alert_box.dart';
import '../../../../component/apihelper/common.dart';
import '../../../../component/apihelper/normalmessage.dart';
import '../../../../component/apihelper/toster.dart';
import '../../../../component/commonfiles/shared_preferences.dart';
import '../../../AuthRepository/authrepository.dart';
import '../../verify.dart';
import '../../verifyemail.dart';
import 'loginstate.dart';

class LogInCubit extends Cubit<LogInState> {
  LogInCubit() : super(const LogInState());

  void phone(String phone) {
    emit(state.copyWith(phoneNumber: phone));
  }

  Future<String> getDeviceType() async {
    if (Platform.isAndroid) {
      return '1'; // Android device type
    } else if (Platform.isIOS) {
      return '2'; // iOS device type
    }
    return '0'; // Default device type
  }

  void login(
      BuildContext context,
      String code,
      String phoneNumber,
      String lati,
      String longi,
      String fcmToken,
      ) async {
    AppUtils.keyboardHide(context);

    if (phoneNumber.isEmpty) {
      NormalMessage().normalerrorstate(
          context, 'Please enter your phone number.');
    } else if (!NormalMessage().phoneNumberRegex.hasMatch(phoneNumber)) {
      NormalMessage().normalerrorstate(context, 'Invalid phone number format.');
    } else {
      AuthRepository repo = AuthRepository();
      emit(state.copyWith(status: ApiState.isLoading));
      try {
        String deviceType = await getDeviceType();
        final response = await repo.login(
          context,
          code,
          phoneNumber,
          lati,
          longi,
          deviceType,
          fcmToken,
        );
        emit(state.copyWith(status: ApiState.normal));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyScreen(
              latitude:lati,
              longitute:longi,
              deviceToken:fcmToken,
              deviceType:deviceType,
              code: code,
              phoneNUmber: phoneNumber,
            ),
          ),
        );
      } catch (e) {
        handleError(context, e);
      }
    }
  }

  void email(
      BuildContext context,
      String code,
      String email,
      String lati,
      String longi,
      String fcmToken,
      ) async {
    AppUtils.keyboardHide(context);

    if (email.isEmpty) {
      NormalMessage().normalerrorstate(context, 'Please enter your email.');
    // } else if (!NormalMessage().phoneoremail.hasMatch(email)) {
    //   NormalMessage().normalerrorstate(context, 'Invalid email format.');
    } else {
      AuthRepository repo = AuthRepository();
      emit(state.copyWith(status: ApiState.isLoading));
      try {
        String deviceType = await getDeviceType();
        final response = await repo.emailLogin(
          context,
          "",
          email,
          lati,
          longi,
          deviceType,
          fcmToken,
        );
        emit(state.copyWith(status: ApiState.normal));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyEmailScreen(
              latitude:lati,
              longitute:longi,
              deviceToken:fcmToken,
              deviceType:deviceType,
              code: code,
              Email: email,
            ),
          ),
        );
      } catch (e) {
        handleError(context, e);
      }
    }
  }

  void handleError(BuildContext context, dynamic error) {
    log(error.toString());
    emit(state.copyWith(status: ApiState.error));
    if (error.toString() != "NO DATA FOUND") {
      NormalMessage().normalerrorstate(context, error.toString());
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertBox(title: error.toString()),
      );
    }
  }
}
