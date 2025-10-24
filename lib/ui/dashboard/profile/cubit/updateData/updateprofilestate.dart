import 'package:equatable/equatable.dart';
import '../../../../../component/apihelper/common.dart';

class UpdateProfileState extends Equatable {
  final String description;
  final ApiState status;

  // Constructor with default values
  const UpdateProfileState({
    this.description = "",
    this.status = ApiState.normal
  });

  @override
  List<Object?> get props => [description, status];

  // copyWith method for updating the state immutably
  UpdateProfileState copyWith({
    String? description,
    ApiState? status
  }) {
    return UpdateProfileState(
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}




