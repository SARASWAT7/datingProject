import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../component/reuseable_widgets/appText.dart';
import '../../../../component/reuseable_widgets/customNavigator.dart';
import '../../../../component/reuseable_widgets/custom_button.dart';
import '../silverSub.dart';

class Silver extends StatefulWidget {
  const Silver({super.key});

  @override
  State<Silver> createState() => _SilverState();
}

class _SilverState extends State<Silver> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bgpattern.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Align(
            alignment:Alignment.center ,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...[
                    'See who likes you.',
                    'Like up to 50 profiles per day.',
                    '30 match profiles per day.',
                    'Load 10 reel per day.',
                    '1 free boost.',
                    'Video call with a single contact.',
                  ].map((text) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.2.h),
                        child: AppText(
                          maxlin: 2,
                          text: text,
                          size: 14.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 40.h,),
                  GestureDetector(
                      onTap: (){
                        CustomNavigator.push(context: context, screen: SubscriptionPage());
                      },
                      child: CustomButton(text: 'Silver Subscription')),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
