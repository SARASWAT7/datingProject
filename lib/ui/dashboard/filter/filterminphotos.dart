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

class MinimumPhotos extends StatefulWidget {
  final String initialSelection;

  const MinimumPhotos({Key? key, required this.initialSelection})
      : super(key: key);

  @override
  State<MinimumPhotos> createState() => _MinimumPhotosState();
}

class _MinimumPhotosState extends State<MinimumPhotos> {
  final List<String> photoOptions = [ "6-10", "11-15", "16-20","20-25"];
  final GroupButtonController controller = GroupButtonController();
  late String selectedButton;

  @override
  void initState() {
    super.initState();
    selectedButton = widget.initialSelection;
    controller.selectIndex(photoOptions.indexOf(selectedButton));
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
        title: 'Minimum Photos',
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  AppText(
                    size: 18,
                    maxlin: 2,
                    text: 'Select the number of photos as per your preference.',
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GroupButton(
                      controller: controller,
                      maxSelected: 1,
                      isRadio: true,
                      buttons: photoOptions,
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
                  SizedBox(height: 6.h),
                  GestureDetector(
                    onTap: () {
                      context
                          .read<FilterCubit>()
                          .minNumberPhotoUpdate(selectedButton);
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
