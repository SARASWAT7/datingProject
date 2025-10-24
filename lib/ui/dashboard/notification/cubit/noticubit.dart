import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../component/apihelper/normalmessage.dart';
import '../../../../component/apihelper/urls.dart';
import '../../home/repository/homerepository.dart';
import '../deleteallmodel.dart';
import '../userdelete.dart';
import 'notistate.dart';

class NotificationListCubit extends Cubit<NotificationListState> {
  NotificationListCubit() : super( NotificationListState());
  HomeRepository repo = HomeRepository();

  void NotiList(BuildContext context) async {
    emit(state.copyWith(status: ApiStates.loading));
    try {

      final response = await repo.getAllNotification();
      emit(state.copyWith(status: ApiStates.success, response: response));
    } catch (e) {
      log("${e} zssss");
      emit(state.copyWith(status: ApiStates.error));
      NormalMessage.instance.normalerrorstate(context, e.toString());
    }
  }


  //////////////deletebyidnotification///////////////

  void Deleteid(BuildContext context, String id) async {
    emit(state.copyWith(status: ApiStates.loading));
    print("delete user id: $id");

    try {
      final NotificationDeleteResponse notificationDeleteResponse = await repo.delNotiByid(id);

      emit(state.copyWith(
        status: ApiStates.success,
        deleteResponse: notificationDeleteResponse,
      ));

      NotiList(context);
    } catch (e) {
      log("$e error");

      emit(state.copyWith(status: ApiStates.error));
      NormalMessage.instance.normalerrorstate(context, e.toString());
    }
  }

  //////////delete all notification/////////////

  void delNotiall(BuildContext context) async {
    emit(state.copyWith(status: ApiStates.loading));
    try {
      final deleteAllResponse = await repo.delNotiall();
      emit(state.copyWith(status: ApiStates.success, deleteAllResponse: deleteAllResponse));
      NotiList(context);
    } catch (e) {
      log("Error deleting all notifications: $e");
      emit(state.copyWith(status: ApiStates.error));
      NormalMessage.instance.normalerrorstate(context, e.toString());
    }
  }

}