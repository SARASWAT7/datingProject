import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/ui/dashboard/likes/modal/likedyouresponse.dart';
import 'package:equatable/equatable.dart';

class LikedYouState extends Equatable {
  final ApiStates status;
  final LikedYouResponse? response;
  const LikedYouState({this.response, this.status = ApiStates.normal});

  @override
  // TODO: implement props
  List<Object?> get props => [response, status];
  LikedYouState copyWith({LikedYouResponse? response, ApiStates? status}) {
    return LikedYouState(
        response: response ?? this.response, status: status ?? this.status);
  }
}
