import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/ui/dashboard/profile/model/profileresponse.dart';
import 'package:equatable/equatable.dart';

import 'liveresponse.dart';

class LiveState extends Equatable {
  final ApiState status;
  final LiveResponse? liveResponse;

  const LiveState({this.liveResponse, this.status = ApiState.normal});

  @override
  List<Object?> get props => [status, liveResponse];

  LiveState copyWith({ApiState? status, LiveResponse? liveResponse}) {
    return LiveState(
      liveResponse: liveResponse ?? this.liveResponse,
      status: status ?? this.status,
    );
  }
}
