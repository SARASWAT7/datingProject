import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/ui/dashboard/profile/model/profileresponse.dart';
import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final ApiState status;
  final bool isDelete;
  final ProfileResponse? profileResponse;
  final List<String>? selectedPhoto;
  const ProfileState(
      {this.selectedPhoto,
      this.isDelete = false,
      this.profileResponse,
      this.status = ApiState.normal});
  @override
  List<Object?> get props => [status, isDelete, selectedPhoto, profileResponse];

  ProfileState copyWith(
      {ApiState? status,
      List<String>? selectedPhoto,
      bool? isDelete,
      ProfileResponse? profileResponse}) {
    return ProfileState(
        isDelete: isDelete ?? this.isDelete,
        selectedPhoto: selectedPhoto ?? this.selectedPhoto,
        profileResponse: profileResponse ?? this.profileResponse,
        status: status ?? this.status);
  }
}
