import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCommentWidget extends StatelessWidget {
  final String comment;

  const MyCommentWidget({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 10,bottom: 10),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColor.tinderclr,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            comment,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}


class UserCommentWidget extends StatelessWidget {
  final String profile;
  final String username;
  final String comment;

  const UserCommentWidget({
    Key? key,
    required this.profile,
    required this.username,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 5,bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: profile.isNotEmpty
                  ? NetworkImage(profile) // Load image from API
                  : null,
              backgroundColor: Colors.grey[300],
              child: profile.isEmpty
                  ? Icon(Icons.person, color: Colors.white) // Default icon if no image
                  : null,
            ),
            SizedBox(width: 10),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Username and Comment
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            comment,
                            style: TextStyle(fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis, // Handle long comments
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
