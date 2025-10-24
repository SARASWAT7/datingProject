import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../commonfiles/appcolor.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isEnable;
  final VoidCallback? onPressed; // Add onPressed callback

  const CustomButton({
    Key? key,
    required this.text,
    this.isEnable = true,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 4.w),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: kElevationToShadow[3],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isEnable
                ? [AppColor.firstmainColor, AppColor.darkmainColor]
                : [Colors.grey, Colors.grey],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnable ? onPressed : null, // Handle button press
            borderRadius: BorderRadius.circular(30),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
