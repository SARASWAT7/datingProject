import 'dart:developer';
import 'dart:io';

import 'package:demoproject/component/apihelper/toster.dart';
import 'package:demoproject/component/utils/fcm_token_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../component/commonfiles/appcolor.dart';
import '../../../component/reuseable_widgets/appText.dart';
import '../../../component/reuseable_widgets/apploder.dart';
import '../../../component/reuseable_widgets/customNavigator.dart';
import '../../../component/reuseable_widgets/whitebox.dart';
import '../cubit/socallogin/socallogincubit.dart';
import '../cubit/socallogin/socialloginstate.dart';
import 'terms.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String lati = "";
  String longi = "";
  String devicetype = "";
  String deviceToken = "";

  @override
  void initState() {
    super.initState();
    getDeviceToken();
    _getCurrentPosition();
    getDeviceName();
  }

  Future<void> _getCurrentPosition() async {
    if (!await _handleLocationPermission()) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        lati = position.latitude.toString();
        longi = position.longitude.toString();
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('lat', lati);
      prefs.setString('long', longi);

      log("Location fetched: $lati, $longi");
    } catch (e) {
      log("Error fetching location: $e");
    }
  }

  Future<bool> _handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log("Location permissions are denied");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      log("Location permissions are permanently denied");
      return false;
    }
    return true;
  }

  void getDeviceToken() async {
    try {
      String? token = await FCMTokenHelper.getTokenWithRetry();
      if (token != null) {
        setState(() {
          deviceToken = token;
        });
        log("Device Token: $deviceToken");
      } else {
        log("Failed to get device token");
      }
    } catch (e) {
      log("Error getting device token: $e");
    }
  }

  void getDeviceName() {
    if (Platform.isAndroid) {
      devicetype = "1"; // Android
    } else if (Platform.isIOS) {
      devicetype = "2"; // iOS
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginSocialCubit, LoginSocialState>(
      listener: (context, state) {
        if (state is LoginSocialSuccessState) {
          log("Login Successful");
          print(
            state.socialLoginResponse.result?.userData?.email.toString() ??
                "Hello",
          );
          print("qwertyuiop");
        } else if (state is LoginSocialErrorState) {
          log("Login Failed: ${state.error}");
        }
      },
      builder: (context, state) {
        if (state is LoginSocialLoadingState) {
          return AppLoader();
        }

        return Scaffold(
          backgroundColor: AppColor.white,
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [AppColor.firstmainColor, AppColor.darkmainColor],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Image.asset('assets/images/icon.png', height: 18.h),
                  AppText(
                    fontWeight: FontWeight.w700,
                    size: 24.sp,
                    text: 'Dating',
                    color: Colors.white,
                  ),
                  AppText(
                    fontWeight: FontWeight.w300,
                    size: 12.sp,
                    text: 'Finding your love',
                    color: Colors.white,
                  ),
                  const Spacer(),
                  AppText(
                    fontWeight: FontWeight.w600,
                    size: 14.sp,
                    text:
                        'By clicking “Log in”, you agree with Lempire Dating ',
                    color: Colors.white,
                  ),
                  GestureDetector(
                    onTap: _launchURL,
                    child: AppText(
                      fontWeight: FontWeight.w600,
                      size: 16.sp,
                      text: 'Terms & Condition',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      CustomNavigator.push(
                        context: context,
                        screen: const TermsScreen(loginType: 'peEmail'),
                      );
                    },
                    child: WhiteContainer(
                      iconPath: 'assets/images/email.png',
                      text: 'Login with Email',
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      CustomNavigator.push(
                        context: context,
                        screen: const TermsScreen(loginType: 'workEmail'),
                      );
                    },
                    child: WhiteContainer(
                      iconPath: 'assets/images/email.png',
                      text: 'Login with Work Email',
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      CustomNavigator.push(
                        context: context,
                        screen: const TermsScreen(loginType: 'pePhone'),
                      );
                    },
                    child: WhiteContainer(
                      iconPath: 'assets/images/mobile.png',
                      text: 'Login with Mobile',
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                  ),
                  devicetype == "1"
                      ? GestureDetector(
                          onTap: () => signInWithGoogle(context),

                          child: WhiteContainer(
                            iconPath: 'assets/images/google.png',
                            text: 'Login With Google',
                            width: MediaQuery.of(context).size.width * 0.9,
                          ),
                        )
                      : GestureDetector(
                          onTap: () => signInWithApple(context),
                          child: WhiteContainer(
                            iconPath: 'assets/images/apple.png',
                            text: 'Login With Apple',
                            width: MediaQuery.of(context).size.width * 0.9,
                          ),
                        ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Clear all Google Sign-In cache to force account selection
  Future<void> _clearGoogleSignInCache() async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();
      
      // Sign out from Google Sign-In
      await GoogleSignIn().signOut();
      
      // Clear any cached authentication
      await GoogleSignIn().disconnect();
      
      log("✅ Google Sign-In cache cleared successfully");
    } catch (e) {
      log("⚠️ Error clearing Google Sign-In cache: $e");
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Clear all cached accounts to force account selection
      await _clearGoogleSignInCache();
      
      // Create GoogleSignIn instance with account selection forced
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        // Force account selection every time
        forceCodeForRefreshToken: true,
        // Additional configuration to force account selection
        clientId: null, // Let it use default client ID
      );

      // Force account selection dialog - this will always show account picker
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        log("Google sign-in cancelled.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String idToken = googleAuth.idToken ?? "";
      final String accessToken = googleAuth.accessToken ?? "";

      if (idToken.isEmpty || accessToken.isEmpty) {
        log("Google sign-in failed: Missing tokens.");
        if (context.mounted) {
          showToast(context, "Failed to retrieve access credentials.");
        }
        return;
      }

      if (context.mounted) {
        BlocProvider.of<LoginSocialCubit>(
          context,
        ).signInWithGoogle(idToken, lati, longi, "1", deviceToken, context);
      }
    } catch (e) {
      log("Error during Google sign-in: $e");
      if (context.mounted) {
        showToast(context, "Google sign-in failed.");
      }
    }
  }

  Future<void> signInWithApple(BuildContext context) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final identityToken = credential.identityToken ?? "";

      if (identityToken.isNotEmpty) {
        BlocProvider.of<LoginSocialCubit>(context).signInWithApple(
          identityToken,
          deviceToken,
          lati,
          longi,
          "2",
          context,
        );
      }
    } catch (e) {
      log("Error during Apple sign-in: $e");
    }
  }

  Future<void> _launchURL() async {
    const url = 'https://dev.webmobrildemo.com/inhouse/lempiredating/';
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
