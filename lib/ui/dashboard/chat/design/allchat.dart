// import 'dart:developer';
//
// import 'package:demoproject/component/apihelper/normalmessage.dart';
// import 'package:demoproject/component/commonfiles/appcolor.dart';
// import 'package:demoproject/component/reuseable_widgets/apploder.dart';
// import 'package:demoproject/ui/dashboard/chat/cubit/cubit/chatcubit.dart';
// import 'package:demoproject/ui/dashboard/chat/cubit/cubit/chatstate.dart';
// import 'package:demoproject/ui/dashboard/chat/design/inboxcontainer.dart';
// import 'package:demoproject/ui/dashboard/chat/model/inboxmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../../../component/reuseable_widgets/appBar.dart';
// import '../../../../component/reuseable_widgets/bottomTabBar.dart';
//
// class AllChatScreen extends StatefulWidget {
//   const AllChatScreen({super.key});
//
//   @override
//   State<AllChatScreen> createState() => _AllChatScreenState();
// }
//
// class _AllChatScreenState extends State<AllChatScreen> {
//   getToken() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     log('${pref.getString("token") ?? ""} =============================++>hello');
//   }
//
//   @override
//   void initState() {
//     getToken();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return BlocBuilder<ChatCubit, ChatState>(
//       builder: (context, state) {
//
//         log(state.userId);
//         return  WillPopScope(
//           onWillPop: () async{
//             Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                     builder: (_) => BottomBar(
//                       currentIndex: 2,
//                     )),
//                     (route) => false);
//             return true;
//           },
//
//           child: SingleChildScrollView(
//             child: Container(
//               decoration: BoxDecoration(
//                   color: AppColor.slideColor,
//                   borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(35), topRight: Radius.circular(35))),
//               height: DynamicSize.height(context) * .7,
//               child: state.userId.isNotEmpty
//                   ? StreamBuilder<List<ChatInboxModel>>(
//                       stream: context.read<ChatCubit>().chatContacts(state.userId),
//                       builder: (context, snap) {
//                         if (snap.connectionState == ConnectionState.active) {
//                           if ((snap.data?.isNotEmpty ?? false)) {
//                             return ListView.builder(
//                                 shrinkWrap: true,
//                                 itemCount: snap.data?.length ?? 0,
//                                 itemBuilder: (context, i) {
//                                   return InboxContainer(
//                                     otherUserId: snap.data?[i].senderId ?? "",
//                                     userId: state.userId.toString(),
//                                     profileImage: snap.data?[i].senderImg ?? "",
//                                     userName: snap.data?[i].sendername ?? "",
//                                     myImage: state.profileImage,
//                                     name: state.name,
//                                     returnTimeStamp: context
//                                         .read<ChatCubit>()
//                                         .returnTimeStamp(snap.data?[i].timestamp),
//                                     lastMesage: snap.data?[i].lastMesage ?? "",
//                                     badgeCount:
//                                         snap.data?[i].badgeCount.toString() ?? "",
//                                   );
//                                 });
//                           } else {
//                             return Center(
//                               child: Text(
//                                 'No Chats Found',
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             );
//                           }
//                         } else {
//                           return AppLoader();
//                         }
//                       }).pOnly(top: DynamicSize.height(context) * .01)
//                   : const SizedBox(),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:developer';
import 'dart:ui';

import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/ui/dashboard/chat/cubit/cubit/chatcubit.dart';
import 'package:demoproject/ui/dashboard/chat/cubit/cubit/chatstate.dart';
import 'package:demoproject/ui/dashboard/chat/design/inboxcontainer.dart';
import 'package:demoproject/ui/dashboard/chat/model/inboxmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../component/reuseable_widgets/bottomTabBar.dart';

class AllChatScreen extends StatefulWidget {
  const AllChatScreen({super.key});

  @override
  State<AllChatScreen> createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen> {
  bool isBlurred = false; // To manage the blur effect
  bool shouldShowChats = false; // To determine if chats should be shown

  // Function to check if the plan is gold - DISABLED FOR ALL USERS
  Future<void> checkPlan() async {
    // DISABLED: All users can access chat without subscription
    setState(() {
      shouldShowChats = true;
      isBlurred = false; // Remove the blur for all users
    });

    // Ensure chat token is initialized
    try {
      context.read<ChatCubit>().getUserToken();
    } catch (e) {
      // Handle chat initialization error
      if (kDebugMode) {
        print('Chat initialization error: $e');
      }
    }
  }

  // Call the checkPlan method in initState
  @override
  void initState() {
    super.initState();
    checkPlan(); // Check the plan type when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        log(state.userId);

        return WillPopScope(
          onWillPop: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => BottomBar(currentIndex: 2)),
              (route) => false,
            );
            return true;
          },
          child: Stack(
            children: [
              // Main chat screen
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.slideColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  height: DynamicSize.height(context) * .75,
                  child: shouldShowChats
                      ? StreamBuilder<List<ChatInboxModel>>(
                          stream: context.read<ChatCubit>().chatContacts(
                            state.userId,
                          ),
                          builder: (context, snap) {
                            if (snap.connectionState ==
                                ConnectionState.active) {
                              if ((snap.data?.isNotEmpty ?? false)) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snap.data?.length ?? 0,
                                  itemBuilder: (context, i) {
                                    return InboxContainer(
                                      otherUserId: snap.data?[i].senderId ?? "",
                                      userId: state.userId.toString(),
                                      profileImage:
                                          snap.data?[i].senderImg ?? "",
                                      userName: snap.data?[i].sendername ?? "",
                                      myImage: state.profileImage,
                                      name: state.name,
                                      returnTimeStamp: context
                                          .read<ChatCubit>()
                                          .returnTimeStamp(
                                            snap.data?[i].timestamp,
                                          ),
                                      lastMesage:
                                          snap.data?[i].lastMesage ?? "",
                                      badgeCount:
                                          snap.data?[i].badgeCount.toString() ??
                                          "",
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text(
                                    'No Chats Found',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return AppLoader();
                            }
                          },
                        ).pOnly(top: DynamicSize.height(context) * .01)
                      : const SizedBox(),
                ),
              ),

              // Blurred effect over the background
              if (isBlurred)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(color: Colors.black.withOpacity(0.5)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
