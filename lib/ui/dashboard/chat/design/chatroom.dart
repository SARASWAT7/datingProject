// ignore_for_file: prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers, avoid_print, unnecessary_brace_in_string_interps, deprecated_member_use, use_build_context_synchronously, empty_catches
import 'dart:developer';
import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/commonfiles/shared_preferences.dart';
import 'package:demoproject/component/reuseable_widgets/apppara.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/component/reuseable_widgets/text_field.dart';
import 'package:demoproject/component/utils/gradientwidget.dart';
import 'package:demoproject/ui/dashboard/chat/design/photopreview.dart';
import 'package:demoproject/ui/dashboard/chat/repository/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../component/reuseable_widgets/bottomTabBar.dart';
import '../videocall/audioCall.dart';
import '../videocall/videocall.dart';

int roomId = 0; //

class ChatScreen extends StatefulWidget {
  final String name;
  final String myImage;
  final int pageNavId;
  final String userId;
  final String otherUserId;
  final String profileImage;
  final String userName;
  const ChatScreen({
    Key? key,
    required this.otherUserId,
    required this.userId,
    required this.profileImage,
    required this.userName,
    required this.pageNavId,
    required this.myImage,
    required this.name,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ///////////////
  // readREcipt
  bool isSubscribed = false;

  //////////////
  readreciptupdate(String chatidmy) async {
    await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatidmy)
        .collection(chatidmy)
        .orderBy('timestamp')
        .get()
        .then((value) {
          for (int i = 0; i < value.docs.length; i++) {
            if (value.docs[i]['idFrom'] == widget.otherUserId) {
              if (value.docs[i]['isRead'] == false) {
                FirebaseFirestore.instance
                    .collection("chatroom")
                    .doc(chatidmy)
                    .collection(chatidmy)
                    .doc(value.docs[i].id)
                    .update({"isRead": true});
              }
            }
          }
        });
    log("yobio2==============>");
  }

  bool deleteloading = false;
  bool deleteuser = false;
  String userName = "";
  CorettaChatRepository fbCloudStore = CorettaChatRepository();
  var channelName, token;
  TextEditingController msgController = TextEditingController();
  String chatId = "";
  String imageUrl = "";
  var setroom;
  var roomid;
  String devicetokenofothermer = "";
  String otherusername = " ";
  String otheruserId = " ";
  List totalrAD = [];
  bool isloading = false;
  bool subsStatus = false;

  ///
  @override
  void initState() {
    // Validate user IDs before creating document paths
    if (widget.userId.isEmpty || widget.otherUserId.isEmpty) {
      log(
        'Error: User IDs are empty - userId: ${widget.userId}, otherUserId: ${widget.otherUserId}',
      );
      return;
    }

    try {
      if (int.parse(widget.userId) > int.parse(widget.otherUserId)) {
        setroom = '${widget.userId}-${widget.otherUserId}';
        roomid = widget.userId + widget.otherUserId;
        log('setroom is if $setroom');
        log('setroom is else $roomid');
        setState(() {
          roomId = int.parse(roomid);
        });
      } else {
        setroom = '${widget.otherUserId}-${widget.userId}';
        roomid = widget.otherUserId + widget.userId;
        log('setroom is else $setroom');
        log('setroom is else $roomid');
        setState(() {
          roomId = int.parse(roomid);
        });
      }
    } catch (e) {
      log('Error parsing user IDs: $e');
      return;
    }
    // BlocProvider.of<GetUserProfileCubit>(context).getUserProfile();
    // checksub();
    // Only proceed with Firebase operations if setroom is valid
    if (setroom.isNotEmpty) {
      readreciptupdate(setroom);
      messageCountUpdtae(setroom);

      // Validate otherUserId before Firebase operation
      if (widget.otherUserId.isNotEmpty) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(widget.otherUserId)
            .get()
            .then((value) {
              setState(() {
                devicetokenofothermer = value['deviceToken'];
                otherusername = value['userName'];
                otheruserId = value['user_id'];
                log(value['deviceToken'] + "     samne vale ka device token");
              });
            })
            .catchError((error) {
              log('Error fetching user data: $error');
            });
      }
      updateStatus();
      // Validate userId before Firebase operation
      if (widget.userId.isNotEmpty) {
        fbCloudStore.updateMyChatListValues(
          widget.userId,
          setroom,
          widget.otherUserId,
          "",
        );
      }
    }

    super.initState();
  }

