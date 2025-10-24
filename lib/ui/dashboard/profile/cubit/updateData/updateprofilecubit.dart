

import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/updateData/updateprofilestate.dart';
import 'package:demoproject/ui/dashboard/profile/design/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../component/apihelper/normalmessage.dart';
import '../../../../../component/apihelper/toster.dart';
import '../../../../../component/commonfiles/shared_preferences.dart';

import '../../../../../component/reuseable_widgets/customNavigator.dart';
import '../../../../reels/cubit/myreels/myreelscubit.dart';
import '../../../../reels/myreelprofile.dart';
import '../../design/Media section/mymedia.dart';
import '../../design/profile.dart';
import '../../repository/userData.dart';
import '../profile/profilecubit.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(const UpdateProfileState());
  void bio(String description) {
    emit(state.copyWith(description: description));
  }

  void quotes(BuildContext context, String formData) async {
    AppUtils.keyboardHide(context);

    if (formData.isEmpty) {
      NormalMessage().normalerrorstate(context, NormalMessage().passion);
    } else {
      UpdateProfileDataRepo repo = UpdateProfileDataRepo();
      emit(state.copyWith(status: ApiState.isLoading));

      final response = await repo.quotes(context, {'quote': formData});
      emit(state.copyWith(status: ApiState.normal));

      if (response == 'Quotes updated successfully') {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("quotes", true);
        showToast(context, response);
      } else {
        showToast(context, response);
      }
    }
  }

  //////////////////////UPDATEIMAGEGECUBIT//////////////////

  Future<void> updateProfileImage(
    BuildContext context,
    String file,
  ) async {
    UpdateProfileDataRepo repo = UpdateProfileDataRepo();
    try {
      final response = await repo.updateVerifyPhoto(file);

      emit(state.copyWith(
          status: ApiState.normal, description: response.toString()));

      showToast(context, 'Image updated successfully');
      context.read<ProfileCubit>().getprofile(context);
      Navigator.pop(context, MaterialPageRoute(builder: (context) =>Profile()));
    } catch (e) {
      print("$e  hello=======================================>");
      emit(state.copyWith(status: ApiState.error));
      showToast(context, 'Failed to update image: ${e.toString()}');
    }
  }

  ////////////Show bio//////////
  void show(BuildContext context, String bioText, bool showBio,
      {Widget? nextPage}) async {
    AppUtils.keyboardHide(context);

    if (bioText.isEmpty) {
      NormalMessage().normalerrorstate(context, NormalMessage().bio);
    } else {
      emit(state.copyWith(status: ApiState.isLoading));

      final data = {
        'bio': bioText,
        'show_bio': showBio,
      };

      final response = await UpdateProfileDataRepo().show(context, data);
      emit(state.copyWith(status: ApiState.normal));
      if (response == 'Show Bio successfully') {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => EditProfile()));
        SharedPreferences pref = await SharedPreferences.getInstance();
        showToast(context, response);
        if (nextPage != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => EditProfile()));
        }
      } else {
        showToast(context, response);
      }
    }
  }

/////uploadmedia/////////////

  Future<void> media(BuildContext context, String imagePath) async {
    UpdateProfileDataRepo repo = UpdateProfileDataRepo();

    emit(state.copyWith(status: ApiState.isLoading)); // Emit loading state

    try {
      final response = await repo.addMedia(context, [imagePath]);
      Navigator.of(context).pop();
      CustomNavigator.push(context: context, screen: MyMedia());

      emit(state.copyWith(
          status: ApiState.normal, description: response.toString()));
      AppLoader();// Emit normal state
      // Navigator.of(context).pop();
      // CustomNavigator.push(context: context, screen: MyMedia());
    } catch (e) {
      print("$e hello=======================================>");
      emit(state.copyWith(status: ApiState.error));
      showToast(context, 'Failed to upload image: ${e.toString()}');
    }
  }

  ////////////////upload reals////////////////////

  Future<void> uploadReels(BuildContext context, String videoPath, String caption) async {
    UpdateProfileDataRepo repo = UpdateProfileDataRepo();

    emit(state.copyWith(status: ApiState.isLoading));

    try {
      final response = await repo.addReels(context, videoPath, caption);

      emit(state.copyWith(
          status: ApiState.normal,
          description: response.toString()));
     // Navigator.of(context).pop();
      context.read<ProfileReelsCubit>().fetchProfileReels(context);
      CustomNavigator.push(context: context, screen: MyReelProfile());

      AppLoader();
      showToast(context, 'Video uploaded successfully!');
    } catch (e) {
      print("$e hello=======================================>");

      emit(state.copyWith(status: ApiState.error));
      context.read<ProfileReelsCubit>().fetchProfileReels(context);
      CustomNavigator.push(context: context, screen: MyReelProfile());
      // showToast(context, 'Failed to upload video: ${e.toString()}');
    }
  }
  /////////////////////////////////verificationphoto/////////////////

  Future<void> profileVerify(
      BuildContext context,
      String file,
      ) async {
    UpdateProfileDataRepo repo = UpdateProfileDataRepo();

    emit(state.copyWith(status: ApiState.isLoading));

    try {
      final response = await repo.verification(file);

      emit(state.copyWith(
        status: ApiState.normal,
        description: response.toString(),
      ));
      Navigator.of(context).pop();
      CustomNavigator.push(context: context, screen: EditProfile());
      showToast(context, 'Profile verification successful!');
    } catch (e) {
      print("Error during profile verification: $e");

      emit(state.copyWith(status: ApiState.error));

      showToast(context, 'Failed to verify profile: ${e.toString()}');
    }
  }



}
