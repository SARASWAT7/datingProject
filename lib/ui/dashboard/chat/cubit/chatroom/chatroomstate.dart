import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class ChatRoomState extends Equatable {
  final String userId;
  final String otherUserId;
  final String setroom;
  final String myImage;

  final String profileImage;
  final String userName;
  final TextEditingController? controller;
  const ChatRoomState(
      {this.controller,
      this.otherUserId = "",
      this.myImage = "",
      this.profileImage = "",
      this.userName = "",
      this.setroom = "",
      this.userId = ""});
  @override
  List<Object?> get props => throw [controller];
  ChatRoomState copyWith(
      {TextEditingController? controller,
      String? userId,
      String? otherUserId,
      String? setroom,
      String? myImage,
      String? profileImage,
      String? userName}) {
    return ChatRoomState(
        controller: controller ?? this.controller,
        otherUserId: otherUserId ?? this.otherUserId,
        userId: userId ?? this.userId,
        setroom: setroom ?? this.setroom,
        myImage: myImage ?? this.myImage,
        profileImage: profileImage ?? this.profileImage,
        userName: userName ?? this.userName);
  }
}
