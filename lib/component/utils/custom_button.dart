import 'package:flutter/material.dart';
import '../commonfiles/appcolor.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  const CustomButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.62,
      // padding: const EdgeInsets.only(left: 20,right: 20),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: kElevationToShadow[3],
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColor.firstmainColor, AppColor.darkmainColor],
        ),
      ),
      child: Center(
          child: Text(text!,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w600))),
    );
  }
}
