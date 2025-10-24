import 'package:demoproject/component/apihelper/common.dart';
import 'package:equatable/equatable.dart';

class FeedbackState extends Equatable {
  final String message;
  final ApiState status;

  const FeedbackState({this.message = "", this.status = ApiState.normal});
  @override
  List<Object?> get props => [message, status];
  FeedbackState copyWith({String? message, ApiState? status}) {
    return FeedbackState(
        message: message ?? this.message, status: status ?? this.status);
  }
}
