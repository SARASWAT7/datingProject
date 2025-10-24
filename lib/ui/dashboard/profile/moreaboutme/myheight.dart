import 'package:demoproject/component/reuseable_widgets/text_field.dart';
import 'package:demoproject/ui/dashboard/profile/moreaboutme/moreAboutMe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../component/commonfiles/appcolor.dart';
import '../../../../component/reuseable_widgets/appBar.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/custom_button.dart';
import '../../../../component/reuseable_widgets/reusebottombar.dart';
import '../cubit/moreabout/moreaboutmecubit.dart';
import '../cubit/moreabout/moreaboutmestate.dart';
import 'package:dio/dio.dart';

class MyHeight extends StatefulWidget {
  String height="";
   MyHeight({super.key, required this.height,});

  @override
  State<MyHeight> createState() => _MyHeightState();
}

class _MyHeightState extends State<MyHeight> {

  bool dist = false;

  @override
  void initState() {
    print(widget.height);
    super.initState();
  }

  void _submitDetails() {
    final formData = FormData.fromMap({
      'height': widget.height,
    });

    context.read<MoreAboutMeProfileCubit>().moreAboutMeProfile(context, formData);
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<MoreAboutMeProfileCubit, MoreAboutMeProfileState>(
        builder: (context, state) {
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
                    // Handle back button tap
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
              title: 'My Height',
              titleColor: Colors.black,
              backgroundColor: Colors.white,
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    AppText(
                        fontWeight: FontWeight.w600,
                        size: 18, maxlin: 2,
                        text: "Fill all the details which tells about you more!"
                            " will help you to find your partner."),
                    SpaceWidget(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: 'Height',
                          size: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        AppText(
                          text: dist
                              ? "${(double.parse(widget.height) / 30.48).toStringAsFixed(1)} Ft"
                              : '${widget.height} Cm',
                          size: 13.sp,
                          color: bgClr,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                    SpaceWidget(height: MediaQuery.of(context).size.height * 0.01),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Slider(
                        activeColor: AppColor.iconsColor,
                        inactiveColor: Color(0xffD3D3D3),
                        value: double.parse(widget.height),
                        max: 300,
                        min: 100,
                        // divisions: 0,
                        label:double.parse(widget.height).truncateToDouble().toString(),
                        onChanged: (double value) {
                          setState(() {
                            widget.height = value.round().toString();
                          });
                        },
                      ),
                    ),
                    SpaceWidget(height: MediaQuery.of(context).size.height * 0.2),
                    CustomButton(
                      text: 'Submit Details',
                      onPressed: _submitDetails, // Attach the method here
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      listener: (BuildContext context, MoreAboutMeProfileState state) { if(state is MoreAboutMeProfileSuccess){
      // showToast(context, state.response);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MoreAboutMe()),
      );
    } },);
  }
}
