import 'dart:developer';

import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/dataprivacy/dataprivacystate.dart';
import 'package:demoproject/ui/dashboard/profile/repository/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataprivacyCubit extends Cubit<DataprivacyState> {
  DataprivacyCubit() : super(const DataprivacyState());
  CorettaUserProfileRepo repo = CorettaUserProfileRepo();

  void getDataPrivacy(BuildContext context) async {
    emit(state.copyWith(status: ApiStates.loading));
    try {
      // updateUserDatatoFirebase();

      final response = await repo.dataPrivacy();
      emit(state.copyWith(status: ApiStates.success, response: response));
    } catch (e) {
      log("${e} zssss");
      emit(state.copyWith(status: ApiStates.error));
      NormalMessage.instance.normalerrorstate(context, e.toString());
    }
  }
}
