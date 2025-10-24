import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/commonfiles/icons.dart';
import 'package:demoproject/component/reuseable_widgets/apppara.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/component/reuseable_widgets/text_field.dart';
import 'package:demoproject/ui/dashboard/home/design/homeheader.dart';
import 'package:demoproject/ui/dashboard/home/design/homepreviewcont.dart';
import 'package:demoproject/ui/dashboard/home/model/homeresponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../auth/design/splash.dart';
import '../cubit/homecubit/homecubit.dart';
//
// class HomeApiData extends StatefulWidget {
//   final int index;
//   final Users? response;
//   const HomeApiData({super.key, this.index = 0, this.response});
//
//   @override
//   State<HomeApiData> createState() => _HomeApiDataState();
// }
//
// class _HomeApiDataState extends State<HomeApiData> {
//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//
//       color: AppColor.activeiconclr,
//       onRefresh: _handleRefresh,
//       child: Container(
//           height: DynamicSize.height(context) * .76,
//           width: DynamicSize.width(context),
//           alignment: Alignment.bottomLeft,
//           decoration: const BoxDecoration(
//             color: Colors.transparent,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 HomePreviewContainer(
//                   response: widget.response,
//                   index: widget.index,
//                   imageIndex: 0,
//                 ),
//                 SpaceWidget(height: DynamicSize.height(context) * .02),
//                 DescreiptionContiner(
//                   title: "Basic information",
//                   childrens: [
//                     2.h.heightBox,
//                     Row(
//                       children: [
//                         Icon(
//                           MyIconMilomi.profile,
//                           size: 22.sp,
//                           color: AppColor.iconsColor,
//                         ).pOnly(left: 2.w),
//                         2.w.widthBox,
//                         Container(
//                           constraints: BoxConstraints(maxWidth: 70.w),
//                           child: AppText(
//                               color:AppColor.black,
//                               fontWeight: FontWeight.w600,
//                               size: 16.sp,
//                               maxlin: 2,
//                               text: "${widget.response?.firstName ?? ""}"),
//                         )
//                       ],
//                     ).pOnly(left: 2.w),
//                     1.5.h.heightBox,
//                     Row(
//                       children: [
//                         Icon(
//                           MyIconMilomi.graduationcap,
//                           size: 24.sp,
//                           color: AppColor.iconsColor,
//                         ).pOnly(left: 2.w),
//                         2.w.widthBox,
//                         Container(
//                           constraints: BoxConstraints(maxWidth: 70.w),
//                           child: AppText(
//                               color:AppColor.black,
//                               fontWeight: FontWeight.w600,
//                               size: 16.sp,
//                               text: widget.response?.degree ?? ''),
//                         )
//                       ],
//                     ).pOnly(left: 2.w),
//                     1.5.h.heightBox,
//                     Row(
//                       children: [
//                         Icon(
//                           MyIconMilomi.facebook_jobs,
//                           size: 23.sp,
//                           color: AppColor.iconsColor,
//                         ).pOnly(left: 2.w),
//                         2.w.widthBox,
//                         Container(
//                           constraints: BoxConstraints(maxWidth: 70.w),
//                           child: AppText(
//                               color:AppColor.black,
//                               fontWeight: FontWeight.w600,
//                               size: 16.sp,
//                               text: widget.response?.profession ?? ""),
//                         )
//                       ],
//                     ).pOnly(left: 2.w),
//                     3.h.heightBox,
//                   ],
//                 ),
//                 SpaceWidget(height: DynamicSize.height(context) * .02),
//                 HomePreviewContainer(
//                   response: widget.response,
//                   index: widget.index,
//                   imageIndex: 1,
//                   first: false,
//                 ),
//                 SpaceWidget(height: DynamicSize.height(context) * .02),
//                 DescreiptionContiner(
//                     title: "Bio",
//                     showContainer: (widget.response?.bio?.isNotEmpty ?? false),
//                     childrens: [
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: AppPara(
//                           color:AppColor.black,
//                           fontWeight: FontWeight.w600,
//                           size: 14.sp,
//                           text: "${widget.response?.bio}",
//                         ).p(2.h).centered(),
//                       )
//                     ]),
//                 SpaceWidget(
//                     height: (widget.response?.bio?.isNotEmpty ?? false)
//                         ? DynamicSize.height(context) * .02
//                         : 0),
//
//                 HomePreviewContainer(
//                   response: widget.response,
//                   index: widget.index,
//                   imageIndex: 2,
//                   first: false,
//                 ),
//                 SpaceWidget(
//                     height: (widget.response?.media?.length ?? 0) >= (3 + 1)
//                         ? DynamicSize.height(context) * .02
//                         : 0),
//                 SpaceWidget(height: DynamicSize.height(context) * .02),
//
//                 DescreiptionContiner(title: "More About Me", childrens: [
//                   Row(
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           MoreAboutMeOptions(
//                             icons: MyIconMilomi.relationship,
//                             widthText: 30.w,
//                             title: widget.response?.relationshipStatus?? "",
//                           ),
//                           0.9.h.heightBox,
//                           MoreAboutMeOptions(
//                             icons: MyIconMilomi.astrology_1,
//                             widthText: 30.w,
//                             title: widget.response?.sunSign ?? "",
//                           ),
//                           0.9.h.heightBox,
//                           MoreAboutMeOptions(
//                             icons: MyIconMilomi.layer,
//                             widthText: 30.w,
//                             title: "${widget.response?.height?? ""} cm",
//                           ),
//                           0.9.h.heightBox,
//                           MoreAboutMeOptions(
//                             icons: MyIconMilomi.beer_mug_1,
//                             widthText: 30.w,
//                             title: widget.response?.drinking ?? "",
//                           ),
//                           0.9.h.heightBox,
//                           MoreAboutMeOptions(
//                             icons: MyIconMilomi.child_friendly_1,
//                             widthText: 30.w,
//                             title: widget.response?.haveKids ?? "",
//                           ),
//                           0.9.h.heightBox,
//                           MoreAboutMeOptions(
//                             icons: MyIconMilomi.vector_1,
//                             widthText: 30.w,
//                             title: widget.response?.politic ?? "",
//                           ),
//                           0.9.h.heightBox,
//                           // 20.sp.heightBox,
//                         ],
//                       ).pOnly(left: 3.w, right: 3.w, bottom: 1.h, top: 1.h),
//                       const Spacer(),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           MoreAboutMeOptions(
//                             icons: MyIconMilomi.hamsa,
//                             widthText: 25.w,
//                             title: widget.response?.religion ?? "",
//                           ),
//                           0.9.h.heightBox,
//                           MoreAboutMeOptions(
//                             icons: MyIconMilomi.speaker,
//                             widthText: 25.w,
//                             title:
//                                 (widget.response?.languages?.isNotEmpty ?? false)
//                                     ? (widget.response?.languages?[0] ?? "")
//                                     : "",
//                           ),
//                           0.9.h.heightBox,
//                           MoreAboutMeOptions(
//                             icons: MyIconMilomi.smoking_rooms,
//                             widthText: 25.w,
//                             title: widget.response?.smoking ?? "",
//                           ),
//                           0.9.h.heightBox,
//                           MoreAboutMeOptions(
//                             icons: MyIconMilomi.exercise__1__1,
//                             widthText: 25.w,
//                             title: widget.response?.exercise?? "",
//                           ),
//                           0.9.h.heightBox,
//                           MoreAboutMeOptions(
//                             icons: MyIconMilomi.pets_1,
//                             widthText: 25.w,
//                             title: widget.response?.pet ?? "",
//                           ),
//                           0.9.h.heightBox,
//                           20.sp.heightBox,
//                         ],
//                       ).pOnly(left: 3.w, right: 3.w, bottom: 1.h, top: 1.h),
//                     ],
//                   )
//                 ]),
//                 SpaceWidget(height: DynamicSize.height(context) * .02),
//                 HomePreviewContainer(
//                   response: widget.response,
//                   index: widget.index,
//                   imageIndex: 3,
//                   first: false,
//                 ),
//                 SpaceWidget(
//                     height: (widget.response?.media?.length ?? 0) >= (3 + 1)
//                         ? DynamicSize.height(context) * .02
//                         : 0),
//                 DescreiptionContiner(
//                     title: "Quote",
//                     showContainer: (widget.response?.quote ?? "").isNotEmpty,
//                     childrens: [
//                       Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(17),
//                             border: Border.all(color: whitecolor)
//
//                             ),
//                         child: Stack(
//                           children: [
//                             Container(
//                               height: 5.h,
//                               width: 5.h,
//                               padding: EdgeInsets.all(1.h),
//                               decoration: BoxDecoration(
//                                 // color: Colors.white,
//                                 border: Border.all(
//                                     color: const Color(0xffFC1572), width: .5),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Image.asset(
//                                 "assets/images/kuchto.png",
//                                 fit: BoxFit.contain,
//                                 color: AppColor.tinderclr,
//                               ),
//                             ).pOnly(left: 2.w, top: 1.h),
//                             5.w.widthBox,
//                             Container(
//                               constraints: BoxConstraints(maxWidth: 60.w),
//                               child: AppPara(
//                                   color: whitecolor,
//                                   fontWeight: FontWeight.w600,
//                                   size: 14.sp,
//                                   text: widget.response?.quote ?? ""),
//                             ).pOnly(top: 3.h, left: 14.w, bottom: 2.h, right: 2.h)
//                           ],
//                         ),
//                       ).pOnly(top: 2.w, bottom: 2.w).centered(),
//                     ]),
//                 SpaceWidget(height: DynamicSize.height(context) * .02),
//
//
//                 (widget.response?.media?.length ?? 0) > 4
//                     ? ListView.builder(
//                         padding: EdgeInsets.zero,
//                         physics: const NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: (widget.response?.media?.length ?? 0) - 3,
//                         itemBuilder: (context, index) {
//                           return HomePreviewContainer(
//                             response: widget.response,
//                             index: widget.index,
//                             imageIndex: index + 3,
//                             first: false,
//                           ).pOnly(bottom: DynamicSize.height(context) * .02);
//                         },
//                       )
//                     : SpaceWidget()
//               ],
//             ),
//           )).pOnly(left: 3.w, right: 3.w),
//     );
//   }
//   Future<void> _handleRefresh() async {
//     setState(() {
//       context.read<HomePageCubit>().likeSidlike(
//         context,
//         widget.response?.sId ?? "",
//         'dislike',
//         token,
//         widget.response?.firstName ?? "",
//       );
//     });
//     await Future.delayed(const Duration(seconds: 2));
//   }
// }



import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/commonfiles/icons.dart';
import 'package:demoproject/component/reuseable_widgets/apppara.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/component/reuseable_widgets/text_field.dart';
import 'package:demoproject/ui/dashboard/home/design/homeheader.dart';
import 'package:demoproject/ui/dashboard/home/design/homepreviewcont.dart';
import 'package:demoproject/ui/dashboard/home/model/homeresponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../auth/design/splash.dart';
import '../cubit/homecubit/homecubit.dart';

class HomeApiData extends StatefulWidget {
  final int index;
  final Users? response;
  const HomeApiData({super.key, this.index = 0, this.response});

  @override
  State<HomeApiData> createState() => _HomeApiDataState();
}

class _HomeApiDataState extends State<HomeApiData> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColor.activeiconclr,
      onRefresh: _handleRefresh,
      child:
      Container(
          height: DynamicSize.height(context) * .76,
          width: DynamicSize.width(context),
          alignment: Alignment.bottomLeft,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                HomePreviewContainer(
                  response: widget.response,
                  index: widget.index,
                  imageIndex: 0,
                ),
                SpaceWidget(height: DynamicSize.height(context) * .02),
                DescreiptionContiner(
                  title: "Basic information",
                  childrens: [
                    2.h.heightBox,
                    Row(
                      children: [
                        Icon(
                          MyIconMilomi.profile,
                          size: 20.sp,
                          color: AppColor.iconsColor,
                        ).pOnly(left: 2.w),
                        2.w.widthBox,
                        Container(
                          constraints: BoxConstraints(maxWidth: 70.w),
                          child: AppText(
                              color:AppColor.black,
                              fontWeight: FontWeight.w600,
                              size: 16.sp,
                              maxlin: 2,
                              text: "${widget.response?.firstName ?? ""} ${widget.response?.lastName??""}"),
                        )
                      ],
                    ).pOnly(left: 2.w),
                    1.5.h.heightBox,

                    Row(
                      children: [
                        Icon(
                          MyIconMilomi.graduationcap,
                          size: 20.sp,
                          color: AppColor.iconsColor,
                        ).pOnly(left: 2.w),
                        2.w.widthBox,
                        Container(
                          constraints: BoxConstraints(maxWidth: 70.w),
                          child: AppText(
                              color:AppColor.black,
                              fontWeight: FontWeight.w600,
                              size: 16.sp,
                              text: widget.response?.degree ?? ''),
                        )
                      ],
                    ).pOnly(left: 2.w),
                    1.5.h.heightBox,
                    Row(
                      children: [
                        Icon(
                          MyIconMilomi.facebook_jobs,
                          size: 20.sp,
                          color: AppColor.iconsColor,
                        ).pOnly(left: 2.w),
                        2.w.widthBox,
                        Container(
                          constraints: BoxConstraints(maxWidth: 70.w),
                          child: AppText(
                              color:AppColor.black,
                              fontWeight: FontWeight.w600,
                              size: 16.sp,
                              text: widget.response?.profession ?? ""),
                        )
                      ],
                    ).pOnly(left: 2.w),
                    3.h.heightBox,
                  ],
                ),

                SpaceWidget(height: DynamicSize.height(context) * .02),
                DescreiptionContiner(
                    title: "Bio",
                    showContainer: (widget.response?.bio?.isNotEmpty ?? false),
                    childrens: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: AppPara(
                          color:AppColor.black,
                          fontWeight: FontWeight.w600,
                          size: 16.sp,
                          text: "${widget.response?.bio}",
                        ).p(2.h).centered(),
                      )
                    ]),
                SpaceWidget(
                    height: (widget.response?.bio?.isNotEmpty ?? false)
                        ? DynamicSize.height(context) * .02
                        : 0),


                DescreiptionContiner(title: "More About Me", childrens: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset("assets/images/gender.png",color: AppColor.activeiconclr,height: 35,width: 35,),
                    2.w.widthBox,
                    AppText(
                        textAlign: TextAlign.center,
                        color:AppColor.black,
                        fontWeight: FontWeight.w600,
                        size: 16.sp,
                        text: widget.response?.gender?? "" )
                  ],
                ),
                          0.7.h.heightBox,

                          MoreAboutMeOptions(
                            icons: MyIconMilomi.relationship,
                            widthText: 25.w,
                            title: widget.response?.relationshipStatus?? "",
                          ),
                          0.9.h.heightBox,
                          MoreAboutMeOptions(
                            icons: MyIconMilomi.astrology_1,
                            widthText: 25.w,
                            title: widget.response?.sunSign ?? "",
                          ),
                          0.9.h.heightBox,
                          MoreAboutMeOptions(
                            icons: MyIconMilomi.layer,
                            widthText: 25.w,
                            title: "${widget.response?.height?? ""} cm",
                          ),
                          0.9.h.heightBox,
                          MoreAboutMeOptions(
                            icons: MyIconMilomi.beer_mug_1,
                            widthText: 25.w,
                            title: widget.response?.drinking ?? "",
                          ),
                          0.9.h.heightBox,
                          MoreAboutMeOptions(
                            icons: MyIconMilomi.child_friendly_1,
                            widthText: 25.w,
                            title: widget.response?.haveKids ?? "",
                          ),
                          0.9.h.heightBox,
                          MoreAboutMeOptions(
                            icons: MyIconMilomi.vector_1,
                            widthText: 25.w,
                            title: widget.response?.politic ?? "",
                          ),
                          0.9.h.heightBox,
                          // 20.sp.heightBox,
                        ],
                      ).pOnly(left: 3.w, right: 3.w, bottom: 1.h, top: 1.h),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MoreAboutMeOptions(
                            icons: MyIconMilomi.hamsa,
                            widthText: 25.w,
                            title: widget.response?.religion ?? "",
                          ),
                          0.9.h.heightBox,
                          MoreAboutMeOptions(
                            icons: MyIconMilomi.speaker,
                            widthText: 25.w,
                            title:
                            (widget.response?.languages?.isNotEmpty ?? false)
                                ? (widget.response?.languages?[0] ?? "")
                                : "",
                          ),
                          0.9.h.heightBox,
                          MoreAboutMeOptions(
                            icons: MyIconMilomi.smoking_rooms,
                            widthText: 25.w,
                            title: widget.response?.smoking ?? "",
                          ),
                          0.9.h.heightBox,
                          MoreAboutMeOptions(
                            icons: MyIconMilomi.exercise__1__1,
                            widthText: 25.w,
                            title: widget.response?.exercise?? "",
                          ),
                          0.9.h.heightBox,
                          MoreAboutMeOptions(
                            icons: MyIconMilomi.pets_1,
                            widthText: 25.w,
                            title: widget.response?.pet ?? "",
                          ),
                          0.9.h.heightBox,

                          20.sp.heightBox,
                        ],
                      ).pOnly(left: 3.w, right: 3.w, bottom: 1.h, top: 1.h),
                    ],
                  )
                ]),
                SpaceWidget(height: DynamicSize.height(context) * .02),

                DescreiptionContiner(
                    title: "Quote",
                    showContainer: (widget.response?.quote ?? "").isNotEmpty,
                    childrens: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: whitecolor)

                        ),
                        child: Stack(
                          children: [
                            Container(
                              height: 5.h,
                              width: 5.h,
                              padding: EdgeInsets.all(1.h),
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                border: Border.all(
                                    color: const Color(0xffFC1572), width: .5),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/images/kuchto.png",
                                fit: BoxFit.contain,
                                color: AppColor.tinderclr,
                              ),
                            ).pOnly(left: 2.w, top: 1.h),
                            5.w.widthBox,
                            Container(
                              constraints: BoxConstraints(maxWidth: 60.w),
                              child: AppPara(
                                  color:AppColor.black,
                                  fontWeight: FontWeight.w600,
                                  size: 14.sp,
                                  text: widget.response?.quote ?? ""),
                            ).pOnly(top: 3.h, left: 14.w, bottom: 2.h, right: 2.h)
                          ],
                        ),
                      ).pOnly(top: 2.w, bottom: 2.w).centered(),
                    ]),
                SpaceWidget(height: DynamicSize.height(context) * .02),

              ],
            ),
          )).pOnly(left: 3.w, right: 3.w),
    );
  }
  Future<void> _handleRefresh() async {
    setState(() {
      context.read<HomePageCubit>().likeSidlike(
        context,
        widget.response?.id ?? "",
        'dislike',
        token,
        widget.response?.firstName ?? "",
      );
    });
    await Future.delayed( Duration(seconds: 2));
  }
}
