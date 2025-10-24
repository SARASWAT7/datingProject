import 'package:demoproject/component/reuseable_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../component/apihelper/common.dart';
import '../../../../component/commonfiles/appcolor.dart';
import '../../../../component/reuseable_widgets/appbar.dart';
import '../../../../component/reuseable_widgets/apploder.dart';
import '../../../../component/reuseable_widgets/container.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/reusebottombar.dart';
import '../../../../component/reuseable_widgets/text_field.dart';
import '../../../../component/utils/custom_text.dart';
import '../cubit/updateData/updateprofilecubit.dart';
import '../cubit/updateData/updateprofilestate.dart';
import 'editProfile.dart';

class Bio extends StatefulWidget {
  const Bio({Key? key}) : super(key: key);

  @override
  State<Bio> createState() => _BioState();
}

class _BioState extends State<Bio> {
  final TextEditingController _controller = TextEditingController();
  final List<String> items = List<String>.generate(10, (i) => "Item $i");
  int? lettercount = 500;
  bool isToggled = false; // Moved isToggled inside the State class

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => UpdateProfileCubit(), // Create your UpdateProfileCubit here
      child: BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                bottomNavigationBar: BottomSteet(
                  currentIndex: 4,
                ),
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
                    title: 'Bio',
                    titleColor: Colors.black,
                    backgroundColor: Colors.white,
                    centerTitle: true,
                    showBorder: true
                ),
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 18),
                    child: Column(
                      children: [
                        SizedBox(height: 18),
                        AppText(
                          fontWeight: FontWeight.w500,
                          size: 20.0,
                          text:
                          'Write your Bio here, that will be display \n on your profile.',
                        ),
                        AppContainer(
                          height: MediaQuery.of(context).size.height * 0.060,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              AppText(
                                fontWeight: FontWeight.w400,
                                size: 14.sp,
                                text: 'Show Bio On Profile',
                              ),
                              Spacer(),
                              Switch(
                                activeColor: AppColor.tinderclr,
                                inactiveThumbColor: Colors.grey.shade300,
                                inactiveTrackColor: Colors.white,
                                value: isToggled,
                                onChanged: (value) {
                                  setState(() {
                                    isToggled = value;
                                  });
                                },
                              ),
                            ],

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 20),
                          child: CustomText(
                            weight: FontWeight.w600,
                            size: 12.sp,
                            text: "${lettercount}/ 500 Words",
                            color: bgClr,
                            fontFamily: 'Nunito Sans',
                          ).objectCenterRight(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17,top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color:AppColor.grey),
                                color: Colors.transparent),
                            child: TextField(
                              controller: _controller,
                              onChanged: (value) {
                                context.read<UpdateProfileCubit>().bio(value);
                                setState(() {
                                  lettercount = value.length;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none, hintText: 'Type here....'),
                              maxLines: 6,
                              cursorColor: AppColor.tinderclr,
                              maxLength: 500,
                            ).pOnly(left: 2.3.w, right: 2.3.w),
                          ),
                        ),
                        SpaceWidget(height: 40),
                        GestureDetector(
                            onTap: () {
                              context.read<UpdateProfileCubit>().show(
                                context,
                                _controller.text,
                                isToggled,
                                nextPage: EditProfile(), // Navigate to the next page
                              );
                            },
                            child: CustomButton(text: 'Submit')),
                      ],
                    ),
                  ),
                ),
              ),
              state?.status == ApiState.isLoading ? AppLoader() : Container()
            ],
          );
        },
      ),
    );
  }
}
