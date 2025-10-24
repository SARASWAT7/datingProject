import 'package:flutter/cupertino.dart';

@immutable
abstract class MoreAboutMeProfileState {}

class MoreAboutMeProfileInitialState extends MoreAboutMeProfileState {}

class MoreAboutMeProfileSuccess extends MoreAboutMeProfileState {
  final String response;
  MoreAboutMeProfileSuccess(this.response);
}

class MoreAboutMeProfileLoading extends MoreAboutMeProfileState {}

class MoreAboutMeProfileError extends MoreAboutMeProfileState {
  final String message;
  MoreAboutMeProfileError(this.message);
}
