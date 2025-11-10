import 'dart:async';
import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/component/reuseable_widgets/custom_button.dart';
import 'package:demoproject/ui/auth/design/myfirstnameis.dart';
import 'package:demoproject/ui/personalinformation/getstarted.dart';
import 'package:demoproject/ui/personalinformation/iam.dart';
import 'package:demoproject/ui/personalinformation/passion.dart';
import 'package:demoproject/ui/personalinformation/uploadimage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../component/reuseable_widgets/apptext.dart';
import '../../../component/reuseable_widgets/bottomTabBar.dart';
import '../../personalinformation/bio.dart';
import '../../personalinformation/moreaboutme.dart';
import 'login.dart';

String token = "";
bool emailverify = true;

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String lat = "";
  var long = "";
  String? _currentAddress;
  Position? _currentPosition;
   bool isLoading = true;

  @override
  void initState() {
    super.initState();
    invokeTimer();
  }



  // _callSplashScreen() async {
  //   Future.delayed(const Duration(seconds: 3), () async {
  //     token = await getToken() ?? "";
  //     log("pushker");
  //     if (token.isNotEmpty) {
  //       log("Token: $token");
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) =>BottomBar()),
  //             (Route<dynamic> route) => false,
  //       );
  //     } else {
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => LoginScreen()),
  //             (Route<dynamic> route) => false,
  //       );
  //     }
  //   });
  // }

  Future<void> invokeTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Timer(const Duration(seconds: 3), ()  {

      lat = prefs.getString('lat').toString();
      long = prefs.getString('long').toString();
      String? isLoggedIn = prefs.getString("token");

      bool Name = prefs.getBool("firstName")??false;
      bool? Photo = prefs.getBool("UploadPhoto");
      bool? info = prefs.getBool("BasicInformation");
      bool? MoreAbout = prefs.getBool("MoreAbout");
      bool? mybio = prefs.getBool("Bio");
      bool? passion = prefs.getBool("Passion");
      bool? getstart = prefs.getBool('GetStart');
      Map data ={
"Name":"$Name","Photo":"$Photo","info":"$info","MoreAbout":"$MoreAbout","mybio":"$mybio","passion":"$passion","getstart":"$getstart","":"$Name",
      };
      print(data);
setState(() {
  startUp=true;
});
      if (isLoggedIn == "" || isLoggedIn == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false);
      } else {
        if (Name != true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyFirstName()),
                  );
        } else if (Photo != true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UploadImage()),
                  );
        } else if (info != true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const IamScreen()),
                 );
        } else if (MoreAbout != true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MoreAboutMeScreen()),
                  );
        } else if (mybio != true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BioScreen()),
                  );
        } else if (passion != true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PassionScreen()),
   );
        }  else if ( getstart != true) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const GetStarted()),
          );
        }
        else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => const BottomBar()),
                  (route) => false);
        }
      }
    });
  }

bool startUp= false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Image.asset(
                'assets/images/pinkheart.png',
                height: 200,
                width: 200,
              ),
              AppText(fontWeight: FontWeight.w700, size: 19.sp, text: 'Dating'),
              AppText(
                fontWeight: FontWeight.w400,
                size: 16.sp,
                text: 'Finding your love',
              ),

              Spacer(),
              startUp?  GestureDetector(
                onTap: (){
                  CustomNavigator.push(context: context, screen: LoginScreen());
                },
                  child: CustomButton(text: 'get Started',)):Container(),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var login = prefs.getBool('login');

    if (login == true) {
      token = prefs.getString('token') ?? "";
      return true;
    } else {
      return false;
    }
  }
}

Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}


