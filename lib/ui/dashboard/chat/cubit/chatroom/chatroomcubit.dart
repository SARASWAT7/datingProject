import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apppara.dart';
import 'package:demoproject/ui/dashboard/chat/cubit/chatroom/chatroomstate.dart';
import 'package:demoproject/ui/dashboard/chat/design/photopreview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  ChatRoomCubit() : super(const ChatRoomState());

  updatedata(String name, String myImage, int pageNavId, String userId,
      String otherUserId, String profileImage, String userName) {
    emit(state.copyWith(
      userName: name,
    ));
  }

  String setroom() {
    if (int.parse(state.userId) > int.parse(state.otherUserId)) {
      return '${state.userId}-${state.otherUserId}';
    } else {
      return '${state.otherUserId}-${state.userId}';
    }
  }

  messageCountUpdtae() async {
    // Map datauser={};
    await FirebaseFirestore.instance
        .collection("users")
        .doc(state.userId)
        .collection("myInbox")
        .doc(state.setroom)
        .update({"badgeCount": 0});
  }

  void deleteMessages(id, String setroom, BuildContext context) {
    FirebaseFirestore.instance
        .collection('chatroom')
        .doc(setroom)
        .collection(setroom)
        .doc(id)
        .delete();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Deleted Sucessfully')));
    log(">>>>>>>>>>>>>>>>>>>>>");
    log(">>>>>>>>>>>>>>>>>>>>>${id}");
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

  Widget messagesListview(String setroom, String otherid) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chatroom")
            .doc(setroom)
            .collection(setroom)
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          readreciptupdate(setroom, otherid);
          if (snapshot.hasData) {
            return ListView(
                shrinkWrap: true,
                reverse: true,
                children:
                    addInstructionInSnapshot(snapshot.data!.docs).map((e) {
                  return _returnChatWidget(e, context, otherid);
                }).toList());
          }
          return const SizedBox();
        });
  }

  readreciptupdate(String chatidmy, String otherID) async {
    await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatidmy)
        .collection(chatidmy)
        .orderBy('timestamp')
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i]['idFrom'] == otherID) {
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

  late Widget _returnWidget;
  Widget _returnChatWidget(dynamic data, BuildContext context, String otherID) {
    if (data is QueryDocumentSnapshot) {
      _returnWidget = data['idFrom'] == otherID
          ? peerUserListTile(context, data['content'],
              returnTimeStamp(data['timestamp']), data['type'])
          : mineListTile(
              context,
              data['content'],
              returnTimeStamp(data['timestamp']),
              data['type'],
              data['timestamp'].toString(),
              data['isRead']);
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

  String returnTimeStamp(int messageTimeStamp) {
    String resultString = '';
    var format = DateFormat('hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(messageTimeStamp);
    resultString = format.format(date);
    return resultString;
  }

  Widget peerUserListTile(
      BuildContext context, String message, String time, String type) {
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
                                      maxWidth: size.width - 150),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        type == 'text' ? 10.0 : 0),
                                    child: AppPara(
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                        size: 12.sp,
                                        text: message),
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
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 14.0, left: 4),
                    //   child: Text(
                    //     time,
                    //     style: const TextStyle(fontSize: 12),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List deleteMessageId = [];
  Widget mineListTile(BuildContext context, String message, String time,
      String type, String timesamp, bool readUnread) {
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
                  type == 'text'
                      ? Container(
                          constraints: BoxConstraints(
                              maxWidth: size.width - size.width * 0.28),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xffFD5564), Color(0xffFE3C72)]),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(type == 'text' ? 10.0 : 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppPara(
                                    color: AppColor.white,
                                    fontWeight: FontWeight.w500,
                                    size: 12.sp,
                                    text: message),
                                readUnread == false
                                    ? Image.asset(
                                        "assets/images/un_read_image.png",
                                        height: 15,
                                        width: 15,
                                        color: AppColor.white,
                                      )
                                    : Image.asset("assets/images/readAll.png",
                                        height: 15,
                                        width: 15,
                                        color: AppColor.white)
                              ],
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
                          child: Image.network(
                            message,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                ],
              ),
            ],
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
}
