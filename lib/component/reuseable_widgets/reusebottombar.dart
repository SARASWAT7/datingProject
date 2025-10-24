
import 'package:flutter/material.dart';

import '../commonfiles/appcolor.dart';
import 'bottomTabBar.dart';

class BottomSteet extends StatefulWidget {
  final int currentIndex;

  const BottomSteet({super.key, required this.currentIndex});

  @override
  State<BottomSteet> createState() => _BottomSteetState();
}

class _BottomSteetState extends State<BottomSteet> {
  void onTap(int index) {
    if (index != widget.currentIndex) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => BottomBar(
                    currentIndex: index,
                  )),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      onTap: onTap,
      currentIndex: widget.currentIndex,
      selectedItemColor: AppColor.iconsColor,
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      items: const [

        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/search.png'), size: 24),
          label: "Tour",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/chat.png'), size: 24),
          label: "Chat",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/pinkheart.png'), size: 24),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/img_1.png'), size: 24),
          label: "Like",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/profile12.png'), size: 24),
          label: "Profile",
        ),
      ],
    );
  }
}
