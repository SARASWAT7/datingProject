import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../component/commonfiles/appcolor.dart';
import '../../../../component/reuseable_widgets/apploder.dart';
import '../../../../component/reuseable_widgets/apptext.dart';

class ChatRoomUserInfo extends StatefulWidget {
  final String name, image;
  final String time;
  final bool callStatus;
  const ChatRoomUserInfo(
      {super.key,
      required this.name,
      required this.image,
      required this.callStatus,
      required this.time});

  @override
  State<ChatRoomUserInfo> createState() => _ChatRoomUserInfoState();
}

class _ChatRoomUserInfoState extends State<ChatRoomUserInfo> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            fontWeight: FontWeight.w600,
            size: 18.sp,
            text: widget.time,
            color: whitecolor,
          ),
          3.h.heightBox,
          Container(
            height: 15.h,
            width: 40.w,
            decoration: BoxDecoration(
                color: whitecolor,
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: widget.image.contains("http")
                        ? NetworkImage(widget.image)
                        : Image.asset("assets/images/nopicdummysq.png").image,
                    fit: BoxFit.cover),
                border: Border.all(color: whitecolor, width: 2)),
          ),
          3.h.heightBox,
          AppText(
            fontWeight: FontWeight.w700,
            size: 22.sp,
            text: widget.name,
            color: whitecolor,
          ),
          widget.callStatus
              ? AppText(
                  fontWeight: FontWeight.w600,
                  size: 11.sp,
                  text: 'Ringing',
                  color: whitecolor,
                )
              : Container(),
        ],
      ),
    );
  }
}

class ChatRoomUserImage extends StatefulWidget {
  final String name;

  const ChatRoomUserImage({
    super.key,
    required this.name,
  });

  @override
  State<ChatRoomUserImage> createState() => _ChatRoomUserImageState();
}

class _ChatRoomUserImageState extends State<ChatRoomUserImage> {
  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
            height: 100.h,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: widget.name.contains("http")
                  ? NetworkImage(widget.name)
                  : Image.asset("assets/images/nopicdummysq.png").image,
              fit: BoxFit.cover,
            ))));
  }
}

class ChatRoomUserImageForVideo extends StatefulWidget {
  final String name;
  final String time;
  final bool callStatus;
  final Widget child;
  const ChatRoomUserImageForVideo(
      {super.key,
      required this.name,
      required this.callStatus,
      required this.time,
      required this.child});

  @override
  State<ChatRoomUserImageForVideo> createState() =>
      _ChatRoomUserImageForVideoState();
}

class _ChatRoomUserImageForVideoState extends State<ChatRoomUserImageForVideo> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("chat_id", isEqualTo: int.parse(widget.name))
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.connectionState != ConnectionState.active
              ? AppLoader()
              : Stack(
                  children: [
                    ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          height: 100.h,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: (snapshot.data?.docs.length ?? 0) == 0
                                ? Image.asset("assets/images/nopicdummysq.png")
                                    .image
                                : (snapshot.data?.docs.first
                                                .data()['profilePicture']
                                                .toString() ??
                                            "")
                                        .isEmpty
                                    ? Image.asset("assets/nopicdummy.png").image
                                    : NetworkImage((snapshot.data?.docs.first
                                                    .data()['profilePicture']
                                                    .toString() ??
                                                "")
                                            .isEmpty
                                        ? ""
                                        : (snapshot.data?.docs.first
                                                .data()['profilePicture']
                                                .toString() ??
                                            "")),
                            fit: BoxFit.cover,
                          )),
                        )),
                    widget.child,
                  ],
                );
        });
  }
}
