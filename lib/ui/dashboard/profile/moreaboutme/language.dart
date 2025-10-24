import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart'; // Import Dio for FormData
import '../../../../component/commonfiles/appcolor.dart';
import '../../../../component/reuseable_widgets/appBar.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/custom_button.dart';
import '../../../../component/reuseable_widgets/reusebottombar.dart';
import '../../../../component/reuseable_widgets/text_field.dart';
import '../cubit/moreabout/moreaboutmecubit.dart'; // Import your cubit
import '../cubit/moreabout/moreaboutmestate.dart';
import 'moreAboutMe.dart'; // Import your cubit state

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart'; // Import Dio for FormData
import '../../../../component/commonfiles/appcolor.dart';
import '../../../../component/reuseable_widgets/appBar.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/custom_button.dart';
import '../../../../component/reuseable_widgets/reusebottombar.dart';
import '../../../../component/reuseable_widgets/text_field.dart';
import '../cubit/moreabout/moreaboutmecubit.dart'; // Import your cubit
import '../cubit/moreabout/moreaboutmestate.dart';
import 'moreAboutMe.dart'; // Import your cubit state

class Language extends StatefulWidget {
  final List<String> language;

  Language({Key? key, required this.language}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  final List<String> allLanguages = [
    "Amharic", "Arabic", "Basque", "Bengali", "Portugues", "Bulgarian",
    "Catalan", "Cherokee", "Croatian", "Czech", "Danish", "Dutch","English (UK)","English (US)",
    "Estonian", "Filipino", "Finnish", "French", "German", "Greek",
    "Gujarati", "Hebrew", "Hindi", "Hungarian", "Icelandic", "Indonesian",
    "Italian", "Japanese", "Kannada", "Korean", "Latvian", "Lithuanian",
    "Malay", "Malayalam", "Marathi", "Norwegian", "Polish",
    "Portuguese", "Romanian", "Russian", "Serbian", "Chinese",
    "Slovak", "Slovenian", "Spanish", "Swahili", "Swedish", "Tamil",
    "Telugu", "Thai", "Chinese", "Turkish", "Urdu", "Ukrainian",
    "Vietnamese", "Welsh"
  ];

  List<String> passionList = [];
  final GroupButtonController _controller = GroupButtonController();

  @override
  void initState() {
    super.initState();

    passionList = widget.language;
    print("Received Languages: $passionList");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateGroupButtonController(); // Update the controller after the first frame is rendered
    });
  }

  void _updateGroupButtonController() {
    _controller.unselectAll();

    for (var lang in passionList) {
      final index = allLanguages.indexOf(lang);
      if (index != -1) {
        _controller.selectIndex(index); // Select the matching language
      }
    }

    setState(() {});
  }

  // Save the selected languages
  void _saveLanguages() {
    print("Selected Languages to Save: $passionList");

    final formData = FormData.fromMap({
      'languages': passionList,
    });

    context.read<MoreAboutMeProfileCubit>().moreAboutMeProfile(context, formData);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MoreAboutMeProfileCubit, MoreAboutMeProfileState>(
      builder: (context, state) {
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
            title: 'Language',
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
                    maxlin: 2,
                    size: 18,
                    text: 'Fill all the details which tell about you more! It will help you to find your partner.',
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  SpaceWidget(height: MediaQuery.of(context).size.height * 0.02),
                  GroupButton(
                    isRadio: false,
                    controller: _controller,
                    onSelected: (value, index, isSelected) {
                      log(isSelected.toString());
                      setState(() {
                        // Step 3: Add or remove selected languages from passionList
                        if (isSelected) {
                          if (!passionList.contains(value.toString())) {
                            passionList.add(value.toString());
                          }
                        } else {
                          passionList.remove(value.toString());
                        }
                      });
                    },
                    buttons: allLanguages,
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
                  SpaceWidget(height: MediaQuery.of(context).size.height * 0.2),
                  CustomButton(
                    text: 'Save',
                    onPressed: _saveLanguages,
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
      },
    );
  }
}
