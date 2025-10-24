
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/commonfiles/shared_preferences.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/component/reuseable_widgets/bottomTabBar.dart';
import 'package:demoproject/ui/dashboard/chat/chatmethod/firestore.dart';
import 'package:demoproject/ui/dashboard/chat/design/photopreview.dart';
// import 'package:demoproject/ui/dashboard/chat/design/chatroom.dart';
import 'package:demoproject/ui/dashboard/explore/design/exploredetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    try {
      final doc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .get();
      
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data.containsKey('members')) {
          membersList = data['members'] ?? [];
          log('Group members loaded: ${membersList.length}');
        } else {
          log('No members field found in group document');
          membersList = [];
        }
      } else {
        log('Group document does not exist: ${widget.groupId}');
        membersList = [];
      }
      setState(() {});
    } catch (e) {
      log('Error getting group details: $e');
      membersList = [];
      setState(() {});
    }
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
                      fontSize: 20,
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
                      fontSize: 18,
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
      padding: EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Profile image
          GestureDetector(
            onTap: () {
              _showProfileView(context, name, img);
            },
            child: Container(
              height: 5.h,
              width: 5.h,
              decoration: BoxDecoration(
                color: whitecolor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.tinderclr.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: img == ""
                    ? Icon(
                        Icons.person,
                        size: 2.5.h,
                        color: Colors.grey[400],
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: 'assets/images/profile12.png',
                        image: img,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (_, Object, StackTrace) {
                          return Icon(
                            Icons.person,
                            size: 2.5.h,
                            color: Colors.grey[400],
                          );
                        },
                      ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Name
                Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: AppText(
                    fontWeight: FontWeight.w700,
                    size: 16.sp,
                    text: name,
                  ),
                ),
                // Message bubble
                Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: type == 'text'
                      ? Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            message,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PhotoViewScreen(
                                    imagePath: message,
                                  )),
                            );
                          },
                          child: Container(
                            height: 20.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200]),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/profile12.png',
                              image: message,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (_, Object, StackTrace) {
                                return Icon(
                                  Icons.image,
                                  size: 12.sp,
                                );
                              },
                            ),
                          ),
                        ),
                ),
                // Time
                Padding(
                  padding: EdgeInsets.only(top: 0.5.h),
                  child: AppText(
                    fontWeight: FontWeight.w400,
                    size: 12.sp,
                    color: Colors.grey[600]!,
                    text: time,
                  ),
                ),
              ],
            ),
          ),
        ],
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
      padding: EdgeInsets.only(top: 2.0, right: 8, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
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
            child: Container(
              constraints: BoxConstraints(maxWidth: size.width * 0.75),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xffFD5564), Color(0xffFE3C72)]),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(5),
                  bottomLeft: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: type == 'text'
                  ? Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppPara(
                            color: AppColor.white, 
                            fontWeight: FontWeight.w400, 
                            size: 16.sp, 
                            text: message
                          ),
                          SizedBox(height: 0.5.h),
                          readUnread == false
                              ? Image.asset(
                                  "assets/images/un_read_image.png", 
                                  height: 16, 
                                  width: 16, 
                                  color: AppColor.white
                                )
                              : Image.asset(
                                  "assets/images/readAll.png", 
                                  height: 16, 
                                  width: 16, 
                                  color: AppColor.white
                                ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PhotoViewScreen(imagePath: message)),
                        );
                      },
                      child: Container(
                        height: 20.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200]
                        ),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/profile12.png',
                          image: message,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (_, Object, StackTrace) {
                            return Icon(
                              Icons.image,
                              size: 12.sp,
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(height: 0.5.h),
          AppText(
            fontWeight: FontWeight.w400,
            size: 12.sp,
            color: Colors.grey[600]!,
            text: time,
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
          preferredSize: Size.fromHeight(8.h), // More responsive height
          child: Container(
            width: 100.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ]),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button and group info
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 2.5.h,
                          ).onTap(() {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BottomBar(
                                      currentIndex: 0,
                                    )),
                                    (route) => false);
                          }),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText(
                                  textAlign: TextAlign.left,
                                  maxlin: 1,
                                  fontWeight: FontWeight.w600,
                                  size: 16.sp,
                                  text: widget.gropuname,
                                ),
                                StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('groups')
                                        .doc(widget.groupId)
                                        .collection('members')
                                        .snapshots(),
                                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        return AppText(
                                          textAlign: TextAlign.left,
                                          fontWeight: FontWeight.w500,
                                          size: 14.sp,
                                          color: Colors.grey[600]!,
                                          text: "${snapshot.data?.docs.length} members",
                                        );
                                      }
                                      return const SizedBox();
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Exit button
                    GestureDetector(
                      onTap: () async {
                        FirebaseFirestore.instance
                            .collection('groups')
                            .doc(widget.groupId)
                            .collection('members')
                            .doc(widget.userId)
                            .delete();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const BottomBar(currentIndex: 0)),
                            (route) => false);
                      },
                      child: Container(
                        height: 4.h,
                        width: 20.w,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [AppColor.tinderclr, AppColor.tinderclr]),
                            borderRadius: BorderRadius.circular(20)),
                        child: AppText(
                                fontWeight: FontWeight.w600,
                                size: 14.sp,
                                color: Colors.white,
                                text: "Exit")
                            .centered(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body:
        Column(
          children: [
            Expanded(child: messagesListview()),
            Container(
              height: 8.h, // Reduced from size.height / 8 to 8.h for better responsiveness
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: whitecolor),
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: 6.h, // Limit max height for normal phones
                        ),
                        child: TextField(
                          minLines: 1,
                          maxLines: 3, // Reduced from 5 to 3 for normal phones
                          controller: _message,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: bgClr,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFFE4DFDF),
                                  )),
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                              ),
                              focusColor: bgClr,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              hintText: "Type something....",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      height: 5.h,
                      width: 5.h,
                      decoration: BoxDecoration(
                        color: AppColor.tinderclr,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: whitecolor,
                          size: 20,
                        ),
                        onPressed: onSendMessage,
                      ),
                    ),
                  ],
                ),
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

  /// Show profile view when user taps on profile image
  void _showProfileView(BuildContext context, String name, String imageUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.w),
            topRight: Radius.circular(4.w),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
            // Profile content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Column(
                  children: [
                    // Profile image
                    Container(
                      height: 20.h,
                      width: 20.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.h),
                        child: imageUrl.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 12.h,
                                color: Colors.grey[400],
                              )
                            : FadeInImage.assetNetwork(
                                placeholder: 'assets/images/profile12.png',
                                image: imageUrl,
                                fit: BoxFit.cover,
                                imageErrorBuilder: (_, __, ___) {
                                  return Icon(
                                    Icons.person,
                                    size: 12.h,
                                    color: Colors.grey[400],
                                  );
                                },
                              ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    // Name
                    AppText(
                      text: name,
                      fontWeight: FontWeight.bold,
                      size: 20.sp,
                      color: Colors.black,
                    ),
                    SizedBox(height: 1.h),
                    // Status
                    AppText(
                      text: "Group Member",
                      fontWeight: FontWeight.w500,
                      size: 14.sp,
                      color: Colors.grey[600]!,
                    ),
                    SizedBox(height: 4.h),
                    // Additional profile info
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[200]!, width: 1),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildInfoItem(Icons.person, "Group Member"),
                              _buildInfoItem(Icons.group, "Active"),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildInfoItem(Icons.chat, "Chat Available"),
                              _buildInfoItem(Icons.visibility, "Profile View"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    // Close button
                    Container(
                      width: 60.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: AppColor.tinderclr,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.tinderclr.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AppText(
                          text: "Close",
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          size: 16.sp,
                        ),
                      ),
                    ).onTap(() {
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

          /// Build info item for profile view
          Widget _buildInfoItem(IconData icon, String label) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    icon,
                    color: AppColor.tinderclr,
                    size: 6.w,
                  ),
                  SizedBox(height: 0.5.h),
                  AppText(
                    text: label,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    size: 10.sp,
                  ),
                ],
              ),
            );
          }

          /// Start personal chat with a user from group chat
          // void _startPersonalChat(BuildContext context, String userName, String userImage) async {
          //   print("1234567890--->personal chat started");
          //   print(userName);
          //   print(userImage); 
          //   try {
          //     // Get current user data
          //     SharedPreferences prefs = await SharedPreferences.getInstance();
          //     String currentUserId = prefs.getString('user_id') ?? '';
          //     String currentUserName = prefs.getString('userName') ?? '';
          //     String currentUserImage = prefs.getString('profileImage') ?? '';
          //     
          //     if (currentUserId.isEmpty) {
          //       log('Error: Current user ID is empty');
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(content: Text('Unable to start chat. Please login again.')),
          //       );
          //       return;
          //     }

          //     // Check if membersList is empty or null
          //     if (membersList.isEmpty) {
          //       log('Error: Members list is empty');
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(content: Text('Group members not loaded. Please try again.')),
          //       );
          //       return;
          //     }

          //     // Find the user ID from the group members
          //     String otherUserId = '';
          //     for (var member in membersList) {
          //       if (member != null && member is Map && member['userName'] == userName) {
          //         otherUserId = member['user_id'] ?? '';
          //         break;
          //       }
          //     }

          //     if (otherUserId.isEmpty) {
          //       log('Error: Could not find user ID for $userName');
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(content: Text('Unable to find user information.')),
          //       );
          //       return;
          //     }

          //     log('Starting personal chat: Current user: $currentUserId, Other user: $otherUserId');

          //     // Navigate to personal chat screen
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ChatScreen(
          //           name: userName,
          //           myImage: currentUserImage,
          //           pageNavId: 0,
          //           userId: currentUserId,
          //           otherUserId: otherUserId,
          //           profileImage: userImage,
          //           userName: currentUserName,
          //         ),
          //       ),
          //     );
          //   } catch (e) {
          //     log('Error starting personal chat: $e');
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(content: Text('Failed to start chat. Please try again.')),
          //     );
          //   }
          // }

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

