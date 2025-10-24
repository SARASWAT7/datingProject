import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class AppErrorError extends StatelessWidget {
  final double contHeight;
  final double contWidth;
  final GestureTapCallback onPressed;
  final String? loader;
  final Color? color;

  AppErrorError({
    Key? key,
    this.loader,
    this.color,
    required this.onPressed,
    this.contHeight = 0,
    this.contWidth = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: contHeight == 0 ? double.maxFinite : contHeight,
        width: contWidth == 0 ? double.maxFinite : contWidth,
        child: Center(
          child: LottieBuilder.asset("assets/images/errorlotti.json")
              .onTap(onPressed),
        ),
      ),
    );
  }
}