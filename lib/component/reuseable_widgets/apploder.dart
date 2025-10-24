import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class AppLoader extends StatelessWidget {
  double contHeight;
  double contWidth;
  String? loader = "";
  Color? color = Colors.black.withOpacity(0.5);
  AppLoader(
      {Key? key,
      this.loader,
      this.color,
      this.contHeight = 0,
      this.contWidth = 0
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        // color: AppColors().blackColor.withOpacity(0.5),
        height: contHeight == 0 ? double.maxFinite : contHeight,
        width: contWidth == 0 ? double.maxFinite : contWidth,
        child: Center(child: LottieBuilder.asset("assets/images/loading.json")),
      ),
    );
  }
}



class LovelyLoader extends StatelessWidget {
  const LovelyLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background to white
      body: Center(
        child: Lottie.asset(
          "assets/images/lodinglogo.json", // Path to your Lottie animation
          width: 15, // Default size for the loader
          height: 15,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
