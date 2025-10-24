import 'package:demoproject/component/reuseable_widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart';

import '../../../../component/apihelper/toster.dart';
import '../../../../component/commonfiles/appcolor.dart';
import '../../../../component/reuseable_widgets/appBar.dart';
import '../../../../component/reuseable_widgets/apploder.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/custom_button.dart';
import '../../../../component/reuseable_widgets/reusebottombar.dart';
import '../cubit/moreabout/moreaboutmecubit.dart';
import '../cubit/moreabout/moreaboutmestate.dart';
import 'moreAboutMe.dart';

class Exercise extends StatefulWidget {
  final String exercise;

  const Exercise({super.key, this.exercise = ""});

  @override
  State<Exercise> createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  final List<String> gender = [
    "Active",
    "Sometimes",
    "Not Serious",
    "Never",
  ];

  final GroupButtonController controller = GroupButtonController();
  String selectedButton = "";

  @override
  void initState() {
    super.initState();
    selectedButton = widget.exercise;
    controller.selectIndex(gender.indexOf(selectedButton)); // Pre-select the button
  }

  void _saveExercise() {
    if (selectedButton.isEmpty) {
      showToast(context, 'Please select an exercise level.');
      return;
    }
    final formData = FormData.fromMap({
      'exercise': selectedButton,
    });
    context.read<MoreAboutMeProfileCubit>().moreAboutMeProfile(context, formData);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MoreAboutMeProfileCubit, MoreAboutMeProfileState>(
      builder: (context, state) {
        if (state is MoreAboutMeProfileLoading) {
          return Scaffold(
            bottomNavigationBar: BottomSteet(
              currentIndex: 4,
            ),
            appBar: appBarWidgetThree(
              leading: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Transform.scale(
                    scale: 0.5,
                    child: Image.asset(
                      'assets/images/backarrow.png',
                      height: 50,
                      width: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              title: 'Exercise',
              titleColor: Colors.black,
              backgroundColor: Colors.white,
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: Center(child: AppLoader()), // Show loading spinner
          );
        }

        return Scaffold(
          bottomNavigationBar: BottomSteet(
            currentIndex: 4,
          ),
          appBar: appBarWidgetThree(
            leading: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Transform.scale(
                  scale: 0.5,
                  child: Image.asset(
                    'assets/images/backarrow.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            title: 'Exercise',
            titleColor: Colors.black,
            backgroundColor: Colors.white,
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  AppText(
                    fontWeight: FontWeight.w600,
                    size: 18,
                    maxlin: 2,
                    text: "Fill all the details which tell about you more!"
                        " will help you to find your partner.",
                  ),
                  SpaceWidget(height: MediaQuery.of(context).size.height * 0.02),
                  Center(
                    child: GroupButton(
                      controller: controller,
                      isRadio: true,
                      maxSelected: 1,
                      buttons: gender,
                      onSelected: (value, index, isSelected) {
                        setState(() {
                          selectedButton = value.toString();
                        });
                      },
                      options: GroupButtonOptions(
                        selectedTextStyle: TextStyle(
                          fontSize: 18.sp,
                          color: bgClr,
                        ),
                        selectedColor: Colors.white,
                        unselectedColor: Colors.transparent,
                        selectedBorderColor: bgClr,
                        unselectedBorderColor: Colors.transparent,
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
                  SpaceWidget(height: MediaQuery.of(context).size.height * 0.1),
                  CustomButton(
                    text: 'Save',
                    onPressed: _saveExercise,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (BuildContext context, MoreAboutMeProfileState state) {
        if (state is MoreAboutMeProfileSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MoreAboutMe()),
          );
        }
        if (state is MoreAboutMeProfileError) {
          showToast(context, state.message);
        }
      },
    );
  }
}
