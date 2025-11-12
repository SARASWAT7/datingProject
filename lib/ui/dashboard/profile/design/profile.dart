import 'package:demoproject/ui/reels/reals.dart';
import 'package:demoproject/component/utils/fcm_token_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/component/reuseable_widgets/apperror.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/generated/assets.dart';
import 'package:demoproject/ui/auth/design/login.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/profile/profilecubit.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/profile/profilestate.dart';
import 'package:demoproject/ui/dashboard/profile/design/profileHome.dart';
import 'package:demoproject/ui/dashboard/profile/design/userfeedback.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/component/reuseable_widgets/container.dart';
import '../../../../component/apihelper/normalmessage.dart';
import '../../../../component/reuseable_widgets/bottomTabBar.dart';
import '../../../../component/reuseable_widgets/customNavigator.dart';
import '../../../../component/reuseable_widgets/profilecircle.dart';
import '../../../reels/myreelprofile.dart';
import '../../../reels/userreelprofile.dart';
import '../../../subscrption/design/silverSub.dart';
import '../../../subscrption/design/subscriptionType/subtabSwitcher.dart';
import '../../Settings/setting.dart';
import '../../home/repository/homerepository.dart';
import 'Media section/mymedia.dart';
import 'lisenseUsed.dart';
import 'contactus.dart';
import 'dataandprivacy.dart';
import 'faq.dart';
import 'editprofile.dart';
import '../moreaboutme/moreAboutMe.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final HomeRepository _authRepo = HomeRepository();

  String? _deviceToken;
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to safely access context after widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileCubit>().getprofile(context);
      }
    });
    _getDeviceToken();
  }

  Future<String?> _getDeviceToken() async {
    return await FCMTokenHelper.getTokenWithRetry();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => BottomBar(currentIndex: 2)),
          (route) => false,
        );
        return true;
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: const Color(0xffFFFFFF),
              elevation: 0,
              title: Row(
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: Assets.fontsNunitoSansBlack,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      bool? shouldLogout = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.transparent,
                            content: Container(
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.redAccent, Colors.pink],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 20.0,
                                      horizontal: 10.0,
                                    ),
                                    child: Text(
                                      'Are you sure you want to logout?',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Divider(color: Colors.white, height: 1),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 15,
                                            ),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(15),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'No',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const VerticalDivider(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 15,
                                            ),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(
                                                  15,
                                                ),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Yes',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );

                      // if (shouldLogout == true) {
                      //   try {
                      //     await _authRepo.onlinestatus(false);
                      //     await context.read<ProfileCubit>().logoutApi(context,_deviceToken!);
                      //
                      //     SharedPreferences pref = await SharedPreferences.getInstance();
                      //     await pref.clear();
                      //
                      //     Navigator.pushAndRemoveUntil(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => const LoginScreen()),
                      //           (Route<dynamic> route) => false,
                      //     );
                      //   } catch (e) {
                      //     NormalMessage.instance.normalerrorstate(context, e.toString());
                      //   }
                      // }
                      if (shouldLogout == true) {
                        try {
                          // Await the device token fetching method
                          String? deviceToken = await _getDeviceToken();

                          if (deviceToken == null) {
                            // Handle the case where the device token is not available
                            throw Exception('Device token is not available');
                          }

                          await _authRepo.onlinestatus(false);
                          await context.read<ProfileCubit>().logoutApi(
                            context,
                            deviceToken,
                          );

                          SharedPreferences pref = await SharedPreferences.getInstance();
                          await pref.clear();

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        } catch (e) {
                          NormalMessage.instance.normalerrorstate(
                            context,
                            e.toString(),
                          );
                        }
                      }
                    },
                    icon: Image.asset(
                      'assets/images/img.png',
                      height: 33,
                      width: 33,
                    ),
                  ),
                ],
              ),
              automaticallyImplyLeading: false,
            ),
            body: state.status == ApiState.isLoading
                ? AppLoader()
                : state.status == ApiState.error
                ? AppErrorError(
                    onPressed: () {
                      context.read<ProfileCubit>().getprofile(context);
                    },
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 18,
                            right: 18,
                            top: 18,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleProfile(
                                  percentage:
                                      (state
                                                  .profileResponse
                                                  ?.result
                                                  ?.profileCompletionPercentage ??
                                              0)
                                          .toDouble(),
                                  imagePath:
                                      state
                                          .profileResponse
                                          ?.result
                                          ?.profilePicture ??
                                      "",
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyProfile(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.12,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.redAccent, // Top color
                                          Colors.pink, // Bottom color
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'Hi,',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 42.w,
                                                child: Text(
                                                  maxLines: 1,
                                                  '${state.profileResponse?.result?.firstName} ${state.profileResponse?.result?.lastName}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w700,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Your profile is ${state.profileResponse?.result?.profileCompletionPercentage ?? 0}% completed fill all the details.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfile(),
                              ),
                            );
                          },
                          child: AppContainer(
                            height: MediaQuery.of(context).size.height * 0.060,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                AppText(
                                  fontWeight: FontWeight.w400,
                                  size: 16.sp,
                                  text: 'My Profile',
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/myprofile.png',
                                  width: 34,
                                  height: 34,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MoreAboutMe(),
                              ),
                            );
                          },
                          child: AppContainer(
                            height: MediaQuery.of(context).size.height * 0.060,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                AppText(
                                  fontWeight: FontWeight.w400,
                                  size: 16.sp,
                                  text: 'Edit Your Details',
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/aboutme.png',
                                  width: 34,
                                  height: 34,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            CustomNavigator.push(
                              context: context,
                              screen: MyMedia(),
                            );
                          },
                          child: AppContainer(
                            height: MediaQuery.of(context).size.height * 0.060,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                AppText(
                                  fontWeight: FontWeight.w400,
                                  size: 16.sp,
                                  text: 'My Photos',
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/aboutme.png',
                                  width: 34,
                                  height: 34,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // CustomNavigator.push(context: context, screen: UserReelProfile(
                            //   imagePath: state.profileResponse?.result?.profilePicture ??"",
                            //     name:'${state.profileResponse?.result?.firstName} ${state.profileResponse?.result?.lastName}',
                            //      bio:state.profileResponse?.result?.bio??"",
                            // ));
                            CustomNavigator.push(
                              context: context,
                              screen: MyReelProfile(),
                            );
                          },
                          child: AppContainer(
                            height: MediaQuery.of(context).size.height * 0.060,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                AppText(
                                  fontWeight: FontWeight.w400,
                                  size: 16.sp,
                                  text: 'Reels Profile',
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/aboutme.png',
                                  width: 34,
                                  height: 34,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     CustomNavigator.push(
                        //       context: context,
                        //       screen: SubTabSwitcher(),
                        //     );

                        //     // CustomNavigator.push(context: context, screen: SubscriptionPage());
                        //   },
                        //   child: AppContainer(
                        //     height: MediaQuery.of(context).size.height * 0.060,
                        //     width: MediaQuery.of(context).size.width,
                        //     child: Row(
                        //       children: [
                        //         AppText(
                        //           fontWeight: FontWeight.w400,
                        //           size: 16.sp,
                        //           text: 'My subscriptions',
                        //         ),
                        //         const Spacer(),
                        //         Image.asset(
                        //           'assets/images/subscription.png',
                        //           width: 34,
                        //           height: 34,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            CustomNavigator.push(
                              context: context,
                              screen: Setting(),
                            );
                          },
                          child: AppContainer(
                            height: MediaQuery.of(context).size.height * 0.060,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                AppText(
                                  fontWeight: FontWeight.w400,
                                  size: 16.sp,
                                  text: 'Settings',
                                ),
                                Spacer(),
                                Image.asset(
                                  'assets/images/setting.png',
                                  width: 34,
                                  height: 34,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DataPrivacyPage(),
                              ),
                            );
                          },
                          child: AppContainer(
                            height: MediaQuery.of(context).size.height * 0.060,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                AppText(
                                  fontWeight: FontWeight.w400,
                                  size: 16.sp,
                                  text: 'Data privacy',
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/dataPrive.png',
                                  width: 34,
                                  height: 34,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LisenseUsed(),
                              ),
                            );
                          },
                          child: AppContainer(
                            height: MediaQuery.of(context).size.height * 0.060,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                AppText(
                                  fontWeight: FontWeight.w400,
                                  size: 16.sp,
                                  text: 'License used',
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/license.png',
                                  width: 34,
                                  height: 34,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Faq(),
                              ),
                            );
                          },
                          child: AppContainer(
                            height: MediaQuery.of(context).size.height * 0.060,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                AppText(
                                  fontWeight: FontWeight.w400,
                                  size: 16.sp,
                                  text: 'FAQ',
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/contact.png',
                                  width: 34,
                                  height: 34,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserFeedback(),
                              ),
                            );
                          },
                          child: AppContainer(
                            height: MediaQuery.of(context).size.height * 0.060,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                AppText(
                                  fontWeight: FontWeight.w400,
                                  size: 16.sp,
                                  text: 'Feedback',
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/feedback.png',
                                  width: 34,
                                  height: 34,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactUs(),
                              ),
                            );
                          },
                          child: AppContainer(
                            height: MediaQuery.of(context).size.height * 0.060,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                AppText(
                                  fontWeight: FontWeight.w400,
                                  size: 16.sp,
                                  text: 'Contact us',
                                ),
                                const Spacer(),
                                Image.asset(
                                  'assets/images/contact.png',
                                  width: 34,
                                  height: 34,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => Reals()),
                        //     );
                        //   },
                        //   child: AppContainer(
                        //     height:
                        //     MediaQuery.of(context).size.height * 0.060,
                        //     width: MediaQuery.of(context).size.width,
                        //     child: Row(
                        //       children: [
                        //         AppText(
                        //             fontWeight: FontWeight.w400,
                        //             size: 16.sp,
                        //             text: 'Contact us'),
                        //         const Spacer(),
                        //         Image.asset(
                        //           'assets/images/contact.png',
                        //           width: 34,
                        //           height: 34,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
