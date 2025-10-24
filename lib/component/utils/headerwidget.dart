import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final double progress;
  final GestureTapCallback? onTap;

  HeaderWidget({
    required this.title,
    required this.progress,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back, // You can use a custom image here if needed
                size: 30.0,

              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 48), // Same width as IconButton to balance the row
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LinearProgressIndicator(
            borderRadius: BorderRadius.circular(10),
            minHeight: 1.5.h,
            // backgroundColor: Colors.black,
            value: progress,
            color: Color(0xffFD5564)
          ),
        ),
      ],
    );
  }
}