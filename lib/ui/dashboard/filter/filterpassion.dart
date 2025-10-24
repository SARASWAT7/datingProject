import 'dart:developer';
import 'package:demoproject/component/reuseable_widgets/text_field.dart';
import 'package:demoproject/ui/dashboard/filter/cubit/filtercubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:sizer/sizer.dart';

import '../../../component/commonfiles/appcolor.dart';
import '../../../component/reuseable_widgets/appBar.dart';
import '../../../component/reuseable_widgets/apptext.dart';
import '../../../component/reuseable_widgets/custom_button.dart';

class FilterPassion extends StatefulWidget {
  final List<String> initialPassions; // Pass initial passions for pre-selection

  const FilterPassion({Key? key, required this.initialPassions})
      : super(key: key);

  @override
  State<FilterPassion> createState() => _FilterPassionState();
}

class _FilterPassionState extends State<FilterPassion> {
  final List<String> name = [
    "Singing",
    "Car Racing",
    "Dancing",
    "Philosophy",
    "Drawing",
    "Gardening",
    "Dog Lover",
    "Dramas",
    "Foodie",
    "Instagram",
    "Cooking",
    "Comedy",
    "Photography",
    "Partying",
    "Boxing",
    "Hollywood",
    "Cricket",
    "Football",
    "Self-care",
    "Sports",
    "Tattoos",
    "Picnicking",
    "Singing",
    "Car Racing",
    "Dancing",
    "Philosophy",
    "Drawing",
    "Gardening",
    "Dog Lover",
    "Dramas",
    "Foodie",
    "Instagram",
    "Cooking",
    "Comedy",
    "Photography",
    "Partying",
    "Boxing",
    "Hollywood",
    "Cricket",
    "Football",
    "Self-care",
    "Sports",
    "Tattoos",
    "Picnicking",
  ];

  final GroupButtonController _controller = GroupButtonController();
  List<String> passionList = [];

  @override
  void initState() {
    super.initState();
    passionList = List.from(widget.initialPassions);
    // Pre-select the initial passions
    _controller.selectIndexes(
        widget.initialPassions.map((e) => name.indexOf(e)).toList());
  }

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
        title: 'Passion',
        titleColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: true,
        showBorder: false,
      ),
      backgroundColor: Colors.white,
      body:  Column(
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
                      text:
                      'Select the languages you want your loved one to know.',
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SpaceWidget(
                      height: MediaQuery.of(context).size.height * 0.03),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GroupButton(
                      isRadio: false,
                      maxSelected: 5,
                      onSelected: (value, index, isSelected) {
                        setState(() {
                          if (isSelected) {
                            passionList.add(value.toString());
                          } else {
                            passionList.remove(value.toString());
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
                  ),
                  SpaceWidget(height: MediaQuery.of(context).size.height * 0.1),
                  GestureDetector(
                    onTap: () {
                      context
                          .read<FilterCubit>()
                          .languageUpdate(passionList);
                      Navigator.pop(context);
                    },
                    child: CustomButton(text: 'Apply Filter'),
                  ),
                  SpaceWidget(height: MediaQuery.of(context).size.height * 0.1),

                ],
              ),
            ),
          ),
        ],
      ),
      // Column(
      //   children: [
      //
      //     Container(
      //       height: MediaQuery.of(context).size.height * 0.86,
      //       width: MediaQuery.of(context).size.width,
      //       decoration: BoxDecoration(
      //         color: Color(0xffFFC8D3),
      //         borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
      //       ),
      //       child: Column(
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.all(20),
      //             child: AppText(
      //               size: 16,
      //               maxlin: 2,
      //               text: 'Select the passions you want in your love one!',
      //               color: Colors.black,
      //               fontWeight: FontWeight.w400,
      //             ),
      //           ),
      //           // Make this area scrollable
      //           Expanded(
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 16),
      //                 child: GroupButton(
      //                   controller: _controller,
      //                   isRadio: false,
      //                   maxSelected: 5,
      //                   buttons: name,
      //                   onSelected: (value, index, isSelected) {
      //                     log(isSelected.toString());
      //                     setState(() {
      //                       if (isSelected) {
      //                         passionList.add(value.toString());
      //                       } else {
      //                         passionList.remove(value.toString());
      //                       }
      //                     });
      //                   },
      //                   options: GroupButtonOptions(
      //                     selectedShadow: [],
      //                     selectedTextStyle: TextStyle(
      //                       fontSize: 18.sp,
      //                       color: bgClr,
      //                     ),
      //                     selectedColor: const Color(0xffFFFFFF),
      //                     unselectedShadow: [],
      //                     unselectedTextStyle: TextStyle(
      //                       fontSize: 18.sp,
      //                       color: Colors.black,
      //                     ),
      //                     selectedBorderColor: bgClr,
      //                     unselectedBorderColor: Colors.grey.shade300,
      //                     borderRadius: BorderRadius.circular(30),
      //                     spacing: 10,
      //                     runSpacing: 10,
      //                     groupingType: GroupingType.wrap,
      //                     mainGroupAlignment: MainGroupAlignment.start,
      //                     crossGroupAlignment: CrossGroupAlignment.start,
      //                     groupRunAlignment: GroupRunAlignment.start,
      //                     textAlign: TextAlign.center,
      //                     textPadding: EdgeInsets.zero,
      //                     alignment: Alignment.center,
      //                     elevation: 0,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //
      //           const SizedBox(height: 30),
      //           Padding(
      //             padding: const EdgeInsets.all(20.0),
      //             child: GestureDetector(
      //               onTap: () {
      //                 context.read<FilterCubit>().passionUpdate(passionList);
      //                 Navigator.pop(context);
      //               },
      //               child: CustomButton(text: 'Apply Filter'),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
