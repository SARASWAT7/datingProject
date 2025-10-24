// ignore_for_file: use_build_context_synchronously


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../component/apihelper/common.dart';
import '../../../../component/apihelper/normalmessage.dart';
import '../../../../component/apihelper/toster.dart';
import '../../../../component/commonfiles/shared_preferences.dart';
import '../../../AuthRepository/authrepository.dart';
import '../../../personalinformation/moreaboutme.dart';
import 'bacisinformationstate.dart';

class BasicInformationCubit extends Cubit<BasicInformationState> {
  BasicInformationCubit() : super(const BasicInformationState());


  

  void basicinformation(BuildContext context,String gender,List iamInterstedname,List sexualorientation,String height,String city,String statesname,String degree,String profession) async {
    AppUtils.keyboardHide(context);
    // if (state.grownUp.isEmpty) {
      //NormalMessage().normalerrorstate(context, NormalMessage().phonetext);
    // }else {
      AuthRepository repo = AuthRepository();
      emit(state.copyWith(status: ApiState.isLoading));
      try {
        final response =
            await repo.basicinformation(context,FormData.fromMap({"gender":gender,"interested_in":iamInterstedname.join(","),"my_sexual_orientations":sexualorientation.join(","),"height":height,"degree":degree,"profession":profession}));
        emit(state.copyWith(status: ApiState.normal));
        showToast(context, response);
        SharedPreferences pref=await SharedPreferences.getInstance();
        pref.setBool("BasicInformation", true);
       Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MoreAboutMeScreen()));
      } catch (e) {
        emit(state.copyWith(status: ApiState.error));
        NormalMessage().normalerrorstate(context, e.toString());
      }
    // }
  }
}
