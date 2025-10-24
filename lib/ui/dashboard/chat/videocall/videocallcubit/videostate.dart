import 'package:equatable/equatable.dart';

enum CallState { oncall, callend, ringing, loading, wating, error }

class VideoCallState extends Equatable {
  final String senderImage;
  final String channelName;
  final String channleToken;
  final String sendername, callTimer;
  final CallState callStatus;
  final bool isRinging;
  final bool mute;
  final bool cameraOn;
  final bool speakerOn;
  final bool otherPersonCameraOn;
  final bool isotherPersonisonMute;

  const VideoCallState(
      {this.sendername = "",
        this.isRinging = false,
        this.channelName = "",
        this.channleToken = "",
        this.mute = false,
        this.cameraOn = false,
        this.speakerOn = false,
        this.otherPersonCameraOn = false,
        this.isotherPersonisonMute = false,
        this.callTimer = "",
        this.senderImage = "",
        this.callStatus = CallState.wating});

  @override
  List<Object?> get props => [
    senderImage,
    sendername,
    isRinging,
    channelName,
    channleToken,
    callTimer,
    callStatus,
    mute,
    cameraOn,
    speakerOn,
    otherPersonCameraOn,
    isotherPersonisonMute
  ];

  VideoCallState copyWith(
      {String? senderImage,
        String? sendername,
        String? channelName,
        String? channleToken,
        String? callTimer,
        bool? isRinging,
        CallState? callStatus,
        bool? mute,
        bool? cameraOn,
        bool? speakerOn,
        bool? isotherPersonisonMute,
        bool? otherPersonCameraOn}) {
    return VideoCallState(
        channelName: channelName ?? this.channelName,
        channleToken: channleToken ?? this.channleToken,
        isRinging: isRinging ?? this.isRinging,
        senderImage: senderImage ?? this.senderImage,
        sendername: sendername ?? this.sendername,
        callTimer: callTimer ?? this.callTimer,
        callStatus: callStatus ?? this.callStatus,
        mute: mute ?? this.mute,
        cameraOn: cameraOn ?? this.cameraOn,
        speakerOn: speakerOn ?? this.speakerOn,
        isotherPersonisonMute:
        isotherPersonisonMute ?? this.isotherPersonisonMute,
        otherPersonCameraOn: otherPersonCameraOn ?? this.otherPersonCameraOn);
  }
}
