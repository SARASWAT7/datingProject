// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:demoproject/component/alert_box.dart';
import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:demoproject/component/apihelper/toster.dart';
import 'package:demoproject/component/commonfiles/shared_preferences.dart';
import 'package:demoproject/component/reuseable_widgets/bottomTabBar.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/feedback/feedbackstate.dart';
import 'package:demoproject/ui/dashboard/profile/repository/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(const FeedbackState());
  void phone(String phone) {
    emit(state.copyWith(message: phone));
  }

  void feedback(BuildContext context, String message) async {
    AppUtils.keyboardHide(context);
    if (message.isEmpty) {
      NormalMessage().normalerrorstate(context, NormalMessage().feedback);
    } else {
      CorettaUserProfileRepo repo = CorettaUserProfileRepo();
      emit(state.copyWith(status: ApiState.isLoading));
      try {
        final response = await repo.feedback(context, message);
        emit(state.copyWith(status: ApiState.normal));
        showToast(context, response.message.toString());
        log(response.message ?? '' "======================>");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const BottomBar(currentIndex: 4)),
            (route) => false);
      } catch (e) {
        log(e.toString());
        emit(state.copyWith(status: ApiState.error));
        if (e.toString() != "NO DATA FOUND") {
          NormalMessage().normalerrorstate(context, e.toString());
        } else {
          showDialog(
              context: context, builder: (_) => AlertBox(title: e.toString()));
        }
      }
    }
  }
}
