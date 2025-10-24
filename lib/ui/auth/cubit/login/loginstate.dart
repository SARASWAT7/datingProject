

// ignore: must_be_immutable
import 'package:equatable/equatable.dart';
import '../../../../component/apihelper/common.dart';


class LogInState extends Equatable {
  final String phoneNumber;
  final ApiState status;

  const LogInState({this.phoneNumber = "", this.status = ApiState.normal});
  @override
  List<Object?> get props => [phoneNumber, status];
  LogInState copyWith({String? phoneNumber, ApiState? status}) {
    return LogInState(
        phoneNumber: phoneNumber ?? this.phoneNumber, status: status ?? this.status);
  }
}
