

import 'package:equatable/equatable.dart';
import '../../../../component/apihelper/common.dart';


class VerifyOtpWithPhoneState extends Equatable {
  final String OTP;
  final ApiState status;

  const VerifyOtpWithPhoneState({this.OTP = "", this.status = ApiState.normal});
  @override
  List<Object?> get props => [OTP, status];

  VerifyOtpWithPhoneState copyWith({String? otp, ApiState? status}) {
    return VerifyOtpWithPhoneState(
        OTP: otp ?? this.OTP, status: status ?? this.status);
  }
}
