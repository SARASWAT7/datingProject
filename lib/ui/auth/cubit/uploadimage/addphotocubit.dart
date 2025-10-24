import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../component/alert_box.dart';
import '../../../../component/apihelper/common.dart';
import '../../../../component/apihelper/normalmessage.dart';
import '../../../../component/apihelper/toster.dart';
import '../../../AuthRepository/authrepository.dart';
import '../../../dashboard/profile/cubit/updateData/updateprofilecubit.dart';
import '../../../personalinformation/iam.dart';
import 'addphotostate.dart';

class AddPhotoCubit extends Cubit<AddPhotoState> {
  AddPhotoCubit() : super(const AddPhotoState());

  void addphoto(BuildContext context, List<String> images) async {
    if (images.isEmpty) {
      NormalMessage().normalerrorstate(context, NormalMessage().selectphoto);
    } else {
      emit(state.copyWith(currentState: ApiState.isLoading));
      AuthRepository repo = AuthRepository();
      UpdateProfileCubit repo2 = UpdateProfileCubit();

      try {
        // Directly call upload APIs without internet check
        final homedata = await repo.addphoto(context, images);

        final response = await repo2.updateProfileImage(context, images.first);

        emit(state.copyWith(currentState: ApiState.normal));

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("UploadPhoto", true);

        showToast(context, homedata);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IamScreen()),
        );
      } catch (e, s) {
        emit(state.copyWith(currentState: ApiState.error));

        String message = "Unexpected error";

        if (e is DioError) {
          message = "Dio Error: ${e.message}";
          if (e.response != null) {
            message += "\nStatus: ${e.response?.statusCode}";
            message += "\nData: ${e.response?.data}";
          }
        } else {
          message = e.toString();
        }

        debugPrint("addphoto error: $message\n$s");

        showDialog(
          context: context,
          builder: (_) => AlertBox(title: message),
        );
      }
    }
  }
}
