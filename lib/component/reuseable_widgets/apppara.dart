import 'package:flutter/material.dart';

class AppPara extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double size;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppPara({
    Key? key,
    required this.text,
    required this.color,
    required this.fontWeight,
    required this.size,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: size,
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
