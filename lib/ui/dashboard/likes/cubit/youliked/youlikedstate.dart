import 'package:demoproject/ui/dashboard/likes/modal/likedyouresponse.dart';
import 'package:equatable/equatable.dart';

import '../../../../../component/apihelper/urls.dart';
import '../../modal/youlikeresponse.dart';

class YouLikedState extends Equatable {
  final ApiStates status;
  final YouLikedResponse? response;

  const YouLikedState({this.response, this.status = ApiStates.normal});

  @override
  List<Object?> get props => [response, status];

  YouLikedState copyWith({YouLikedResponse? response, ApiStates? status}) {
    return YouLikedState(
        response: response ?? this.response, status: status ?? this.status);
  }
}
