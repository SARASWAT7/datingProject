import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';

class ProfileInfoCard extends StatelessWidget {
  final String title;
  final List<ProfileInfoItem> items;
  final VoidCallback onEditPressed;
  final bool showEditIcon; // To show/hide the edit icon

  ProfileInfoCard({
    required this.title,
    required this.items,
    required this.onEditPressed,
    this.showEditIcon = true, // Default is true
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(255, 200, 211, 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 4.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Color.fromRGBO(253, 85, 100, 1),
                        fontSize: 15,
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (showEditIcon)
                  GestureDetector(
                    onTap: onEditPressed,
                    child: const Icon(Icons.edit, size: 25),
                  ),
              ],
            ),
            SizedBox(height: 1.5.h),

            // Masonry Grid View for Profile Info Items
            MasonryGridView.count(
              crossAxisCount: 2,
              itemCount: items.length,
              shrinkWrap: true,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      items[index].icon, // Icon
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          items[index].text, // Text next to the icon
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'NunitoSans',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  final Widget icon;
  final String text;
  final int? maxLines; // Nullable, so you can pass null if you don't want to use maxLines

  ProfileInfoItem({
    required this.icon,
    required this.text,
    this.maxLines, // Optional maxLines
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 8), // Add some spacing between icon and text
        Expanded(
          child: Text(
            text,
            maxLines: maxLines, // If maxLines is null, no limit will be applied
            overflow: maxLines != null ? TextOverflow.ellipsis : null, // Adds ellipsis if text exceeds maxLines
          ),
        ),
      ],
    );
  }
}
