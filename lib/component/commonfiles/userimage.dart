import 'package:flutter/material.dart';
import 'dart:io';

class CustomImage extends StatelessWidget {
  final double size;
  final String imagePath;

  const CustomImage({
    Key? key,
    required this.size,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: Colors.grey.shade200, // Placeholder background color
        child: imagePath.isNotEmpty
            ? Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        )
            : Icon(
          Icons.person,
          size: size * 0.6,
          color: Colors.grey,
        ),
      ),
    );
  }
}
