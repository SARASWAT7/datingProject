import 'package:demoproject/ui/dashboard/filter/cubit/filtercubit.dart';
import 'package:demoproject/ui/dashboard/filter/cubit/filterstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../component/commonfiles/appcolor.dart';
import '../../../component/reuseable_widgets/appBar.dart';
import '../../../component/reuseable_widgets/apptext.dart';
import '../../../component/reuseable_widgets/custom_button.dart';
import '../../../component/reuseable_widgets/text_field.dart';
import '../../../component/utils/custom_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../component/commonfiles/appcolor.dart';
import '../../../component/reuseable_widgets/appBar.dart';
import '../../../component/reuseable_widgets/apptext.dart';
import '../../../component/reuseable_widgets/custom_button.dart';
import '../../../component/utils/custom_text.dart';
import 'package:demoproject/ui/dashboard/filter/cubit/filtercubit.dart';
import 'package:demoproject/ui/dashboard/filter/cubit/filterstate.dart';

class FilterHeight extends StatefulWidget {
  const FilterHeight({Key? key}) : super(key: key);

  @override
  _FilterHeightState createState() => _FilterHeightState();
}

class _FilterHeightState extends State<FilterHeight> {
  RangeValues _heightRange = RangeValues(100, 200);

  @override
  void initState() {
    super.initState();

    final state = context.read<FilterCubit>().state;
    double heightMin = state.heightmin.isEmpty
        ? 100
        : double.parse(state.heightmin.split(' ').first);
    double heightMax = state.heightmax.isEmpty
        ? 200
        : double.parse(state.heightmax.split(' ').first);

    if (heightMin > heightMax) {
      final temp = heightMin;
      heightMin = heightMax;
      heightMax = temp;
    }

    _heightRange = RangeValues(heightMin, heightMax);
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
        title: 'Height',
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
            height: MediaQuery.of(context).size.height * 0.85,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xffFFC8D3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  AppText(
                    size: 18,
                    maxlin: 2,
                    text: 'Scale the height as per your preference.',
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  SpaceWidget(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 17, right: 17),
                        child: CustomText(
                          text: 'Min Height',
                          size: 13.sp,
                          weight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: '',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 17, right: 17),
                        child: CustomText(
                          text: "${_heightRange.start.toInt()} cm",
                          size: 13.sp,
                          color: bgClr,
                          weight: FontWeight.w700,
                          fontFamily: '',
                        ),
                      ),
                    ],
                  ),
                  SpaceWidget(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 17, right: 17),
                        child: CustomText(
                          text: 'Max Height',
                          size: 13.sp,
                          weight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: '',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 17, right: 17),
                        child: CustomText(
                          text: "${_heightRange.end.toInt()} cm",
                          size: 13.sp,
                          color: bgClr,
                          weight: FontWeight.w700,
                          fontFamily: '',
                        ),
                      ),
                    ],
                  ),
                  SpaceWidget(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: RangeSlider(
                      activeColor: AppColor.tinderclr,
                      inactiveColor: Color(0xffD3D3D3),
                      values: _heightRange,
                      max: 300,
                      min: 100,
                      labels: RangeLabels(
                        "${_heightRange.start.toInt()}cm",
                        "${_heightRange.end.toInt()}cm",
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _heightRange = values;
                        });
                      },
                      onChangeEnd: (RangeValues values) {
                        context.read<FilterCubit>().heightUpdate(
                          "${values.start.toInt()}",
                          "${values.end.toInt()}",
                        );
                      },
                    ),
                  ),
                  SpaceWidget(
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, _heightRange);
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
