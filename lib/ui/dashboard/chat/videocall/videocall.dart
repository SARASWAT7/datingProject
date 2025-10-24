// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, prefer_final_fields, sort_child_properties_last, unused_field, unnecessary_null_comparison, unused_element, use_build_context_synchronously, unused_local_variable

import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoproject/ui/auth/design/splash.dart';
import 'package:demoproject/ui/dashboard/chat/videocall/videocallcubit/vediocubit.dart';
import 'package:demoproject/ui/dashboard/chat/videocall/videocallcubit/videostate.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../component/alert_box.dart';
import '../../../../component/commonfiles/appcolor.dart';
import '../../../../component/reuseable_widgets/apploder.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../model/sent_notification.dart';
import '../repository/service.dart';
import 'chatbackground.dart';
import 'native_device_orientation.dart';

const appId = "f4c7a7bbd78e4707b10e030f3b83c9d0";
String channelName = "";
String userToken = "";

class VideoCall extends StatefulWidget {
  final bool isReciver;
  final String channelName, token;
  final String userId, myUserId;
  const VideoCall(
      {super.key,
      required this.userId,
      required this.myUserId,
      this.isReciver = false,
      this.channelName = "",
      this.token = ""});
  //  required this.appName, required this.toekn

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  RtcEngineEventHandler? _engineEventHandler;

