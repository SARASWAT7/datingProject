import 'package:flutter/cupertino.dart';

import '../../model/getquestionresponse.dart';

@immutable
abstract class GetQuestionState {}

class GetQuestionInitialState extends GetQuestionState {}

class GetQuestionSuccessState extends GetQuestionState {
  final GetQuestionsResponse response;
  GetQuestionSuccessState(this.response);
}

class GetQuestionLoadingState extends GetQuestionState {}

class GetQuestionErrorState extends GetQuestionState {
  final String message;
  GetQuestionErrorState(this.message);
}
