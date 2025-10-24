import 'package:demoproject/ui/dashboard/profile/cubit/contactus/contactuscubit.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/contactus/contactusstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../component/commonfiles/appcolor.dart';
import '../../../../component/reuseable_widgets/appbar.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/container.dart';
import '../../../../component/reuseable_widgets/custom_button.dart';
import '../../../../component/reuseable_widgets/reusebottombar.dart';
import '../../../../component/reuseable_widgets/text_field.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final TextEditingController _controller = TextEditingController();
  TextEditingController contactusFor = TextEditingController();
  var _dropDownValue3;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      contactusFor.text = "1";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactUsCubit(),
      child: BlocBuilder<ContactUsCubit, ContactUsState>(
        builder: (context, state) {
          return Scaffold(
            // bottomNavigationBar: BottomSteet(
            //   currentIndex: 4,
            // ),
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
              title: 'ContactUs',
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
                    SizedBox(height: 18),
                    Container(
                        height: 7.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0xffFFFFFF),
                                  const Color(0xffFFFFFF)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                            border: Border.all(
                                color: bgClr.withOpacity(0.5), width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButton(
                          underline: const SizedBox(),
                          hint: _dropDownValue3 == null
                              ? AppText(
                                  fontWeight: FontWeight.w600,
                                  size: 12.sp,
                                  text: "Ask a general question")
                              : AppText(
                                  fontWeight: FontWeight.w600,
                                  size: 12.sp,
                                  text: _dropDownValue3),
                          isExpanded: true,
                          iconSize: 30.0,
                          icon: const Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Colors.black,
                          ),
                          iconDisabledColor: Colors.black,
                          iconEnabledColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          items: [
                            "Ask a general question",
                            "Report a Safety concern",
                            "Report a technical issue",
                            "Help with Payment"
                          ].map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            setState(
                              () {
                                if (val == "Ask a general question") {
                                  contactusFor.text = "1";
                                } else if (val == "Report a Safety concern") {
                                  contactusFor.text = "2";
                                } else if (val ==
                                    "Report a technical issue") {
                                  contactusFor.text = "3";
                                } else if (val == "Help with Payment") {
                                  contactusFor.text = "4";
                                }

                                _dropDownValue3 = val;
                              },
                            );
                          },
                        ).pSymmetric(h: 15).pOnly(top: 1.h)),
                    3.h.heightBox,
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 270.0, top: 10),
                    //   child: GradientText('500 Words',
                    //       gradient: LinearGradient(
                    //         colors: [
                    //           AppColor.firstmainColor,
                    //           AppColor.darkmainColor,
                    //         ],
                    //         begin: Alignment.topCenter,
                    //         end: Alignment.bottomCenter,
                    //       ),
                    //       style: const TextStyle(
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.w600,
                    //           fontFamily: 'Nunito Sans')),
                    // ),
                    AppContainer(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          maxLines: 8,
                          cursorHeight: 20,
                          cursorColor: Colors.black,
                          textAlignVertical: TextAlignVertical.top,
                          controller: _controller,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Nunito Sans',
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Type here...',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Nunito Sans',
                              color: Colors.black,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            border: InputBorder.none,
                            isDense:
                                true, // Ensures the TextField height is as small as possible
                          ),
                        ),
                      ),
                    ),
                    SpaceWidget(height: 40),
                    GestureDetector(
                        onTap: () {
                          context
                              .read<ContactUsCubit>()
                              .contactus(context, _controller.text.toString());
                        },
                        child: const CustomButton(text: 'Submit')),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  GradientText(
    this.text, {
    required this.gradient,
    required this.style,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}
