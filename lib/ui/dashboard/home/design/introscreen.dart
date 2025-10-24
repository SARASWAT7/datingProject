import 'package:demoproject/component/apihelper/toster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../component/commonfiles/appcolor.dart';
import '../../../../component/commonfiles/shared_preferences.dart';
import '../../../../component/reuseable_widgets/appText.dart';
import '../../../../component/reuseable_widgets/apploder.dart';
import '../../../../component/reuseable_widgets/bottomTabBar.dart';
import '../../../auth/design/splash.dart';
import '../cubit/Introduce/intropagecubit.dart';
import '../cubit/Introduce/intropagestate.dart';
import '../cubit/homecubit/homecubit.dart';
import '../repository/homerepository.dart';

class IntroBottomSheet extends StatefulWidget {
  final String userId;
  final String profilePicture;
  final String firstName;

  const IntroBottomSheet({
    Key? key,
    required this.userId,
    required this.profilePicture,
    required this.firstName,
  }) : super(key: key);

  @override
  _IntroBottomSheetState createState() => _IntroBottomSheetState();
}

class _IntroBottomSheetState extends State<IntroBottomSheet> {
  final TextEditingController msgController = TextEditingController();

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom; // Get keyboard height

    return WillPopScope(
      onWillPop: () async {
        // Show Bottom Bar when user attempts to dismiss the bottom sheet
        await BottomBar();
        return true;
      },
      child: GestureDetector(
        onTap: () {
          BottomBar();
          Navigator.of(context).pop(); // Close the bottom sheet on tapping outside
        },
        behavior: HitTestBehavior.opaque,
        child: BlocProvider(
          create: (context) => IntroAddCubit(HomeRepository()),
          child: BlocConsumer<IntroAddCubit, IntroStateState>(
            listener: (context, state) {
              if (state is IntroStateSuccess) {
                print("Introduction successfully sent!");
                msgController.clear();
                BottomBar(); // Show Bottom Bar after success
                showToast(context, "Intro sent successfully");
                Navigator.of(context).pop();
              } else if (state is IntroStateError) {
                print("Error: ${state.message}");
                showToast(context, "Failed to send intro: ${state.message}");
              }
            },
            builder: (context, state) {
              return GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.35,
                    minChildSize: 0.3,
                    expand: true,
                    maxChildSize: 0.6,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColor.tinderclr, // Background color
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20),
                              AppText(
                                fontWeight: FontWeight.w700,
                                size: 16.sp,
                                text: "Introduce yourself!",
                              ),
                              SizedBox(height: 10),
                              AppText(
                                fontWeight: FontWeight.w600,
                                size: 12.sp,
                                color: Colors.white,
                                text: "Type something to introduce yourself",
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 10.h,
                                width: 10.h,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 2),
                                  shape: BoxShape.circle,
                                  image: widget.profilePicture.isEmpty
                                      ? const DecorationImage(
                                    image: AssetImage("assets/nopicdummy.png"),
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.fill,
                                  )
                                      : DecorationImage(
                                    image: NetworkImage(widget.profilePicture),
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: TextField(
                                          cursorColor: AppColor.tinderclr,
                                          minLines: 1,
                                          maxLines: 5,
                                          controller: msgController,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                width: 1,
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                width: 1,
                                                color: Color(0xFFE4DFDF),
                                              ),
                                            ),
                                            errorBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(width: 1),
                                            ),
                                            focusColor: Colors.black,
                                            contentPadding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 10,
                                            ),
                                            hintText: "Send Intro.......",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      height: 5.5.h,
                                      width: 5.5.h,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: (state is IntroStateLoading)
                                          ? SizedBox(
                                        height: 2.h,
                                        width: 2.h,
                                        child: AppLoader(),
                                      )
                                          : IconButton(
                                        icon: const Icon(
                                          Icons.send,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          String message = msgController.text.trim();
                                          if (message.isNotEmpty) {
                                            // Pass the message to the Cubit
                                            BlocProvider.of<IntroAddCubit>(context).getIntroState(
                                              widget.userId,
                                              message,
                                            );

                                            // Clear the message from the text field
                                            msgController.clear();

                                            // Hide the keyboard
                                            AppUtils.keyboardHide(context);
                                          } else {
                                            print("Message cannot be empty");
                                            showToast(context, "Message cannot be empty");
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
