// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dashboard/home/repository/homerepository.dart';
import '../model/getuserbyidmodel.dart';
import 'getuserbyidstate.dart';

class GetUserByIdCubit extends Cubit<GetUserByIdState> {
  final HomeRepository _repository;

  GetUserByIdCubit(this._repository) : super(GetUserByIdInitialState());

  Future<void> getUserById(String userId) async {
    try {
      emit(GetUserByIdLoading());

      GetUserByUserIDModel homeResponse = await _repository.userbyid(userId);

      emit(GetUserByIdSuccess(homeResponse));
    } catch (e) {
      emit(GetUserByIdError(e.toString()));
    }
  }


  ////////////////onlygetdatabyid//////////////////

  Future<void> UserById(String id) async {
    try {
      emit(GetUserByIdLoading());

      GetUserByUserIDModel homeResponse = await _repository.byid(id);

      emit(GetUserByIdSuccess(homeResponse));
    } catch (e) {
      emit(GetUserByIdError(e.toString()));
    }
  }

  // Future<void> getUserByFirebaseId(String userId) async {
  //   try {
  //     emit(GetUserByIdLoading());
  //
  //     GetUserByUserIDModel homeResponse =
  //     await _repository.userbyFirebaseid(userId);
  //
  //     emit(GetUserByIdSuccess(homeResponse));
  //   } catch (e) {
  //     emit(GetUserByIdError(e.toString()));
  //   }
  // }
}
