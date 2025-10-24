import 'package:demoproject/component/reuseable_widgets/text_field.dart';
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
import '../cubit/moreabout/moreaboutmecubit.dart'; // Import your cubit
import '../cubit/moreabout/moreaboutmestate.dart';
import 'moreAboutMe.dart'; // Import your cubit state

class Sunsign extends StatefulWidget {
  final String sunSign;
  const Sunsign({Key? key, this.sunSign = ""}) : super(key: key);

  @override
  State<Sunsign> createState() => _SunsignState();
}

class _SunsignState extends State<Sunsign> {
  final List<String> sunSigns = [
    "Aries",
    "Leo",
    "Virgo",
    "Libra",
    "Sagittarius",
    "Capricorn",
    "Gemini",
    "Aquarius",
    "Scorpio",
    "Pisces",
  ];

  final GroupButtonController controller = GroupButtonController();
  String selectedButton = "";

  @override
  void initState() {
    super.initState();
    // Initialize the selected button with the value passed from ProfileItem
    selectedButton = widget.sunSign;
    // Pre-select the button based on the passed sunSign value
    controller.selectIndex(sunSigns.indexOf(selectedButton));
  }

  void _saveSunsign() {
    if (selectedButton.isEmpty) {
      showToast(context, 'Please select a Sun Sign.');
      return;
    }
    final formData = FormData.fromMap({
      'sun_sign': selectedButton,
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
              title: 'SunSign',
              titleColor: Colors.black,
              backgroundColor: Colors.white,
              centerTitle: true,
              showBorder: true,
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
            title: 'SunSign',
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
                    isRadio: true,
                    maxSelected: 1,
                    buttons: sunSigns,
                    onSelected: (value, index, isSelected) {
                      setState(() {
                        selectedButton = value.toString();
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
                  SpaceWidget(height: MediaQuery.of(context).size.height * 0.1),
                  CustomButton(
                    text: 'Save',
                    onPressed: _saveSunsign,
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
