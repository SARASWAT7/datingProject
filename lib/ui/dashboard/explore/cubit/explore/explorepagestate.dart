// import 'package:datingapp/feature/dashboard/explore/model/exploremodel.dart';
// import 'package:flutter/cupertino.dart';

// @immutable
// abstract class ExplorePageState {}

// class ExplorePageInitialState extends ExplorePageState {}

// class ExplorePageSuccessState extends ExplorePageState {
//   final ExploreResponse response;
//   ExplorePageSuccessState(this.response);
// }

// class ExplorePageLoadingState extends ExplorePageState {}

// class ExplorePageErrorState extends ExplorePageState {
//   final String message;
//   ExplorePageErrorState(this.message);
// }

import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/ui/dashboard/explore/model/exploremodel.dart';
import 'package:equatable/equatable.dart';

class ExploreState extends Equatable {
  final ApiStates status;
  final ExploreResponse? response;
  const ExploreState({this.response, this.status = ApiStates.normal});

  @override
  // TODO: implement props
  List<Object?> get props => [response, status];
  ExploreState copyWith({ExploreResponse? response, ApiStates? status}) {
    return ExploreState(
        response: response ?? this.response, status: status ?? this.status);
  }
}
