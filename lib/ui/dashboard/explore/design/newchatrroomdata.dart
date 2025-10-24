//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dash_chat/dash_chat.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../../../component/commonfiles/appcolor.dart';
// import '../../../../component/commonfiles/shared_preferences.dart';
// import '../../../../component/reuseable_widgets/appText.dart';
// import '../../../auth/model/getanswerresponse.dart';
// import '../../chat/chatmethod/firestore.dart';
// import '../../chat/design/photopreview.dart';
// import 'exploredetail.dart';
//
// class GroupChatScreen1 extends StatefulWidget {
//   final int index;
//  // final Result? explore;
//   final String userId;
//   final String profileImage;
//   final String userName;
//   final String gropuname;
//   final String groupId;
//   final String otherUserId;
//   const GroupChatScreen1(
//       {Key? key,
//         required this.userId,
//         required this.profileImage,
//         required this.userName,
//         required this.gropuname,
//         required this.groupId,
//         required this.otherUserId,
//         // required this.explore,
//         required this.index})
//       : super(key: key);
//
//   @override
//   State<GroupChatScreen1> createState() => _GroupChatScreen1State();
// }
//
// class _GroupChatScreen1State extends State<GroupChatScreen1> {
//   List membersList = [];
//   Future getGroupDetails() async {
//     await FirebaseFirestore.instance
//         .collection('groups')
//         .doc(widget.groupId)
//         .get()
//         .then((chatMap) {
//       membersList = chatMap['members'];
//
//       setState(() {});
//     });
//   }
//
//   @override
//   void initState() {
//     getGroupDetails();
//     super.initState();
//   }
//
//   String userName = "";
//   FBCloudStore fbCloudStore = FBCloudStore();
//   TextEditingController msgController = TextEditingController();
//   String chatId = "";
//   String imageUrl = "";
//   var setroom;
//   final TextEditingController _message = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Widget messageTile(Size size, Map<String, dynamic> chatMap) {
//     return Builder(builder: (_) {
//       if (chatMap['type'] == "text") {
//         return Container(
//           width: size.width,
//           alignment: chatMap['sendBy'] == widget.userId
//               ? Alignment.centerRight
//               : Alignment.centerLeft,
//           child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
//               margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 color: Colors.blue,
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     chatMap['sendBy'],
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(
//                     height: size.height / 200,
//                   ),
//                   Text(
//                     chatMap['message'],
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               )),
//         );
//       } else if (chatMap['type'] == "img") {
//         return Container(
//           width: size.width,
//           alignment: chatMap['sendBy'] == widget.userName
//               ? Alignment.centerRight
//               : Alignment.centerLeft,
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//             margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//             height: size.height / 2,
//             child: Image.network(
//               chatMap['message'],
//             ),
//           ),
//         );
//       } else if (chatMap['type'] == "notify") {
//         return Container(
//           width: size.width,
//           alignment: Alignment.center,
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//             margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               color: Colors.black38,
//             ),
//             child: Text(
//               chatMap['message'],
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         );
//       } else {
//         return const SizedBox();
//       }
//     });
//   }
//
//   onSendMessage() async {
//     if (_message.text.isNotEmpty) {
//       Map<String, dynamic> chatData = {
//         "sendBy": widget.userId,
//         "senderName": widget.userName,
//         "senderimg": widget.profileImage,
//         "message": _message.text.trim(),
//         "type": "text",
//         "time": DateTime.now().millisecondsSinceEpoch,
//       };
//
//       _message.clear();
//
//       await _firestore
//           .collection('groups')
//           .doc(widget.groupId)
//           .collection('chats')
//           .add(chatData);
//     }
//   }
//
//   Widget messagesListview() {
//     return StreamBuilder<QuerySnapshot>(
//         stream: _firestore
//             .collection('groups')
//             .doc(widget.groupId)
//             .collection('chats')
//             .orderBy('time')
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasData) {
//             return ListView(
//                 shrinkWrap: true,
//                 reverse: true,
//                 children: addInstructionInSnapshot(snapshot.data!.docs)
//                     .map(_returnChatWidget)
//                     .toList());
//           }
//           return const SizedBox();
//         });
//   }
//
//   Widget peerUserListTile(BuildContext context, String message, String time,
//       String type, String name, String img) {
//     final size = MediaQuery.of(context).size;
//     return Padding(
//       padding: const EdgeInsets.only(top: 4.0),
//       child: SizedBox(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Row(
//                         children: [
//                           Container(
//                             height: 3.h,
//                             width: 3.h,
//                             decoration: /* chat.unread */
//                             BoxDecoration(
//                               // border: Border.all(color: Colors.black),
//                               color: whitecolor,
//                               shape: BoxShape.circle,
//                             ),
//                             child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(50),
//                                 child: img == ""
//                                     ? Icon(
//                                   Icons.person,
//                                   size: 14.sp,
//                                 )
//                                     : FadeInImage.assetNetwork(
//                                   placeholder: 'assets/logonew.png',
//                                   imageErrorBuilder:
//                                       (_, Object, StackTrace) {
//                                     return Icon(
//                                       Icons.person,
//                                       size: 26.sp,
//                                     );
//                                   },
//                                   image: img,
//                                   fit: BoxFit.cover,
//
//                                   // height: 250.0,
//                                 ) /* Image.network(
//                                               chatRoomModel.senderImg ?? "") */
//                             ),
//                           ),
//                           1.w.widthBox,
//                           Container(
//                             constraints: BoxConstraints(maxWidth: 35.w),
//                             child: AppText(
//                               fontWeight: FontWeight.w700,
//                               size: 12.sp,
//                               text: name,
//                             ),
//                           )
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
//                             child: type == 'text'
//                                 ? Container(
//                               constraints: BoxConstraints(
//                                   maxWidth: size.width - 150),
//                               decoration: BoxDecoration(
//                                 color: AppColor.slideColor,
//                                 borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(20),
//                                     topRight: Radius.circular(20),
//                                     bottomRight: Radius.circular(20)),
//                               ),
//                               child: Padding(
//                                 padding: EdgeInsets.all(
//                                     type == 'text' ? 10.0 : 0),
//                                 child: Text(
//                                   message,
//                                   style: const TextStyle(
//                                       color: Colors.black),
//                                 ),
//                               ),
//                             )
//                                 : GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           PhotoViewScreen(
//                                             imagePath: message,
//                                           )),
//                                 );
//                               },
//                               child: Image.network(
//                                 message,
//                                 height: 200,
//                                 width: 200,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 14.0, left: 4),
//                         child: Text(
//                           time,
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget mineListTile(BuildContext context, String message, String time,
//       String type, String timesamp, bool readUnread) {
//     final size = MediaQuery.of(context).size;
//     return PopupMenuButton<int>(
//       itemBuilder: (context) => [
//         // PopupMenuItem 1
//         PopupMenuItem(
//           value: 1,
//           // row with 2 children
//           child: Row(
//             children: [
//               Text(
//                 "Delete",
//                 style: TextStyle(color: AppColor.black),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Icon(Icons.delete, color: AppColor.activeiconclr),
//             ],
//           ),
//         ),
//
//         //PopupMenuItem 2
//       ],
//       // offset: Offset(0, 100),
//
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.only(top: 2.0, right: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 2, 4, 4),
//                       child: type == 'text'
//                           ? Container(
//                         constraints: BoxConstraints(
//                             maxWidth: size.width - size.width * 0.28),
//                         decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(20),
//                               topRight: Radius.circular(20),
//                               bottomLeft: Radius.circular(20)),
//                         ),
//                         child: Padding(
//                           padding:
//                           EdgeInsets.all(type == 'text' ? 10.0 : 0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 message,
//                                 style:
//                                 const TextStyle(color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                           : GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => PhotoViewScreen(
//                                   imagePath: message,
//                                 )),
//                           );
//                         },
//                         child: Image.network(
//                           message,
//                           height: 200,
//                           width: 200,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             /*        Container(
//               padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
//               alignment: Alignment.centerRight,
//               child: readUnread == false
//                   ? Image.asset(
//                       "assets/un_read_image.png",
//                       height: 15,
//                       width: 15,
//                     )
//                   : Image.asset(
//                       "assets/readAll.png",
//                       height: 15,
//                       width: 15,
//                     ),
//             ),
//          */
//             Padding(
//               padding: const EdgeInsets.only(bottom: 14.0, right: 4, left: 8),
//               child: Text(
//                 time,
//                 style: const TextStyle(fontSize: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//       // on selected we show the dialog box
//       onSelected: (value) {
//         deleteMessages(timesamp);
//       },
//     );
//   }
//
//   String returnTimeStamp(int messageTimeStamp) {
//     String resultString = '';
//     var format = DateFormat('hh:mm a');
//     var date = DateTime.fromMillisecondsSinceEpoch(messageTimeStamp);
//     resultString = format.format(date);
//     return resultString;
//   }
//
//   late Widget _returnWidget;
//   Widget _returnChatWidget(dynamic data) {
//     if (data is QueryDocumentSnapshot) {
//       _returnWidget = data['sendBy'] == widget.userId
//           ? mineListTile(
//           context,
//           data['message'],
//           returnTimeStamp(data['time']),
//           data['type'],
//           data['time'].toString(),
//           false)
//           : peerUserListTile(
//           context,
//           data['message'],
//           returnTimeStamp(data['time']),
//           data['type'],
//           data['senderName'],
//           data['senderimg']);
//     } else if (data is String) {
//       _returnWidget = stringListTile(data);
//     }
//     return _returnWidget;
//   }
//
//   Widget stringListTile(String data) {
//     Widget _returnWidget;
//
//     _returnWidget = Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: Center(
//         child: Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16), color: Colors.grey[300]),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
//             child: Text(
//               data,
//               style: const TextStyle(color: Colors.black87, fontSize: 12),
//             ),
//           ),
//         ),
//       ),
//     );
//
//     return _returnWidget;
//   }
//
//   List<dynamic> addInstructionInSnapshot(List<QueryDocumentSnapshot> snapshot) {
//     // print("snapshot");
//     // print(snapshot);x
//     List<dynamic> _returnList;
//     List<dynamic> _newData = addChatDateInSnapshot(snapshot);
//     _returnList = List<dynamic>.from(_newData.reversed);
//     // _returnList.add(chatInstruction);
//     return _returnList;
//   }
//
//   List<dynamic> addChatDateInSnapshot(List<QueryDocumentSnapshot> snapshot) {
//     List<dynamic> _returnList = [];
//     String _currentDate = "";
//
//     for (QueryDocumentSnapshot snapshot in snapshot) {
//       var format = DateFormat('EEEE, MMMM d, yyyy');
//       var date = DateTime.fromMillisecondsSinceEpoch(snapshot['time']);
//
//       // ignore: unnecessary_null_comparison
//       if (_currentDate == null) {
//         _currentDate = format.format(date);
//         _returnList.add(_currentDate);
//       }
//
//       if (_currentDate == format.format(date)) {
//         _returnList.add(snapshot);
//       } else {
//         _currentDate = format.format(date);
//         _returnList.add(_currentDate);
//         _returnList.add(snapshot);
//       }
//     }
//
//     return _returnList;
//   }
//
//   _willPopupScope() {
//
//   }
//
//   TextEditingController showcontroller = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return WillPopScope(
//       onWillPop: () => _willPopupScope(),
//       child: Scaffold(
//         backgroundColor: AppColor.white,
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(71.89),
//           child: Container(
//               height: 30.h,
//               width: 100.w,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(30),
//                       bottomRight: Radius.circular(30)),
//                   //boxShadow: kElevationToShadow[1],
//                   color: Colors.white),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   2.w.widthBox,
//                   Icon(
//                     Icons.arrow_back,
//                     color: Colors.black,
//                     size: 3.2.h,
//                   ).pOnly(top: 5.5.h).onTap(() {
//                     // Navigator.of(context).pushAndRemoveUntil(
//                     //     MaterialPageRoute(
//                     //         builder: (BuildContext context) => ExploreDetail(
//                     //           explore: widget.explore,
//                     //           index: widget.index,
//                     //         )),
//                     //         (route) => false);
//                   }),
//                   3.w.widthBox,
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText(
//                           fontWeight: FontWeight.w700,
//                           size: 15.sp,
//                           text: widget.gropuname),
//                       StreamBuilder<QuerySnapshot>(
//                           stream: _firestore
//                               .collection('groups')
//                               .doc(widget.groupId)
//                               .collection('members')
//                               .snapshots(),
//                           builder:
//                               (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                             if (snapshot.hasData) {
//                               return AppText(
//                                   fontWeight: FontWeight.w700,
//                                   size: 12.sp,
//                                   text:
//                                   "${snapshot.data?.docs.length} people joined");
//                             }
//                             return const SizedBox();
//                           }),
//                     ],
//                   ).pOnly(top: 6.5.h),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: () async {
//                       FirebaseFirestore.instance
//                           .collection('groups')
//                           .doc(widget.groupId)
//                           .collection('members')
//                           .doc(widget.userId)
//                           .delete();
//                       // Navigator.pushAndRemoveUntil(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //         builder: (_) => const BottomAppBar(currentIndex: 0)),
//                       //         (route) => false);
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text(
//                               'Return again to Explore with ${widget.gropuname}')));
//                     },
//                     child: Container(
//                       height: 4.h,
//                       width: 11.h,
//                       decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                               colors: [bgClr, bgClrDark]),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: AppText(
//                           fontWeight: FontWeight.w600,
//                           size: 12.sp,
//                           color: Colors.white,
//                           text: "Exit Chat")
//                           .centered(),
//                     ).pOnly(top: 6.5.h, right: 4.w),
//                   )
//                 ],
//               )),
//         ),
//         body: Column(
//           children: [
//             Expanded(child: messagesListview()),
//             /*     Container(
//               height: size.height / 1.27,
//               width: size.width,
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _firestore
//                     .collection('groups')
//                     .doc(widget.groupId)
//                     .collection('chats')
//                     .orderBy('time')
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return ListView.builder(
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         Map<String, dynamic> chatMap =
//                             snapshot.data!.docs[index].data()
//                                 as Map<String, dynamic>;
//
//                         return messageTile(size, chatMap);
//                       },
//                     );
//                   } else {
//                     return Container();
//                   }
//                 },
//               ),
//             ),
//           */
//
//             Container(
//               height: size.height / 8,
//               width: size.width,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30)),
//                 color: whitecolor,
//               ),
//               alignment: Alignment.center,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 75.w,
//                     child: TextField(
//                       minLines: 1,
//                       maxLines: 5,
//                       controller: _message,
//                       decoration: InputDecoration(
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               borderSide: BorderSide(
//                                 width: 2,
//                                 color:Colors.red,
//                               )),
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               borderSide: BorderSide(
//                                 width: 2,
//                                 color: Colors.red,
//                               )),
//                           errorBorder: const OutlineInputBorder(
//                             borderSide: BorderSide(width: 1),
//                           ),
//                           focusColor: bgClr,
//                           contentPadding: const EdgeInsets.symmetric(
//                               vertical: 0, horizontal: 10),
//                           hintText: "type messages",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           )),
//                     ),
//                   ),
//                   Container(
//                     height: 4.5.h,
//                     width: 4.5.h,
//                     decoration:
//                     BoxDecoration(color: bgClr, shape: BoxShape.circle),
//                     child: Center(
//                       child: Image.asset(
//                         'assets/sendmsg.png',
//                         height: 18,
//                         width: 18,
//                       ).onTap(() {
//                         onSendMessage();
//                       }),
//                     ),
//                   ).pOnly(left: 2.h),
//                   // Container(
//                   //   decoration: const BoxDecoration(
//                   //       color: Colors.black,
//                   //       borderRadius: BorderRadius.only(
//                   //           topRight: Radius.circular(10),
//                   //           bottomRight: Radius.circular(10))),
//                   //   child: IconButton(
//                   //       icon: Icon(
//                   //         Icons.send,
//                   //         color: whitecolor,
//                   //       ),
//                   //       onPressed: onSendMessage),
//                   // ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ).onTap(() {
//         AppUtils.keyboardHide(context);
//       }),
//     );
//   }
//
//   String readTimestamp(int timestamp) {
//     var now = DateTime.now();
//     var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
//     var diff = now.difference(date);
//     var time = '';
//
//     if (diff.inSeconds <= 0 ||
//         diff.inSeconds > 0 && diff.inMinutes == 0 ||
//         diff.inMinutes > 0 && diff.inHours == 0 ||
//         diff.inHours > 0 && diff.inDays == 0) {
//       if (diff.inHours > 0) {
//         time = '${diff.inHours} hour ago';
//       } else if (diff.inMinutes > 0) {
//         time = '${diff.inMinutes} min ago';
//       } else if (diff.inSeconds > 0) {
//         time = 'now';
//       } else if (diff.inMilliseconds > 0) {
//         time = 'now';
//       } else if (diff.inMicroseconds > 0) {
//         time = 'now';
//       } else {
//         time = 'now';
//       }
//     } else if (diff.inDays > 0 && diff.inDays < 7) {
//       time = '${diff.inDays} days ago';
//     } else if (diff.inDays > 6) {
//       time = '${(diff.inDays / 7).floor()} week ago';
//     } else if (diff.inDays > 29) {
//       time = '${(diff.inDays / 30).floor()} month ago';
//     } else if (diff.inDays > 365) {
//       time = '${date.month}-${date.day}-${date.year}';
//     }
//     return time;
//   }
//
//   //// send image function
//
//   showAlertDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           color: Colors.black38,
//           child: const Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }
//
//   void deleteMessages(id) {
//     FirebaseFirestore.instance
//         .collection('chatroom')
//         .doc(setroom)
//         .collection(setroom)
//         .doc(id)
//         .delete();
//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text('Deleted Sucessfully')));
//   }
// }
