// ignore_for_file: file_names, non_constant_identifier_names

// import 'dart:convert';

class ChatInboxModel {
  String? senderId;
  String? recevierId;
  String? lastMesage;
  int? badgeCount;
  String? senderImg;
  String? sendername;
  String? chatID;
  int? timestamp;
  ChatInboxModel({
    this.senderId,
    this.recevierId,
    this.lastMesage,
    this.badgeCount,
    this.senderImg,
    this.chatID,
  });

  ChatInboxModel.fromMap(Map<String, dynamic> map) {
    badgeCount = map["badgeCount"];
    chatID = map["chatID"];
    lastMesage = map["lastChat"];
    recevierId = map["recevierId"];
    sendername = map["senderName"];
    senderId = map["senderId"];
    senderImg = map["senderImg"];
    timestamp = map["timestamp"];
  }

  Map<String, dynamic> toMap() {
    return {
      'badgeCount': badgeCount,
      'chatID': chatID,
      'chatRoomId': "no",
      'lastChat': lastMesage,
      'recevierId': recevierId,
      'senderName': sendername,
      'senderId': senderId,
      'senderImg': senderImg,
      'timestamp': timestamp,
    };
  }
}
