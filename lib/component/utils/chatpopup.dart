import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:group_button/group_button.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../ui/dashboard/home/cubit/Introduce/intropagecubit.dart';
import '../../ui/dashboard/home/cubit/Introduce/intropagestate.dart';
import '../../ui/dashboard/home/cubit/homecubit/homecubit.dart';
import '../alert_box.dart';
import '../apihelper/common.dart';
import '../apihelper/toster.dart';
import '../commonfiles/appcolor.dart';
import '../reuseable_widgets/appText.dart';
import '../reuseable_widgets/apploder.dart';
import '../reuseable_widgets/bottomTabBar.dart';

String singleLetter(String myname) {
  List name = myname.split(' ');
  return name[0];
}

class DeletePopUPChat extends StatefulWidget {
  const DeletePopUPChat({
    super.key,
    required this.title,
  });

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _DeletePopUPChatState createState() => _DeletePopUPChatState();
}

class _DeletePopUPChatState extends State<DeletePopUPChat> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [bgClr, bgClrDark])),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            4.h.heightBox,
            AppText(
                fontWeight: FontWeight.w600,
                size: 14.sp,
                color: whitecolor,
                text: "Are you Sure, want to block"),
            AppText(
                fontWeight: FontWeight.w600,
                size: 14.sp,
                color: whitecolor,
                text: singleLetter(widget.title).capitalized),
            2.h.heightBox,
            Container(
              color: Colors.white,
              height: 1,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [bgClr, bgClrDark]),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15.0),
                          //  bottomRight: Radius.circular(11.0),
                        ),
                      ),
                      height: 58,
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15.0),
                          // bottomRight: Radius.circular(11.0),
                        ),
                        highlightColor: Colors.grey[200],
                        onTap: () async {},
                        child: Center(
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 58,
                    color: Colors.white,
                  ),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [bgClr, bgClrDark]),
                        borderRadius: const BorderRadius.only(
                          // bottomLeft: Radius.circular(11.0),
                          bottomRight: Radius.circular(15.0),
                        ),
                      ),
                      height: 58,
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          // bottomLeft: Radius.circular(11.0),
                          bottomRight: Radius.circular(15.0),
                        ),
                        highlightColor: Colors.grey[200],
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Text(
                            "No",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlockBox extends StatefulWidget {
  const BlockBox({
    super.key,
    required this.userId,
    required this.title,
  });
  final String userId;
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _BlockBoxState createState() => _BlockBoxState();
}

class _BlockBoxState extends State<BlockBox> {
  String selectedButon = "";
  final controller = GroupButtonController();
  @override
  void initState() {
    log(widget.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: 53.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColor.activeiconclr, AppColor.tinderclr])),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                4.h.heightBox,
                AppText(
                    fontWeight: FontWeight.w600,
                    size: 14.sp,
                    color: whitecolor,
                    text: "Choose the reason to block"),
                AppText(
                    fontWeight: FontWeight.w600,
                    size: 14.sp,
                    color: whitecolor,
                    text: singleLetter(widget.title).capitalized),
                2.h.heightBox,
                GroupButton(
                  isRadio: true,
                  maxSelected: 1,
                  controller: controller,
                  onSelected: (value, index, isSelected) {
                    // log(isSelected.toString());
                    setState(() {
                      // questionId = state.response.result?[i].sId ?? "";
                      selectedButon = value.toString();
                    });
                  },
                  buttons: const [
                    "Inappropriate content",
                    "Profile is fake/spam",
                    "Minor",
                    "Offline behaviour",
                    "Someone in danger"
                  ],
                  options: GroupButtonOptions(
                    selectedShadow: const [],
                    selectedTextStyle: TextStyle(
                      fontSize: 16,
                      color: blackColor,
                    ),
                    unselectedColor: AppColor.tinderclr,
                    selectedColor: const Color(0xffFFFFFF),
                    unselectedShadow: const [],
                    // unselectedColor: Colors.amber[100],
                    unselectedTextStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    selectedBorderColor: const Color(0xffFFFFFF),
                    unselectedBorderColor: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(10),
                    spacing: 5,
                    runSpacing: 5,
                    groupingType: GroupingType.column,
                    direction: Axis.horizontal,
                    buttonHeight: 5.h,

                    buttonWidth: 50.w,
                    mainGroupAlignment: MainGroupAlignment.start,
                    crossGroupAlignment: CrossGroupAlignment.start,
                    groupRunAlignment: GroupRunAlignment.start,
                    textAlign: TextAlign.center,
                    // textPadding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    elevation: 0,
                  ),
                ),
                2.h.heightBox,
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [AppColor.tinderclr, AppColor.tinderclr]),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(15.0),
                            ),
                          ),
                          height: 58,
                          child: InkWell(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(15.0),
                            ),
                            highlightColor: Colors.grey[200],
                            onTap: () {
                              if (selectedButon.isNotEmpty) {
                              Helper.executeWithConnectivityCheck(
                                context,
                                () async {
                                  BlocProvider.of<IntroAddCubit>(context).getIntro(
                                    widget.userId,
                                    "block",
                                    selectedButon,
                                  ).then((_) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => BottomBar()), // Replace with your home screen widget
                                          (route) => false, // Remove all previous routes
                                    );
                                    showToast(context, "Block User successfully");

                                    // Refresh data
                                    BlocProvider.of<HomePageCubit>(context).homeApi(context);
                                  }).catchError((error) {
                                    showToast(context, "Failed to block user");
                                  });
                                },
                              );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => const AlertBox(title: 'Select an Option'),
                                );
                              }
                            },


                            child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ],
            ),
            /* (state is ReportLoading)
                    ? CircularProgressIndicator(
                        color: whitecolor,
                      ).centered()
                    : Container() */
          ],
        ),
      ),
    );
  }
}

