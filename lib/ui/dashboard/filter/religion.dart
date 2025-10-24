import 'dart:developer';

import 'package:demoproject/ui/dashboard/filter/cubit/filtercubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../component/commonfiles/appcolor.dart';
import '../../../component/reuseable_widgets/appBar.dart';
import '../../../component/reuseable_widgets/apptext.dart';
import '../../../component/reuseable_widgets/custom_button.dart';
import '../../../component/reuseable_widgets/text_field.dart';
import '../../../component/utils/custom_text.dart';

class FilterReligion extends StatefulWidget {
  const FilterReligion({Key? key}) : super(key: key);

  @override
  State<FilterReligion> createState() => _FilterReligionState();
}

class _FilterReligionState extends State<FilterReligion> {
  List<String> name = [
    "Hinduism",
    "Christianity",
    "Sikhism",
    "Buddhism",
    "Jainism",
    "Islam",
    "Judaism",
    "African Diaspora Religions",
    "Indigenous American Religions",
    "Atheism/Agnosticism",
  ];

  String selectedReligions = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: 'Religion',
        titleColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: true,
        showBorder: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Spacer(),
          Container(
            height: MediaQuery.of(context).size.height * 0.86,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xffFFC8D3),
              borderRadius: BorderRadius.only(topLeft:Radius.circular(45),topRight:Radius.circular(45)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: AppText(
                      size: 18,
                      maxlin: 2,
                      text: 'Select the religions you prefer in your partner.',
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GroupButton(
                    isRadio: true,
                    maxSelected: 1,
                    onSelected: (value, index, isSelected) {
                      log(isSelected.toString());
                      setState(() {
                        if (isSelected) {
                          selectedReligions = value.toString();
                        } else {
                          selectedReligions = value.toString();
                        }
                      });
                    },
                    buttons: name,
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
                      selectedBorderColor: bgClr,
                      unselectedBorderColor: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                      spacing: 10,
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
                  GestureDetector(
                    onTap: () {
                      context
                          .read<FilterCubit>()
                          .religionUpdate(selectedReligions);
                      Navigator.pop(context); // Return selected value
                    },
                    child: CustomButton(text: 'Apply Filter'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