  messageCountUpdtae(String chatId) async {
    // Map datauser={};
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .collection("myInbox")
        .doc(chatId)
        .update({"badgeCount": 0});
  }

  List<dynamic> addInstructionInSnapshot(List<QueryDocumentSnapshot> snapshot) {
    List<dynamic> _returnList;
    List<dynamic> _newData = addChatDateInSnapshot(snapshot);
    _returnList = List<dynamic>.from(_newData.reversed);
    // _returnList.add(chatInstruction);
    return _returnList;
  }

  List<dynamic> addChatDateInSnapshot(List<QueryDocumentSnapshot> snapshot) {
    List<dynamic> _returnList = [];
    String _currentDate = "";

    for (QueryDocumentSnapshot snapshot in snapshot) {
      var format = DateFormat('EEEE, MMMM d, yyyy');
      var date = DateTime.fromMillisecondsSinceEpoch(snapshot['timestamp']);

      // ignore: unnecessary_null_comparison
      if (_currentDate == null) {
        _currentDate = format.format(date);
        _returnList.add(_currentDate);
      }

      if (_currentDate == format.format(date)) {
        _returnList.add(snapshot);
      } else {
        _currentDate = format.format(date);
        _returnList.add(_currentDate);
        _returnList.add(snapshot);
      }
    }

    return _returnList;
  }

  String update() {
    if (int.parse(widget.userId) > int.parse(widget.otherUserId)) {
      return '${widget.userId}-${widget.otherUserId}';
      // roomid = widget.userId + widget.otherUserId;
    } else {
      return '${widget.otherUserId}-${widget.userId}';
    }
  }

