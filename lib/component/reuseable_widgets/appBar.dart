import 'package:flutter/material.dart';

PreferredSizeWidget appBarWidgetThree({
  required String title,
  required Color titleColor,
  required Color backgroundColor,
  List<Widget>? actions,
  bool? centerTitle,
  VoidCallback? onBackTap, // Callback for back button tap
  Widget? leading, // Custom leading widget
  String? imagePath, // Path to the image to display at the end of the AppBar
  bool showBorder = false, // Parameter to control border visibility
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
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: Container(
      decoration: BoxDecoration(
        border: showBorder
            ? Border(
                bottom: BorderSide(
                  color: Colors.grey, // Change color as needed
                  width: 1.5, // Adjust the thickness of the divider
                ),
              )
            : null, // No border if showBorder is false
      ),
      child: AppBar(
        elevation: 0.0, // Removes shadow
        backgroundColor: Colors.white,
        centerTitle: centerTitle,
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: leading ??
            defaultLeading, // Use provided leading widget, otherwise use default
        actions: appBarActions,
      ),
    ),
  );
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    required this.style,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}

PreferredSizeWidget AppBarWidgetTwo({
  required String title,
  required Color titleColor,
  required backgroundColor,
  List<Widget>? actions,
  bool? centerTitle,
  VoidCallback? onBackTap, // Callback for back button tap
  Widget? leading, // Custom leading widget
}) {
  // Default leading widget: Back button
  Widget defaultLeading = IconButton(
    icon: Image.asset(
      'assets/images/backarrow.png',
      height: 10,
      width:
          10, // Path to your custom back icon image// Set the width of the image
    ),
    onPressed: onBackTap,
  );

  return AppBar(
    elevation: 0.0,
    backgroundColor: Colors.white,
    centerTitle: centerTitle,
    title: Text(""), // Set your desired height

    leading: leading ??
        defaultLeading, // Use provided leading widget, otherwise use default
    actions: actions,
  );
}
