import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/component/reuseable_widgets/bottomTabBar.dart';
import 'package:demoproject/component/reuseable_widgets/custom_button.dart';
import 'package:demoproject/ui/dashboard/explore/design/groupchatscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:demoproject/ui/dashboard/explore/model/exploremodel.dart';

class ExploreDetail extends StatefulWidget {
  final int index;
  final Result? explore;

  const ExploreDetail({Key? key, required this.index, this.explore})
      : super(key: key);

  @override
  State<ExploreDetail> createState() => _ExploreDetailState();
}

class _ExploreDetailState extends State<ExploreDetail> {
  String userImage = "";
  String userName = "";
  String userId = ""; // Backend userId
  String firebaseUserId = ""; // Firebase ID from chatToken
  bool joinTrue = false;
  String buttonName = "Join Now";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Loads Firebase ID from chatToken (saved by homecubit.dart updateUserDatatoFirebase)
  Future<void> _loadFirebaseId() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final chatToken = preferences.getString("chatToken") ?? "";
      if (chatToken.isNotEmpty) {
        final tokenData = jsonDecode(chatToken) as Map<String, dynamic>;
        // Firebase ID is stored as 'userID' in chatToken JSON
        firebaseUserId = tokenData['userID']?.toString() ?? "";
        log("🔥 Firebase ID loaded from chatToken: $firebaseUserId");
      } else {
        log("⚠️ chatToken is empty - Firebase ID not saved yet");
      }
    } catch (e) {
      log("❌ Error parsing chatToken for Firebase ID: $e");
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    
    // Get backend userId
    userId = preferences.getInt("userId")?.toString() ?? "";
    
    // Load Firebase ID from chatToken (saved in homecubit.dart updateUserDatatoFirebase)
    await _loadFirebaseId();

    setState(() {
      userImage = preferences.getString("profilePicture") ?? "";
      userName = preferences.getString("name") ?? "";
      log("📱 User Data - Backend userId: $userId, Firebase ID: $firebaseUserId, Image: $userImage");
    });

    // Use Firebase ID for group operations (preferred), fallback to backend userId
    final idToUse = firebaseUserId.isNotEmpty ? firebaseUserId : userId;
    if (idToUse.isNotEmpty) {
      createGroup(userName, userImage, idToUse);
    } else {
      log("❌ No valid user ID found for group operations");
    }
  }

  void getUserDetail(String firebaseUserId) async {
    final groupId = widget.explore?.sId?.toString().trim();
    if (groupId == null || groupId.isEmpty) {
      log("❌ Cannot get user detail: groupId is null or empty");
      return;
    }

    if (firebaseUserId.isEmpty) {
      log("❌ Cannot get user detail: firebaseUserId is empty");
      return;
    }

    try {
      FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .get()
          .then((value) {
        setState(() {
          for (var doc in value.docs) {
            // Check using Firebase ID (uid field or doc.id)
            if (doc.data()["uid"] == firebaseUserId || doc.id == firebaseUserId) {
              joinTrue = true;
              buttonName = "Joined";
              break;
            }
          }
        });
      }).onError((error, stackTrace) {
        log("Error in getUserDetail: $error");
      });
    } catch (e) {
      log("❌ Exception in getUserDetail: $e");
    }
  }

  void createGroup(String userName, String userImage, String firebaseUserId) async {
    final groupId = widget.explore?.sId?.toString().trim();
    if (groupId == null || groupId.isEmpty) {
      log("❌ Cannot create group: groupId is null or empty");
      return;
    }

    if (firebaseUserId.isEmpty) {
      log("❌ Cannot create group: firebaseUserId is empty");
      return;
    }

    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      // Use Firebase ID for user document path
      await _firestore
          .collection('users')
          .doc(firebaseUserId)
          .collection('groups')
          .doc(groupId)
          .set({
        "groupImg": widget.explore?.thumbnail ?? "",
        "groupname": widget.explore?.name ?? "",
        "id": groupId,
        "members": [{}]
      }).then((_) {
        getUserDetail(firebaseUserId);
      }).onError((error, stackTrace) {
        log("Error in createGroup: $error");
      });
    } catch (e) {
      log("❌ Exception in createGroup: $e");
    }
  }

  void toJoinGroup() async {
    // Validate group ID
    final groupId = widget.explore?.sId?.toString().trim();
    if (groupId == null || groupId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Group ID is missing. Cannot join group.')),
      );
      log("❌ Cannot join group: groupId is null or empty");
      return;
    }

    // Ensure Firebase ID is loaded (refresh if empty)
    if (firebaseUserId.isEmpty) {
      log("⚠️ Firebase ID not loaded, trying to reload from chatToken...");
      await _loadFirebaseId();
    }

    // Use Firebase ID (preferred), fallback to backend userId
    final idToUse = firebaseUserId.isNotEmpty ? firebaseUserId : userId;
    
    if (idToUse.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Firebase ID not found. Please ensure you have completed profile setup.'),
          duration: Duration(seconds: 3),
        ),
      );
      log("❌ Cannot join group: No valid user ID found (backend: $userId, Firebase: $firebaseUserId)");
      return;
    }

    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      Map<String, dynamic> members = {
        "name": userName,
        "userImg": userImage,
        "uid": idToUse, // Use Firebase ID
        "isAdmin": true,
      };
      
      log("🔗 Joining group: $groupId with Firebase ID: $idToUse");
      
      // Use Firebase ID as document ID in members collection
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .doc(idToUse) // Firebase ID as document ID
          .set(members)
          .then((_) {
        log("✅ Successfully joined group: $groupId with Firebase ID: $idToUse");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => GroupChatScreen(
                  otherUserId: idToUse, // Pass Firebase ID
                  profileImage: userImage,
                  userName: userName,
                  userId: idToUse, // Pass Firebase ID
                  groupId: groupId,
                  gropuname: widget.explore?.name ?? '',
                  explore: widget.explore,
                  index: widget.index,
                )),
                (route) => false);
      }).catchError((error) {
        log("❌ Error joining group: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join group: $error')),
        );
      });
    } catch (e) {
      log("❌ Exception joining group: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => BottomBar(
                  currentIndex: 0,
                )),
                (route) => false);
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      widget.explore?.thumbnail ?? "",
                      errorListener: (e) {
                        log("Error loading image: $e");
                      }),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high)),
          height: 100.h,
          width: 100.w,
          child: Column(
            children: [
              const Spacer(),
              AppText(
                maxlin: 4,
                color: AppColor.white,
                fontWeight: FontWeight.w700,
                size: 26.sp,
                text: widget.explore?.name.toString() ?? '',
              ),
              AppText(
                  color: whitecolor,
                  fontWeight: FontWeight.w600,
                  size: 12.sp,
                  text: "Find Someone down for something"),
              AppText(
                  color: whitecolor,
                  fontWeight: FontWeight.w600,
                  size: 12.sp,
                  text: "spontaneous"),
              1.h.heightBox,
              GestureDetector(
                onTap: toJoinGroup,
                child: CustomButton(
                  text: joinTrue ? buttonName : "Join Now",
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BottomBar(
                              currentIndex: 0,
                            )),
                            (route) => false);
                  },
                  child: AppText(
                      color: whitecolor,
                      fontWeight: FontWeight.w700,
                      size: 13.sp,
                      text: "No, Thanks")),
              3.h.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
