import 'dart:developer';

import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/Faq/faqstate.dart';
import 'package:demoproject/ui/dashboard/profile/repository/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class FaqCubit extends Cubit<FaqState> {
//   FaqCubit() : super(const FaqState());
//   CorettaUserProfileRepo repo = CorettaUserProfileRepo();
//   void getFaq(BuildContext context) async {
//     try {
//       emit(state.copyWith(status: ApiState.isLoading));
//       final response = await repo.faq();
//       emit(state.copyWith(status: ApiState.success, response: response));
//     } catch (e) {
//       log("$e=======================++++++>");
//       emit(state.copyWith(status: ApiState.error));
//       NormalMessage.instance.normalerrorstate(context, e.toString());
//     }
//   }
// }

class FaqCubit extends Cubit<FaqState> {
  FaqCubit() : super(const FaqState());
  CorettaUserProfileRepo repo = CorettaUserProfileRepo();

  void getFaq(BuildContext context) async {
    emit(state.copyWith(status: ApiStates.loading));
    try {
      // updateUserDatatoFirebase();

      final response = await repo.faq();
      emit(state.copyWith(status: ApiStates.success, response: response));
    } catch (e) {
      log("${e} zssss");
      emit(state.copyWith(status: ApiStates.error));
      NormalMessage.instance.normalerrorstate(context, e.toString());
    }
  }
}
