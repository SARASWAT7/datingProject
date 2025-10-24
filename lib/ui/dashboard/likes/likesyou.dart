// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:demoproject/component/apihelper/urls.dart';
// import 'package:demoproject/component/reuseable_widgets/apploder.dart';
// import 'package:demoproject/component/reuseable_widgets/apptext.dart';
// import 'package:demoproject/ui/dashboard/home/match/match.dart';
// import 'package:demoproject/ui/dashboard/likes/cubit/likedyoucubit.dart';
// import 'package:demoproject/ui/dashboard/likes/cubit/likedyoustate.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../../component/reuseable_widgets/bottomTabBar.dart';
// import '../../../component/reuseable_widgets/customNavigator.dart';
// import '../home/cubit/homecubit/homecubit.dart';
// import 'fullprofileview.dart';
//
// class Likesyou extends StatefulWidget {
//   const Likesyou({super.key});
//
//   @override
//   State<Likesyou> createState() => _LikesyouState();
// }
//
// class _LikesyouState extends State<Likesyou> {
//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<LikedYouCubit>(context).likedyou(context);
//   }
//
//   @override
//   Future<void> dispose() async {
//     super.dispose();
//     await DefaultCacheManager().emptyCache();
//   }
//
//   Future<String?> getToken() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }
//
//   Future<void> _likeUser(String id, String userName) async {
//     final token = await getToken();
//     if (token != null) {
//       context.read<HomePageCubit>().likeSidlike(
//         context,
//         id,
//         'like',
//         token,
//         userName,
//       );
//     } else {
//       print("Token not found");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (_) => BottomBar(
//               currentIndex: 2,
//             ),
//           ),
//               (route) => false,
//         );
//         return true;
//       },
//       child: BlocBuilder<LikedYouCubit, LikedYouState>(
//         builder: (context, state) {
//           if (state.status == ApiStates.loading) {
//             return AppLoader(); // Show loader while fetching
//           } else if (state.status == ApiStates.success) {
//             if (state.response?.result == null || state.response!.result!.isEmpty) {
//               return Center(
//                 child: AppText(
//                   fontWeight: FontWeight.w600,
//                   size: 14.sp,
//                   color: Colors.black,
//                   text: 'No Likes You Found',
//                 ).centered(),
//               );
//             }
//
//             return MasonryGridView.count(
//               reverse: false,
//               shrinkWrap: true,
//               crossAxisCount: 2,
//               mainAxisSpacing: 2.h,
//               crossAxisSpacing: 5.w,
//               itemCount: state.response?.result?.length ?? 0,
//               itemBuilder: (context, index) {
//                 final result = state.response!.result![index];
//                 final imageUrl = result.userId?.profilePicture ?? '';
//                 final userName = result.userId?.firstName ?? '';
//                 final id = result.userId?.sId ?? '';
//
//                 return StaggeredGridTile.count(
//                   crossAxisCellCount: 4,
//                   mainAxisCellCount: 2,
//                   child: Transform(
//                     transform: Matrix4.identity()
//                       ..setEntry(3, 2, 0.001)
//                       ..rotateX(-0.01)
//                       ..rotateY(0.01),
//                     alignment: FractionalOffset.center,
//                     child:
//                     CachedNetworkImage(
//                       height: MediaQuery.of(context).size.height * 0.25,
//                       width: MediaQuery.of(context).size.width * .02,
//                       imageUrl: imageUrl,
//                       imageBuilder: (context, imageProvider) => GestureDetector(
//                         onTap: () {
//                           CustomNavigator.push(
//                             context: context,
//                             screen: AllDataView(id:id ),
//                           );
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             image: DecorationImage(
//                               image: imageProvider,
//                               fit: BoxFit.cover,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.red.withOpacity(0.4),
//                                 spreadRadius: 1,
//                                 blurRadius: 18,
//                                 offset: const Offset(5, 5),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               Align(
//                                 alignment: Alignment.topRight,
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     _likeUser(id, userName);
//                                   },
//                                   child: Container(
//                                     height: 5.5.h,
//                                     width: 5.5.h,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.white.withOpacity(0.5),
//                                     ),
//                                     child: Center(
//                                       child: Icon(
//                                         Icons.favorite,
//                                         color: Colors.red,
//                                         size: 4.h,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ).pOnly(top: 3.w, right: 1.w),
//                               const Spacer(),
//                               Align(
//                                 alignment: Alignment.bottomLeft,
//                                 child: AppText(
//                                   fontWeight: FontWeight.w700,
//                                   size: 3.h,
//                                   color: Colors.white,
//                                   text: userName,
//                                 ),
//                               ).pOnly(left: 2.w),
//                               2.h.heightBox,
//                             ],
//                           ),
//                         ),
//                       ),
//                       placeholder: (context, url) => Center(child: AppLoader()),
//                       errorWidget: (context, url, error) => Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           image: DecorationImage(
//                             image: AssetImage('assets/images/nn.png'),
//                             fit: BoxFit.cover,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               spreadRadius: 1,
//                               blurRadius: 15,
//                               offset: Offset(5, 5),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             const Spacer(),
//                             Align(
//                               alignment: Alignment.bottomLeft,
//                               child: AppText(
//                                 fontWeight: FontWeight.w700,
//                                 size: 3.h,
//                                 color: Colors.black,
//                                 text: '', // Fallback text in case of error
//                               ),
//                             ).pOnly(left: 2.w),
//                             2.h.heightBox,
//                           ],
//                         ),
//                       ),
//                       fit: BoxFit.fill,
//                       filterQuality: FilterQuality.high,
//                     ),
//                   ),
//                 );
//
//               },
//             ).pOnly(left: 3.w, right: 3.w);
//           } else if (state.status == ApiStates.error) {
//             return Center(
//               child: AppText(
//                 fontWeight: FontWeight.w600,
//                 size: 14.sp,
//                 color: Colors.black,
//                 text: 'No Likes You Found',
//               ),
//             );
//           }
//           return SizedBox.shrink(); // Default case
//         },
//       ),
//     );
//   }
// }





import 'package:cached_network_image/cached_network_image.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/ui/dashboard/likes/cubit/likedyoucubit.dart';
import 'package:demoproject/ui/dashboard/likes/cubit/likedyoustate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../component/reuseable_widgets/bottomTabBar.dart';
import '../../../component/reuseable_widgets/customNavigator.dart';
import '../home/cubit/homecubit/homecubit.dart';
import 'fullprofileview.dart';
import 'dart:ui';  // Import for the blur effect


class Likesyou extends StatefulWidget {
  const Likesyou({super.key});

  @override
  State<Likesyou> createState() => _LikesyouState();
}

class _LikesyouState extends State<Likesyou> {
  bool isBlurred = false;  // To manage the blur effect
  bool shouldShowContent = false;  // To determine if the content should be shown
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    BlocProvider.of<LikedYouCubit>(context).likedyou(context);
    // checkPlan();  // Check the plan type when the page loads
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200 pixels from the bottom
      if (mounted) {
        BlocProvider.of<LikedYouCubit>(context).loadMoreLikedYou();
      }
    }
  }

  // Function to check the user's plan - DISABLED FOR ALL USERS
  Future<void> checkPlan() async {
    // DISABLED: All users can access likes without subscription
    setState(() {
      shouldShowContent = true;
      isBlurred = false;  // Remove the blur for all users
    });
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _likeUser(String id, String userName) async {
    final token = await getToken();
    if (token != null) {
      context.read<HomePageCubit>().likeSidlike(
        context,
        id,
        'like',
        token,
        userName,
      );
    } else {
      print("Token not found");
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => BottomBar(
              currentIndex: 2,
            ),
          ),
              (route) => false,
        );
        return true;
      },
      child: BlocBuilder<LikedYouCubit, LikedYouState>(
        builder: (context, state) {
          if (state.status == ApiStates.loading) {
            return AppLoader(); // Show loader while fetching
          } else if (state.status == ApiStates.success) {
            if (!shouldShowContent) {
              return Stack(
                children: [
                  Center(
                    child: AppText(
                      fontWeight: FontWeight.w600,
                      size: 14.sp,
                      color: Colors.black,
                      text: 'No Likes You Found',
                    ).centered(),
                  ),
                  if (isBlurred)
                  // Only apply blur to the content area of the Likesyou widget
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

            if (state.response?.result == null || state.response!.result!.isEmpty) {
              return Center(
                child: AppText(
                  fontWeight: FontWeight.w600,
                  size: 14.sp,
                  color: Colors.black,
                  text: 'No Likes You Found',
                ).centered(),
              );
            }

            return MasonryGridView.count(
              controller: _scrollController,
              reverse: false,
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 2.h,
              crossAxisSpacing: 5.w,
              itemCount: (state.response?.result?.length ?? 0) + (BlocProvider.of<LikedYouCubit>(context).hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                // Show loading indicator at the end if there are more users
                if (index == (state.response?.result?.length ?? 0)) {
                  return Container(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final result = state.response!.result![index];
                final imageUrl = result.likedUserId?.profilePicture ?? '';
                final userName = result.likedUserId?.firstName ?? '';
                final id = result.id ?? '';

                return StaggeredGridTile.count(
                  crossAxisCellCount: 4,
                  mainAxisCellCount: 2,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(-0.01)
                      ..rotateY(0.01),
                    alignment: FractionalOffset.center,
                    child: CachedNetworkImage(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * .02,
                      imageUrl: imageUrl,
                      imageBuilder: (context, imageProvider) => GestureDetector(
                        onTap: () {
                          CustomNavigator.push(
                            context: context,
                            screen: AllDataView(id: id),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 18,
                                offset: const Offset(5, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    _likeUser(id, userName);
                                  },
                                  child: Container(
                                    height: 5.5.h,
                                    width: 5.5.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 4.h,
                                      ),
                                    ),
                                  ),
                                ).pOnly(top: 3.w, right: 1.w),
                              ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: AppText(
                                  fontWeight: FontWeight.w700,
                                  size: 3.h,
                                  color: Colors.white,
                                  text: userName,
                                ),
                              ).pOnly(left: 2.w),
                              2.h.heightBox,
                            ],
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Center(child: AppLoader()),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage('assets/images/nn.png'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: Offset(5, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: AppText(
                                fontWeight: FontWeight.w700,
                                size: 3.h,
                                color: Colors.black,
                                text: '', // Fallback text in case of error
                              ),
                            ).pOnly(left: 2.w),
                            2.h.heightBox,
                          ],
                        ),
                      ),
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                );
              },
            ).pOnly(left: 3.w, right: 3.w);
          } else if (state.status == ApiStates.error) {
            return Center(
              child: AppText(
                fontWeight: FontWeight.w600,
                size: 14.sp,
                color: Colors.black,
                text: 'No Likes You Found',
              ),
            );
          }
          return SizedBox.shrink(); // Default case
        },
      ),
    );
  }
}

