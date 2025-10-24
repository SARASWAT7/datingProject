import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../commonfiles/appcolor.dart';
import '../reuseable_widgets/apppara.dart';

showToast(BuildContext context, String message) {
  FToast().init(context).showToast(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppColor.iconsColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: AppPara(
              text: message,
              size: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ).pOnly(bottom: 5.5.h),
        toastDuration: const Duration(seconds: 3),
        gravity: ToastGravity.BOTTOM,
      );
}
