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
  String userId = "";
  bool joinTrue = false;
  String buttonName = "Join Now";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userImage = preferences.getString("profilePicture") ?? "";
      userId = preferences.getInt("userId")?.toString() ?? "";
      userName = preferences.getString("name") ?? "";
      print("1234567890987654321:$userImage");
    });

    createGroup(userName, userImage, userId);
  }

  void getUserDetail(String userId) async {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.explore!.sId)
        .collection('members')
        .get()
        .then((value) {
      setState(() {
        for (var doc in value.docs) {
          if (doc.data()["uid"] == userId) {
            joinTrue = true;
            buttonName = "Joined";
            break;
          }
        }
      });
    }).onError((error, stackTrace) {
      log("Error in getUserDetail: $error");
    });
  }

  void createGroup(String userName, String userImage, String userId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('groups')
        .doc(widget.explore!.sId)
        .set({
      "groupImg": widget.explore!.thumbnail,
      "groupname": widget.explore!.name ?? "",
      "id": widget.explore!.sId,
      "members": [{}]
    }).then((_) {
      getUserDetail(userId);
    }).onError((error, stackTrace) {
      log("Error in createGroup: $error");
    });
  }

  void toJoinGroup() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Map<String, dynamic> members = {
      "name": userName,
      "userImg": userImage,
      "uid": userId,
      "isAdmin": true,
    };
    await _firestore
        .collection('groups')
        .doc(widget.explore!.sId)
        .collection('members')
        .doc(userId)
        .set(members)
        .then((_) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => GroupChatScreen(
                otherUserId: userId,
                profileImage: userImage,
                userName: userName,
                userId: userId,
                groupId: widget.explore?.sId ?? " ",
                gropuname: widget.explore?.name ?? '',
                explore: widget.explore,
                index: widget.index,
              )),
              (route) => false);
    }).onError((error, stackTrace) {
      log("Error in toJoinGroup: $error");
    });
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
                size: 24.sp,
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
