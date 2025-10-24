
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../commonfiles/appcolor.dart';
import 'appText.dart';

class AppContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final Color color;

  const AppContainer({
    Key? key,
    required this.child,
    required this.height,
    required this.width,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: child,
    );
  }
}

// ignore: must_be_immutable
class AppContainer1 extends StatefulWidget {
  final String text;

  // final int? itemCount;
  // final GestureTapCallback onPressed;
  bool isSelected;
  // TextEditingController? controller;
  AppContainer1(
      {super.key,
      // this.controller,
      // required this.itemCount,
      // required this.onPressed,
      required this.isSelected,
      required this.text});

  @override
  State<AppContainer1> createState() => _AppContainer1State();
}

class _AppContainer1State extends State<AppContainer1> {
  String? selectedItems;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, left: 10, right: 10),
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(width: 1)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: AppText(
                  text: widget.text,
                  size: 12.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color: bgClr,
                  ),
                  color: widget.isSelected == true ? bgClr : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
