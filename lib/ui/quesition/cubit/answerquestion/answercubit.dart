import 'package:bloc/bloc.dart';

import '../../repo/questionsrepository.dart';
import 'answerstate.dart';

class AnswerCubit extends Cubit<AnswerState> {
  final Questionsrepository _repository;

  AnswerCubit(this._repository) : super(AnswerInitialState());

  Future<void> answerQuestion(
      String questionId, List answer, String comment, String mainAnswer) async {
    try {
      emit(AnswerLoadingState());

      String response = await _repository.answerQuestion(
          questionId, answer, comment, mainAnswer);

      emit(AnswerSuccessState(response));
    } catch (e) {
      emit(AnswerErrorState(e.toString()));
    }
  }


  Future<void> answerQuestionRemaning(
      String questionId, List answer, String comment, String mainAnswer) async {
    try {
      emit(AnswerLoadingState());

      String response = await _repository.answerQuestionRemaning(
          questionId, answer, comment, mainAnswer);

      emit(AnswerSuccessState(response));
    } catch (e) {
      emit(AnswerErrorState(e.toString()));
    }
  }
}
