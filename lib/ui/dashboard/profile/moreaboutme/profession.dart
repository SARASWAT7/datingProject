import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart'; // Import Dio for FormData
import '../../../../component/apihelper/toster.dart';
import '../../../../component/commonfiles/appcolor.dart';
import '../../../../component/reuseable_widgets/appBar.dart';
import '../../../../component/reuseable_widgets/apploder.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/custom_button.dart';
import '../../../../component/reuseable_widgets/reusebottombar.dart';
import '../../../../component/reuseable_widgets/text_field.dart';
import '../cubit/moreabout/moreaboutmecubit.dart';
import '../cubit/moreabout/moreaboutmestate.dart';
import 'moreAboutMe.dart'; // Import your cubit

class Profession extends StatefulWidget {
  final String profession;
  const Profession({Key? key,  this.profession=""}) : super(key: key);

  @override
  State<Profession> createState() => _ProfessionState();
}

class _ProfessionState extends State<Profession> {
  final List<String> professionOptions = [
    "Business Man", "Teacher", "Doctor", "Engineer", "Police Officer",
    "IAS Officer", "Nurse", "Lawyer", "Architect", "Scientist",
    "Pharmacist", "Journalist", "Accountant", "Chef", "Artist",
    "Musician", "Plumber", "Electrician", "Mechanic", "Pilot",
    "Flight Attendant", "Graphic Designer", "Web Developer",
    "Software Engineer", "Data Scientist", "HR Manager",
    "Marketing Manager", "Financial Analyst", "Real Estate Agent",
    "Sales Manager", "Social Worker", "Counselor", "Librarian",
    "Veterinarian", "Physical Therapist", "Occupational Therapist",
    "Radiologist", "Surgeon", "Dentist", "Optometrist",
    "Public Relations Specialist", "Event Planner", "Interior Designer",
    "Fashion Designer", "Researcher", "Biologist", "Chemist", "Historian",
    "Economist", "Geologist", "Meteorologist", "Astronomer",
    "Sociologist", "Anthropologist", "Philosopher", "Theologian",
    "Cryptocurrency Analyst", "Investment Banker", "Insurance Agent",
    "Supply Chain Manager", "Logistics Coordinator", "Construction Manager",
    "Architectural Drafter", "Landscaper", "Chef", "Baker", "Barista",
    "Waiter", "Bartender", "Personal Trainer", "Fitness Instructor",
    "Yoga Instructor", "Massage Therapist", "Travel Agent",
    "Tour Guide", "Photographer", "Videographer", "Actor", "Director",
    "Screenwriter", "Producer", "Voice Actor", "Editor", "Publisher"
  ];

  final GroupButtonController controller = GroupButtonController();
  String selectedButton = "";

  @override
  void initState() {
    super.initState();
    selectedButton = widget.profession;
    print("list----------->:$selectedButton");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preselectProfession();
    });
  }

  void _preselectProfession() {
    if (selectedButton.isNotEmpty && professionOptions.contains(selectedButton)) {
      final index = professionOptions.indexOf(selectedButton);
      controller.selectIndex(index);
    }
  }

  void _saveProfession() {
    if (selectedButton.isEmpty) {
      showToast(context, 'Please select a profession.');
      return;
    }

    final formData = FormData.fromMap({
      'profession': selectedButton,
    });

    context.read<MoreAboutMeProfileCubit>().moreAboutMeProfile(context, formData);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MoreAboutMeProfileCubit, MoreAboutMeProfileState>(
      builder: (context, state) {
        if (state is MoreAboutMeProfileLoading) {
          return Scaffold(
            bottomNavigationBar: BottomSteet(currentIndex: 4),
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
              title: 'Profession',
              titleColor: Colors.black,
              backgroundColor: Colors.white,
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: AppLoader(), // Show loader during loading
          );
        }

        return Scaffold(
          bottomNavigationBar: BottomSteet(currentIndex: 4),
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
            title: 'Profession',
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
                    size: 18,
                    maxlin: 2,
                    text: 'Fill all the details which tell about you more! It will help you to find your partner.',
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  SpaceWidget(height: MediaQuery.of(context).size.height * 0.02),
                  Center(
                    child: GroupButton(
                      controller: controller,
                      isRadio: false,
                      buttons: professionOptions,
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
                        textAlign: TextAlign.center,
                        elevation: 0,
                      ),
                    ),
                  ),
                  SpaceWidget(height: MediaQuery.of(context).size.height * 0.1),
                  CustomButton(
                    text: 'Save',
                    onPressed: _saveProfession,
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
            MaterialPageRoute(builder: (context) => const MoreAboutMe()),
          );
        }
        if (state is MoreAboutMeProfileError) {
          showToast(context, state.message);
        }
      },
    );
  }
}
