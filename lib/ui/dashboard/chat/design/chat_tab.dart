import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/ui/dashboard/chat/cubit/cubit/chatcubit.dart';
import 'package:demoproject/ui/dashboard/chat/cubit/cubit/chatstate.dart';
import 'package:demoproject/ui/dashboard/chat/design/allchat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  @override
  void initState() {
    context.read<ChatCubit>().getUserToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return SafeArea(
            child: SizedBox(
              width: DynamicSize.width(context),
              height: DynamicSize.height(context),
              child: Column(
                children: [
                  // SpaceWidget(height: DynamicSize.height(context) * 0.06),
                  SizedBox(
                    width: DynamicSize.width(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: state.selectedIndex == 0
                                  ? Colors.transparent
                                  : Colors.grey,
                              width: .5.w,
                            ),

                            gradient: state.selectedIndex == 0
                                ? LinearGradient(
                                    colors: [
                                      AppColor.tinderclr,
                                      AppColor.activeiconclr,
                                    ],
                                  )
                                : LinearGradient(
                                    colors: [whitecolor, whitecolor],
                                  ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 6.h,
                          width: 80.w,
                          child: AppText(
                            color: state.selectedIndex == 0
                                ? whitecolor
                                : Colors.black,
                            fontWeight: FontWeight.w600,
                            size: 14.sp,
                            text: "All Chats",
                          ).centered(),
                        ).onTap(() {
                          context.read<ChatCubit>().updateIndex(0);
                        }),
                      ],
                    ),
                  ),

                  Spacer(),
                  state.selectedIndex == 0
                      ? const AllChatScreen()
                      : state.selectedIndex == 1
                      ? Container()
                      : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
