import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';

class ProfileListCard extends StatelessWidget {
  final String title;
  final List<Widget> icons;
  final List<String> texts;
  final Function onEditPressed;
  final bool showEditIcon; // Add this parameter

  ProfileListCard({
    required this.title,
    required this.icons,
    required this.texts,
    required this.onEditPressed,
    this.showEditIcon = true, // Set default value to true
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    int itemCount = (icons.length < texts.length) ? icons.length : texts.length;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color.fromRGBO(255, 200, 211, 1),
      ),

      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 4.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Color.fromRGBO(253, 85, 100, 1),
                        fontSize: 15,
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (showEditIcon) // Only show the icon if showEditIcon is true
                  GestureDetector(
                    onTap: () => onEditPressed(),
                    child: Icon(Icons.edit, size: 20),
                  ),
              ],
            ),
            SizedBox(
              height: 1.5.h,
            ),
            ...List.generate(icons.length, (index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    icons[index],
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        texts[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'NunitoSans',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
