import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/component/reuseable_widgets/text_field.dart';
import 'package:demoproject/ui/dashboard/chat/design/chatroom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../component/apihelper/normalmessage.dart';

class InboxContainer extends StatelessWidget {
  final String otherUserId;
  final String userId;
  final String profileImage;
  final String userName;
  final String myImage;
  final String name;
  final String returnTimeStamp;
  final String lastMesage;
  final String badgeCount;
  const InboxContainer(
      {super.key,
      required this.otherUserId,
      required this.userId,
      required this.profileImage,
      required this.userName,
      required this.myImage,
      required this.name,
      required this.returnTimeStamp,
      required this.lastMesage,
      required this.badgeCount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChatScreen(
                    otherUserId: otherUserId,
                    userId: userId,
                    profileImage: profileImage,
                    userName: userName,
                    pageNavId: 2,
                    myImage: myImage,
                    name: name)));
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(
          horizontal: DynamicSize.height(context) * .01,
          vertical: DynamicSize.height(context) * .01,
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 7.h,
              width: 7.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: AppColor.activeiconclr,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: (profileImage).isEmpty
                      ? Image.asset(
                          "assets/images/nopicdummy.png",
                          fit: BoxFit.cover,
                        )
                      : FadeInImage.assetNetwork(
                          placeholder: 'assets/images/nopicdummy.png',
                          imageErrorBuilder: (_, Object, StackTrace) {
                            return Image.asset(
                              "assets/images/nopicdummy.png",
                              fit: BoxFit.cover,
                            );
                          },
                          image: profileImage,
                          fit: BoxFit.cover,

                          // height: 250.0,
                        )),
            ),
            4.w.widthBox,
            SizedBox(
              width: 65.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AppText(
                        fontWeight: FontWeight.w700,
                        size: 16.sp,
                        text: userName != "" ? (userName) : "No_Name",
                      ),
                      AppText(
                        fontWeight: FontWeight.w600,
                        size: 14.sp,
                        text: returnTimeStamp,
                        color: textcolor,
                      )
                    ],
                  ),
                  SpaceWidget(height: DynamicSize.height(context) * .003),
                  Container(
                    width: 100.w,
                    alignment: Alignment.topLeft,
                    child: AppText(
                        fontWeight: FontWeight.w400,
                        size: 14.sp,
                        color: Colors.black54,
                        text: lastMesage),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).pOnly(
          left: DynamicSize.height(context) * .01,
          right: DynamicSize.height(context) * .01,
          top: DynamicSize.height(context) * .005,
          bottom: DynamicSize.height(context) * .005),
    );
    ;
  }
}
