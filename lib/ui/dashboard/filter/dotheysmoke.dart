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
import 'languagetheyknow.dart';

class FilterDoTheySmoke extends StatefulWidget {
  const FilterDoTheySmoke({Key? key}) : super(key: key);

  @override
  State<FilterDoTheySmoke> createState() => _FilterDoTheySmokeState();
}

class _FilterDoTheySmokeState extends State<FilterDoTheySmoke> {
  final List<String> smoke = [

    "Never",
    "Socially",
    "Friquently",
    "Sober",
  ];
  final GroupButtonController controller = GroupButtonController();
  String selectedButon = "";

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
        title: 'Do They Smoke',
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
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: AppText(
                      size: 18,
                      text: 'Select the smoking preference of your loved one.',
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Center(
                    child: GroupButton(
                      controller: controller,
                      isRadio: false,
                      maxSelected: 1,
                      buttons: smoke,
                      onSelected: (value, index, isSelected) {
                        setState(() {
                          selectedButon = value.toString();
                        });
                      },
                      options: GroupButtonOptions(

                        selectedTextStyle: TextStyle(
                          fontSize: 18.sp,
                          color: bgClr,
                        ),
                        unselectedShadow: const [],
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
                  GestureDetector(
                    onTap: () {
                      context.read<FilterCubit>().doSmokeUpdate(selectedButon);
                      Navigator.pop(context);
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
