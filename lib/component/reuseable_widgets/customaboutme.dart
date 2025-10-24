import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final String iconAssetPath; // Asset path for the icon
  final String title;
  final String trailingText;
  final int index;
  final int? selectedIndex;
  final ValueChanged<int> onTap;

  ProfileItem({
    required this.iconAssetPath,
    required this.title,
    required this.trailingText,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  // Function to format the trailing text
  String formatTrailingText(String text) {
    List<String> words = text.split(' ');
    if (words.length > 1) {
      return '${words.first}...';
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        iconAssetPath,
        height: 30, // Default image size
        width: 30, // Default image size
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18, // Default text size
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formatTrailingText(trailingText),
            style: TextStyle(
              color: selectedIndex == index ? Colors.pink : Colors.black,
              fontSize: 14, // Default trailing text size
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.black,
            size: 30, // Default icon size
          ),
        ],
      ),
      onTap: () => onTap(index),
    );
  }
}
