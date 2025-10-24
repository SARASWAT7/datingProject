import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoproject/ui/dashboard/home/repository/homerepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../videocallcubit/videostate.dart';
import 'callstate.dart';

class AcceptRejectCubit extends Cubit<AcceptRejectState> {
  AcceptRejectCubit() : super(const AcceptRejectState());

  Future<void> getUserData(String userId) async {
    HomeRepository repo = HomeRepository();
    emit(state.copyWith(callStatus: CallState.loading));
    try {
      final response = await repo.byidFireBase(userId);
      log("message${response.result?.user?.media?.first ?? ""}");
      emit(state.copyWith(
          callStatus: CallState.wating,
          senderImage: response.result?.user?.media?.first ?? "assets/images/nopicdummysq.png",
          sendername: response.result?.user?.firstName));
    } catch (e) {
      emit(state.copyWith(
          callStatus: CallState.error,
          senderImage: "assets/images/nopicdummysq.png"));
    }
  }
}