  Future<bool> updateStatus() async {
    bool otheruserStatus = false;
    await FirebaseFirestore.instance
        .collection("Status")
        .doc(update())
        .get()
        .then((value) {
          log("message${value.data()} hello");
          otheruserStatus = value.data()?[widget.otherUserId] ?? false;
        })
        .onError((error, stackTrace) {
          log(error.toString());
        });

    await FirebaseFirestore.instance
        .collection("Status")
        .doc(update())
        .set({widget.userId: true, widget.otherUserId: otheruserStatus})
        .then((value) {
          log(
            "hello ${{widget.userId: true, widget.otherUserId: otheruserStatus}} ",
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
        });
    log("message hello$otheruserStatus ${widget.otherUserId}");
    return otheruserStatus;
  }

  updateMyStatustofalse() async {
    bool otheruserStatus = false;
    await FirebaseFirestore.instance
        .collection("Status")
        .doc(update())
        .get()
        .then((value) {
          print("message${value.data()} hello");
          otheruserStatus = value.data()?[widget.otherUserId] ?? false;
        })
        .onError((error, stackTrace) {
          log(error.toString());
        });

    await FirebaseFirestore.instance
        .collection("Status")
        .doc(update())
        .set({widget.userId: false, widget.otherUserId: otheruserStatus})
        .then((value) {
          print(
            "hello ${{widget.userId: false, widget.otherUserId: otheruserStatus}} ",
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
        });
  }

  sendMessageFunction() async {
    bool sendnoti = false;
    /* bool sendnoti = */
    await updateStatus()
        .then((value) {
          sendnoti = value;
          log("messag e =========++++++++++++++> $value");
        })
        .onError((error, stackTrace) {
          sendnoti = false;
        });
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.otherUserId)
        .get()
        .then((value) {
          setState(() {
            devicetokenofothermer = value['deviceToken'];
            otherusername = value['userName'];
            otheruserId = value['user_id'];
            log(value['deviceToken'] + "     samne vale ka device token");
          });
        });
    if (msgController.text.trim().isNotEmpty) {
      setState(() {
        howsubread = true;
        fbCloudStore.sendMessageToChatRoom(
          setroom,
          widget.userId,
          widget.otherUserId,
          imageUrl.isNotEmpty ? imageUrl : msgController.text.toString(),
          imageUrl.isNotEmpty ? "image" : 'text',
          false,
          DateTime.now().millisecondsSinceEpoch,
        );
        fbCloudStore.updateUserChatListField(
          0,
          0,
          widget.otherUserId,
          imageUrl.isNotEmpty ? imageUrl : msgController.text.toString(),
          setroom,
          widget.userId,
          widget.name,
          widget.userName,
          widget.myImage,
          widget.profileImage,
          setroom,
          DateTime.now().millisecondsSinceEpoch,
        );
        if (sendnoti == false) {
          log("++++++++++++++++++++++++++===================+++> message ");
          fbCloudStore.sentNotiMessage(
            widget.otherUserId,
            imageUrl.isNotEmpty
                ? "${widget.name} has sent an image"
                : msgController.text.toString(),
          );
          // BlocProvider.of<NotificationCubit>(context).sendnotification(
          //   devicetokenofothermer,
          //   "${widget.name} has send you a message",
          //   imageUrl.isNotEmpty
          //       ? "${widget.name} has send an image"
          //       : msgController.text.toString(),
          // );
        }

        msgController.clear();
        imageUrl = "";
      });
    }
  }

  deleteMessagefuntion(List delete) async {
    // Set the state to indicate loading and remove the message from the UI optimistically
    setState(() {
      deleteloading = true;
      deleteuser = false;
    });

    // Remove the message from the list immediately (optimistic UI update)
    for (int i = 0; i < delete.length; i++) {
      log("${delete.length} = $i  message id");

      // Immediately remove the message from the local list (optimistic update)
      deleteMessageId.remove(delete[i]);
    }

    // Now proceed to delete the message from Firestore
    for (int i = 0; i < delete.length; i++) {
      try {
        // Delete the message from Firestore
        await FirebaseFirestore.instance
            .collection('chatroom')
            .doc(setroom)
            .collection(setroom)
            .doc(delete[i])
            .delete();
        log('Message deleted: ${delete[i]}');
      } catch (e) {
        // Handle errors gracefully
        log("Error deleting message: $e");
      }
    }

    // Update the state to reflect the completion of the deletion
    setState(() {
      deleteloading = false;
    });
  }

  bool howsubread = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        updateMyStatustofalse();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => BottomBar(currentIndex: 1)),
          (route) => false,
        );
        return true;
      },
      child:
          Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(71.89),
              child: SafeArea(
                child: Container(
                  height: 30.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    boxShadow: kElevationToShadow[1],
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      2.w.widthBox,
                      Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 20.sp,
                      ).onTap(() {
                        Navigator.of(context).pop();
                        if (widget.pageNavId == 1) {
                          Navigator.of(context).pop();
                        }
                        if (widget.pageNavId == 2) {
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => const Dashboard(
                          //             currentindex: 1)),
                          //     (route) => false);
                        }
                        if (widget.pageNavId == 3) {
                          Navigator.of(context).pop();
                        }
                      }),
                      2.w.widthBox,
                      Container(
                        height: 7.h,
                        width: 7.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            CustomNavigator.push(
                              context: context,
                              screen: PhotoViewScreen(
                                imagePath: widget.profileImage,
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: widget.myImage.isEmptyOrNull
                                ? Image.asset(
                                    "assets/images/nopicdummy.png",
                                    fit: BoxFit.cover,
                                  )
                                : FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/nopicdummy.png',
                                    imageErrorBuilder: (_, object, stackTrace) {
                                      return Image.asset(
                                        "assets/images/nopicdummy.png",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                    image: widget.profileImage,
                                    fit: BoxFit.cover,

                                    // height: 250.0,
                                  ),
                          ),
                        ),
                      ).onTap(() {}),
                      2.w.widthBox,
                      AppText(
                        fontWeight: FontWeight.w700,
                        size: 16.sp,
                        text: widget.userName,
                      ),

                      const Spacer(),

                      4.w.widthBox,
                      SizedBox(
                            height: 20.sp,
                            width: 20.sp,
                            child: Image.asset(
                              "assets/images/callimg.png",
                              color: bgClr,
                            ),
                          )
                          .onTap(() async {
                            await [Permission.microphone]
                                .request()
                                .then((value) {
                                  log(value.toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AudioCallCall(
                                        userId: widget.otherUserId,
                                        profileImage: widget.profileImage,
                                        name: widget.userName,
                                        myUserId: widget.userId,
                                        userName: widget.userName,
                                      ),
                                    ),
                                  );
                                  print(
                                    "====================================>>",
                                  );
                                  print(widget.name);
                                })
                                .onError((error, stackTrace) => null);
                          })
                          .pOnly(right: 2.h),
                      deleteuser == false
                          ? SizedBox(
                              height: 20.sp,
                              width: 20.sp,
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
                              await [Permission.microphone, Permission.camera]
                                  .request()
                                  .then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => VideoCall(
                                          userId: widget.otherUserId,
                                          myUserId: widget.userId,
                                        ),
                                      ),
                                    );
                                  })
                                  .onError((error, stackTrace) {
                                    log(error.toString());
                                  });
                            })
                          : Icon(
                              Icons.delete,
                              color: bgClr,
                              size: 25.sp,
                              semanticLabel: "delete",
                            ).onTap(() {
                              deleteMessagefuntion(deleteMessageId);
                            }),

                      SpaceWidget(width: DynamicSize.width(context) * 0.01),
                    ],
                  ),
                ),
              ),
            ),

            body: SafeArea(
              child: Column(
                children: [
                  Expanded(child: messagesListview()),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: DynamicSize.width(context) * 0.02,
                      vertical: DynamicSize.height(context) * .01,
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        // minHeight: 50,
                        // maxHeight: DynamicSize.height(context) * 0.15,
                      ),
                      width: DynamicSize.width(context),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: const Color(0xffFD5564),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              cursorColor: AppColor.tinderclr,
                              minLines: 1,
                              maxLines: 5,
                              controller: msgController,
                              decoration: InputDecoration(
                                hintText: "Message....",
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.black),
                            onPressed: () {
                              if (msgController.text.trim().isNotEmpty) {
                                sendMessageFunction();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).onTap(() {
            AppUtils.keyboardHide(context);
          }),
    );
  }

  Widget messagesListview() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chatroom")
          .doc(setroom)
          .collection(setroom)
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        readreciptupdate(setroom);
        if (snapshot.hasData) {
          return ListView(
            shrinkWrap: true,
            reverse: true,
            children: addInstructionInSnapshot(
              snapshot.data!.docs,
            ).map(_returnChatWidget).toList(),
          );
        }
        return const SizedBox();
      },
    );
  }

  late Widget _returnWidget;
  Widget _returnChatWidget(dynamic data) {
    if (data is QueryDocumentSnapshot) {
      String message = data['content'] ?? '';
      String time = returnTimeStamp(data['timestamp']);
      String type = data['type'] ?? 'text';
      String messageId = data.id;
      bool readUnread = data['isRead'] ?? false;

      _returnWidget = data['idFrom'] == widget.otherUserId
          ? peerUserListTile(context, message, time, type)
          : myMessage(
              context,
              message,
              time,
              type,
              data['timestamp'].toString(),
              readUnread,
              messageId,
            );
    } else if (data is String) {
      _returnWidget = stringListTile(data);
    }
    return _returnWidget;
  }

  Widget stringListTile(String data) {
    Widget _returnWidget;

    _returnWidget = Padding(
      padding: const EdgeInsets.all(2.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[300],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            child: Text(
              data,
              style: const TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ),
        ),
      ),
    );

    return _returnWidget;
  }

  String returnTimeStamp(int messageTimeStamp) {
    String resultString = '';
    var format = DateFormat('hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(messageTimeStamp);
    resultString = format.format(date);
    return resultString;
  }

  Widget peerUserListTile(
    BuildContext context,
    String message,
    String time,
    String type,
  ) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Text(name),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                          child: type == 'text'
                              ? Container(
                                  constraints: BoxConstraints(
                                    maxWidth: size.width - 150,
                                    minHeight: 40,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(0),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      type == 'text' ? 10.0 : 0,
                                    ),
                                    child: AppPara(
                                      color: AppColor.black,
                                      fontWeight: FontWeight.w500,
                                      size: 16.sp,
                                      text: message,
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PhotoViewScreen(imagePath: message),
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    message,
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14.0, left: 4),
                      child: Text(
                        time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // List deleteMessageId = [];
  // Widget myMessage(BuildContext context, String message, String time,
  //     String type, String timesamp, bool readUnread) {
  //   final size = MediaQuery.of(context).size;
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 2.0, right: 8),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: <Widget>[
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 type == 'text'
  //                     ? Container(
  //                         constraints: BoxConstraints(
  //                             maxWidth: size.width - size.width * 0.2),
  //                         decoration: BoxDecoration(
  //                           gradient: const LinearGradient(
  //                               colors: [Color(0xffFD5564), Color(0xffFE3C72)]),
  //                           borderRadius: BorderRadius.only(
  //                             topLeft: Radius.circular(15),
  //                             topRight: Radius.circular(15),
  //                             bottomRight: Radius.circular(00),
  //                             bottomLeft: Radius.circular(15),
  //                           ),
  //                         ),
  //                         child: Padding(
  //                           padding: EdgeInsets.all(type == 'text' ? 10.0 : 0),
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.end,
  //                             mainAxisSize: MainAxisSize.min,
  //                             children: [
  //                               AppPara(
  //
  //                                   color: AppColor.white,
  //                                   fontWeight: FontWeight.w400,
  //                                   size: 10.sp,
  //                                   text: message),
  //                               readUnread == false
  //                                   ? Image.asset(
  //                                       "assets/images/un_read_image.png",
  //                                       height: 15,
  //                                       width: 15,
  //                                       color: AppColor.white,
  //                                     )
  //                                   : Image.asset("assets/images/readAll.png",
  //                                       height: 15,
  //                                       width: 15,
  //                                       color: AppColor.white)
  //                             ],
  //                           ),
  //                         ),
  //                       )
  //                     : GestureDetector(
  //                         onTap: () {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => PhotoViewScreen(
  //                                       imagePath: message,
  //                                     )),
  //                           );
  //                         },
  //                         child: Image.network(
  //                           message,
  //                           height: 200,
  //                           width: 200,
  //                           fit: BoxFit.cover,
  //                         ),
  //                       ),
  //               ],
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 5,),
  //         Padding(
  //           padding: const EdgeInsets.only(bottom: 14.0, left: 4),
  //           child: Text(
  //             time,
  //             style: const TextStyle(fontSize: 12 ,color: Colors.black),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  //
  // }
  List deleteMessageId = [];

  Widget myMessage(
    BuildContext context,
    String message,
    String time,
    String type,
    String timestamp,
    bool readUnread,
    String messageId,
  ) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 2.0, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Delete Message"),
                          content: Text(
                            "Are you sure you want to delete this message?",
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: AppColor.black),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: Text(
                                "Delete",
                                style: TextStyle(color: AppColor.activeiconclr),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                deleteMessagefuntion([messageId]);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: type == 'text'
                        ? Container(
                            constraints: BoxConstraints(
                              maxWidth: size.width - size.width * 0.2,
                              minHeight: 40,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xffFD5564), Color(0xffFE3C72)],
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(00),
                                bottomLeft: Radius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(
                                type == 'text' ? 10.0 : 0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppPara(
                                    color: AppColor.white,
                                    fontWeight: FontWeight.w400,
                                    size: 16.sp,
                                    text: message,
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  readUnread == false
                                      ? Image.asset(
                                          "assets/images/un_read_image.png",
                                          height: 20,
                                          width: 20,
                                          color: AppColor.white,
                                        )
                                      : Image.asset(
                                          "assets/images/readAll.png",
                                          height: 20,
                                          width: 20,
                                          color: AppColor.white,
                                        ),
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PhotoViewScreen(imagePath: message),
                                ),
                              );
                            },
                            child: Image.network(
                              message,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(bottom: 14.0, left: 4),
            child: Text(
              time,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      if (diff.inHours > 0) {
        time = '${diff.inHours} hour ago';
      } else if (diff.inMinutes > 0) {
        time = '${diff.inMinutes} min ago';
      } else if (diff.inSeconds > 0) {
        time = 'now';
      } else if (diff.inMilliseconds > 0) {
        time = 'now';
      } else if (diff.inMicroseconds > 0) {
        time = 'now';
      } else {
        time = 'now';
      }
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      time = '${diff.inDays} days ago';
    } else if (diff.inDays > 6) {
      time = '${(diff.inDays / 7).floor()} week ago';
    } else if (diff.inDays > 29) {
      time = '${(diff.inDays / 30).floor()} month ago';
    } else if (diff.inDays > 365) {
      time = '${date.month}-${date.day}-${date.year}';
    }
    return time;
  }

  //// send image function
  void getImageLink(String baseName) async {
    final imageUrls = await FirebaseStorage.instance
        .ref()
        .child("images/path/to/$baseName")
        .getDownloadURL();

    setState(() {
      imageUrl = imageUrls;
      sendMessageFunction();
      Navigator.of(context).pop();
    });

    log(imageUrl.toString());
  }
}
