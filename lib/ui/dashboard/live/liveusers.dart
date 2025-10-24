// import 'dart:convert';
// import 'dart:developer';
// import 'package:demoproject/component/reuseable_widgets/apploder.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../component/apihelper/common.dart';
// import '../../../component/reuseable_widgets/appBar.dart';
// import '../../../component/reuseable_widgets/reusebottombar.dart';
// import '../home/repository/homerepository.dart';
// import 'cubit/liveCubit.dart';
// import 'cubit/liveState.dart';
// import '../chat/design/chatroom.dart';  // Import ChatScreen
//
// class LiveUserList extends StatefulWidget {
//   const LiveUserList({super.key});
//
//   @override
//   _LiveUserListState createState() => _LiveUserListState();
// }
//
// class _LiveUserListState extends State<LiveUserList> {
//   String userId = "";
//   String userImage = "";
//   String username = "";
//
//   @override
//   void initState() {
//     super.initState();
//     getToken();
//   }
//
//   getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     var userToken = prefs.getString("chatToken");
//     log("asdfghjk==================>");
//     print("userToken$userToken");
//     var jsondata = json.decode(userToken!);
//
//     setState(() {
//       userImage = jsondata['profilePic'].toString();
//       userId = jsondata['userID'].toString();
//       username = jsondata['name'].toString();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => LiveCubit(HomeRepository())..getProfile(context),
//       child: Scaffold(
//         // bottomNavigationBar: BottomSteet(
//         //   currentIndex: 0,
//         // ),
//         appBar: appBarWidgetThree(
//           leading: Padding(
//             padding: const EdgeInsets.only(left: 5.0),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pop();
//               },
//               child: Transform.scale(
//                 scale: 0.5,
//                 child: Image.asset(
//                   'assets/images/backarrow.png',
//                   height: 50,
//                   width: 50,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ),
//           title: 'Live Users',
//           titleColor: Colors.black,
//           backgroundColor: Colors.white,
//           centerTitle: true,
//         ),
//         backgroundColor: Colors.white,
//         body: BlocBuilder<LiveCubit, LiveState>(
//           builder: (context, state) {
//             if (state.status == ApiState.isLoading) {
//               return AppLoader();
//             } else if (state.status == ApiState.error) {
//               return Center(
//                 child: Text('NO User Online'),
//               );
//             } else if (state.status == ApiState.success && state.liveResponse != null) {
//               final users = state.liveResponse!.result?.users ?? [];
//               return Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "${users.length} Users are Live",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Colors.green,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: users.length,
//                       itemBuilder: (context, index) {
//                         final user = users[index];
//
//                         return GestureDetector(
//                           onTap: () {
//                             print("live users on chat");
//                             print(user.firebaseId.toString());
//                             print(userId);
//                             print(user.profilePicture ?? "");
//                             print('${user.firstName} ${user.lastName} ');
//                             print(userImage);
//                             print(username);
//
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => ChatScreen(
//                                   otherUserId: user.firebaseId.toString(),
//                                   userId: userId,
//                                   profileImage: user.profilePicture ?? "",
//                                   userName: '${user.firstName} ${user.lastName} ' ?? "",
//                                   pageNavId: 1,
//                                   myImage: userImage,
//                                   name: username,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: UserProfile(
//                             name: '${user.firstName} ${user.lastName}, ${user.age ?? 0}',
//                             location: '${user.city ?? 'Unknown'}, ${user.country ?? 'Unknown'}',
//                             distance: '${user.distance ?? 0} Miles Away',
//                             isOnline: user.isOnline ?? false,
//                             imageUrl: user.profilePicture ?? '',
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               return const Center(child: Text('No User Online'));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class UserProfile extends StatelessWidget {
//   final String name;
//   final String location;
//   final String distance;
//   final bool isOnline;
//   final String imageUrl;
//
//   const UserProfile({
//     Key? key,
//     required this.name,
//     required this.location,
//     required this.distance,
//     required this.isOnline,
//     required this.imageUrl,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       padding: const EdgeInsets.all(12.0),
//       decoration: BoxDecoration(
//         color: Colors.redAccent,
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               ClipOval(
//                 child: Image.network(
//                   imageUrl,
//                   width: 60,
//                   height: 60,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               if (isOnline)
//                 Positioned(
//                   bottom: 2,
//                   right: 2,
//                   child: Container(
//                     width: 12.0,
//                     height: 12.0,
//                     decoration: const BoxDecoration(
//                       color: Colors.green,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(width: 12.0),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                 ),
//                 const SizedBox(height: 4.0),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on,
//                       color: Colors.white70,
//                       size: 16.0,
//                     ),
//                     const SizedBox(width: 4.0),
//                     Expanded(
//                       child: Text(
//                         location,
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14.0,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),
//                     ),
//                     const SizedBox(width: 8.0),
//                     Text(
//                       distance,
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14.0,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

///////////////with sub scription condition ///////////////////////////


import 'dart:convert';
import 'dart:developer';
import 'dart:ui';  // Import for the blur effect
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../component/apihelper/common.dart';
import '../../../component/reuseable_widgets/appBar.dart';
import '../home/repository/homerepository.dart';
import 'cubit/liveCubit.dart';
import 'cubit/liveState.dart';
import '../chat/design/chatroom.dart';  // Import ChatScreen

class LiveUserList extends StatefulWidget {
  const LiveUserList({super.key});

  @override
  _LiveUserListState createState() => _LiveUserListState();
}

class _LiveUserListState extends State<LiveUserList> {
  String userId = "";
  String userImage = "";
  String username = "";
  bool isBlurred = false;
  bool shouldShowUsers = false;
  late final ScrollController _scrollController;
  LiveCubit? _liveCubit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // try to get cubit reference after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _liveCubit = context.read<LiveCubit>();
        _liveCubit?.getProfile(context);
      } catch (e) {
        // we'll try to recover later from build()
        log("❌ initState: couldn't read LiveCubit: $e");
      }
    });

    getToken();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Robust scroll listener:
  // - triggers when nearing bottom (normal ListView)
  // - if reverse: triggers when nearing top (minScrollExtent)
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_liveCubit == null) return;

    final pos = _scrollController.position;
    if (pos.maxScrollExtent == 0.0) return;

    // More aggressive scroll detection - trigger when user is 100 pixels from bottom
    if (pos.pixels >= pos.maxScrollExtent - 100) {
      log("🔄 Live Users - Scroll trigger activated - 100px from bottom");
      if (!_liveCubit!.isLoadingMore && _liveCubit!.hasMoreData) {
        log("🔄 Live Users - Triggering loadMoreUsers from scroll");
        _liveCubit!.loadMoreUsers();
      } else {
        log("🚫 Live Users - Cannot load more - isLoadingMore: ${_liveCubit!.isLoadingMore}, hasMoreData: ${_liveCubit!.hasMoreData}");
      }
    }
  }


  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString("chatToken");
    log("User Token (LiveUserList): $userToken");

    if (userToken == null || userToken.isEmpty) return;

    try {
      var jsondata = json.decode(userToken);
      setState(() {
        userImage = jsondata['profilePic']?.toString() ?? "";
        userId = jsondata['userID']?.toString() ?? "";
        username = jsondata['name']?.toString() ?? "";
      });

      checkPlan();
    } catch (e) {
      log("Error decoding chatToken: $e");
    }
  }

  Future<void> checkPlan() async {
    setState(() {
      shouldShowUsers = true;
      isBlurred = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // fallback: if _liveCubit wasn't set earlier, try getting it here
    _liveCubit ??= context.read<LiveCubit>();

    return Scaffold(
      appBar: appBarWidgetThree(
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Transform.scale(
              scale: 0.5,
              child: Image.asset(
                'assets/images/backarrow.png',
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        title: 'Live Users',
        titleColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          BlocBuilder<LiveCubit, LiveState>(
            builder: (context, state) {
              log("Live State: ${state.status}");
              final users = state.liveResponse?.result?.users ?? [];

              if (state.status == ApiState.isLoading) return AppLoader();

              if (state.status == ApiState.error) {
                return const Center(child: Text('NO User Online'));
              }

              if (state.status == ApiState.success && users.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No users are currently online',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

               return Column(
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(16.0),
                     child: Align(
                       alignment: Alignment.centerLeft,
                       child: Text(
                         "${_liveCubit?.totalUsersCount ?? users.length} Users Available",
                         style: const TextStyle(
                           fontSize: 18,
                           color: Colors.green,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                     ),
                   ),
                   Expanded(
                     child: ListView.builder(
                       controller: _scrollController,
                       itemCount: users.length + 1, // Always add 1 for loading/end message
                       itemBuilder: (context, index) {
                         // Show loading indicator or end message at the end
                         if (index == users.length) {
                           // If still loading more users, show loading indicator
                           if (_liveCubit?.isLoadingMore == true) {
                             return const Padding(
                               padding: EdgeInsets.all(16.0),
                               child: Center(child: CircularProgressIndicator()),
                             );
                           }
                           // If no more data, show message
                           else if (_liveCubit?.hasMoreData == false) {
                             return Padding(
                               padding: const EdgeInsets.all(16.0),
                               child: Center(
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Icon(
                                       Icons.people_outline,
                                       size: 48,
                                       color: Colors.grey[600],
                                     ),
                                     SizedBox(height: 8),
                                     Text(
                                       "Only ${_liveCubit?.totalUsersCount ?? users.length} users are active",
                                       style: TextStyle(
                                         fontSize: 16,
                                         color: Colors.grey[600],
                                         fontWeight: FontWeight.w500,
                                       ),
                                       textAlign: TextAlign.center,
                                     ),
                                     SizedBox(height: 4),
                                     Text(
                                       "Showing ${users.length} of ${_liveCubit?.totalUsersCount ?? users.length} users",
                                       style: TextStyle(
                                         fontSize: 12,
                                         color: Colors.grey[500],
                                       ),
                                       textAlign: TextAlign.center,
                                     ),
                                   ],
                                 ),
                               ),
                             );
                           }
                           // Default loading state
                           return const Padding(
                             padding: EdgeInsets.all(16.0),
                             child: Center(child: CircularProgressIndicator()),
                           );
                         }

                         // Safety trigger: if user reaches the 8th user (index 7), attempt to trigger
                         if (index == 7 && 
                             _liveCubit != null && 
                             !_liveCubit!.isLoadingMore && 
                             _liveCubit!.hasMoreData) {
                           log("⚠️ Live Users - Safety trigger at 8th user (index 7) -> loadMoreUsers()");
                           WidgetsBinding.instance.addPostFrameCallback((_) {
                             if (mounted && !_liveCubit!.isLoadingMore && _liveCubit!.hasMoreData) {
                               _liveCubit!.loadMoreUsers();
                             }
                           });
                         }

                         final user = users[index];
                         return GestureDetector(
                           onTap: () {
                             Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (_) => ChatScreen(
                                   otherUserId: user.firebaseId.toString(),
                                   userId: userId,
                                   profileImage: user.profilePicture ?? '',
                                   userName: '${user.firstName} ${user.lastName}',
                                   pageNavId: 1,
                                   myImage: userImage,
                                   name: username,
                                 ),
                               ),
                             );
                           },
                           child: UserProfile(
                             name: '${user.firstName} ${user.lastName}, ${user.age ?? 0}',
                             location: '${user.city ?? 'Unknown'}, ${user.country ?? 'Unknown'}',
                             distance: '${user.distance ?? 0} Miles Away',
                             isOnline: user.isOnline ?? false,
                             imageUrl: user.profilePicture ?? '',
                           ),
                         );
                       },
                     ),
                   ),
                 ],
               );
            },
          ),

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
  }
}



class UserProfile extends StatelessWidget {
  final String name;
  final String location;
  final String distance;
  final bool isOnline;
  final String imageUrl;

  const UserProfile({
    Key? key,
    required this.name,
    required this.location,
    required this.distance,
    required this.isOnline,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipOval(
                child: Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              if (isOnline)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white70,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      distance,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
