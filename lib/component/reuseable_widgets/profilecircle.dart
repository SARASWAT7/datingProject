import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'apploder.dart';

class CircleProfile extends StatelessWidget {
  final String? imagePath;
  final double? percentage; // Make percentage nullable

  CircleProfile({
    super.key,
    this.imagePath,
    this.percentage, // Update to nullable
  });

  @override
  Widget build(BuildContext context) {
    Widget content = _buildCircleImage();

    if (percentage != null) {
      content = CircularPercentIndicator(
        radius: 50.0,
        lineWidth: 5.0,
        percent: percentage! / 100, // Convert percentage to a value between 0 and 1
        center: Stack(
          alignment: Alignment.center,
          children: [
            _buildCircleImage(),
            Text(
              "${percentage!.toInt()}%",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        progressColor: Colors.red,
        backgroundColor: Colors.black12,
        circularStrokeCap: CircularStrokeCap.round,
      );
    }

    return content;
  }

  Widget _buildCircleImage() {
    if (imagePath != null && imagePath!.isNotEmpty) {
      if (imagePath!.startsWith('http') || imagePath!.startsWith('https')) {
        return ClipOval(
          child: CachedNetworkImage(
            imageUrl: imagePath!,
            fit: BoxFit.cover,
            width: 80.0,
            height: 80.0,
            placeholder: (context, url) => AppLoader(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
      } else if (imagePath!.endsWith('.svg')) {
        return ClipOval(
          child: SvgPicture.asset(
            imagePath!,
            fit: BoxFit.cover,
            width: 80.0,
            height: 80.0,
          ),
        );
      } else if (imagePath!.startsWith('/data/')) {
        return ClipOval(
          child: Image.file(
            File(imagePath!),
            fit: BoxFit.cover,
            width: 80.0,
            height: 80.0,
          ),
        );
      } else {
        return ClipOval(
          child: Image.asset(
            imagePath!,
            fit: BoxFit.cover,
            width: 80.0,
            height: 80.0,
          ),
        );
      }
    } else {
      AppLoader();
      return ClipOval(
        child: Image.asset(
          'assets/images/image_not_found.png',
          fit: BoxFit.cover,
          width: 80.0,
          height: 80.0,
        ),
      );
    }
  }
}
