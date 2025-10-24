import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppText extends StatelessWidget {
  double size;
  FontWeight fontWeight;
  final Color color;
  final String text;
  final int maxlin;
  TextAlign textAlign;
  final TextOverflow hello;
  AppText({
    Key? key,
    this.hello = TextOverflow.ellipsis,
    required this.fontWeight,
    this.textAlign = TextAlign.center,
    required this.size,
    required this.text,
    this.maxlin = 1,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxlin,
      overflow: hello,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: "Nunito Sans",
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
      softWrap: true,
    );
  }
}

