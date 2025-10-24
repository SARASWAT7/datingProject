import 'package:demoproject/component/alert_box.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/component/reuseable_widgets/apppara.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/Faq/faqcubit.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/Faq/faqstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:html/parser.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqPageState();
}

class _FaqPageState extends State<Faq> {
  @override
  void initState() {
    BlocProvider.of<FaqCubit>(context).getFaq(context);
    super.initState();
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: AppText(size: 16.sp, text: 'FAQ', fontWeight: FontWeight.w600),
      ),
      body: BlocBuilder<FaqCubit, FaqState>(
        builder: (context, state) {
          if (state.status == ApiStates.loading) {
            return AppLoader();
          }
          return SizedBox(
              height: 100.h,
              width: 100.w,
              child: ListView.builder(
                  itemCount: state.response?.result?.length,
                  itemBuilder: (_, i) {
                    return Container(
                      width: 89.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: blackColor.withOpacity(0.4), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 9,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AppText(
                                  textAlign: TextAlign.start,
                                  maxlin: 2,
                                  fontWeight: FontWeight.w500,
                                  size: 12.sp,
                                  text: state.response?.result?[i].question ??
                                      "",
                                ).pSymmetric(h:3.w), // Add horizontal padding here
                              ),
                              Image.asset(
                                'assets/images/plus.png',
                                width: 34,
                                height: 34,
                              ).onTap(() {
                                if (selectedIndex == i) {
                                  setState(() {
                                    selectedIndex = -1;
                                  });
                                } else {
                                  setState(() {
                                    selectedIndex = i;
                                  });
                                }
                              }),
                            ],
                          ).pOnly(top: 2.h, bottom: 2.h,right: 8),
                          selectedIndex == i
                              ? SizedBox(
                            width: 89.w,
                            child: Column(
                              children: [
                                const Divider(),
                                AppPara(
                                    color: blackColor,
                                    fontWeight: FontWeight.w500,
                                    size: 12.sp,
                                    text: _parseHtmlString(state
                                        .response
                                        ?.result?[i]
                                        .answer
                                        .toString()
                                        .replaceAll("<br>", "\n") ??
                                        ""))
                                    .pSymmetric(
                                    h: 3.w, // Add horizontal padding here
                                    v: 1.h), // Add vertical padding here
                              ],
                            ),
                          )
                              : Container()
                        ],
                      ),
                    ).pOnly(top: 2.h, left: 7.w, right: 7.w);
                  }).pOnly(top: 2.h));
        },
      ),
    );
  }
}
