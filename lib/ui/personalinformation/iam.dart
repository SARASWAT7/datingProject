

import 'package:demoproject/component/utils/headerwidget.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:sizer/sizer.dart';
import '../../component/alert_box.dart';
import '../../component/commonfiles/appcolor.dart';
import '../../component/reuseable_widgets/custom_button.dart';


import 'iaminterested.dart';

class IamScreen extends StatefulWidget {
  const IamScreen({Key? key}) : super(key: key);

  @override
  State<IamScreen> createState() => _IamScreenState();
}

class _IamScreenState extends State<IamScreen> {
  final List<String> items = List<String>.generate(10, (i) => "Item $i");

  final List<String> gender = [
    "Male", "Female", "Lesbian","Bisexual","Asexual","Demi sexual","Pansexual",
  "Queer","Bicurious","Aromantic"];

  final GroupButtonController gendercontroller = GroupButtonController();
  String selectedButon = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // HeaderWidget(title: 'I done
              //Am Interested', progress: 0.16, onTap: () {
              HeaderWidget(title: 'I Am ' , progress: 0.0, onTap: () {
          
              },),
              Center(
                child: GroupButton(
                  controller: gendercontroller,
                  isRadio: true,
                  maxSelected: 1,
                  buttons: gender,
                  onSelected: (value, index, isSelected) {
                    setState(() {
                      selectedButon = value.toString();
                     
                    });
                  },
                  options: GroupButtonOptions(unselectedShadow: [],
                    selectedTextStyle: TextStyle(
                      fontSize: 18.sp,
                      color: AppColor.iconsColor,
                    ),
                    selectedColor: Colors.transparent,
                    selectedBorderColor: AppColor.iconsColor,
                    unselectedBorderColor:  Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    unselectedColor: Colors.white,
                    spacing: 1.h,
                    runSpacing: 1.h,
                    groupingType: GroupingType.column,
                    direction: Axis.horizontal,
                    buttonHeight: 5.5.h,
                    buttonWidth: 30.w,
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
                    if (selectedButon.isEmpty) {
                      showDialog<void>(
                        context: context,
                        builder: (_) =>
                        const AlertBox(
                          title: "Select Gender",
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>IamInterestScreen(genderList:selectedButon.toString())
                                //gender: selectedButon,
                        ),
                      );
                    }
                  },
                  child:
                  Padding(
                    padding:   EdgeInsets.only(left: 4.w,right: 4.w),
                    child: CustomButton(text: 'Continue'),
                  ),


              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
