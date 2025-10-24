// import 'package:demoproject/ui/reels/model/mycomment.dart';
//
// import '../../../../component/apihelper/urls.dart';
// import '../../model/allreelsresponse.dart';
// import '../../model/commentresponse.dart';
//
// class AllReelsState {
//   final ApiStates status;
//   final AllReelsResponse? response;
//   final GetCommentsResponse? responseCmt;
//   final MyCommentsResponse? myCommentsResponse;
//   final String? errorMessage;
//
//   const AllReelsState({
//     this.status = ApiStates.normal,
//     this.response,
//     this.responseCmt,
//     this.myCommentsResponse,
//     this.errorMessage,
//   });
//
//   AllReelsState copyWith({
//     ApiStates? status,
//     AllReelsResponse? response,
//     GetCommentsResponse? responseCmt,
//     MyCommentsResponse? myCommentsResponse,
//     String? errorMessage,
//   }) {
//     return AllReelsState(
//       status: status ?? this.status,
//       response: response ?? this.response,
//       responseCmt: responseCmt ?? this.responseCmt,
//       myCommentsResponse: myCommentsResponse ?? this.myCommentsResponse,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }
// }

import '../../../../component/apihelper/urls.dart';
import '../../model/allreelsresponse.dart';
import '../../model/commentresponse.dart';
import '../../model/mycomment.dart';

class AllReelsState {
  final ApiStates status;
  final AllReelsResponse? response;
  final GetCommentsResponse? responseCmt;
  final MyCommentsResponse? myCommentsResponse;
  final String? errorMessage;
  final int currentPage; // Add currentPage to track page number

  const AllReelsState({
    this.status = ApiStates.normal,
    this.response,
    this.responseCmt,
    this.myCommentsResponse,
    this.errorMessage,
    this.currentPage = 1, // Default to page 1
  });

  AllReelsState copyWith({
    ApiStates? status,
    AllReelsResponse? response,
    GetCommentsResponse? responseCmt,
    MyCommentsResponse? myCommentsResponse,
    String? errorMessage,
    int? currentPage, // Include currentPage in copyWith
  }) {
    return AllReelsState(
      status: status ?? this.status,
      response: response ?? this.response,
      responseCmt: responseCmt ?? this.responseCmt,
      myCommentsResponse: myCommentsResponse ?? this.myCommentsResponse,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage, // Update currentPage
    );
  }
}
