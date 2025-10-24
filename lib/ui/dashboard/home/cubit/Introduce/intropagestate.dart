import 'package:flutter/cupertino.dart';

@immutable
abstract class IntroStateState {}

class IntroStateInitialState extends IntroStateState {}

class IntroStateSuccess extends IntroStateState {
  final String response;
  IntroStateSuccess(this.response);
}

class IntroStateLoading extends IntroStateState {}

class IntroStateError extends IntroStateState {
  final String message;
  IntroStateError(this.message);
}

