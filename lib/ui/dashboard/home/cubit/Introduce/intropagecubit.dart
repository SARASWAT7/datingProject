import 'package:bloc/bloc.dart';

import '../../repository/homerepository.dart';
import 'intropagestate.dart';

class IntroAddCubit extends Cubit<IntroStateState> {
  final HomeRepository  _repository;

  IntroAddCubit(this._repository) : super(IntroStateInitialState());

  Future<void> getIntroState(String userId, String message) async {
    try {
      emit(IntroStateLoading());
      print("pushkar");
      print(message);

      String response = await _repository.addIntro(userId, message);

      emit(IntroStateSuccess(response));
    } catch (e) {
      emit(IntroStateError(e.toString()));
    }
  }


  Future<void> getIntro(String userid, String type, String messages, ) async {
    try {
      emit(IntroStateLoading());

      String response = await _repository.reportblock(userid, type, messages);

      emit(IntroStateSuccess(response));

      // log(deleteResponse.toString());
    } catch (e) {
      emit(IntroStateError(e.toString()));
    }
  }



}
