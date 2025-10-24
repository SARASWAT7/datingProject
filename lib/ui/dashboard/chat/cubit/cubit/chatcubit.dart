import 'dart:convert';
import 'dart:developer';
import 'package:demoproject/ui/auth/model/verifyotpwithphoneresponse.dart';
import 'package:demoproject/ui/dashboard/chat/cubit/cubit/chatstate.dart';
import 'package:demoproject/ui/dashboard/chat/model/datacreationmodel.dart';
import 'package:demoproject/ui/dashboard/chat/model/inboxmodel.dart';
import 'package:demoproject/ui/dashboard/chat/repository/service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState());

  final CorettaChatRepository repo = CorettaChatRepository();
  void updateIndex(int update) {
    emit(state.copyWith(selectedIndex: update));
  }

  String formatLastChatTime(DateTime timestamp) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    if (timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day) {
      // Today
      return DateFormat.jm().format(timestamp);
    } else if (timestamp.year == yesterday.year &&
        timestamp.month == yesterday.month &&
        timestamp.day == yesterday.day) {
      // Yesterday
      return 'Yesterday';
    } else {
      // Older than yesterday
      return DateFormat('dd/MM/yyyy')
          .format(timestamp); // Format as "dd/MM/yyyy"
    }
  }

  String returnTimeStamp(messageTimeStamp) {
    String resultString = '';
    var formatc = DateFormat('EEEE, MMMM d, yyyy');
    var format = DateFormat('hh:mm');
    var format1 = DateFormat('EEE');
    var format2 = DateFormat('d MMM');
    var _currentdate = formatc.format(DateTime.now());
    var date = DateTime.fromMillisecondsSinceEpoch(messageTimeStamp);
    var chack = formatc.format(date);
    Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 7) return resultString = format1.format(date);
    if (diff.inDays > 0) {
      if (_currentdate == chack) {
        return resultString = format2.format(date);
      }
    }
    //  return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0) return resultString = format.format(date);
    // return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "min" : "min"} ago";
    }
    return "just now";
  }

  Stream<List<ChatInboxModel>> chatContacts(String userId) {
    log("$userId 1237");
    return repo.getChatContacts(userId);
  }

  void updateInbox(
    List<ChatInboxModel> inbox,
  ) {
    emit(state.copyWith(chatInbox: inbox));
  }

  void getUserToken() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? chatToken = pref.getString("chatToken");
      
      if (chatToken == null || chatToken.isEmpty) {
        return;
      }
      
      Map<String, dynamic> data = jsonDecode(chatToken);
      
      emit(state.copyWith(
          name: data['name'],
          profileImage: data['profilePic'],
          userId: data['userID'].toString()));
    } catch (e) {
      // Don't emit anything if parsing fails
    }
  }

  void registerChat(BuildContext context, User userData) async {
    String token = await FirebaseMessaging.instance.getToken() ?? "";
    try {
      final response = await repo.registerUser(FirebaseUserCreation(
          deviceToken: token,
          email: userData.email ?? "",
          userId: userData.firebaseId?.toInt() ?? 0,
          name: "${userData.firstName} ${userData.lastName}",
          mobile: userData.phone.toString(),
          profilePic: userData.profilePicture ?? ""));
      log(response.toString());
      // return "{response.toString()}";
    } catch (e) {
      // NormalMessage.instance.normalerrorstate(context, "message");
    }
  }
}
