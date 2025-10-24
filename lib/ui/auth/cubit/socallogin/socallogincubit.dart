import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:demoproject/ui/auth/cubit/socallogin/socialloginstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../component/reuseable_widgets/bottomTabBar.dart';
import '../../../AuthRepository/authrepository.dart';
import '../../../personalinformation/bio.dart';
import '../../../personalinformation/iam.dart';
import '../../../personalinformation/moreaboutme.dart';
import '../../../personalinformation/passion.dart';
import '../../../personalinformation/uploadimage.dart';
import '../../../quesition/quesition.dart';
import '../../design/myfirstnameis.dart';

class LoginSocialCubit extends Cubit<LoginSocialState> {
  final AuthRepository _repository;
  String deviceType = "";
  String deviceToken = "";
  String token = "";

  LoginSocialCubit(this._repository) : super(LoginSocialInitialState());

  Future<void> getDeviceInfo() async {
    if (Platform.isAndroid) {
      deviceType = "1";
    } else if (Platform.isIOS) {
      deviceType = "2";
    }
  }

  Future<void> signInWithGoogle(
    String idToken,
    String lat,
    String long,
    String deviceType,
    String devicetoken,
    BuildContext context,
  ) async {
    try {
      emit(LoginSocialLoadingState());
      final prefs = await SharedPreferences.getInstance();

      final response = await _repository.socialLogin(
        idToken,
        lat,
        long,
        deviceType,
        devicetoken,
      );

      final token = response.result?.token ?? '';
      await prefs.setString('token', token);
      log("Stored Token: $token");
      log("user resoonse: ${jsonEncode(response.result?.userData?.email)}");

      final user = response.result?.userData;
      log("dob value: ${user?.dob.toString()}");

      if (user?.dob?.toString().isEmpty ?? true) {
        log("Navigating to First Name");
        _navigateTo(context, const MyFirstName());
      } else if (user?.media?.isEmpty ?? true) {
        log("Navigating to Upload Image");
        await _setPrefs(prefs, ['firstName']);
        _navigateTo(context, const UploadImage());
      } else if (user?.gender?.isEmpty ?? true) {
        log("Navigating to Gender Selection");
        await _setPrefs(prefs, ['firstName', 'UploadPhoto']);
        _navigateTo(context, const IamScreen());
      } else if (user?.exercise?.isEmpty ?? true) {
        log("Navigating to More About Me");
        await _setPrefs(prefs, [
          'firstName',
          'UploadPhoto',
          'BasicInformation',
        ]);
        _navigateTo(context, const MoreAboutMeScreen());
      } else if (user?.bio?.isEmpty ?? true) {
        log("Navigating to Bio Screen");
        await _setPrefs(prefs, [
          'firstName',
          'UploadPhoto',
          'BasicInformation',
          'MoreAbout',
        ]);
        _navigateTo(context, const BioScreen());
      } else if (user?.passions?.isEmpty ?? true) {
        log("Navigating to Passion Screen");
        await _setPrefs(prefs, [
          'firstName',
          'UploadPhoto',
          'BasicInformation',
          'MoreAbout',
          'Bio',
        ]);
        _navigateTo(context, const PassionScreen());
      } else if ((user?.questionAnswerPercentage ?? 0) > 30) {
        log("Navigating to Questions Page");
        await _setPrefs(prefs, [
          'firstName',
          'UploadPhoto',
          'BasicInformation',
          'MoreAbout',
          'Bio',
          'Passion',
        ]);
        _navigateTo(context, const QuesitionsPage());
      } else {
        log("Navigating to BottomBar");
        await _setPrefs(prefs, [
          'firstName',
          'UploadPhoto',
          'BasicInformation',
          'MoreAbout',
          'Bio',
          'Passion',
          'GetStart',
        ]);
        _navigateTo(context, const BottomBar());
      }
      emit(LoginSocialSuccessState(socialLoginResponse: response));
    } catch (e) {
      log("Error during social login: $e");
      emit(LoginSocialErrorState(error: e.toString()));
    }
  }

  Future<void> _setPrefs(SharedPreferences prefs, List<String> keys) async {
    for (var key in keys) {
      await prefs.setBool(key, true);
    }
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> signInWithApple(
    String idToken,
    String devicetoken,
    String lat,
    String long,
    String deviceType,
    BuildContext context,
  ) async {
    try {
      emit(LoginSocialLoadingState());

      final response = await _repository.appleLogin(
        idToken,
        devicetoken,
        deviceType,
        lat,
        long,
      );
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', response.result?.token ?? '');

      if ((response.result?.userData?.dob?.isEmpty ?? false)) {
        log("first name");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyFirstName()),
        );
      } else if ((response.result?.userData?.media?.isEmpty ?? false)) {
        log("media");
        await prefs.setBool('firstName', true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UploadImage()),
        );
      } else if ((response.result?.userData?.gender?.isEmpty ?? false)) {
        log("gender");
        await prefs.setBool('firstName', true);
        await prefs.setBool('UploadPhoto', true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const IamScreen()),
        );
      } else if ((response.result?.userData?.exercise?.isEmpty ?? false)) {
        log("more about me");
        await prefs.setBool('firstName', true);
        await prefs.setBool('UploadPhoto', true);
        await prefs.setBool('BasicInformation', true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MoreAboutMeScreen()),
        );
      } else if ((response.result?.userData?.bio?.isEmpty ?? false)) {
        log("bio");
        await prefs.setBool('MoreAbout', true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BioScreen()),
        );
      } else if ((response.result?.userData?.passions?.isEmpty ?? false)) {
        log("passion");
        await prefs.setBool('Bio', true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PassionScreen()),
        );
      } else if ((response.result?.userData?.questionAnswerPercentage ?? 0) >
          30) {
        log("questions");
        await prefs.setBool('Passion', true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuesitionsPage()),
        );
      } else {
        await prefs.setBool('GetStart', true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BottomBar()),
        );
      }
      emit(LoginSocialSuccessState(socialLoginResponse: response));
    } catch (e) {
      log("Error during Apple Login: $e");
      emit(LoginSocialErrorState(error: e.toString()));
    }
  }
}
