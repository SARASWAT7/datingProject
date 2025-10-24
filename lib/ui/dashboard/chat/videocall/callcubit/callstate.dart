import 'package:equatable/equatable.dart';

import '../videocallcubit/videostate.dart';

class AcceptRejectState extends Equatable {
  final String senderImage;
  final String channelName;
  final String channleToken;
  final String sendername, callTimer;
  final CallState callStatus;
  const AcceptRejectState({
    this.sendername = "",
    this.callStatus = CallState.wating,
    this.channelName = "",
    this.channleToken = "",
    this.callTimer = "",
    this.senderImage = "",
  });
  @override
  List<Object?> get props =>
      [senderImage, sendername, callStatus, channelName, channleToken];
  AcceptRejectState copyWith(
      {String? senderImage,
        String? channelName,
        String? channleToken,
        CallState? callStatus,
        String? sendername,
        String? callTimer}) {
    return AcceptRejectState(
        callStatus: callStatus ?? this.callStatus,
        channelName: channelName ?? this.channelName,
        channleToken: channleToken ?? this.channleToken,
        senderImage: senderImage ?? this.senderImage,
        sendername: sendername ?? this.sendername);
  }
}
