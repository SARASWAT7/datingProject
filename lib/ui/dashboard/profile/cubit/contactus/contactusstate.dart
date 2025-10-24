import 'package:demoproject/component/apihelper/common.dart';
import 'package:equatable/equatable.dart';

class ContactUsState extends Equatable {
  final String message;
  final ApiState status;

  const ContactUsState({this.message = "", this.status = ApiState.normal});
  @override
  List<Object?> get props => [message, status];
  ContactUsState copyWith({String? message, ApiState? status}) {
    return ContactUsState(
        message: message ?? this.message, status: status ?? this.status);
  }
}
