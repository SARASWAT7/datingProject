import 'package:demoproject/ui/dashboard/chat/model/inboxmodel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChatState extends Equatable {
  final int selectedIndex;
  final String userId;
  final String profileImage;
  final String name;
  final ConnectionState streamStatus;
  final List<ChatInboxModel>? chatInbox;
  ChatState(
      {this.selectedIndex = 0,
      this.name = "",
      this.streamStatus = ConnectionState.none,
      this.chatInbox,
      this.profileImage = "",
      this.userId = ""});
  @override
  List<Object?> get props =>
      [selectedIndex, chatInbox, userId, streamStatus, profileImage, name];
  ChatState copyWith(
      {int? selectedIndex,
      ConnectionState? streamStatus,
      String? name,
      List<ChatInboxModel>? chatInbox,
      String? userId,
      String? profileImage}) {
    return ChatState(
        name: name ?? this.name,
        streamStatus: streamStatus ?? this.streamStatus,
        profileImage: profileImage ?? this.profileImage,
        userId: userId ?? this.userId,
        chatInbox: chatInbox ?? this.chatInbox,
        selectedIndex: selectedIndex ?? this.selectedIndex);
  }
}
