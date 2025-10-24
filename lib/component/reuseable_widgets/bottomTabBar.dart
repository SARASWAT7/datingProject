import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ui/dashboard/chat/design/chat_tab.dart';
import '../../ui/dashboard/chat/videocall/audiocallaccept.dart';
import '../../ui/dashboard/explore/design/exploredata.dart';
import '../../ui/dashboard/home/design/homeheader.dart';
import '../../ui/dashboard/home/design/homepage.dart';
import '../../ui/dashboard/likes/slideSwitcher.dart';
import '../../ui/dashboard/profile/design/profile.dart';
import '../apihelper/normalmessage.dart';
import '../apihelper/internet_connectivity_service.dart';
import '../commonfiles/appcolor.dart';

class BottomBar extends StatefulWidget {
  final int currentIndex;
  const BottomBar({Key? key, this.currentIndex = 2}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 2;

  // // updatecall() async {}
  // // callNotification(
  //     String notificationType, Map<String, dynamic> data, String body) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   bool callStatus = pref.getBool("callRecived") ?? false;
  //   count += 1;
  //   _setBadgeNum(count);
  //   if (data["type"].toString() == "2") {
  //     if (callStatus == false) {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => AudioCallAccept(
  //                 userId: data["sender_firebase"].toString(),
  //                 profileImage: body,
  //                 name: data["callType"].toString(),
  //                 channelName: data["channelName"].toString(),
  //                 token: data["token"].toString(),
  //               )));
  //     }
  //   } else if (data["type"].toString() == "4") {
  //     setState(() {
  //       chatshowbadge = true;
  //     });
  //     // Navigator.push(
  //     //     context,
  //     //     MaterialPageRoute(
  //     //         builder: (_) => const Dashboard(
  //     //               currentindex: 1,
  //     //             )));
  //   } else if (data["type"].toString() == "3") {
  //     setState(() {
  //       showbadge = true;
  //     });
  //     // Navigator.push(
  //     //     context,
  //     //     MaterialPageRoute(
  //     //         builder: (_) => const Dashboard(
  //     //               currentindex: 3,
  //     //             )));
  //   }
  // }

  // getnotification() {
  //   FirebaseMessaging.instance.getInitialMessage().then(
  //         (message) {
  //       if (message != null) {
  //         callNotification("getInitialMessage", message.data,
  //             message.notification?.body ?? "");
  //       }
  //     },
  //   );
  //   // 2. This method only call when App in forground it mean app must be opened

  //   FirebaseMessaging.onMessage.listen(
  //         (message) {
  //       if (message != null && message.notification != null) {
  //         callNotification("App in forground", message.data,
  //             message.notification?.body ?? "");
  //       }
  //     },
  //   );
  //   // 3. This method only call when App in background and not terminated(not closed)
  //   FirebaseMessaging.onMessageOpenedApp.listen(
  //         (message) {
  //       if (message != null && message.notification != null) {
  //         callNotification("App in background ", message.data,
  //             message.notification?.body ?? "");
  //       }
  //     },
  //   );
  // }

  @override
  void initState() {
    setState(() {
      currentIndex = widget.currentIndex;
    });
    getnotification();
    super.initState();
  }

  callNotification(
    String notificationType,
    Map<String, dynamic> data,
    String body,
  ) async {
    log("$notificationType");

    // Ensure type is available in data and cast it safely to a string
    String notificationTypeFromData = data["type"]?.toString() ?? "unknown";

    if (notificationTypeFromData == "call") {
      // Proceed with the call-related notification
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AudioCallAccept(
            userId: data["sender_firebase"].toString(),
            profileImage: body,
            name: data["callType"].toString(),
            channelName: data["channelName"].toString(),
            token: data["token"].toString(),
            userName: "", // You may want to pass a userName here if needed
          ),
        ),
      );
    } else if (notificationTypeFromData == "4") {
      // Handle type 4 notification (e.g., chat-related)
      // setState(() {
      //   chatshowbadge = true;
      // });
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => const Dashboard(
      //       currentindex: 1,
      //     ),
      //   ),
      // );
    } else if (notificationTypeFromData == "3") {
      // Handle type 3 notification (e.g., another type of action)
      // setState(() {
      //   showbadge = true;
      // });
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => const Dashboard(
      //       currentindex: 3,
      //     ),
      //   ),
      // );
    } else {
      // If the notification type is unknown, you can log it or show a default action.
      log("Unknown notification type: $notificationTypeFromData");
    }
  }

  getnotification() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        callNotification(
          "getInitialMessage",
          message.data,
          message.notification?.body ?? "",
        );
      }
    });
    // 2. This method only call when App in forground it mean app must be opened

    FirebaseMessaging.onMessage.listen((message) {
      if (message != null && message.notification != null) {
        callNotification(
          "App in forground",
          message.data,
          message.notification?.body ?? "",
        );
      }
    });
    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message != null && message.notification != null) {
        callNotification(
          "App in background ",
          message.data,
          message.notification?.body ?? "",
        );
      }
    });
  }

  final List<Widget> pages = [
    ExploreData(),
    const ChatTab(),
    const HomePage(),
    LikePage(),
    const Profile(),
  ];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: currentIndex == 2
          ? PreferredSize(
              preferredSize: Size.fromHeight(DynamicSize.height(context) * .1),
              child: SafeArea(child: HomeHeader(onPressed: () {})),
            )
          : null,
      body: Column(
        children: [
          // Add connectivity indicator at the top
          InternetConnectivityService.buildConnectivityIndicator(context),
          // Main content
          Expanded(child: pages[currentIndex]),
        ],
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              onTap: onTap,
              currentIndex: currentIndex,
              selectedItemColor: AppColor.iconsColor,
              unselectedItemColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: GradientIcon(
                    image: 'assets/images/search.png',
                    isSelected: currentIndex == 0,
                  ),
                  label: "Tour",
                ),
                BottomNavigationBarItem(
                  icon: GradientIcon(
                    image: 'assets/images/chat.png',
                    isSelected: currentIndex == 1,
                  ),
                  label: "Chat",
                ),
                BottomNavigationBarItem(
                  icon: SizedBox.shrink(), // Empty placeholder for hover circle
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: GradientIcon(
                    image: 'assets/images/img_1.png',
                    isSelected: currentIndex == 3,
                  ),
                  label: "Like",
                ),
                BottomNavigationBarItem(
                  icon: GradientIcon(
                    image: 'assets/images/profile12.png',
                    isSelected: currentIndex == 4,
                  ),
                  label: "Profile",
                ),
              ],
            ),
          ),
          Positioned(
            top: -15, // Adjust height to hover above the bar
            child: GestureDetector(
              onTap: () => onTap(2), // Navigate to the "Home" page
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: GradientIcon(
                  image: 'assets/images/pinkheart.png',
                  isSelected: currentIndex == 2,
                  size: 45.0, // Larger size for hover circle icon
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  final String image;
  final bool isSelected;
  final double size; // New size property

  const GradientIcon({
    Key? key,
    required this.image,
    required this.isSelected,
    this.size = 24.0, // Default size if not provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        isSelected ? AppColor.iconsColor : Colors.black,
        BlendMode.srcIn,
      ),
      child: ImageIcon(
        AssetImage(image),
        size: size, // Use the new size property here
      ),
    );
  }
}
