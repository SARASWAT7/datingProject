import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WhiteContainer extends StatelessWidget {
  final String iconPath;
  final String text;
  final double iconSize;
  final double textSize;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final FontWeight textWeight;
  final String fontFamily;
  final double borderRadius;

  WhiteContainer({
    required this.iconPath,
    required this.text,
    this.iconSize = 28,
    this.textSize = 16,
    this.width = double.infinity,
    this.height = 50,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.textWeight = FontWeight.w600,
    this.fontFamily = 'Nunito Sans',
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
              child: Image.asset(
                iconPath,
                width: iconSize,
                height: iconSize,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
            Text(
              text,
              style: TextStyle(
                fontSize: textSize,
                color: textColor,
                fontWeight: textWeight,
                fontFamily: fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
