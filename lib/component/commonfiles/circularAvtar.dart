import 'package:flutter/material.dart';

class CircularProfilePicture extends StatelessWidget {
  final String imagePath;
  final double radius;

  const CircularProfilePicture({
    Key? key,
    required this.imagePath,
    this.radius = 30.0, // Default radius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage("assets/images/profileLogo.png"),
    );
  }
}
