// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../component/apihelper/common.dart';
import '../../../../component/apihelper/normalmessage.dart';
import '../../../../component/apihelper/toster.dart';
import '../../../../component/commonfiles/shared_preferences.dart';
import '../../../../component/reuseable_widgets/bottomTabBar.dart';
import '../../../AuthRepository/authrepository.dart';
import '../../../personalinformation/bio.dart';
import '../../../personalinformation/iam.dart';
import '../../../personalinformation/moreaboutme.dart';
import '../../../personalinformation/passion.dart';
import '../../../personalinformation/uploadimage.dart';
import '../../../quesition/quesition.dart';
import '../../design/myfirstnameis.dart';
import 'verifyotpwithphonestate.dart';

class VerifyOtpWithPhoneCubit extends Cubit<VerifyOtpWithPhoneState> {
  VerifyOtpWithPhoneCubit() : super(const VerifyOtpWithPhoneState());

  void opt(String otp) {
    emit(state.copyWith(otp: otp));
  }

  void verifyotpwithphone(BuildContext context,String code, String phone,String email ) async {
    AppUtils.keyboardHide(context);
    if (state.OTP.isEmpty) {
      NormalMessage().normalerrorstate(context, NormalMessage().otpEmpty);
    } else if (state.OTP.length < 4) {
      NormalMessage().normalerrorstate(context, NormalMessage().otplessEmpty);
    } else {
      AuthRepository repo = AuthRepository();
      emit(state.copyWith(status: ApiState.isLoading));
      try {
        String verificationType = email.isNotEmpty ? "email":"phone";
        final response =
            await repo.verifyotpwithphone(context, phone,email, state.OTP, verificationType);
        emit(state.copyWith(status: ApiState.normal));
        showToast(context, response.message.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.result?.token.toString() ?? '');
        if ((response.result?.user?.dob?.isEmpty ?? false)) {
          log("first name");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MyFirstName()),
          );
        } else if ((response.result?.user?.media?.isEmpty ?? false)) {
          log("media");
          await prefs.setBool('firstName', true);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UploadImage()),
          );
        } else if ((response.result?.user?.gender?.isEmpty ?? false)) {
          log("gender");
          await prefs.setBool('firstName', true);
          await prefs.setBool('UploadPhoto', true);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const IamScreen()),
          );
        } else if ((response.result?.user?.exercise?.isEmpty ?? false)) {
          log("more about me");
          await prefs.setBool('firstName', true);
          await prefs.setBool('UploadPhoto', true);
          await prefs.setBool('BasicInformation', true);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MoreAboutMeScreen()),
          );
        } else if ((response.result?.user?.bio?.isEmpty ?? false)) {
          print("bio ${response.result?.user?.bio}");
          await prefs.setBool('firstName', true);
          await prefs.setBool('UploadPhoto', true);
          await prefs.setBool('BasicInformation', true);
          await prefs.setBool('MoreAbout', true);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BioScreen()),
          );
        } else if ((response.result?.user?.passions?.isEmpty ?? false)) {
          log("passion");

          await prefs.setBool('firstName', true);
          await prefs.setBool('UploadPhoto', true);
          await prefs.setBool('BasicInformation', true);
          await prefs.setBool('MoreAbout', true);
          await prefs.setBool('Bio', true);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PassionScreen()),
          );
        } else if (((response.result?.user?.questionAnswerPercentage ?? 0) >
            30)) {
          log("questions");

          await prefs.setBool('firstName', true);
          await prefs.setBool('UploadPhoto', true);
          await prefs.setBool('BasicInformation', true);
          await prefs.setBool('MoreAbout', true);
          await prefs.setBool('Bio', true);
          await prefs.setBool('Passion', true);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QuesitionsPage()),
          );
        } else {
          await prefs.setBool('firstName', true);
          await prefs.setBool('UploadPhoto', true);
          await prefs.setBool('BasicInformation', true);
          await prefs.setBool('MoreAbout', true);
          await prefs.setBool('Bio', true);
          await prefs.setBool('Passion', true);
          await prefs.setBool('GetStart', true);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BottomBar()),
          );
        }
      } catch (e) {
        emit(state.copyWith(status: ApiState.error));
        NormalMessage().normalerrorstate(context, e.toString());
      }
    }
  }



  void resend(BuildContext context, String code,String phone,String latitude,String  longitude,String deviceType,String deviceToken) async {
    AppUtils.keyboardHide(context);
    if (phone.isEmpty) {
      NormalMessage().normalerrorstate(context, " NormalMessage().phonetext");
    } else {
      AuthRepository repo = AuthRepository();
      emit(state.copyWith(status: ApiState.isLoading));
      try {
        final response = await repo.login(context,code, phone, longitude,latitude,deviceType,deviceToken);
        emit(state.copyWith(status: ApiState.normal));
        showToast(context, response.message.toString());
      } catch (e) {
        emit(state.copyWith(status: ApiState.error));
        NormalMessage().normalerrorstate(context, e.toString());
      }
    }
  }

  void resendEmail(BuildContext context, String email,String latitude,String  longitude,String,String deviceType,String deviceToken) async {
    AppUtils.keyboardHide(context);
    if (email.isEmpty) {
      NormalMessage().normalerrorstate(context, "otp resend ");
    } else {
      AuthRepository repo = AuthRepository();
      emit(state.copyWith(status: ApiState.isLoading));
      try {
        final response = await repo.emailLogin(context, "",email,latitude,longitude,deviceType,deviceToken);
        emit(state.copyWith(status: ApiState.normal));
        showToast(context, response.message.toString());
      } catch (e) {
        emit(state.copyWith(status: ApiState.error));
        NormalMessage().normalerrorstate(context, e.toString());
      }
    }
  }
}
