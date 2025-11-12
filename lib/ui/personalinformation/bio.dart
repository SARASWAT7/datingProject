import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/ui/auth/cubit/updatedata/updatedatacubit.dart';
import 'package:demoproject/ui/auth/cubit/updatedata/updatedatastate.dart';
import 'package:demoproject/component/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../component/commonfiles/appcolor.dart';
import '../../component/reuseable_widgets/custom_button.dart';

import '../../component/utils/headerwidget.dart';

class BioScreen extends StatefulWidget {
  const BioScreen({Key? key}) : super(key: key);

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {
  final List<String> items = List<String>.generate(10, (i) => "Item $i");
  int? lettercount = 500;

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
          child: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    HeaderWidget(title: 'Bio', progress: 0.70, onTap: () {}),
                    Padding(
                      padding: const EdgeInsets.only(left: 17, right: 17),
                      child: CustomText(
                        size: 15.sp,
                        text: 'Write something about you to display on your profile.',
                        color: subhead, weight: FontWeight.w600,
                        fontFamily: 'Nunito Sans',
                      ),
                    ),
                    3.h.heightBox,
                    Padding(
                      padding: const EdgeInsets.only(left: 17, right: 20),
                      child: CustomText(
                        weight: FontWeight.w600,
                        size: 15.sp,
                        text: "${lettercount}/ 500 Words",
                        color: bgClr,
                        fontFamily: 'Nunito Sans',
                      ).objectCenterRight(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 17, right: 17,top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xffBDBDBD)),
                            color: Colors.transparent),
                        child: TextField(
                          cursorColor: AppColor.tinderclr,
                          //controller: controller,
                          inputFormatters: const [],
                          onChanged: (value) {
                             context.read<UpdateDataCubit>().bio(value);
                            setState(() {
                              lettercount = 00 + value.length;
                            });
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Type here....'),
                          maxLines: 6,
                          maxLength: 500,
                        ).pOnly(left: 2.3.w, right: 2.3.w),
                      ),
                    ),
                    7.h.heightBox,
                    GestureDetector(
                      onTap: () {
                      context.read<UpdateDataCubit>().updatedata(context);
                      },
                      child: CustomButton(
                        text: 'Continue',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      state.status == ApiState.isLoading ? AppLoader() : Container()

      ],
    );
    },
      ),
    );
  }
}


