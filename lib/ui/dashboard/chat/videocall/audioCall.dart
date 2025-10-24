// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, prefer_final_fields, sort_child_properties_last, unused_local_variable, unnecessary_null_comparison, deprecated_member_use, use_build_context_synchronously, unused_field
import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/ui/dashboard/chat/videocall/videocall.dart';
import 'package:demoproject/ui/dashboard/chat/videocall/videocallcubit/vediocubit.dart';
import 'package:demoproject/ui/dashboard/chat/videocall/videocallcubit/videostate.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../component/alert_box.dart';
import '../../../../component/reuseable_widgets/apploder.dart';

import '../../../../component/utils/gradientwidget.dart';
import '../model/sent_notification.dart';
import '../repository/service.dart';
import 'chatbackground.dart';

const appId = "f4c7a7bbd78e4707b10e030f3b83c9d0";


String channelName = "";
String userToken = "";

//  channel = "hello";
class AudioCallCall extends StatefulWidget {
  final bool isReciver;
  final String channelName, token;
  final String myUserId;
  final String userId;
  final String profileImage;
  final String name;
  final String userName;


  const AudioCallCall(
      {super.key,
      this.isReciver = false,
      this.channelName = "",
      this.token = "",
      required this.userId,
      required this.profileImage,
      required this.name,
        required this.userName,
      required this.myUserId});
  //  required this.appName, required this.toekn

  @override
  State<AudioCallCall> createState() => _AudioCallCallState();
}

class _AudioCallCallState extends State<AudioCallCall> {
  String uid = "";
  int? _remoteUid;
  bool _localUserJoined = true;
  bool _localUserSpeaker = true;

  deleteChatStatus() {
    FirebaseFirestore.instance
        .collection("CallStatus")
        .doc(channelName)
        .update({
      "call_end": true,
      "callEndTime": DateTime.now().toString()
    }).then((value) {
      log("false ");
    }).onError((error, stackTrace) {
      log(error.toString());
    });
  }

