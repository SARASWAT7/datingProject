

// ignore: must_be_immutable
import 'package:equatable/equatable.dart';
import '../../../../component/apihelper/common.dart';


class BasicInformationState extends Equatable {

  final ApiState status;

  const BasicInformationState({ this.status = ApiState.normal});
  @override
  List<Object?> get props => [ status];
  BasicInformationState copyWith({ ApiState? status}) {
    return BasicInformationState(
       status: status ?? this.status);
  }
}
