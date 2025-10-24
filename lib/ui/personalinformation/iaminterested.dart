import 'dart:developer';

import 'package:demoproject/component/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:sizer/sizer.dart';

import '../../component/alert_box.dart';
import '../../component/commonfiles/appcolor.dart';
import '../../component/reuseable_widgets/custom_button.dart';
import '../../component/utils/headerwidget.dart';
import 'mysesualorientation.dart';

class IamInterestScreen extends StatefulWidget {
  final String genderList;
  const IamInterestScreen({super.key, this.genderList = ""});

  @override
  State<IamInterestScreen> createState() => _IamInterestScreenState();
}

class _IamInterestScreenState extends State<IamInterestScreen> {
  final List<String> items = List<String>.generate(10, (i) => "Item $i");
  final List<String> Intrested = [
    "A relationship",
    "Looking for friendship",
    "I’m not sure yet",
    "Hook-Ups",
    "Short term relationship",
    "Something casual",
    "Long term relationship",
    "Prefer not to say"
  ];
  GroupButtonController controller = GroupButtonController();
  List<String> iamIntersed = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  HeaderWidget(
                    title: 'I Am Interested',
                    progress: 0.14,
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomText(
                        size: 18,
                        text: 'You can select multiple choices.',
                        color: AppColor.grey,
                        weight: FontWeight.w500,
                        fontFamily: 'Nunito Sans',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: GroupButton(
                      isRadio: false,
                      controller: controller,
                      onSelected: (value, index, isSelected) {
                        log(value.toString());

                        setState(() {
                          // If "Prefer not to say" is selected
                          if (value == "Prefer not to say") {
                            if (isSelected) {
                              // Clear all other selections
                              iamIntersed.clear();
                              controller.unselectAll();
                              // Add "Prefer not to say" to the list
                              iamIntersed.add(value);
                              controller.selectIndex(index);
                            } else {
                              // If deselecting "Prefer not to say", just remove it from the list
                              iamIntersed.remove(value);
                            }
                          } else {
                            // If any other option is selected
                            if (isSelected) {
                              // Remove "Prefer not to say" if it's selected
                              iamIntersed.remove("Prefer not to say");
                              controller.unselectIndex(Intrested.indexOf("Prefer not to say"));
                              iamIntersed.add(value);
                            } else {
                              // If deselecting any other option, remove it from the list
                              iamIntersed.remove(value);
                            }
                          }
                        });
                      },
                      buttons: Intrested,
                      options: GroupButtonOptions(
                        unselectedShadow: [],
                        selectedTextStyle: TextStyle(
                          fontSize: 18.sp,
                          color: AppColor.iconsColor,
                        ),
                        selectedColor: Colors.transparent,
                        selectedBorderColor: AppColor.iconsColor,
                        unselectedColor: Colors.transparent,
                        unselectedBorderColor: null,
                        borderRadius: BorderRadius.circular(30),
                        spacing: 1.h,
                        runSpacing: 1.h,
                        groupingType: GroupingType.column,
                        direction: Axis.horizontal,
                        buttonHeight: 6.h,
                        buttonWidth: 45.w,
                        mainGroupAlignment: MainGroupAlignment.start,
                        crossGroupAlignment: CrossGroupAlignment.start,
                        groupRunAlignment: GroupRunAlignment.start,
                        textAlign: TextAlign.center,
                        textPadding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      if (iamIntersed.isEmpty) {
                        showDialog<void>(
                          context: context,
                          builder: (_) => const AlertBox(
                            title: "Please Select Interested",
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MySexualOrientation(
                              gender: widget.genderList,
                              iamInterstedList: iamIntersed,
                            ),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.w, right: 4.w),
                      child: CustomButton(text: 'Continue'),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
