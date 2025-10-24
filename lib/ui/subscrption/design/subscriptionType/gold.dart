import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../component/reuseable_widgets/appText.dart';
import '../../../../component/reuseable_widgets/custom_button.dart';
import '../goldSub.dart';

class Gold extends StatefulWidget {
  const Gold({super.key});

  @override
  State<Gold> createState() => _GoldState();
}

class _GoldState extends State<Gold> {
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
                    'Unlimited Likes.',
                    'Unlimited profile view.',
                    'Unlimited Video call Access.',
                    'Unlimited Audio call Access.',
                    'City Change possibility.',
                    'Unlimited Reels view.',
                    'Priority like.',
                    'Unlimited Reels upload.',
                    'Profile Boost first page.',
                    'Unlimited rewinds.',
                    'Chat with people anywhere in the world.',
                    'Control who see you.',
                    'Control your profile.',
                    'Cannot see match Profile.'
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
          SizedBox(height: 10.h,),
              GestureDetector(
                onTap: (){
                  CustomNavigator.push(context: context, screen: PremimumSubscription());
                },
                  child: CustomButton(text: 'Gold Subscription')),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

}
