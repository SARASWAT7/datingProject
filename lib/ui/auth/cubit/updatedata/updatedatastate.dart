

// ignore: must_be_immutable
import 'package:equatable/equatable.dart';
import '../../../../component/apihelper/common.dart';


class UpdateDataState extends Equatable {
  final String description;
  final ApiState status;

  const UpdateDataState({this.description = "", this.status = ApiState.normal});
  @override
  List<Object?> get props => [description, status];
  UpdateDataState copyWith({String? description, ApiState? status}) {
    return UpdateDataState(
        description: description ?? this.description, status: status ?? this.status);
  }
}
