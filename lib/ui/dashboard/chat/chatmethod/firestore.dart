import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class FBCloudStore {
  static FBCloudStore get instanace => FBCloudStore();
  // About Firebase Database
  Future<List<String>?> saveUserDataToFirebaseDatabase(
      userId, String chatId, userInfo) async {
    try {
      String myID = userInfo['userId'].toString();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(chatId)
          .set(userInfo)
          .then((value) {
        log("upadte");
      }).onError((error, stackTrace) {
        log("$error");
      });
      log("message");
      return [myID];
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<void> updateMyChatListValues(String userId, String chatID,
      String otherUserId, String typeUpdate) async {
    log('updateMyChatListValues');
    log(userId);
    log(otherUserId);

    // Validate all parameters before Firebase operation
    if (userId.isEmpty || chatID.isEmpty || otherUserId.isEmpty) {
      log('Error: Empty parameters for updateMyChatListValues - userId: $userId, chatID: $chatID, otherUserId: $otherUserId');
      return;
    }

    var updateData = {
      'badgeCount': 0,
      'chatRoomId': typeUpdate.isEmpty ? otherUserId : "no"
    };

    log("--=-=>>> userId $userId");
    log("--=-=>>> otherUserId $otherUserId");

    log("--=-=>>> chatID $chatID");
    log("--=-=>>> updateData $updateData");

    try {
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
    } catch (e) {
      log('Error in updateMyChatListValues transaction: $e');
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
      int timeStamp) async {
    // return;
    log("my badgecount: $mybadgecount , other user badgecount $otherbadgecount   %%%%%%%%%%%%%%%%%%%%>");
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
      'chatRoomId': "no"
    };
    // timestamp= DateTime.now().millisecondsSinceEpoch
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
      'chatRoomId': "no"
    };
    log("$myinbox=======>my");
    log("$other=======>other");
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

  Future sendMessageToChatRoom(chatID, userId, otherUserId, content,
      messageType, isread, int timeStamp) async {
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
      'isRead': isread
    });
  }
}
