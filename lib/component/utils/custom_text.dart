import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final FontWeight weight;
  final String fontFamily;
  final int? maxLines;
  final TextOverflow? overflow;

  CustomText({
    Key? key,
    required this.size,
    required this.text,
    required this.color,
    required this.weight,
    required this.fontFamily,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines, // Set max lines if provided
      overflow: overflow, // Set overflow if provided
      style: TextStyle(
        fontWeight: weight,
        color: color,
        fontSize: size,
        fontFamily: fontFamily,
      ),
    );
  }
}
