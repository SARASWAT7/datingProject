// ignore: must_be_immutable
import 'package:equatable/equatable.dart';
import '../../../../component/apihelper/common.dart';


class CreateAccountState extends Equatable {
  final String firstname;
  final String lastname;
  final String dob;
  final ApiState status;

  const CreateAccountState({this.firstname = "",this.lastname = "",this.dob = "", this.status = ApiState.normal});
  @override
  List<Object?> get props => [firstname,lastname,dob, status];
  CreateAccountState copyWith({String? firstname,String? lastname,String? dob, ApiState? status}) {
    return CreateAccountState(
        firstname: firstname ?? this.firstname,lastname: lastname ?? this.lastname,dob: dob ?? this.dob, status: status ?? this.status);
  }
}
