import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/ui/dashboard/filter/filter.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../component/reuseable_widgets/apptext.dart';
import '../../../component/reuseable_widgets/container.dart';
import '../../../component/reuseable_widgets/custom_image_view.dart';
import '../../../component/reuseable_widgets/reusebottombar.dart';
import '../notification/notification.dart';
import '../profile/design/refferal.dart';

class Setting extends StatefulWidget {
  final bool
      fromOtherPage; // Add a boolean to indicate navigation from another page

  const Setting({super.key, this.fromOtherPage = false}); // Default to false

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
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
            Spacer(),
            GestureDetector(
              onTap: () {}, // Add functionality if needed
              child: Column(
                children: [
                  CustomImageView(
                    imagePath: "assets/images/setting.png",
                    height: 3.h,
                    width: 3.h,
                    color: widget.fromOtherPage
                        ? AppColor.tinderclr
                        : null, // Change color conditionally
                  ),
                  SizedBox(height: 0.5.h),
                  AppText(
                    fontWeight: FontWeight.w500,
                    size: 9.sp,
                    text: "Setting",
                    color: widget.fromOtherPage
                        ? AppColor.tinderclr
                        : Colors.black, // Change color conditionally
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  CustomNavigator.push(
                      context: context, screen: const FilterScreen());
                },
                child: AppContainer(
                  height: MediaQuery.of(context).size.height * 0.060,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      AppText(
                          fontWeight: FontWeight.w400,
                          size: 13.sp,
                          text: 'Filter'),
                      Spacer(),
                      Image.asset(
                        'assets/images/arrows.png',
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  CustomNavigator.push(context: context, screen: Refferal());
                },
                child: AppContainer(
                  height: MediaQuery.of(context).size.height * 0.060,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      AppText(
                          fontWeight: FontWeight.w400,
                          size: 13.sp,
                          text: 'Referral'),
                      Spacer(),
                      Image.asset(
                        'assets/images/arrows.png',
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  CustomNavigator.push(context: context, screen: NotificationScreen());
                },
                child: AppContainer(
                  height: MediaQuery.of(context).size.height * 0.060,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      AppText(
                          fontWeight: FontWeight.w400,
                          size: 13.sp,
                          text: 'Notifications'),
                      Spacer(),
                      Image.asset(
                        'assets/images/arrows.png',
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
