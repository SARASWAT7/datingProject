import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/ui/subscrption/design/silverSub.dart';
import 'package:demoproject/ui/subscrption/design/subscriptionType/subtabSwitcher.dart';
import 'package:flutter/material.dart';

import '../../../component/reuseable_widgets/bottomTabBar.dart';
import '../../../component/reuseable_widgets/custom_button.dart';

class SubscriptionSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade200],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Text
          Text(
            'Subscription',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          // Icon (Heart with Key)
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.red.withOpacity(0.1),
            child: Image.asset("assets/images/keyheart.png"),
          ),
          SizedBox(height: 20),
          // Subheader Text
          Text(
            'Unlock All Contents',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          // Description
          Text(
            'Buy Subscription To Enjoy The Dating App',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          // Button for Plans
          GestureDetector(onTap: (){
            CustomNavigator.push(context: context, screen: SubTabSwitcher());
          },
              child: CustomButton(text: 'View Plans')),
          SizedBox(height: 10),
          // Skip Button
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => BottomBar(currentIndex: 2), // Replace with your target page
                ),
                    (Route<dynamic> route) => false, // This removes all previous routes
              );
            },
            child: Text(
              'SKIP',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
