import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/ui/dashboard/chat/model/datacreationmodel.dart';
import 'package:demoproject/ui/dashboard/chat/model/inboxmodel.dart';
import 'package:demoproject/ui/dashboard/chat/model/usermodel.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/get_toekn_model.dart';
import '../model/sent_notification.dart';

class CorettaChatRepository {
  static final BaseOptions _baseOptions = BaseOptions(
    // baseUrl: "http://172.16.100.132:7200",
    baseUrl: UrlEndpoints.baseUrl,
  );
  Dio dio = Dio(_baseOptions);
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> registerUser(
    FirebaseUserCreation request,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(request.toMap()['userID'].toString())
          .set(request.toMap());

      return request.toMap();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getCurrentUserData(String userId) async {
    var userData = await firestore.collection('user').doc(userId).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Future<void> updateMyChatListValues(
    String userId,
    String chatID,
    String otherUserId,
    String typeUpdate,
  ) async {
    log('updateMyChatListValues');
    log(userId);
    log(otherUserId);

    var updateData = {
      'badgeCount': 0,
      'chatRoomId': typeUpdate.isEmpty ? otherUserId : "no",
    };

    log("--=-=>>> userId $userId");
    log("--=-=>>> otherUserId $otherUserId");

    log("--=-=>>> chatID $chatID");
    log("--=-=>>> updateData $updateData");

    final DocumentReference result = FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserId)
        .collection('myInbox')
        .doc(chatID);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(result);
      if (!snapshot.exists) {
        final DocumentReference result1 = FirebaseFirestore.instance
            .collection('users')
            .doc(otherUserId)
            .collection('myInbox')
            .doc(chatID);
        transaction.update(result1, updateData);
      } else {
        transaction.update(result, updateData);
      }
    });
  }

  Stream<List<ChatInboxModel>> getChatContacts(String userId) {
    // Validate userId before Firebase operation
    if (userId.isEmpty) {
      log('Error: User ID is empty for getChatContacts');
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('myInbox')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((event) async {
          List<ChatInboxModel> contacts = [];
          for (var document in event.docs) {
            log(document.data().toString());
            contacts.add(ChatInboxModel.fromMap(document.data()));
          }
          return contacts;
        });
  }

  Future sendMessageToChatRoom(
    chatID,
    userId,
    otherUserId,
    content,
    messageType,
    isread,
    int timeStamp,
  ) async {
    // Validate all parameters before Firebase operation
    if (chatID.isEmpty || userId.isEmpty || otherUserId.isEmpty) {
      log(
        'Error: Empty parameters for sendMessageToChatRoom - chatID: $chatID, userId: $userId, otherUserId: $otherUserId',
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(chatID)
          .collection(chatID)
          .doc(timeStamp.toString())
          .set({
            'idFrom': userId,
            'idTo': otherUserId,
            'timestamp': timeStamp,
            'content': content,
            'type': messageType,
            'isRead': isread,
          });
    } catch (e) {
      log('Error sending message to chat room: $e');
    }
  }

  Future updateUserChatListField(
    int mybadgecount,
    int otherbadgecount,
    String otherUserId,
    String lastMessage,
    chatID,
    userId,
    String myName,
    String otherusername,
    String myImg,
    String otherImg,
    String chatroomid,
    int timeStamp,
  ) async {
    var other = {
      'chatID': chatID,
      'inboxId': chatroomid,
      'lastChat': lastMessage,
      'badgeCount': otherbadgecount,
      'timestamp': timeStamp,
      'senderName': myName,
      'senderImg': myImg,
      'senderId': userId,
      'reciverId': otherUserId,
      'chatRoomId': "no",
    };

    var myinbox = {
      'chatID': chatID,
      'inboxId': chatroomid,
      'lastChat': lastMessage,
      'badgeCount': mybadgecount,
      'timestamp': timeStamp,
      'senderName': otherusername,
      'senderImg': otherImg,
      'senderId': otherUserId,
      'reciverId': userId,
      'chatRoomId': "no",
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(otherUserId)
        .collection('myInbox')
        .doc(chatID)
        .set(other);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('myInbox')
        .doc(chatID)
        .set(myinbox);
  }

  //////sent notification///////////
  //sent notification
  Future<sentNotification> sentNoti(
    String deviceToken,
    String userID,
    String channelName,
    String token1,
    String callType,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token');

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.interceptors.add(PrettyDioLogger());
    try {
      final response = await dio.post(
        "user/send-token",
        data: {
          "deviceToken": deviceToken,
          "receiver_id": userID,
          "channelName": channelName,
          "tokenData": token1,
          "callType": callType,
        },
      );
      log(
        "${response.data} $deviceToken ++++++++++++++++++++++====================>",
      );
      return sentNotification.fromJson(response.data);
    } on DioError catch (e) {
      print("${e.response?.data}  eeeee===============>");
      throw e.response?.data['message'].toString() ?? "sdsd";
    } catch (e) {
      throw e.toString();
    }
  }

  Future<sentNotification> sentNotiMessage(
    String userID,
    String message,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('token');

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.interceptors.add(PrettyDioLogger());
    try {
      final response = await dio.post(
        "user/send-notification",
        data: {"receiver_id": userID, "messageString": message, "data": ""},
      );

      return sentNotification.fromJson(response.data);
    } on DioException catch (e) {
      print("${e.response?.data}  eeeee===============>");
      throw e.response?.data['message'].toString() ?? "sdsd";
    } catch (e) {
      throw e.toString();
    }
  }
}

////////////////vediocall////////////////
class AgoraVideoCall {
  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: UrlEndpoints.baseUrl,
  );
  Dio dio = Dio(_baseOptions);

  Future<GetToken> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.interceptors.add(PrettyDioLogger());
    try {
      final response = await dio.get("user/get-channel-token");
      return GetToken.fromJson(response.data);
    } on DioError catch (e) {
      log("message ${e.response?.data} +++++++++++++==============+++++>");
      throw e.response?.data['message'];
    } catch (e) {
      throw e.toString();
    }
  }
}
