import '../../../../component/apihelper/urls.dart';
import '../../model/profilereelsresponse.dart';
import '../../model/userprofiledata.dart';

class ProfileReelsState {
  final ApiStates status;
  final ProfileReelsResponse? response;
  final UserDataReelsResponse? userProfileResponse;
  final String? errorMessage;

  const ProfileReelsState({
    this.status = ApiStates.normal,
    this.response,
    this.userProfileResponse,
    this.errorMessage,
  });

  ProfileReelsState copyWith({
    ApiStates? status,
    ProfileReelsResponse? response,
    UserDataReelsResponse? userProfileResponse, // New field in copyWith
    String? errorMessage,
  }) {
    return ProfileReelsState(
      status: status ?? this.status,
      response: response ?? this.response,
      userProfileResponse: userProfileResponse ?? this.userProfileResponse, // Update userProfileResponse
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
