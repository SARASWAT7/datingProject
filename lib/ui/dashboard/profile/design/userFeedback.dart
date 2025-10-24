import 'package:demoproject/ui/dashboard/profile/cubit/feedback/feedbackcubit.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/feedback/feedbackstate.dart';
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

class UserFeedback extends StatefulWidget {
  const UserFeedback({super.key});

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  final TextEditingController _controller = TextEditingController();
  int? lettercount = 500;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedbackCubit(),
      child: BlocBuilder<FeedbackCubit, FeedbackState>(
        builder: (context, state) {
          return Scaffold(
            // bottomNavigationBar: const BottomSteet(
            //   currentIndex: 4,
            // ),
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
              title: 'Feedback',
              titleColor: Colors.black,
              backgroundColor: Colors.white,
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w500,
                        size: 22.0,
                        text: 'Share Your Feedback',
                      ).pOnly(left: 2.w),
                      SizedBox(height: 2.h), // Use SizedBox instead of Padding for spacing
                      Align(
                        alignment: Alignment.centerRight,
                        child: GradientText(
                          '500 Words',
                          gradient: LinearGradient(
                            colors: [
                              AppColor.firstmainColor,
                              AppColor.darkmainColor,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Nunito Sans',
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      AppContainer(
                        height: 20.h, // Use a fraction of screen height instead of fixed height
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            maxLines: 8,
                            controller: _controller,
                            cursorHeight: 20,
                            cursorColor: Colors.black,
                            textAlignVertical: TextAlignVertical.top,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Nunito Sans',
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type here...',
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Nunito Sans',
                                color: Colors.black,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<FeedbackCubit>()
                                .feedback(context, _controller.text);
                          },
                          child: CustomButton(text: 'Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
