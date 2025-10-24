import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../model/getquestionresponse.dart';
import '../../repo/questionsrepository.dart';
import 'getquestiionstate.dart';

class GetQuestionCubit extends Cubit<GetQuestionState> {
  final Questionsrepository _repository;

  GetQuestionCubit(this._repository) : super(GetQuestionInitialState());

  Future<void> getQuestion() async {

    emit(GetQuestionLoadingState());

    try {
      final GetQuestionsResponse response = await _repository.getQuestion();
      emit(GetQuestionSuccessState(response));
    } on Exception catch (e) {
      emit(GetQuestionErrorState(e.toString()));
    }
  }

  Future<void> getQuestionRemaning() async {

    emit(GetQuestionLoadingState());

    try {
      final GetQuestionsResponse response = await _repository.getQuestionRemaning();
      emit(GetQuestionSuccessState(response));
    } on Exception catch (e) {
      emit(GetQuestionErrorState(e.toString()));
    }
  }
}