class ReportBox extends StatefulWidget {
  const ReportBox({super.key, required this.title, required this.userId});
  final String userId;
  final String title;

  @override
  _ReportBoxState createState() => _ReportBoxState();
}

class _ReportBoxState extends State<ReportBox> {
  String selectedButon = "";
  final controller = GroupButtonController();

  @override
  void initState() {
    log(widget.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IntroAddCubit, IntroStateState>(
      listener: (context, state) {
        // Ensure the context is still mounted and valid before navigating
        if (mounted) {
          if (state is IntroStateSuccess) {
            // Use post-frame callback to pop after the frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
              showToast(context, "Report submitted successfully");
            });
          } else if (state is IntroStateError) {
            showToast(context, "Failed to submit report. Please try again.");
          }
        }
      },
      child: Dialog(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          height: 55.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColor.activeiconclr, AppColor.firstmainColor],
            ),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  4.h.heightBox,
                  AppText(
                    fontWeight: FontWeight.w600,
                    size: 14.sp,
                    color: whitecolor,
                    text: "Choose the reason to report",
                  ),
                  AppText(
                    fontWeight: FontWeight.w600,
                    size: 14.sp,
                    color: whitecolor,
                    text: singleLetter(widget.title).capitalized,
                  ),
                  2.h.heightBox,
                  GroupButton(
                    isRadio: true,
                    maxSelected: 1,
                    controller: controller,
                    onSelected: (value, index, isSelected) {
                      setState(() {
                        selectedButon = value.toString();
                      });
                    },
                    buttons: const [
                      "Inappropriate content",
                      "Profile is fake/spam",
                      "Minor",
                      "Offline behaviour",
                      "Someone in danger"
                    ],
                    options: GroupButtonOptions(
                      selectedShadow: const [],
                      selectedTextStyle: TextStyle(
                        fontSize: 16,
                        color: blackColor,
                      ),
                      unselectedColor: AppColor.tinderclr,
                      selectedColor: const Color(0xffFFFFFF),
                      unselectedTextStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      selectedBorderColor: const Color(0xffFFFFFF),
                      unselectedBorderColor: const Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                      spacing: 5,
                      runSpacing: 5,
                      groupingType: GroupingType.column,
                      buttonHeight: 5.h,
                      buttonWidth: 50.w,
                      elevation: 0,
                    ),
                  ),
                  2.h.heightBox,
                  SizedBox(
                    height: 7.h,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [AppColor.activeiconclr, AppColor.firstmainColor],
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                              ),
                            ),
                            height: 58,
                            child: InkWell(
                              onTap: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Center(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 58,
                          color: Colors.white,
                        ),
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [AppColor.tinderclr, AppColor.tinderclr],
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(15.0),
                              ),
                            ),
                            height: 58,
                            child: InkWell(
                              onTap: () {
                                if (selectedButon.isNotEmpty) {
                                  Helper.executeWithConnectivityCheck(
                                    context,
                                    () async {
                                      BlocProvider.of<IntroAddCubit>(context).getIntro(
                                        widget.userId,
                                        "report",
                                        "report user",
                                      ).then((_) {
                                        if (mounted) {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => const BottomBar()),
                                                (route) => false,
                                          );
                                          showToast(context, "Report User successfully");

                                          // Refresh data
                                          BlocProvider.of<HomePageCubit>(context).homeApi(context);
                                        }
                                      }).catchError((error) {
                                        showToast(context, "Failed to Report user");
                                      });
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const AlertBox(title: 'Select an Option'),
                                  );
                                }
                              },
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // You can show a loading indicator when the state is loading
              BlocBuilder<IntroAddCubit, IntroStateState>(
                builder: (context, state) {
                  if (state is IntroStateLoading) {
                    return Center(
                      child: AppLoader(),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SpamBox extends StatefulWidget {
  const SpamBox({super.key, required this.title, required this.userId});
  final String userId;
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _SpamBoxState createState() => _SpamBoxState();
}

class _SpamBoxState extends State<SpamBox> {
  String selectedButon = "";
  final controller = GroupButtonController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: 20.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColor.activeiconclr, AppColor.firstmainColor])),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                4.h.heightBox,
                AppText(
                    fontWeight: FontWeight.w600,
                    size: 14.sp,
                    color: whitecolor,
                    text: "Are you Sure, want to spam"),
                AppText(
                    fontWeight: FontWeight.w600,
                    size: 14.sp,
                    color: whitecolor,
                    text: singleLetter(widget.title).capitalized),
                2.h.heightBox,
                Container(
                  color: Colors.white,
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [AppColor.activeiconclr, AppColor.firstmainColor]),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15.0),
                              //  bottomRight: Radius.circular(11.0),
                            ),
                          ),
                          height: 58,
                          child: InkWell(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15.0),
                              // bottomRight: Radius.circular(11.0),
                            ),
                            highlightColor: Colors.grey[200],
                            onTap: () {
                              Helper.executeWithConnectivityCheck(
                                context,
                                () async {
                                  BlocProvider.of<IntroAddCubit>(context).getIntro(
                                    widget.userId,
                                    "spam",
                                    "static_key_here",
                                  )
                                      .then((_) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => BottomBar()), // Replace with your home screen widget
                                          (route) => false, // Remove all previous routes
                                    );
                                    showToast(context, "Spam User successfully");

                                    BlocProvider.of<HomePageCubit>(context).homeApi(context);
                                  }).catchError((error) {
                                    showToast(context, "Failed to spam user");
                                  });
                                },
                              );
                            },

                            child: Center(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 58,
                        color: Colors.white,
                      ),
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [AppColor.activeiconclr, AppColor.firstmainColor]),
                            borderRadius: const BorderRadius.only(
                              // bottomLeft: Radius.circular(11.0),
                              bottomRight: Radius.circular(15.0),
                            ),
                          ),
                          height: 58,
                          child: InkWell(
                            borderRadius: const BorderRadius.only(
                              // bottomLeft: Radius.circular(11.0),
                              bottomRight: Radius.circular(15.0),
                            ),
                            highlightColor: Colors.grey[200],
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text(
                                "No",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            /*  (state is ReportLoading)
                    ? CircularProgressIndicator(
                        color: whitecolor,
                      ).centered()
                    : Container() */
          ],
        ),
      ) /*  BlocConsumer<ReportCubit, ReportState>(
        listener: (context, state) {
          if (state is ReportSuccess) {
            Navigator.of(context).pop();
            showToast(context, state.response);
          }
        },
        builder: (context, state) {
          return Container(
            height: 20.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [bgClr, bgClrDark])),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    4.h.heightBox,
                    AppText(
                        fontWeight: FontWeight.w600,
                        size: 14.sp,
                        color: whitecolor,
                        text: "Are you Sure, want to spam"),
                    AppText(
                        fontWeight: FontWeight.w600,
                        size: 14.sp,
                        color: whitecolor,
                        text: singleLetter(widget.title).capitalized),
                    2.h.heightBox,
                    Container(
                      color: Colors.white,
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [bgClr, bgClrDark]),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15.0),
                                  //  bottomRight: Radius.circular(11.0),
                                ),
                              ),
                              height: 58,
                              child: InkWell(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(15.0),
                                  // bottomRight: Radius.circular(11.0),
                                ),
                                highlightColor: Colors.grey[200],
                                onTap: () async {
                                  Helper.executeWithConnectivityCheck(
                                    context,
                                    () async {
                                      BlocProvider.of<ReportCubit>(context)
                                          .getIntro(widget.userId, "2", "");
                                    },
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 58,
                            color: Colors.white,
                          ),
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [bgClr, bgClrDark]),
                                borderRadius: const BorderRadius.only(
                                  // bottomLeft: Radius.circular(11.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                              ),
                              height: 58,
                              child: InkWell(
                                borderRadius: const BorderRadius.only(
                                  // bottomLeft: Radius.circular(11.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                                highlightColor: Colors.grey[200],
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Center(
                                  child: Text(
                                    "No",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                (state is ReportLoading)
                    ? CircularProgressIndicator(
                        color: whitecolor,
                      ).centered()
                    : Container()
              ],
            ),
          );
        },
      ) */
      ,
    );
  }
}
