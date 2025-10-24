import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/component/reuseable_widgets/custom_button.dart';
import 'package:demoproject/ui/dashboard/filter/cubit/filtercubit.dart';
import 'package:demoproject/ui/dashboard/filter/cubit/filterstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class ViewVerified extends StatefulWidget {
  const ViewVerified({
    super.key,
  });

  @override
  State<ViewVerified> createState() => _ViewVerifiedState();
}

class _ViewVerifiedState extends State<ViewVerified> {
  List<String> verified = [
    "Yes",
    "No",
  ];
  late String selectedButton;
  final GroupButtonController controller = GroupButtonController();
  String verifiedKnown = "";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              elevation: 0,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: AppText(
                  fontWeight: FontWeight.w500, size: 2.h, text: "Verified")),
          backgroundColor: Colors.white,
          body: Container(
            height: 100.h,
            width: 100.w,
            decoration: const BoxDecoration(
                // color: contcolor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50))),
            child: Column(
              children: [
                Spacer(),
                // 4.h.heightBox,
                Container(
                  height: MediaQuery.of(context).size.height * 0.86,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffFFC8D3),
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        AppText(
                          size: 18,
                          maxlin: 2,
                          text:
                              'Do you want to filter your match as per verified profile?',
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: GroupButton(
                            controller: controller,
                            isRadio: true,
                            maxSelected: 1,
                            buttons: verified,
                            onSelected: (value, index, isSelected) {
                              setState(() {
                                selectedButton = value.toString();
                              });
                            },
                            options: GroupButtonOptions(
                              selectedTextStyle: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
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
                        SizedBox(height: 6.h),
                        GestureDetector(
                          onTap: () {
                            context
                                .read<FilterCubit>()
                                .verifiedUpdate(selectedButton);
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
          ),
        );
      },
    );
  }
}
