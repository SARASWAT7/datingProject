import 'dart:developer';
import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/component/utils/custom_text.dart';
import 'package:demoproject/ui/auth/cubit/updatedata/updatedatacubit.dart';
import 'package:demoproject/ui/auth/cubit/updatedata/updatedatastate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../component/alert_box.dart';
import '../../component/commonfiles/appcolor.dart';
import '../../component/reuseable_widgets/custom_button.dart';
import '../../component/utils/headerwidget.dart';

class PassionScreen extends StatefulWidget {
  const PassionScreen({Key? key}) : super(key: key);

  @override
  State<PassionScreen> createState() => _PassionScreenState();
}

class _PassionScreenState extends State<PassionScreen> {
  // List of available passions
  List<String> name = [
    "Singing", "Car Racing", "Dancing", "Philosophy", "Drawing", "Gardening",
    "Dog Lover", "Dramas", "Foodie", "Instagram", "Cooking", "Comedy",
    "Photography", "Partying", "Boxing", "Hollywood", "Cricket", "Football",
    "Self-care", "Sports", "Tattoos", "Picnicking",
  ];

  List<String> passionList = []; // List to store selected passions

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateDataCubit(),
      child: BlocBuilder<UpdateDataCubit, UpdateDataState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColor.white,
                body: SingleChildScrollView(
                  child: SafeArea(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          // Header
                          HeaderWidget(
                            title: 'Passion',
                            progress: 100,
                            onTap: () {},
                          ),
                          SizedBox(height: 10),
                          CustomText(
                            weight: FontWeight.w600,
                            size: 16.sp,
                            color: AppColor.grey,
                            text: 'Select Any Five.',
                            fontFamily: 'Nunito Sans',
                          ).objectCenterLeft().pOnly(left: 6.w),
                          4.h.heightBox,

                          // Passion Selection
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: GroupButton(
                              isRadio: false,
                              maxSelected: 5,
                              onSelected: (String value, int index, bool isSelected) {
                                log(isSelected.toString());
                                setState(() {
                                  if (isSelected) {
                                    passionList.add(value);
                                  } else {
                                    passionList.remove(value);
                                  }
                                });
                              },
                              buttons: name,
                              options: GroupButtonOptions(
                                selectedShadow: const [],
                                selectedTextStyle: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColor.iconsColor,
                                ),
                                selectedColor: Colors.transparent,
                                unselectedShadow: const [],
                                unselectedColor: Colors.white,
                                unselectedTextStyle: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.black,
                                ),
                                selectedBorderColor: AppColor.iconsColor,
                                unselectedBorderColor: Colors.grey,
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
                          ),
                          10.h.heightBox,

                          // Continue Button
                          GestureDetector(
                            onTap: () {
                              // Validation for selecting at least 5 passions
                              if (passionList.length < 5) {
                                showDialog<void>(
                                  context: context,
                                  builder: (_) => const AlertBox(
                                    title: "Please select at least five passions",
                                  ),
                                );
                              } else {
                                context.read<UpdateDataCubit>().paasion(context, passionList);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 4.w, right: 4.w),
                              child: CustomButton(text: 'Continue'),
                            ),

                          ),
                                                    10.h.heightBox,

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (state.status == ApiState.isLoading) AppLoader(),
            ],
          );
        },
      ),
    );
  }
}
