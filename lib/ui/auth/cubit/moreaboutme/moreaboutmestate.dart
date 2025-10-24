

// ignore: must_be_immutable
import 'package:equatable/equatable.dart';
import '../../../../component/apihelper/common.dart';


class MoreAboutMeState extends Equatable {

  final ApiState status;

  const MoreAboutMeState({ this.status = ApiState.normal});
  @override
  List<Object?> get props => [ status];
  MoreAboutMeState copyWith({ ApiState? status}) {
    return MoreAboutMeState(
       status: status ?? this.status);
  }
}
