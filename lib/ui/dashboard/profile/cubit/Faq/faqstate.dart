import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/ui/dashboard/profile/model/faqresponse.dart';
import 'package:equatable/equatable.dart';

// class FaqState extends Equatable {
//   final ApiState status;
//   final FaqResponse? response;
//   const FaqState({this.response, this.status = ApiState.normal});
//   @override
//   List<Object?> get props => [status, response];

//   FaqState copyWith({ApiState? status, FaqState? response}) {
//     return FaqState(
//         response: response ?? this.response, status: status ?? this.status);
//   }
// }

class FaqState extends Equatable {
  final ApiStates status;
  final FaqResponse? response;
  const FaqState({this.response, this.status = ApiStates.normal});

  @override
  // TODO: implement props
  List<Object?> get props => [response, status];
  FaqState copyWith({FaqResponse? response, ApiStates? status}) {
    return FaqState(
        response: response ?? this.response, status: status ?? this.status);
  }
}
