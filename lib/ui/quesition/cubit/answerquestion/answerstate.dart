import 'package:flutter/cupertino.dart';

@immutable
abstract class AnswerState {}

class AnswerInitialState extends AnswerState {}

class AnswerSuccessState extends AnswerState {
  final String response;
  AnswerSuccessState(this.response);
}

class AnswerLoadingState extends AnswerState {}

class AnswerErrorState extends AnswerState {
  final String message;
  AnswerErrorState(this.message);
}
