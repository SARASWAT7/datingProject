// import 'dart:developer';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:demoproject/component/apihelper/common.dart';
// import 'package:demoproject/component/commonfiles/appcolor.dart';
// import 'package:demoproject/component/reuseable_widgets/apploder.dart';
// import 'package:demoproject/component/reuseable_widgets/apptext.dart';
// import 'package:demoproject/ui/dashboard/explore/cubit/explore/explorecubit.dart';
// import 'package:demoproject/ui/dashboard/explore/cubit/explore/explorepagestate.dart';
// import 'package:demoproject/ui/dashboard/explore/design/exploredetail.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:sizer/sizer.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../../../component/apihelper/urls.dart';
// import '../../../../component/reuseable_widgets/bottomTabBar.dart';
//
// class ExploreData extends StatefulWidget {
//   const ExploreData({super.key});
//
//   @override
//   State<ExploreData> createState() => _ExploreDataState();
// }
//
// class _ExploreDataState extends State<ExploreData> {
//   bool loadingdata = false;
//
//   @override
//   void initState() {
//     setState(() {
//       loadingdata = true;
//     });
//     Helper().check().then((value) {
//       if (value) {
//         setState(() {
//           loadingdata = true;
//         });
//         BlocProvider.of<ExploreCubit>(context).exploredata(context);
//       } else {
//       }
//     });
//     super.initState();
//   }
//
//   Future<void> _pullToRefresh() async {
//     BlocProvider.of<ExploreCubit>(context).exploredata(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async{
//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => BottomBar(
//                   currentIndex: 2,
//                 )),
//                 (route) => false);
//         return true;
//       },
//       child: BlocBuilder<ExploreCubit, ExploreState>(
//         builder: (context, state) {
//           if (state.status == ApiStates.loading) {
//             return  AppLoader();
//           } else if (state.response?.result == null || state.response!.result!.isEmpty) {
//             return Center(
//               child: Text(
//                 "No Explore Field Found",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 18.sp,
//                   color: Colors.black,
//                 ),
//               ),
//             );
//           } else {
//             return RefreshIndicator(
//               color: AppColor.tinderclr,
//               onRefresh: _pullToRefresh,
//               child: SizedBox(
//                 height: 100.h,
//                 width: 100.w,
//                 child: Column(
//                   children: [
//                     SizedBox(height: 5.h),
//                     Expanded(
//                       child: MasonryGridView.count(
//                         shrinkWrap: true,
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 2.h,
//                         itemCount: state.response?.result?.length ?? 0,
//                         itemBuilder: (context, index) {
//                           return SingleChildScrollView(
//                             child: CachedNetworkImage(
//                               height: MediaQuery.of(context).size.height * 0.17,
//                               width: MediaQuery.of(context).size.width,
//                               imageUrl: state.response?.result?[index].thumbnail ?? '',
//                               imageBuilder: (context, imageProvider) => Container(
//                                 height: 30.h,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   image: DecorationImage(
//                                       image: imageProvider, fit: BoxFit.cover),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.5),
//                                       offset: Offset(4, 4),
//                                       blurRadius: 8,
//                                     ),
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.3),
//                                       offset: Offset(-2, -2),
//                                       blurRadius: 6,
//                                     ),
//                                   ],
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.transparent,
//                                       Colors.black.withOpacity(0.2)
//                                     ],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                   ),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: SizedBox(
//                                         width: 25.w,
//                                         child: AppText(
//                                           fontWeight: FontWeight.w400,
//                                           size: 16.sp,
//                                           text: state.response?.result?[index].name ?? '',
//                                           color: Colors.white,
//                                           maxlin: 2,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ).onTap(() {
//                                 log("$index");
//                                 Navigator.pushAndRemoveUntil(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => ExploreDetail(
//                                       explore: state.response?.result?[index],
//                                       index: index,
//                                     ),
//                                   ),
//                                       (route) => false,
//                                 );
//                               }),
//                               errorWidget: (context, url, error) {
//                                 log(error.toString());
//                                 return Container(
//                                   height: 30.h,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(18),
//                                     border: Border.all(color: AppColor.tinderclr),
//                                     image: DecorationImage(
//                                       image: Image.asset('assets/images/splash.png').image,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: AppText(
//                                       fontWeight: FontWeight.w600,
//                                       size: 16.sp,
//                                       text: "No Explore Field Found",
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ).pOnly(left: 3.w, right: 3.w),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
//
//