  String uid = "";
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  Future<void> initAgora(String tokens, String Channelname) async {
    // retrieve permissions

    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
// _engine.onJ

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("==================> local ${connection.localUid} joined");

          setState(() {
            uid = connection.localUid.toString();
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          log("==================> remote $remoteUid joined");
          log("message");

          // showDialog(
          //     context: context,
          //     builder: (_) => AlertBox(title: "remote user $remoteUid joined"));
          setState(() {
            _remoteUid = remoteUid;
            // 1165443601
          });
          log("==================> remote $_remoteUid set");
        },
        onRejoinChannelSuccess: (connection, elapsed) {
          log("message : - onJoinChannel ${connection.localUid}");
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          _leaveChannel();
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (_) => const AlertBox(title: "Call Ended"));
          log("==================> exite $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onLeaveChannel: (connection, stats) {
          log("==================> ${stats.duration} ${connection.channelId} ${connection.localUid}");
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          log('==================> [onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo().then((value) {
      log("message success video");
    }).onError((error, stackTrace) {
      log("message video $error");
    });
    await _engine.enableAudio().then((value) {
      log("message success audio");
    }).onError((error, stackTrace) {
      log("message audio $error");
    });
    await _engine.startPreview().then((value) {
      log("message success start preview");
    }).onError((error, stackTrace) {
      log("message start preview $error");
    });

    await _engine
        .joinChannel(
      token: tokens,
      channelId: Channelname,
      uid: 0,
      options: const ChannelMediaOptions(),
    )
        .then((value) {
      log("message success");
    }).onError((error, stackTrace) {
      log("$error");
    });
  }

  void _switchCamera() {
    _engine.switchCamera();
  }

  // Function to leave the channel
  void _leaveChannel() {
    if (_engine != null) {
      _engine.leaveChannel();

      _engine.release();
      // await _engine.destroyCustomEncodedVideoTrack(videoTrackId);
    }
  }

  bool loading = false;
  AgoraVideoCall _repository = AgoraVideoCall();
  CorettaChatRepository _authRepo = CorettaChatRepository();
  late var client;

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

  updatethischatOnFirebase(
    String channelName,
    String channelToken,
  ) {
    FirebaseFirestore.instance.collection("CallStatus").doc(channelName).set({
      "channelName": channelName,
      "channelToken": channelToken,
      "senderId": widget.myUserId,
      'callType': "video",
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
    /*   await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('myInbox')
        .doc(chatID)
        .set(myinbox) */
  }

  getToken() async {
    context.read<VideoCallCubit>().updateStatus(CallState.loading);
    try {
      final deviceResponse = await _repository.getToken();
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
      channelName = deviceResponse.result?.channelToken?.channelName ?? " ";
      userToken = deviceResponse.result?.channelToken?.token ?? " ";

      log(' ==================>this is the server token $userToken devicetokenofothermer $channelName');
      initAgora(userToken, channelName);
      updatethischatOnFirebase(channelName, userToken);
      sentNotification response = await _authRepo.sentNoti(
          devicetokenofothermer,
          widget.userId,
          channelName,
          userToken,
          "video");

      context
          .read<VideoCallCubit>()
          .updateChannelDetails(channelName, userToken);
      context.read<VideoCallCubit>().getUserData(widget.userId, false);
      context.read<VideoCallCubit>().updateStatus(CallState.wating);
    } catch (e) {
      log("$e eeeee===============>");
      context.read<VideoCallCubit>().updateStatus(CallState.error);
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) =>
              const AlertBox(title: "Some Error occored Call Ended"));
    }
  }

  getTokenrecive() async {
    context.read<VideoCallCubit>().updateStatus(CallState.loading);
    // setState(() {
    //   loading = false;
    // });
    try {
      // initAgora(widget.token, widget.channelName);
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
    // setState(() {
    //   loading = true;
    // });
  }

  // int uid = 0;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _toggleMute(bool update) {
    log(update.toString());
    setState(() {
      _localUserJoined = update;
    });
    _engine.muteLocalAudioStream(update).onError((error, stackTrace) {
      log(" $error message");
    });
  }

  bool disableviceo = false;
  void closecamera() {
    bool muted = !disableviceo;
    _engine.muteLocalVideoStream(muted);
    setState(() {
      disableviceo = muted;
    });
  }

  @override
  void initState() {
    if (widget.isReciver == false) {
      getToken();
    } else {
      getTokenrecive();
    }
    super.initState();
  }

  @override
  void deactivate() {
    // Navigator.of(context).pop();
    _leaveChannel();
    super.deactivate();
  }

  bool _localUserSpeaker = true;
  void _toggleSpeaker(bool update) {
    setState(() {
      _localUserSpeaker = update;
    });
    _engine.setEnableSpeakerphone(update);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoCallCubit, VideoCallState>(
      listener: (context, state) {},
      builder: (context, state) {
        return state.callStatus == CallState.loading
            ? AppLoader()
            : state.callStatus == CallState.error
                ? Container()
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("CallStatus")
                        .where("channelName", isEqualTo: channelName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if ((snapshot.data?.docs.isNotEmpty ?? false)) {
                        context.read<VideoCallCubit>().updateringing((snapshot
                                    .data?.docs.first
                                    .data()['callStartTime']
                                    .toString() ??
                                "")
                            .isEmpty);
                      }
                      return Scaffold(body:
                          NativeDeviceOrientationReader(builder: (context) {
                        return Container(
                          decoration: const BoxDecoration(),
                          child: Stack(
                            children: [
                              _remoteUid != null
                                  ? _remoteVideo()
                                  : AgoraVideoView(
                                      onAgoraVideoViewCreated: (i) {
                                        log("$i ======+++++++++++++++++==========++++++++++======++++++++++=+>");
                                      },
                                      controller: VideoViewController(
                                        rtcEngine: _engine,
                                        canvas: const VideoCanvas(
                                          uid: 0,
                                        ),
                                      ),
                                    ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: _remoteUid != null
                                    ? Container(
                                        height: 20.h,
                                        width: 30.w,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Stack(
                                          children: [
                                            AgoraVideoView(
                                              onAgoraVideoViewCreated: (i) {
                                                log(" ======+++++++++++++++++==========++++++++++======++++++++++=+>");
                                              },
                                              controller: VideoViewController(
                                                rtcEngine: _engine,
                                                canvas: const VideoCanvas(
                                                  uid: 0,
                                                ),
                                              ),
                                            ),
                                            disableviceo
                                                ? Container(
                                                    height: 20.h,
                                                    width: 30.w,
                                                    color: Colors.black,
                                                    child: Icon(
                                                      Icons.videocam_off,
                                                      color: whitecolor,
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      )
                                    : _remoteVideo(),
                              ).pOnly(bottom: 13.h, right: 5.w),
                              Positioned(
                                bottom: 3.h, // Adjust the position as needed
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    height: 9.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: AppColor.firstmainColor
                                            .withOpacity(0.6)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _localUserSpeaker
                                            ? Image.asset(
                                                'assets/images/speaker1.png',
                                                height: 14.h,
                                                width: 14.w,
                                              ).onTap(() {
                                                _toggleSpeaker(false);
                                              })
                                            : Image.asset(
                                                'assets/images/speakerblack1.png',
                                                height: 14.h,
                                                width: 14.w,
                                              ).onTap(() {
                                                _toggleSpeaker(true);
                                              }),
                                        Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: _localUserJoined ==
                                                            false
                                                        ? whitecolor
                                                        : bgClr),
                                                child: const Icon(
                                                    Icons.mic_off_outlined),
                                                width: 60,
                                                height: 60)
                                            .onTap(() {
                                          if (_localUserJoined) {
                                            _toggleMute(false);
                                          } else {
                                            _toggleMute(true);
                                          }
                                        }),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _leaveChannel();
                                            },
                                            child: Image.asset(
                                                "assets/images/callend.png",
                                                width: 60,
                                                height: 60)),
                                        Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: disableviceo == false
                                                        ? whitecolor
                                                        : bgClr),
                                                child: const Icon(
                                                    Icons.videocam_rounded),
                                                width: 60,
                                                height: 60)
                                            .onTap(() {
                                          closecamera();
                                        }),
                                      ],
                                    ).pOnly(
                                        left: 4.w, right: 4.w, bottom: .5.h),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5.h,
                                right: 4.w,
                                child: Container(
                                  height: 4.h,
                                  width: 4.h,
                                  decoration: BoxDecoration(
                                      color: whitecolor,
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.camera_rear,
                                    color: blackColor,
                                    size: 20.sp,
                                  ),
                                ).onTap(() {
                                  _switchCamera();
                                }),
                              )
                            ],
                            // children: [
                            //   // ChatRoomUserImage(
                            //   //   name: widget.userId,
                            //   // ),
                            //   _remoteUid != null
                            //       ? _remoteVideo()
                            //       : AgoraVideoView(
                            //           onAgoraVideoViewCreated: (i) {
                            //             log("$i ======+++++++++++++++++==========++++++++++======++++++++++=+>");
                            //           },
                            //           controller: VideoViewController(
                            //             rtcEngine: _engine,
                            //             canvas: const VideoCanvas(
                            //               uid: 0,
                            //             ),
                            //           ),
                            //         ),
                            //   Align(
                            //     alignment: Alignment.bottomRight,
                            //     child: _remoteUid != null
                            //         ? Container(
                            //             height: 20.h,
                            //             width: 30.w,
                            //             clipBehavior: Clip.antiAlias,
                            //             decoration: BoxDecoration(
                            //               borderRadius:
                            //                   BorderRadius.circular(14),
                            //             ),
                            //             child: Stack(
                            //               children: [
                            //                 AgoraVideoView(
                            //                   onAgoraVideoViewCreated: (i) {
                            //                     log(" ======+++++++++++++++++==========++++++++++======++++++++++=+>");
                            //                   },
                            //                   controller: VideoViewController(
                            //                     rtcEngine: _engine,
                            //                     canvas: const VideoCanvas(
                            //                       uid: 0,
                            //                     ),
                            //                   ),
                            //                 ),
                            //                 disableviceo
                            //                     ? Container(
                            //                         height: 20.h,
                            //                         width: 30.w,
                            //                         color: Colors.black,
                            //                         child: Icon(
                            //                           Icons.videocam_off,
                            //                           color: whitecolor,
                            //                         ),
                            //                       )
                            //                     : Container()
                            //               ],
                            //             ),
                            //           )
                            //         : _remoteVideo(),
                            //   ).pOnly(bottom: 13.h, right: 5.w),
                            //   Positioned(
                            //     bottom: 3.h, // Adjust the position as needed
                            //     left: 0,
                            //     right: 0,
                            //     child: Center(
                            //       child: Container(
                            //         height: 9.h,
                            //         width: 100.w,
                            //         decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(60),
                            //             color:AppColor.firstmainColor.withOpacity(0.6)),
                            //         child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             _localUserSpeaker
                            //                 ? Image.asset(
                            //                     'assets/speaker.png',
                            //                     height: 14.h,
                            //                     width: 14.w,
                            //                   ).onTap(() {
                            //                     _toggleSpeaker(false);
                            //                   })
                            //                 : Image.asset(
                            //                     'assets/speakerblack.png',
                            //                     height: 14.h,
                            //                     width: 14.w,
                            //                   ).onTap(() {
                            //                     _toggleSpeaker(true);
                            //                   }),
                            //             Container(
                            //                     decoration: BoxDecoration(
                            //                         shape: BoxShape.circle,
                            //                         color: _localUserJoined ==
                            //                                 false
                            //                             ? whitecolor
                            //                             : bgClr),
                            //                     child: const Icon(
                            //                         Icons.mic_off_outlined),
                            //                     width: 60,
                            //                     height: 60)
                            //                 .onTap(() {
                            //               if (_localUserJoined) {
                            //                 _toggleMute(false);
                            //               } else {
                            //                 _toggleMute(true);
                            //               }
                            //             }),
                            //             GestureDetector(
                            //                 onTap: () {
                            //                   Navigator.of(context).pop();
                            //                   _leaveChannel();
                            //                 },
                            //                 child: Image.asset(
                            //                     "assets/callend.png",
                            //                     width: 60,
                            //                     height: 60)),
                            //             Container(
                            //                     decoration: BoxDecoration(
                            //                         shape: BoxShape.circle,
                            //                         color: disableviceo == false
                            //                             ? whitecolor
                            //                             : bgClr),
                            //                     child: const Icon(
                            //                         Icons.videocam_rounded),
                            //                     width: 60,
                            //                     height: 60)
                            //                 .onTap(() {
                            //               closecamera();
                            //             }),
                            //           ],
                            //         ).pOnly(
                            //             left: 4.w, right: 4.w, bottom: .5.h),
                            //       ),
                            //     ),
                            //   ),
                            //   Positioned(
                            //     top: 5.h,
                            //     right: 4.w,
                            //     child: Container(
                            //       height: 4.h,
                            //       width: 4.h,
                            //       decoration: BoxDecoration(
                            //           color: whitecolor,
                            //           shape: BoxShape.circle),
                            //       child: Icon(
                            //         Icons.camera_rear,
                            //         color: blackColor,
                            //         size: 20.sp,
                            //       ),
                            //     ).onTap(() {
                            //       _switchCamera();
                            //     }),
                            //   )
                            // ],
                          ),
                        );
                      }));
                    });
      },
    );
  }

  @override
  void dispose() {
    log("dispose ================++++++++>");
    _leaveChannel();
    super.dispose();
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return ChatRoomUserImageForVideo(
        name: widget.userId,
        time: '',
        callStatus: false,
        child: AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: RtcConnection(channelId: channelName),
          ),
        ),
      );
    } else {
      return Center(
        child: AppText(
            fontWeight: FontWeight.w400, size: 20.sp, text: "Please Wait ...."),
      );
    }
  }
}
