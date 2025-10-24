import 'dart:async';
import 'dart:ui';
import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:demoproject/component/apihelper/advanced_performance_optimizer.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/component/reuseable_widgets/text_field.dart';
import 'package:demoproject/component/utils/chatpopup.dart';
import 'package:demoproject/ui/dashboard/home/cubit/homecubit/homecubit.dart';
import 'package:demoproject/ui/dashboard/home/model/homeresponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/design/splash.dart';
import '../../../match/agree.dart';
import 'introscreen.dart';


class HomePreviewContainer extends StatefulWidget {
  final Users? response;
  final int imageIndex;
  final bool first;

  HomePreviewContainer({
    super.key,
    this.response,
    this.first = true,
    required this.imageIndex, required int index,
  });

  @override
  _HomePreviewContainerState createState() => _HomePreviewContainerState();
}

class _HomePreviewContainerState extends State<HomePreviewContainer> {
  late PageController _pageController;
  late Timer _timer;
  String token = "";

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: widget.imageIndex
    );
    _currentPage = widget.imageIndex;
    _startAutoSlide();
    _preloadImages();
    _getToken();
  }

  Future<void> _getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        token = prefs.getString('token') ?? "";
      });
      print("Token retrieved: ${token.isNotEmpty ? 'Present' : 'Missing'}");
    } catch (e) {
      print("Error retrieving token: $e");
    }
  }

  void _preloadImages() {
    final mediaList = widget.response?.media ?? [];
    if (mediaList.isNotEmpty) {
      // Use advanced performance optimizer for ultra-fast preloading
      AdvancedPerformanceOptimizer.preloadImagesBatch(mediaList);
    }
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < (widget.response?.media?.length ?? 0) - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _stopAutoSlide();
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _stopAutoSlide() {
    _timer.cancel();
  }



  @override
  Widget build(BuildContext context) {
    final mediaLength = widget.response?.media?.length ?? 0;

    return GestureDetector(
      onTapDown: (_) => _stopAutoSlide(),
      onTapCancel: _startAutoSlide,
      onTapUp: (_) => _startAutoSlide(),
      onPanDown: (_) => _stopAutoSlide(),
      onPanEnd: (_) => _startAutoSlide(),
      child: SizedBox(
        height: 70.h,
        width: MediaQuery.of(context).size.width,
        child: mediaLength > 0
            ? Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: mediaLength,
              physics: const ClampingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  height: 70.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: AdvancedPerformanceOptimizer.buildUltraFastImage(
                    imageUrl: widget.response?.media?[index] ?? "",
                    width: MediaQuery.of(context).size.width,
                    height: 70.h,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(30),
                  ),
                );
              },
            ),
            if (mediaLength > 1)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      mediaLength,
                          (i) => _buildIndicator(i == _currentPage),
                    ),
                  ),
                ),
              ),
            Column(
              children: [
                widget.first == false
                    ? SpaceWidget()
                    : Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: (){
                          CustomNavigator.push(context: context, screen: AgreeScreen(
                            UserName:widget.response!.firstName??"",
                            UserImg:widget.response!.profilePicture??"",
                            userId: widget.response?.id ?? "",
                          ));
                        },
                        child: Container(
                          height: 5.h,
                          width: 5.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: AppText(
                              maxlin: 1,
                              fontWeight: FontWeight.w600,
                              size: 13.sp,
                              text: "${widget.response!.questionAnswerPercentage?.toStringAsFixed(1) ?? '0.0'}% ",
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton(
                      elevation: 1,
                      padding: EdgeInsets.zero,
                      color: AppColor.tinderclr,
                      icon: Icon(
                        Icons.more_vert,
                        color: whitecolor,
                        size: 20.sp,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      itemBuilder: (_) => <PopupMenuItem<String>>[
                        PopupMenuItem<String>(
                          value: 'report',
                          child: Column(
                            children: [
                              2.h.heightBox,
                              AppText(
                                fontWeight: FontWeight.w400,
                                size: 2.h,
                                color: Colors.white,
                                text: "Report User",
                              ).centered(),
                              1.h.heightBox,
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'block',
                          child: Column(
                            children: [
                              const Divider(color: Colors.white),
                              2.h.heightBox,
                              AppText(
                                fontWeight: FontWeight.w400,
                                size: 2.h,
                                color: Colors.white,
                                text: "Block User",
                              ),
                              1.h.heightBox,
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'spam',
                          child: Column(
                            children: [
                              const Divider(color: Colors.white),
                              2.h.heightBox,
                              AppText(
                                fontWeight: FontWeight.w400,
                                size: 2.h,
                                color: Colors.white,
                                text: "Spam User",
                              ),
                              1.h.heightBox,
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'report') {
                          showDialog(
                            context: context,
                            builder: (_) => ReportBox(
                              title:
                              widget.response?.firstName ?? "",
                              userId: widget.response?.id ?? "",
                            ),
                          );
                        } else if (value == 'block') {
                          showDialog(
                            context: context,
                            builder: (_) => BlockBox(
                              title:
                              widget.response?.firstName ?? "",
                              userId: widget.response?.id ?? "",
                            ),
                          );
                        }
                        else if (value == 'spam') {
                          showDialog(
                            context: context,
                            builder: (_) => SpamBox(
                              title:
                              widget.response?.firstName ?? "",
                              userId: widget.response?.id ?? "",
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                widget.first == false
                    ? SpaceWidget()
                    : SpaceWidget(
                    height: DynamicSize.height(context) * 0.01),
                widget.first == false
                    ? SpaceWidget()
                    : Align(
                  alignment: Alignment.centerLeft,
                  child: Container(

                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 60.w),
                      child: AppText(
                        fontWeight: FontWeight.w700,
                        size: 22.sp,
                        maxlin: 1,
                        text: widget.response?.age.toString() != "0"
                            ? '${widget.response?.firstName} , ${widget.response?.age.toString() ?? ""}'
                            : "${widget.response?.lastName} ",
                        color: Colors.white,
                      ),
                    ),
                    widget.response?.profileVerified == false
                        ? Container(
                      height: 3.h,
                      width: 3.h,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/verify.png"),
                        ),
                      ),
                    )
                        : Container(),
                  ],
                ),
                2.h.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                    1.w.widthBox,
                    AppText(
                      maxlin: 1,
                      fontWeight: FontWeight.w500,
                      size: 14.sp,
                      text:
                      "${widget.response?.city}${widget.response!.city!.isEmpty ? '' : ','} ${widget.response?.country}",
                      color: Colors.white,
                    ),
                    const Spacer(),
                  ],
                ),
                0.5.h.heightBox,
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    maxlin: 1,
                    fontWeight: FontWeight.w500,
                    size: 14.sp,
                    text: "${widget.response!.distance} Miles Away",
                    color: Colors.white,
                  ),
                ),
                widget.response?.isOnline == true
                    ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: DynamicSize.height(context) * .03,
                    width: 28.w,
                    decoration: BoxDecoration(
                      color:
                      const Color(0xff1B8500).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xff3B8B39),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 1.5.h,
                          width: 1.5.h,
                          decoration: BoxDecoration(
                            color: const Color(0xff85E882),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xff3B8B39),
                              width: .7.w,
                            ),
                          ),
                        ).pOnly(left: 1.w),
                        2.w.widthBox,
                        AppText(
                          color: AppColor.white,
                          fontWeight: FontWeight.w600,
                          size: 14.sp,
                          text: "Active Now",
                        ),
                      ],
                    ),
                  ),
                )
                    : Container(),
                SpaceWidget(height: DynamicSize.width(context) * .04),
                widget.first == false
                    ? SpaceWidget()
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: DynamicSize.height(context) * 0.06,
                      width: DynamicSize.width(context) * .07,
                      decoration: BoxDecoration(
                        color: whitecolor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 25.sp,
                        color: AppColor.tinderclr,
                      ),
                    ).onTap(() {
                      if (token.isEmpty) {
                        print("❌ Token is empty, cannot perform dislike action");
                        return;
                      }
                      context.read<HomePageCubit>().likeSidlike(
                        context,
                        widget.response?.id ?? "",
                        'dislike',
                        token,
                        widget.response?.firstName ?? "",
                      );
                    }),
                    Container(
                      height: DynamicSize.height(context) * 0.06,
                      width: DynamicSize.width(context) * .07,
                      decoration: BoxDecoration(
                        color: whitecolor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send,
                        size: 25.sp,
                        color:Colors.white,
                      ),
                    ).onTap(() {
                      print("pushkar$token");
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        backgroundColor: Colors.transparent,
                        constraints: BoxConstraints(maxHeight: 150.h),
                        builder: (_) => IntroBottomSheet(
                          userId: widget.response?.id ?? "",
                          profilePicture: widget.response?.profilePicture ?? "", firstName: widget.response!.firstName.toString(),

                        ),
                      );

                    }
                    ),

                    Container(
                      height: DynamicSize.height(context) * 0.06,
                      width: DynamicSize.width(context) * .07,
                      decoration: BoxDecoration(
                        color: whitecolor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 25.sp,
                        color: const Color(0xffFF281B),
                      ),
                    ).onTap(() {
                      print("pushkar$token");
                      
                      if (token.isEmpty) {
                        print("❌ Token is empty, cannot perform like action");
                        return;
                      }

                      context.read<HomePageCubit>().likeSidlike(
                        context,
                        widget.response?.id ?? "",
                        'like',
                        token,
                        widget.response?.firstName??"",
                      );


                    }
                    ),
                  ],
                ),
                SpaceWidget(height: DynamicSize.width(context) * .03),
              ],
            ).pOnly(
              top: DynamicSize.height(context) * 0.01,
              bottom: DynamicSize.height(context) * 0.01,
              left: DynamicSize.width(context) * .02,
              right: DynamicSize.width(context) * .02,
            ),
          ],
        )
            : Center(
          child: AppText(
            fontWeight: FontWeight.w600,
            size: 14.sp,
            color: Colors.black,
            text: 'No media available',
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: isActive ? 12.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: isActive ? AppColor.activeiconclr : Colors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}


// class HomePreviewContainer extends StatefulWidget {
//   final Users? response;
//   final int index;
//   final int imageIndex;
//   final bool first;
//
//   HomePreviewContainer({
//     super.key,
//     this.response,
//     this.index = 0,
//     this.first = true,
//     required this.imageIndex,
//   });
//
//   @override
//   _HomePreviewContainerState createState() => _HomePreviewContainerState();
// }
//
// class _HomePreviewContainerState extends State<HomePreviewContainer> with WidgetsBindingObserver {
//   late TextEditingController msgController;
//   late Timer _timer;
//   late PageController _pageController;
//   int _currentPage = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     msgController = TextEditingController();
//     _pageController = PageController(initialPage: widget.imageIndex);
//     _currentPage = widget.imageIndex;
//     _startAutoSlide();
//   }
//
//   void _startAutoSlide() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_currentPage < (widget.response?.media?.length ?? 0) - 1) {
//         _currentPage++;
//       } else {
//         _currentPage = 0;
//       }
//       _pageController.animateToPage(
//         _currentPage,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     });
//   }
//
//   void _stopAutoSlide() {
//     _timer.cancel();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
//       _stopAutoSlide();
//     } else if (state == AppLifecycleState.resumed) {
//       _startAutoSlide();
//     }
//     super.didChangeAppLifecycleState(state);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _stopAutoSlide();
//     _pageController.dispose();
//     msgController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final mediaLength = widget.response?.media?.length ?? 0;
//
//     return mediaLength >= (widget.imageIndex + 1)
//         ? WillPopScope(
//       onWillPop: () async {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (_) => BottomBar(currentIndex: 2),
//           ),
//               (route) => false,
//         );
//         return true;
//       },
//       child: RefreshIndicator(
//         onRefresh: () async {
//           BlocProvider.of<HomePageCubit>(context).homeApi(context);
//         },
//         child: SingleChildScrollView(
//           child: Container(
//             height: DynamicSize.height(context) * .75,
//             width: DynamicSize.width(context),
//             decoration: BoxDecoration(
//               border: Border.all(color: blackColor.withOpacity(.5)),
//               borderRadius: BorderRadius.circular(26),
//             ),
//             child: Stack(
//               children: [
//                 PageView.builder(
//                   controller: _pageController,
//                   itemCount: mediaLength,
//                   physics: const ClampingScrollPhysics(),
//                   onPageChanged: (index) {
//                     setState(() {
//                       _currentPage = index;
//                     });
//                   },
//                   itemBuilder: (context, index) {
//                     return CustomImageView(
//                       fit: BoxFit.cover,
//                       clipBehavior: Clip.hardEdge,
//                       radius: BorderRadius.circular(24),
//                       height: DynamicSize.height(context) * .75,
//                       width: DynamicSize.width(context),
//                       imagePath: widget.response?.media?[index],
//                     );
//                   },
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     height: DynamicSize.height(context) * .75,
//                     width: DynamicSize.width(context),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                         colors: [
//                           AppColor.black.withOpacity(0.5),
//                           Colors.transparent
//                         ],
//                       ),
//                       color: AppColor.black.withOpacity(0.0),
//                       borderRadius: BorderRadius.circular(26),
//                     ),
//                   ),
//                 ),
//                 if (mediaLength > 1)
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(
//                           mediaLength,
//                               (i) => _buildIndicator(i == _currentPage),
//                         ),
//                       ),
//                     ),
//                   ),
//
//
//
//                 Column(
//                   children: [
//                     widget.first == false
//                         ? SpaceWidget()
//                         : Row(
//                       children: [
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: GestureDetector(
//                             onTap: (){
//                               CustomNavigator.push(context: context, screen: AgreeScreen(
//                                 UserName:widget.response!.firstName??"",
//                                 UserImg:widget.response!.profilePicture??"",
//                                 userId: widget.response?.sId ?? "",
//                               ));
//                             },
//                             child: Container(
//                               height: 5.h,
//                               width: 5.h,
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white,
//                               ),
//                               child: Center(
//                                 child: AppText(
//                                   maxlin: 1,
//                                   fontWeight: FontWeight.w600,
//                                   size: 10.sp,
//                                   text: "${widget.response!.questionAnswerPercentage?.toStringAsFixed(1) ?? '0.0'}% ",
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const Spacer(),
//                         PopupMenuButton(
//                           elevation: 1,
//                           padding: EdgeInsets.zero,
//                           color: AppColor.tinderclr,
//                           icon: Icon(
//                             Icons.more_vert,
//                             color: whitecolor,
//                             size: 20.sp,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                           itemBuilder: (_) => <PopupMenuItem<String>>[
//                             PopupMenuItem<String>(
//                               value: 'report',
//                               child: Column(
//                                 children: [
//                                   2.h.heightBox,
//                                   AppText(
//                                     fontWeight: FontWeight.w400,
//                                     size: 2.h,
//                                     color: Colors.white,
//                                     text: "Report User",
//                                   ).centered(),
//                                   1.h.heightBox,
//                                 ],
//                               ),
//                             ),
//                             PopupMenuItem<String>(
//                               value: 'block',
//                               child: Column(
//                                 children: [
//                                   const Divider(color: Colors.white),
//                                   2.h.heightBox,
//                                   AppText(
//                                     fontWeight: FontWeight.w400,
//                                     size: 2.h,
//                                     color: Colors.white,
//                                     text: "Block User",
//                                   ),
//                                   1.h.heightBox,
//                                 ],
//                               ),
//                             ),
//                             PopupMenuItem<String>(
//                               value: 'spam',
//                               child: Column(
//                                 children: [
//                                   const Divider(color: Colors.white),
//                                   2.h.heightBox,
//                                   AppText(
//                                     fontWeight: FontWeight.w400,
//                                     size: 2.h,
//                                     color: Colors.white,
//                                     text: "Spam User",
//                                   ),
//                                   1.h.heightBox,
//                                 ],
//                               ),
//                             ),
//                           ],
//                           onSelected: (value) {
//                             if (value == 'report') {
//                               showDialog(
//                                 context: context,
//                                 builder: (_) => ReportBox(
//                                   title:
//                                   widget.response?.firstName ?? "",
//                                   userId: widget.response?.sId ?? "",
//                                 ),
//                               );
//                             } else if (value == 'block') {
//                               showDialog(
//                                 context: context,
//                                 builder: (_) => BlockBox(
//                                   title:
//                                   widget.response?.firstName ?? "",
//                                   userId: widget.response?.sId ?? "",
//                                 ),
//                               );
//                             }
//                             else if (value == 'spam') {
//                               showDialog(
//                                 context: context,
//                                 builder: (_) => SpamBox(
//                                   title:
//                                   widget.response?.firstName ?? "",
//                                   userId: widget.response?.sId ?? "",
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                     widget.first == false
//                         ? SpaceWidget()
//                         : SpaceWidget(
//                         height: DynamicSize.height(context) * 0.01),
//                     widget.first == false
//                         ? SpaceWidget()
//                         : Align(
//                       alignment: Alignment.centerLeft,
//                       child: Container(
//
//                       ),
//                     ),
//                     const Spacer(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Container(
//                           constraints: BoxConstraints(maxWidth: 60.w),
//                           child: AppText(
//                             fontWeight: FontWeight.w700,
//                             size: 22.sp,
//                             maxlin: 1,
//                             text: widget.response?.age.toString() != "0"
//                                 ? '${widget.response?.firstName} , ${widget.response?.age.toString() ?? ""}'
//                                 : "${widget.response?.lastName} ",
//                             color: Colors.white,
//                           ),
//                         ),
//                         widget.response?.profileVerified == false
//                             ? Container(
//                           height: 3.h,
//                           width: 3.h,
//                           decoration: const BoxDecoration(
//                             image: DecorationImage(
//                               image: AssetImage(
//                                   "assets/images/verify.png"),
//                             ),
//                           ),
//                         )
//                             : Container(),
//                       ],
//                     ),
//                     2.h.heightBox,
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Icon(
//                           Icons.location_pin,
//                           color: Colors.white,
//                           size: 18.sp,
//                         ),
//                         1.w.widthBox,
//                         AppText(
//                           maxlin: 1,
//                           fontWeight: FontWeight.w500,
//                           size: 12.sp,
//                           text:
//                           "${widget.response?.city}${widget.response!.city!.isEmpty ? '' : ','} ${widget.response?.country}",
//                           color: Colors.white,
//                         ),
//                         const Spacer(),
//                       ],
//                     ),
//                     0.5.h.heightBox,
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: AppText(
//                         maxlin: 1,
//                         fontWeight: FontWeight.w500,
//                         size: 12.sp,
//                         text: "${widget.response!.distance} Miles Away",
//                         color: Colors.white,
//                       ),
//                     ),
//                     widget.response?.isOnline == true
//                         ? Align(
//                       alignment: Alignment.centerLeft,
//                       child: Container(
//                         height: DynamicSize.height(context) * .03,
//                         width: 28.w,
//                         decoration: BoxDecoration(
//                           color:
//                           const Color(0xff1B8500).withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                             color: const Color(0xff3B8B39),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               height: 1.5.h,
//                               width: 1.5.h,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xff85E882),
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: const Color(0xff3B8B39),
//                                   width: .7.w,
//                                 ),
//                               ),
//                             ).pOnly(left: 1.w),
//                             2.w.widthBox,
//                             AppText(
//                               color: AppColor.white,
//                               fontWeight: FontWeight.w600,
//                               size: 10.sp,
//                               text: "Active Now",
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                         : Container(),
//                     SpaceWidget(height: DynamicSize.width(context) * .04),
//                     widget.first == false
//                         ? SpaceWidget()
//                         : Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           height: DynamicSize.height(context) * 0.06,
//                           width: DynamicSize.width(context) * .07,
//                           decoration: BoxDecoration(
//                             color: whitecolor.withOpacity(0.5),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.close,
//                             size: 25.sp,
//                             color: AppColor.tinderclr,
//                           ),
//                         ).onTap(() {
//                           context.read<HomePageCubit>().likeSidlike(
//                             context,
//                             widget.response?.sId ?? "",
//                             'dislike',
//                             token,
//                             widget.response?.firstName ?? "",
//                           );
//                         }),
//                         Container(
//                           height: DynamicSize.height(context) * 0.06,
//                           width: DynamicSize.width(context) * .07,
//                           decoration: BoxDecoration(
//                             color: whitecolor.withOpacity(0.5),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.send,
//                             size: 25.sp,
//                             color:Colors.white,
//                           ),
//                         ).onTap(() {
//                           print("pushkar$token");
//                           showModalBottomSheet(
//                             isScrollControlled: true,
//                             context: context,
//                             backgroundColor: Colors.transparent,
//                             constraints: BoxConstraints(maxHeight: 150.h),
//                             builder: (_) => IntroBottomSheet(
//                               userId: widget.response?.sId ?? "",
//                               profilePicture: widget.response?.profilePicture ?? "", firstName: widget.response!.firstName.toString(),
//
//                             ),
//                           );
//
//                         }
//                         ),
//
//                         Container(
//                           height: DynamicSize.height(context) * 0.06,
//                           width: DynamicSize.width(context) * .07,
//                           decoration: BoxDecoration(
//                             color: whitecolor.withOpacity(0.5),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.favorite,
//                             size: 25.sp,
//                             color: const Color(0xffFF281B),
//                           ),
//                         ).onTap(() {
//                           print("pushkar$token");
//
//                           context.read<HomePageCubit>().likeSidlike(
//                             context,
//                             widget.response?.sId ?? "",
//                             'like',
//                             token,
//                             widget.response?.firstName??"",
//                           );
//
//
//                         }
//                         ),
//                       ],
//                     ),
//                     SpaceWidget(height: DynamicSize.width(context) * .03),
//                   ],
//                 ).pOnly(
//                   top: DynamicSize.height(context) * 0.01,
//                   bottom: DynamicSize.height(context) * 0.01,
//                   left: DynamicSize.width(context) * .02,
//                   right: DynamicSize.width(context) * .02,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     )
//         : SpaceWidget(color: Colors.transparent);
//   }
//
//   Widget _buildIndicator(bool isActive, {Color? activeColor, Color? inactiveColor}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 2.0),
//       width: isActive ? 14.0 : 10.0,
//       height: 10.0,
//       decoration: BoxDecoration(
//         color: isActive ? (activeColor ?? AppColor.activeiconclr) : (inactiveColor ?? Colors.white),
//         borderRadius: BorderRadius.circular(80.0),
//       ),
//     );
//   }
// }
//
//
//
