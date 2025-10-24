import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../component/reuseable_widgets/appText.dart';

class Free extends StatefulWidget {
  const Free({super.key});

  @override
  State<Free> createState() => _FreeState();
}

class _FreeState extends State<Free> {
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
        Align(
alignment:Alignment.center ,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...[
                  'Access to 20 Likes per day',
                  'Cannot see who likes you',
                  'View only three reels per day',
                  'Cannot see replies',
                  'Cannot make Audio call',
                  'Cannot make Video call',
                  'Cannot see match Profile'
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
