import 'package:flutter/material.dart';

PreferredSizeWidget NormalAppBar({
  required String title,
  required Color titleColor,
  required Color backgroundColor,
  List<Widget>? actions,
  bool? centerTitle,
  VoidCallback? onBackTap, // Callback for back button tap
  Widget? leading, // Custom leading widget
  String? imagePath, // Path to the image to display at the end of the AppBar
}) {
  // Default leading widget: Back button
  Widget defaultLeading = IconButton(
    icon: Image.asset(
      'assets/images/backarrow.png', // Path to your custom back icon image
      width: 24.0, // Set the width of the image
    ),
    onPressed: onBackTap,
  );

  // Add the end image widget to the actions list
  List<Widget> appBarActions = actions ?? [];
  if (imagePath != null) {
    appBarActions.add(
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Center(
          child: Image.asset(
            imagePath,
            width: 24.0, // Adjust the width of the image as needed
          ),
        ),
      ),
    );
  }

  return PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: AppBar(
      elevation: 0.0,
      backgroundColor: backgroundColor,
      centerTitle: centerTitle,
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: leading ?? defaultLeading, // Use provided leading widget, otherwise use default
      actions: appBarActions,
    ),
  );
}
