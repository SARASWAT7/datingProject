// import 'package:flutter_bloc/flutter_bloc.dart';

// class ExplorePageCubit extends Cubit<ExplorePageState> {
//   final DatingAppAuthRepo _repository;

//   ExplorePageCubit(this._repository) : super(ExplorePageInitialState());

//   Future<void> explorePage() async {
//     try {
//       emit(ExplorePageLoadingState());

//       ExploreResponse deviceResponse = await _repository.explorepage();

//       emit(ExplorePageSuccessState(deviceResponse));

//       // log(deleteResponse.toString());
//     } catch (e) {
//       emit(ExplorePageErrorState(e.toString()));
//     }
//   }
// }

import 'dart:convert';
import 'dart:developer';

import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/ui/dashboard/explore/cubit/explore/explorepagestate.dart';
import 'package:demoproject/ui/dashboard/explore/repository/explorerepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit() : super(const ExploreState());
  ExploreRepository repo = ExploreRepository();

  void exploredata(BuildContext context) async {
    emit(state.copyWith(status: ApiStates.loading));
    try {
      final response = await repo.explore();
      emit(state.copyWith(status: ApiStates.success, response: response));
    } catch (e) {
      log("${e} zssss");
      emit(state.copyWith(status: ApiStates.error));
      NormalMessage.instance.normalerrorstate(context, e.toString());
    }
  }

}
