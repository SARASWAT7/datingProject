import 'package:flutter/material.dart';

class AppColor {
  static Color firstmainColor = HexColor('#FD5564');
  static Color whitecolor = HexColor('#FFFFFF');
  static Color darkmainColor = HexColor('#FE3C72');
  static Color grey = HexColor('#555555');
  static Color activeiconclr = HexColor('#FD5564');
  static Color tinderclr = HexColor('#FD5564');
  static Color slideColor = HexColor('#FFC8D3');
  static Color white = HexColor('#FFFFFF');
  static Color black = HexColor('#000000');
  static Color iconsColor = HexColor('#FD5564');
  static Color lightGrey = HexColor('#BABABA');

  static Color homeContainerBackground = HexColor('#BABABA');
  Color get blackColor => const Color(0XFF000000);
  Color get whiteColor => const Color(0XFFffffff);
  Color get bgColor => const Color.fromARGB(255, 158, 66, 66);
  Color get lightTextColor => const Color(0XFFE2E2E2);
  Color get darkSplashBackground => const Color(0XFFE2E2E2);
  Color get primaryBlue => const Color(0XFFE2E2E2);
  Color get lightHintColor => const Color(0XFFE2E2E2);
  Color get classBoxColor => const Color(0XFFE2E2E2);
  Color get thinGreyColor => const Color(0XFFE2E2E2);
  Color get calendarLightBackgroundColor => const Color(0XFFE2E2E2);
  Color get darkBottomNavBar => const Color(0XFFE2E2E2);
  Color get darkThinBlueColor => const Color(0XFFE2E2E2);
  Color get calendarDarkBackgroundColor => const Color(0XFFE2E2E2);
  Color get studentAttendanceSelectedColor => const Color(0XFFE2E2E2);
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

Color whitecolor = const Color.fromARGB(255, 255, 255, 255);
Color likecolor = Colors.red;
Color superLike = Colors.blue;
Color bgClr = const Color(0xffef3f43);
Color subhead = const Color(0xff555555);
Color bgClrDark = const Color.fromARGB(255, 255, 22, 26);
Color dashboardIcon = const Color(0xfff48688);
Color colorCont1 = const Color(0xFFFFFFFF);
Color colorCont2 = const Color(0xFFD3D3D3);
Color contcolor = const Color(0xFFf48688);
Color pincodecolor = const Color.fromRGBO(211, 211, 211, 0.5);
Color textcolor = const Color(0xff363636);
Color contborder = const Color(0xffBDBDBD);
/* Color(0xFFFFFFFF), Color(0xFFD3D3D3) */
