import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoproject/ui/dashboard/chat/videocall/videocallcubit/videostate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

class VideoCallCubit extends Cubit<VideoCallState> {
  VideoCallCubit() : super(const VideoCallState());
  isCallOnStage() async {}
  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  returnmute(bool update) {
    emit(state.copyWith(mute: update));
  }

  returnSpeaker(bool update) {
    log(update.toString());
    // state.copyWith(callStatus: CallState.wating);
    emit(state.copyWith(speakerOn: update));
  }

  String update(DateTime time, String timeData) {
    int sec = 0;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      sec += 1;
      emit(state.copyWith(callTimer: _formatTime(sec)));
    });
    return timeData.isNotEmptyAndNotNull
        ? time.difference(DateTime.parse(timeData)).toHumanizedString()
        : "";
  }

  Future<void> updateStatus(CallState status) async {
    emit(state.copyWith(callStatus: status));
  }

  Future<void> updateringing(bool status) async {
    emit(state.copyWith(isRinging: status));
  }

  Future<bool> getCallStatus(String channelName, BuildContext context) async {
    bool appdata = false;
    await FirebaseFirestore.instance
        .collection("CallStatus")
        .doc(channelName)
        .get()
        .then((value) {
      log("${value.data()} ${value.data()?['call_end'].toString() ?? ""}");
      appdata = (value.data()?['call_end'] ?? false);
    }).onError((error, stackTrace) {
      appdata = false;
    });
    return appdata;
    // emit(state.copyWith(isRinging: status));
  }

  Future<void> getUserData(String userId, bool videobool) async {
    FirebaseFirestore.instance
        .collection("users")
        .where("chat_id", isEqualTo: int.parse(userId))
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        emit(state.copyWith(
            mute: false,
            speakerOn: videobool,
            sendername: value.docs.first.data()['userName'],
            senderImage: value.docs.first.data()['userImage'] ??
                "assets/images/nopicdummy.png"));
      } else {
        emit(state.copyWith(
            sendername: "NO Name", senderImage: "assets/images/nopicdummy.png"));
      }
    }).onError((error, stackTrace) => null);
  }

  updateChannelDetails(String channelName, String token) async {
    log("message $channelName, $token");
    emit(state.copyWith(channelName: channelName, channleToken: token));
  }
}
