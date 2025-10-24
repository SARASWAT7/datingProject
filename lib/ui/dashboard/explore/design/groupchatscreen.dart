
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoproject/component/apihelper/toster.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/commonfiles/shared_preferences.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/component/reuseable_widgets/bottomTabBar.dart';
import 'package:demoproject/ui/dashboard/chat/chatmethod/firestore.dart';
import 'package:demoproject/ui/dashboard/chat/design/photopreview.dart';
import 'package:demoproject/ui/dashboard/explore/design/exploredetail.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:demoproject/ui/dashboard/explore/model/exploremodel.dart';
import '../../../../component/reuseable_widgets/apploder.dart';
import '../../../../component/reuseable_widgets/apppara.dart';

class GroupChatScreen extends StatefulWidget {
  final int index;
  final Result? explore;
  final String userId;
  final String profileImage;
  final String userName;
  final String gropuname;
  final String groupId;
  final String otherUserId;

  const GroupChatScreen(
      {Key? key,
      required this.userId,
      required this.profileImage,
      required this.userName,
      required this.gropuname,
      required this.groupId,
      required this.otherUserId,
      required this.explore,
      required this.index})
      : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  List membersList = [];


  Future getGroupDetails() async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((chatMap) {
      membersList = chatMap['members'];
      log(membersList.toString());
      setState(() {});
    });
  }

  @override
  void initState() {
    getGroupDetails();
    super.initState();
  }

  List<Map<String, dynamic>> messages = []; // List holding messages locally
  List<String> deleteMessageId = []; // List to store message IDs to be deleted

  deleteMessagefuntion(List<String> deleteIds) async {
    setState(() {
      deleteloading = true;
      deleteuser = false;
    });

    // Remove the messages from the local list first (optimistic UI update)
    for (String messageId in deleteIds) {
      messages.removeWhere((message) => message['id'] == messageId); // Remove from local messages list
      deleteMessageId.add(messageId); // Add to delete ID list
    }

    // Now perform the deletion from Firestore
    for (String messageId in deleteIds) {
      try {
        // Delete the message from Firestore
        await FirebaseFirestore.instance
            .collection('chatroom')
            .doc(setroom)
            .collection(setroom)
            .doc(messageId) // Use messageId directly
            .delete();
        log('Message deleted from Firestore: $messageId');
      } catch (e) {
        log("Error deleting message: $e");
      }
    }

    // Update the state to reflect the deletion in the UI
    setState(() {
      deleteloading = false;
    });
  }






  String userName = "";
  FBCloudStore fbCloudStore = FBCloudStore();
  TextEditingController msgController = TextEditingController();
  String chatId = "";
  String imageUrl = "";
  var setroom;
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool deleteloading = false;
  bool deleteuser = false;

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    return Builder(builder: (_) {
      if (chatMap['type'] == "text") {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] == widget.userId
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  Text(
                    chatMap['sen`dBy'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: size.height / 200,
                  ),
                  Text(
                    chatMap['message'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
        );
      } else if (chatMap['type'] == "img") {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] == widget.userName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            height: size.height / 2,
            child: Image.network(
              chatMap['message'],
            ),
          ),
        );
      } else if (chatMap['type'] == "notify") {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black38,
            ),
            child: Text(
              chatMap['message'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  onSendMessage() async {

    if (_message.text.isNotEmpty) {
      print("1234567890--->");
      print(widget.userName );
      print(widget.userId);
      Map<String, dynamic> chatData = {
        "sendBy": widget.userId,
        "senderName": widget.userName,
        "senderimg": widget.profileImage,
        "message": _message.text.trim(),
        "type": "text",
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      _message.clear();

      await _firestore
          .collection('groups')
          .doc(widget.groupId)
          .collection('chats')
          .add(chatData);
    }
  }

  Widget messagesListview() {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('groups')
            .doc(widget.groupId)
            .collection('chats')
            .orderBy('time')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(
                shrinkWrap: true,
                reverse: true,
                children: addInstructionInSnapshot(snapshot.data!.docs)
                    .map(_returnChatWidget)
                    .toList());
          }
          return const SizedBox();
        });
  }

  Widget peerUserListTile(BuildContext context, String message, String time,
      String type, String name, String img) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: SizedBox(
        child: Row(
          // mainAxisAlignment: ,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 4.h,
                            width: 4.h,
                            decoration: /* chat.unread */
                                BoxDecoration(
                              // border: Border.all(color: Colors.black),
                              color: whitecolor,
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: img == ""
                                    ? Icon(
                                        Icons.person,
                                        size: 14.sp,
                                      )
                                    : FadeInImage.assetNetwork(
                                        placeholder: 'assets/images/profile12.png',
                                        height: 10,
                                        width: 10,
                                        imageErrorBuilder:
                                            (_, Object, StackTrace) {
                                          return Icon(
                                            Icons.person,
                                            size: 10.sp,
                                          );
                                        },
                                        image: img,
                                        fit: BoxFit.cover,

                                        // height: 250.0,
                                      ) /* Image.network(
                                              chatRoomModel.senderImg ?? "") */
                                ),
                          ),
                          Container(
                            constraints: BoxConstraints(maxWidth: 100.w),
                            child: AppText(
                              fontWeight: FontWeight.w700,
                              size: 16.sp,
                              text: name,
                            ),
                          ).pOnly(bottom: 0.6.h,left: 2.w)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                            child: type == 'text'
                                ? Column(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: size.width - 150),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),  // You can use a specific value instead of 0.25 if needed
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(0),  // This indicates no rounding for bottom left
                                        ),                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            type == 'text' ? 10.0 : 0),
                                        child: Text(
                                          message,
                                          style:
                                          const TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),

                                  ],
                                )
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PhotoViewScreen(
                                                  imagePath: message,
                                                )),
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
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  // List deleteMessageId = [];
  Widget mineListTile(BuildContext context, String message, String time, String type,
      String timestamp, bool readUnread, String messageId) {

    // If the message has been deleted, don't display it
    if (deleteMessageId.contains(messageId)) {
      return SizedBox.shrink();  // Return an empty widget to hide the message
    }

    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 2.0, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Delete Message"),
                      content: Text(
                        "Are you sure you want to delete this message?",
                        style: TextStyle(color: AppColor.black, fontSize: 12, fontWeight: FontWeight.w200),
                      ),
                      actions: [
                        TextButton(
                          child: Text("Cancel", style: TextStyle(color: AppColor.black)),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: Text("Delete", style: TextStyle(color: AppColor.activeiconclr)),
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
                  constraints: BoxConstraints(maxWidth: size.width - size.width * 0.2),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xffFD5564), Color(0xffFE3C72)]),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(00),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(type == 'text' ? 10.0 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppPara(color: AppColor.white, fontWeight: FontWeight.w400, size: 16.sp, text: message),
                        readUnread == false
                            ? Image.asset("assets/images/un_read_image.png", height: 20, width: 20, color: AppColor.white)
                            : Image.asset("assets/images/readAll.png", height: 20, width: 20, color: AppColor.white),
                      ],
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PhotoViewScreen(imagePath: message)),
                    );
                  },
                  child: Image.network(message, height: 200, width: 200, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(bottom: 14.0, left: 4),
            child: Text(time, style: const TextStyle(fontSize: 12, color: Colors.black)),
          ),
        ],
      ),
    );
  }




  String returnTimeStamp(int messageTimeStamp) {
    String resultString = '';
    var format = DateFormat('hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(messageTimeStamp);
    resultString = format.format(date);
    return resultString;
  }

  late Widget _returnWidget;


  Widget _returnChatWidget(dynamic data) {
    if (data is QueryDocumentSnapshot) {
      String messageId = data.id;

      if (deleteMessageId.contains(messageId)) {
        return SizedBox.shrink();
      }

      _returnWidget = data['sendBy'] == widget.userId
          ? mineListTile(
        context,
        data['message'],
        returnTimeStamp(data['time']),
        data['type'],
        data['time'].toString(),
        false,
        messageId,
      )
          : peerUserListTile(
        context,
        data['message'],
        returnTimeStamp(data['time']),
        data['type'],
        data['senderName'],
        data['senderimg'],
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
              borderRadius: BorderRadius.circular(16), color: Colors.grey[300]),
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

  List<dynamic> addInstructionInSnapshot(List<QueryDocumentSnapshot> snapshot) {
    // print("snapshot");
    // print(snapshot);
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
      var date = DateTime.fromMillisecondsSinceEpoch(snapshot['time']);

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

  _willPopupScope() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => ExploreDetail(
                  index: widget.index,
                  explore: widget.explore,
                )),
        (route) => false);
  }

  TextEditingController showcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _willPopupScope(),
      child: Scaffold(
        backgroundColor: AppColor.slideColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(73.0),
          child: Container(
            // height: 30.h,
            width: 100.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                //boxShadow: kElevationToShadow[1],
                color: Colors.white),
            child: Row(

              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                2.w.widthBox,
                Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 3.2.h,
                ).onTap(() {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BottomBar(
                            currentIndex: 0,
                          )),
                          (route) => false);
                }).pOnly(bottom: 4.h),
                2.w.widthBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 40.w,
                      child: AppText(
                        textAlign: TextAlign.left,
                        maxlin: 2,
                          fontWeight: FontWeight.w600,
                          size: 12.sp,
                          text: widget.gropuname),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('groups')
                            .doc(widget.groupId)
                            .collection('members')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          log("jjjlenght======>${snapshot.data?.docs.length}");
                          if (snapshot.hasData) {
                            return SizedBox(
                              width: 40.w,
                              child: AppText(
                                textAlign: TextAlign.left,
                                hello:TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600,
                                  size: 12.sp,
                                  text:
                                      "${snapshot.data?.docs.length} people joined"),
                            );
                          }
                          return const SizedBox();
                        }),
                  ],
                ).pOnly(left: 4.w),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    FirebaseFirestore.instance
                        .collection('groups')
                        .doc(widget.groupId)
                        .collection('members')
                        .doc(widget.userId)
                        .delete();
                    log("hello   ${widget.userId}");
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BottomBar(currentIndex: 0)),
                        (route) => false);

                  },
                  child: Container(
                    height: 4.h,
                    width: 10.h,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColor.tinderclr, AppColor.tinderclr]),
                        borderRadius: BorderRadius.circular(10)),
                    child: AppText(
                            fontWeight: FontWeight.w600,
                            size: 12.sp,
                            color: Colors.white,
                            text: "Exit Chat")
                        .centered(),
                  ).pOnly(right: 2.w, bottom: 2.h),
                )
              ],
            ).pOnly(top: 5.h),
          ),
        ),
        body:
        Column(
          children: [
            Expanded(child: messagesListview()),
            Container(
              height: size.height / 8,
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: whitecolor),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80.w,
                    child: TextField(
                      minLines: 1,
                      maxLines: 5,
                      controller: _message,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1,
                                color: bgClr,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFFE4DFDF),
                              )),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                          focusColor: bgClr,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                          hintText: "Type something....",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  1.w.widthBox,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: whitecolor,
                      ),
                      onPressed: onSendMessage,

                    ),

                  ),
                ],
              ),
            ),
          ],
        ),
      ).onTap(() {
        AppUtils.keyboardHide(context);
      }),
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
  // Future picImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) return;
  //
  //     setState(() {
  //       uploadeImages(image.path);
  //     });
  //   } on PlatformException catch (e) {
  //     log('no image: $e');
  //   }
  // }
  //
  // uploadeImages(String path) async {
  //   showAlertDialog(context);
  //   final file = File(path);
  //   String fileName = file.path.split('/').last;
  //
  //   final metadata = SettableMetadata(contentType: "image/jpeg");
  //
  //   final storageRef = FirebaseStorage.instance.ref();
  //
  //   final uploadTask =
  //       storageRef.child("images/path/to/$fileName").putFile(file, metadata);
  //
  //   uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
  //     switch (taskSnapshot.state) {
  //       case TaskState.running:
  //         final progress =
  //             100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
  //         print("Upload is $progress% complete.");
  //         break;
  //       case TaskState.paused:
  //         print("Upload is paused.");
  //         break;
  //       case TaskState.canceled:
  //         print("Upload was canceled");
  //         break;
  //       case TaskState.error:
  //         Navigator.of(context).pop();
  //         showToast(context, "error");
  //
  //         // Handle unsuccessful uploads
  //         break;
  //       case TaskState.success:
  //         getImageLink(fileName);
  //
  //         break;
  //     }
  //   });
  // }

  // void getImageLink(String baseName) async {
  //   final imageUrls = await FirebaseStorage.instance
  //       .ref()
  //       .child("images/path/to/$baseName")
  //       .getDownloadURL();
  //
  //   setState(() {
  //     imageUrl = imageUrls;
  //     Navigator.of(context).pop();
  //   });
  //
  //   log(imageUrl.toString());
  // }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black38,
            child: AppLoader());
      },
    );
  }

}

