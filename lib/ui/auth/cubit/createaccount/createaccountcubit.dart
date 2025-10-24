// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../component/apihelper/common.dart';
import '../../../../component/apihelper/normalmessage.dart';
import '../../../../component/apihelper/toster.dart';
import '../../../../component/commonfiles/shared_preferences.dart';
import '../../../AuthRepository/authrepository.dart';
import '../../../personalinformation/uploadimage.dart';
import '../../design/mybirthdayis.dart';
import 'createaccountstate.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountCubit() : super(const CreateAccountState());
  void firstName(String firstname) {
    emit(state.copyWith(firstname: firstname));
  }

  void lastname(String lastname) {
    emit(state.copyWith(lastname: lastname));
  }

  void dob(String dob) {
    emit(state.copyWith(dob: dob));
  }

  void alldatacallect(BuildContext context) {
    if (state.firstname.isEmpty) {

      NormalMessage().normalerrorstate(context, NormalMessage().firstNameEmpty);
    } else if (state.lastname.isEmpty) {
      NormalMessage().normalerrorstate(context, "Please enter last Name");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MyBirthday(
                firstname: state.firstname, lastname: state.lastname)),
      );
    }
  }

  void createaccount(BuildContext context, String firstname, String lastname,
      String dob) async {
    AppUtils.keyboardHide(context);
    if (dob.isEmpty) {
      NormalMessage().normalerrorstate(context,"");
    } else {
      AuthRepository repo = AuthRepository();
      emit(state.copyWith(status: ApiState.isLoading));
      try {
        final response =
            await repo.createaccount(context, firstname, lastname, dob);
        emit(state.copyWith(status: ApiState.normal));
        SharedPreferences pref=await SharedPreferences.getInstance();
        pref.setBool("firstName", true).then((v){
print("$v log");
        }).onError((c,e){
          print("$c $e");
        });
        showToast(context, response);
         Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => UploadImage()),
         );
        
      } catch (e) {
        emit(state.copyWith(status: ApiState.error));
        NormalMessage().normalerrorstate(context, e.toString());
      }
    }
  }


}
