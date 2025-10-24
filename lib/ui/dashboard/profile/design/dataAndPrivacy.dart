import 'package:demoproject/component/alert_box.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/dataprivacy/dataprivacycubit.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/dataprivacy/dataprivacystate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class DataPrivacyPage extends StatefulWidget {
  const DataPrivacyPage({super.key});

  @override
  State<DataPrivacyPage> createState() => _DataPrivacyPageState();
}

class _DataPrivacyPageState extends State<DataPrivacyPage> {
  @override
  void initState() {
    BlocProvider.of<DataprivacyCubit>(context).getDataPrivacy(context);
    super.initState();
  }

  int index = 0;

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: AppText(
            size: 16.sp, text: 'Privacy policy', fontWeight: FontWeight.w600),
      ),
      body: BlocBuilder<DataprivacyCubit, DataprivacyState>(
        builder: (context, state) {
          if (state.status == ApiStates.loading) {
            return AppLoader();
          } else if (state.status == ApiStates.error) {
            return Align(
              alignment: Alignment.center,
              child: AppText(
                // color: whitecolor,
                fontWeight: FontWeight.w400,
                size: 14.sp,
                text: 'No Data',
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 85.w,
                  // color: Colors.grey[100],
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[100],
                      border: Border.all(color: const Color(0xff555555))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        AppText(
                                fontWeight: FontWeight.bold,
                                size: 14,
                                text: _parseHtmlString(
                                    state.response?.result?[0].title ??
                                        ''.replaceAll("<br>", "\n")))
                            .objectTopLeft()
                            .pOnly(left: 14),
                        const Divider(
                          color: Color(0xff000000),
                          height: 2,
                        ).pOnly(top: 10),
                        // HeightBox(1.h),
                        Html(
                          data: state.response?.result?[0].description ?? '',
                          style: {
                            'p': Style(
                              color: blackColor,
                            ),
                            'h1': Style(
                              color: blackColor,
                            ),
                            'h2': Style(
                              color: blackColor,
                            ),
                            'h3': Style(
                              color: blackColor,
                            ),
                            'h4': Style(
                              color: blackColor,
                            ),
                            'h5': Style(
                              color: blackColor,
                            ),
                            'h6': Style(
                              color: blackColor,
                            ),
                          },
                        )

                            /* AppPara(
                                  text: _parseHtmlString(state
                                      .yourLikeResponse.result!.description
                                      .toString()
                                      .replaceAll("<br>", "\n")),
                                  fontWeight: FontWeight.w300,
                                  size: 12.sp,
                                ) */
                            .objectTopLeft()
                            .pOnly(left: 2.w, right: 2.w, bottom: 2.w),
                      ],
                    ),
                  ),
                ).objectTopCenter().pOnly(top: 2.h),
                3.h.heightBox
              ],
            ),
          );
        },
      ),
    );
  }
}
