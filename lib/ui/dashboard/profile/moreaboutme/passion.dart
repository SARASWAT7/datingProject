import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart'; // Import Dio for FormData

import '../../../../component/apihelper/toster.dart';
import '../../../../component/commonfiles/appcolor.dart';
import '../../../../component/reuseable_widgets/appBar.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/custom_button.dart';
import '../../../../component/reuseable_widgets/reusebottombar.dart';
import '../../../../component/reuseable_widgets/text_field.dart';
import '../cubit/moreabout/moreaboutmecubit.dart'; // Import your cubit
import '../cubit/moreabout/moreaboutmestate.dart';
import 'moreAboutMe.dart'; // Import your cubit state

class Passion extends StatefulWidget {
  final List<String> selectedPassions;

  const Passion({Key? key, required this.selectedPassions }) : super(key: key);

  @override
  State<Passion> createState() => _PassionState();
}

class _PassionState extends State<Passion> {
  final List<String> passions = [
    "Skating",
    "Reading",
    "Cooking",
    "Traveling",
    "Music",
    "Art",
    "Sports",
    "Photography",
    "Gardening",
    "Writing",
    "Dancing",
    "Movies",
    "Gaming",
    "Fitness",
    "Yoga",
    "Volunteering",
    "Meditation",
    "Hiking",
    "Fishing",
    "Crafting",
    "Car Racing",
    "Comedy",
    "Cricket",
    "Instagram",
  ];

  final GroupButtonController controller = GroupButtonController();
  List<String> selectedButtons = [];

  @override
  void initState() {
    super.initState();
    selectedButtons = widget.selectedPassions;
    print("asdfghjkl--------->:$selectedButtons");
    controller.selectIndexes(
      passions
          .asMap()
          .entries
          .where((entry) => selectedButtons.contains(entry.value))
          .map((entry) => entry.key)
          .toList(),
    );
  }

  void _savePassions() {
    if (selectedButtons.isEmpty) {
      showToast(context, 'Please select at least one passion.');
      return;
    }
    final formData = FormData.fromMap({
      'passions': selectedButtons,
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
              title: 'Passion',
              titleColor: Colors.black,
              backgroundColor: Colors.white,
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: Center(), // Show loading spinner
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
            title: 'Passion',
            titleColor: Colors.black,
            backgroundColor: Colors.white,
            centerTitle: true,
            showBorder: true,
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
                  GroupButton(
                    controller: controller,
                    isRadio: false, // Allow multiple selections
                    maxSelected: 5, // Allow up to 5 selections
                    buttons: passions,
                    onSelected: (value, index, isSelected) {
                      setState(() {
                        if (isSelected) {
                          if (selectedButtons.length < 5) {
                            selectedButtons.add(value.toString());
                          }
                        } else {
                          selectedButtons.remove(value.toString());
                        }
                      });
                    },
                    options: GroupButtonOptions(
                      selectedShadow: const [],
                      selectedTextStyle: TextStyle(
                        fontSize: 18.sp,
                        color: bgClr,
                      ),
                      selectedColor: const Color(0xffFFFFFF),
                      unselectedShadow: const [],
                      unselectedTextStyle: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black,
                      ),
                      unselectedColor: const Color(0xffFFFFFF),
                      selectedBorderColor: bgClr,
                      unselectedBorderColor: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                      spacing: 20,
                      runSpacing: 10,
                      groupingType: GroupingType.wrap,
                      direction: Axis.horizontal,
                      mainGroupAlignment: MainGroupAlignment.start,
                      crossGroupAlignment: CrossGroupAlignment.start,
                      groupRunAlignment: GroupRunAlignment.start,
                      textAlign: TextAlign.center,
                      textPadding: EdgeInsets.zero,
                      alignment: Alignment.center,
                      elevation: 0,
                    ),
                  ),
                  SpaceWidget(height: MediaQuery.of(context).size.height * 0.05),
                  CustomButton(
                    text: 'Save',
                    onPressed: _savePassions, // Attach the method here
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
              builder: (context) => const MoreAboutMe(),
            ),
          );
        }
        if (state is MoreAboutMeProfileError) {
          showToast(context, state.message);
        }
      },
    );
  }
}