  callendstatus(bool status) {
    if (status == true) {
      _leaveChannel();
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) => const AlertBox(title: "Call Ended"));
    }
  }

  Future<void> updatethischatOnFirebase(
    String channelName,
    String channelToken,
  ) async {
    await FirebaseFirestore.instance
        .collection("CallStatus")
        .doc(channelName)
        .set({
      "channelName": channelName,
      "channelToken": channelToken,
      "senderId": widget.myUserId,
      'callType': "audio",
      'reciverId': widget.userId,
      'callStartTime': "",
      "callEndTime": "",
      "call_start": false,
      "call_end": false
    }).then((value) {
      log("value");
    }).onError((error, stackTrace) {
      log(error.toString());
    });
  }

  Future<void> updatethischatOnFirebasereciver(
    String channelName,
    String channelToken,
  ) async {
    await FirebaseFirestore.instance
        .collection("CallStatus")
        .doc(channelName)
        .update({
      'callStartTime': DateTime.now().toString(),
      "callEndTime": "",
      "call_start": true,
      "call_end": false
    }).then((value) {
      log("value");
    }).onError((error, stackTrace) {
      log(error.toString());
    });
    /*   await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('myInbox')
        .doc(chatID)
        .set(myinbox) */
  }

  RtcEngine _engine = createAgoraRtcEngine();
  Future<void> initAgora(String tokens, String Channelname) async {
    // retrieve permissions
    log("token $tokens channel $channelName");
    await [Permission.microphone].request();

    //create the engine
    // _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
// _engine.onJ
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _localUserJoined = true;
            _localUserSpeaker = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          log("message : - onJoinChannel $remoteUid");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onRejoinChannelSuccess: (connection, elapsed) {
          log("message : - onJoinChannel ${connection.localUid}");
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          _leaveChannel();
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (_) => const AlertBox(title: "Call Ended"));
          setState(() {
            _remoteUid = null;
          });
        },
        onLeaveChannel: (connection, stats) {},
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {},
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.disableVideo();
    await _engine.enableAudio();

    // await _engine.startPreview();

    await _engine
        .joinChannel(
      token: tokens,
      channelId: Channelname,
      uid: 0,
      options: const ChannelMediaOptions(),
    )
        .then((value) {
      log("join channel================+++++++++>");
    }).onError((error, stackTrace) {
      log("$error================+++++++++>");
    });
  }

  bool loading = false;
  AgoraVideoCall _repository = AgoraVideoCall();
  CorettaChatRepository _authRepo = CorettaChatRepository();

  getToken() async {
    context.read<VideoCallCubit>().updateStatus(CallState.loading);
    try {
      final deviceResponse = await _repository.getToken();
      channelName = deviceResponse.result?.channelToken?.channelName ?? "";
      userToken = deviceResponse.result?.channelToken?.token ?? "";
      String devicetokenofothermer = "";
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .get()
          .then((value) {
        setState(() {
          devicetokenofothermer = value['deviceToken'] ?? "";
          // otherusername = value['userName'];
          // otheruserId = value['user_id'];
        });
      });
      log("========+++++++++> $channelName $userToken");
      initAgora(userToken, channelName);
      updatethischatOnFirebase(channelName, userToken);
      sentNotification response = await _authRepo.sentNoti(
          devicetokenofothermer,
          widget.userId,
          channelName,
          userToken,
          "audio");
      context
          .read<VideoCallCubit>()
          .updateChannelDetails(channelName, userToken);
      context.read<VideoCallCubit>().getUserData(widget.userId, true);
      context.read<VideoCallCubit>().updateStatus(CallState.wating);
    } catch (e) {
      context.read<VideoCallCubit>().updateStatus(CallState.error);
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) =>
              const AlertBox(title: "Some Error occored Call Ended"));
    }
  }

  getTokenReciver() async {
    context.read<VideoCallCubit>().updateStatus(CallState.loading);

    try {
      context
          .read<VideoCallCubit>()
          .getCallStatus(widget.channelName, context)
          .then((value) {
        if (value) {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (_) => const AlertBox(title: "Call Ended"));
        } else {
          initAgora(widget.token, widget.channelName);
          updatethischatOnFirebasereciver(widget.channelName, widget.token);
          context.read<VideoCallCubit>().getUserData(widget.userId, false);
          context.read<VideoCallCubit>().updateStatus(CallState.wating);
        }
      });
    } catch (e) {
      context.read<VideoCallCubit>().updateStatus(CallState.error);
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) =>
              const AlertBox(title: "Some Error occored Call Ended"));
    }
    setState(() {
      // loading = true;
    });
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void _toggleMute(bool update) {
    log(update.toString());
    _engine.muteLocalAudioStream(update).onError((error, stackTrace) {});
  }

  void _toggleSpeaker(bool update) {
    _engine.setEnableSpeakerphone(update);
  }

  @override
  void initState() {
    if (widget.isReciver == false) {
      getToken();
    } else {
      getTokenReciver();
    }
    super.initState();
  }

  void _leaveChannel() async {
    deleteChatStatus();
    if (_engine != null) {
      _engine.leaveChannel();
      _engine.release();
    }
  }

  @override
  void deactivate() {
    // Navigator.of(context).pop();
    _leaveChannel();
    super.deactivate();
  }

  _willPopupScope() {
    // Navigator.of(context).pop();
    _leaveChannel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _willPopupScope(),
      child: BlocBuilder<VideoCallCubit, VideoCallState>(
        builder: (context, state) {
          return state.callStatus == CallState.loading
              ? AppLoader()
              : state.callStatus == CallState.error
                  ? Container()
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("CallStatus")
                          .where("channelName",
                              isEqualTo: widget.isReciver
                                  ? widget.channelName
                                  : state.channelName)
                          .snapshots(),
                      builder: (context, snapshot) {
                        // log(snapshot.data?.docs.first.data().toString() ?? "");
                        if ((snapshot.data?.docs.isNotEmpty ?? false)) {
                          context.read<VideoCallCubit>().updateringing((snapshot
                                      .data?.docs.first
                                      .data()['callStartTime']
                                      .toString() ??
                                  "")
                              .isEmpty);
                        }
                        return Scaffold(
                            body: Stack(
                          children: [

                            ChatRoomUserImage(
                              name: state.senderImage,
                            ),
                            AgoraVideoView(
                              controller: VideoViewController(
                                rtcEngine: _engine,
                                canvas: const VideoCanvas(
                                  uid: 0,
                                ),
                              ),
                            ),

                            ChatRoomUserInfo(
                              name: widget.userName,
                              image: widget.profileImage,
                              callStatus: state.isRinging,
                              time: context.read<VideoCallCubit>().update(

                                  DateTime.now(),
                                  snapshot.data?.docs.first
                                          .data()['callStartTime']
                                          .toString() ??
                                      ""),
                            ),
                            Positioned(
                              bottom: 5.h, // Adjust the position as needed
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 9.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: AppColor.firstmainColor.withOpacity(0.6),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Video call button
                                    SizedBox(
                                      height: 25.sp,
                                      width: 25.sp,
                                      child: GradientWidget(
                                        colors: const [
                                          Color(0xffFD5564),
                                          Color(0xffFE3C72),
                                        ],
                                        child: Image.asset(
                                          "assets/images/videocall.png",
                                          color: AppColor.tinderclr,
                                        ),
                                      ),
                                    ).onTap(() async {
                                      await [
                                        Permission.microphone,
                                        Permission.camera,
                                      ].request().then((value) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => VideoCall(
                                              userId: widget.userId,
                                              myUserId: widget.myUserId,
                                            ),
                                          ),
                                        );
                                      }).onError((error, stackTrace) {
                                        log(error.toString());
                                      });
                                    }),

                                    // Speaker toggle button
                                    state.speakerOn
                                        ? Image.asset(
                                      'assets/images/speakerblack.png',
                                      height: 14.h,
                                      width: 14.w,
                                    ).onTap(() {
                                      log(state.speakerOn.toString());
                                      context.read<VideoCallCubit>().returnSpeaker(false);
                                      _toggleSpeaker(false);
                                    })
                                        : Image.asset(
                                      'assets/images/speaker.png',
                                      height: 14.h,
                                      width: 14.w,
                                    ).onTap(() {
                                      context.read<VideoCallCubit>().returnSpeaker(true);
                                      _toggleSpeaker(true);
                                    }),

                                    // Mute button
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: whitecolor,
                                      ),
                                      child: Icon(
                                        state.mute ? Icons.mic_off_outlined : Icons.mic,
                                        size: 3.5.h,
                                      ),
                                      width: 14.w,
                                      height: 14.h,
                                    ).onTap(() {
                                      if (state.mute) {
                                        context.read<VideoCallCubit>().returnmute(false);
                                        _toggleMute(false);
                                      } else {
                                        context.read<VideoCallCubit>().returnmute(true);
                                        _toggleMute(true);
                                      }
                                    }),

                                    // Call end button
                                    GestureDetector(
                                      onTap: () {
                                        _leaveChannel();
                                        Navigator.of(context).pop();
                                      },
                                      child: Image.asset(
                                        "assets/images/callend.png",
                                        width: 60,
                                        height: 60,
                                      ),
                                    ),
                                  ],
                                ).pOnly(
                                  left: 4.w,
                                  right: 4.w,
                                ),
                              ).pOnly(left: 5.w, right: 5.w),
                            ),

                            SafeArea(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back,
                                    color: whitecolor,
                                  ).onTap(() {
                                    _leaveChannel();
                                    Navigator.of(context).pop();
                                  }),
                                  const Spacer(),
                                  Icon(
                                    Icons.more_vert,
                                    color: whitecolor,
                                    size: 3.h,
                                  ),
                                ],
                              ).pOnly(left: 5.w, right: 5.w),

                            ),
                          ],
                        ));
                      });
        },
      ),
    );
  }

  @override
  void dispose() {
    _leaveChannel();
    super.dispose();
  }

}
