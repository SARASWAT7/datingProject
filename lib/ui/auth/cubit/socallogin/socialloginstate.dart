import 'package:flutter/foundation.dart';

import '../../model/socialmodel.dart';

@immutable
abstract class LoginSocialState {}

class LoginSocialInitialState extends LoginSocialState {}

class LoginSocialLoadingState extends LoginSocialState {}

class LoginSocialSuccessState extends LoginSocialState {
  final SocialLoginResponse socialLoginResponse;

  LoginSocialSuccessState({required this.socialLoginResponse});
}

class LoginSocialErrorState extends LoginSocialState {
  final String error;

  LoginSocialErrorState({required this.error});
}
