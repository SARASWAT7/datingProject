import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/design/splash.dart';
import '../../dashboard/home/repository/homerepository.dart';
import '../model/agreedisagreeresponse.dart';
import 'adstate.dart';

class AgreeCubit extends Cubit<AgreeState> {
  final HomeRepository _repository;

  AgreeCubit(this._repository) : super(AgreeInitial());

  Future<void> getAgreeDisagreeData(String userId) async {
    print("123456781111");
    print(userId);
    try {
      emit(AgreeLoading());

      AgreeDisagreeResponse agreeResponse = await _repository.fetchAgreeDisagree(userId);

      emit(AgreeSuccess(agreeResponse: agreeResponse));
    } catch (e) {
      emit(AgreeFailure(message: e.toString()));
    }
  }

}
