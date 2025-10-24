import 'dart:async';
import 'dart:developer';

import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../component/apihelper/common.dart';
import '../../component/reuseable_widgets/apploder.dart';
import '../../component/reuseable_widgets/custom_button.dart';
import 'cubit/verifiyOtpWithphone/verifyotpwithphonecubit.dart';
import 'cubit/verifiyOtpWithphone/verifyotpwithphonestate.dart';

class VerifyScreen extends StatefulWidget {
  final String phoneNUmber;
  final String code;
  final String Email;
  final String  latitude;
  final String deviceType;
  final String  longitute;
  final String deviceToken;

  const VerifyScreen({super.key,
    required this.code,
    this.phoneNUmber = "",
    this.Email="",
    required this.deviceType,
    required this. longitute,
    required this.latitude,
    required this.deviceToken
  });

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  String otp = "";
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyOtpWithPhoneCubit(),
      child: BlocConsumer<VerifyOtpWithPhoneCubit, VerifyOtpWithPhoneState>(


        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                body: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Image.asset('assets/images/backarrow.png',
                              width: 30, height: 30)),
                      const SizedBox(height: 25),
                      CustomText(
                        size: 22,
                        text: 'Verify It’s You!',
                        color: const Color(0xff1B1B1B),
                        weight: FontWeight.w700,
                        fontFamily: 'Nunito Sans',
                      ),
                      const SizedBox(height: 7),
                      CustomText(
                        size: 17,
                        text:
                            'Enter four digit code sent to you at \n${widget.code}-${widget.phoneNUmber} ${widget.Email}',
                        color: const Color(0xff555555),
                        weight: FontWeight.w600,
                        fontFamily: 'Nunito Sans',
                      ),
                      const SizedBox(height:60),
                      PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                        length: 4,
                        blinkWhenObscuring: true,
                        animationType: AnimationType.scale,
                        validator: (v) {
                          if (v!.length < 3) {
                            return "";
                          } else {
                            return null;
                          }
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(16),
                          fieldWidth: 45,
                          borderWidth: 1,
                          activeColor: AppColor.iconsColor,
                          selectedColor: pincodecolor,
                          inactiveColor: AppColor.white,
                          disabledColor: pincodecolor,
                          activeFillColor: pincodecolor,
                          selectedFillColor: pincodecolor,
                          inactiveFillColor: pincodecolor,

                        ),
                        cursorColor: bgClr,
                        boxShadows: kElevationToShadow[10],
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,
                        errorAnimationController: errorController,
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        onCompleted: (v) {},
                        onChanged: (value) {
                          // print(value);
                          context.read<VerifyOtpWithPhoneCubit>().opt(value);
                        },
                      ).pOnly(left: 20.w, right: 20.w),
                      const SizedBox(height: 40),
                      Center(
                          child: GestureDetector(
                              onTap: () {
                                context
                                    .read<VerifyOtpWithPhoneCubit>()
                                    .verifyotpwithphone(
                                        context,widget.code,
                                    widget.phoneNUmber,widget.Email);
                              },
                              child: const CustomButton(text: 'Continue'))),
                      const SizedBox(height: 40).onTap(() {}),
                      Center(
                          child: GestureDetector(
                              onTap: () {
                                context
                                    .read<VerifyOtpWithPhoneCubit>()
                                    .resend(context,widget.code, widget.phoneNUmber,widget.longitute,widget.latitude,widget.deviceType,widget.deviceToken,);
                              },
                              child: const Text('Didn’t receive?'
                              ,
                              style: TextStyle(
                                fontSize: 16,
                              ),))),
                    ],
                  ),
                ),
              ),
              state.status == ApiState.isLoading ? AppLoader() : Container()
            ],
          );
        }, listener: (BuildContext context, VerifyOtpWithPhoneState state) {

      },
      ),
    );
  }
}