import 'dart:developer';
import 'dart:ui'; // For the blur effect
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/ui/dashboard/explore/cubit/explore/explorecubit.dart';
import 'package:demoproject/ui/dashboard/explore/cubit/explore/explorepagestate.dart';
import 'package:demoproject/ui/dashboard/explore/design/exploredetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../component/apihelper/urls.dart';
import '../../../../component/reuseable_widgets/bottomTabBar.dart';
import '../../../subscrption/design/subscriptionpopup.dart';

class ExploreData extends StatefulWidget {
  const ExploreData({super.key});

  @override
  State<ExploreData> createState() => _ExploreDataState();
}

class _ExploreDataState extends State<ExploreData> {
  bool loadingdata = false;
  bool isBlurred = false; // To manage the blur effect
  bool shouldShowExplore = false; // To determine if explore data should be shown

  // Function to check if the plan is gold - DISABLED FOR ALL USERS
  Future<void> checkPlan() async {
    // DISABLED: All users can access explore without subscription
    setState(() {
      shouldShowExplore = true;
      isBlurred = false; // Remove the blur for all users
    });
  }

  @override
  void initState() {
    super.initState();
    // checkPlan();
    setState(() {
      loadingdata = true;
    });
    
    // Use improved connectivity checking
    Helper.executeWithConnectivityCheck(
      context,
      () async {
        BlocProvider.of<ExploreCubit>(context).exploredata(context);
      },
    );
  }

  Future<void> _pullToRefresh() async {
    Helper.executeWithConnectivityCheck(
      context,
      () async {
        BlocProvider.of<ExploreCubit>(context).exploredata(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => BottomBar(
                  currentIndex: 2,
                )),
                (route) => false);
        return true;
      },
      child: BlocBuilder<ExploreCubit, ExploreState>(
        builder: (context, state) {
          if (state.status == ApiStates.loading) {
            return  AppLoader();
          } else if (state.response?.result == null || state.response!.result!.isEmpty) {
            return Center(
              child: Text(
                "No Explore Field Found",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: Colors.black,
                ),
              ),
            );
          } else {
            return Stack(
              children: [
                // Main explore screen
                RefreshIndicator(
                  color: AppColor.tinderclr,
                  onRefresh: _pullToRefresh,
                  child: SizedBox(
                    height: 100.h,
                    width: 100.w,
                    child: Column(
                      children: [
                        SizedBox(height: 5.h),
                        Expanded(
                          child: MasonryGridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            mainAxisSpacing: 2.h,
                            itemCount: state.response?.result?.length ?? 0,
                            itemBuilder: (context, index) {
                              return SingleChildScrollView(
                                child: CachedNetworkImage(
                                  height: MediaQuery.of(context).size.height * 0.17,
                                  width: MediaQuery.of(context).size.width,
                                  imageUrl: state.response?.result?[index].thumbnail ?? '',
                                  imageBuilder: (context, imageProvider) => Container(
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: imageProvider, fit: BoxFit.cover),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          offset: Offset(4, 4),
                                          blurRadius: 8,
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: Offset(-2, -2),
                                          blurRadius: 6,
                                        ),
                                      ],
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.2)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: SizedBox(
                                            width: 25.w,
                                            child: AppText(
                                              fontWeight: FontWeight.w400,
                                              size: 16.sp,
                                              text: state.response?.result?[index].name ?? '',
                                              color: Colors.white,
                                              maxlin: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).onTap(() {
                                    log("$index");
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ExploreDetail(
                                          explore: state.response?.result?[index],
                                          index: index,
                                        ),
                                      ),
                                          (route) => false,
                                    );
                                  }),
                                  errorWidget: (context, url, error) {
                                    log(error.toString());
                                    return Container(
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(color: AppColor.tinderclr),
                                        image: DecorationImage(
                                          image: Image.asset('assets/images/splash.png').image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Center(
                                        child: AppText(
                                          fontWeight: FontWeight.w600,
                                          size: 16.sp,
                                          text: "No Explore Field Found",
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  },
                                ).pOnly(left: 3.w, right: 3.w),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Blurred effect over the background
                if (isBlurred)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
