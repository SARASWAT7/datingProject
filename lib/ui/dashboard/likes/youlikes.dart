import 'package:cached_network_image/cached_network_image.dart';
import 'package:demoproject/component/reuseable_widgets/customNavigator.dart';
import 'package:demoproject/ui/dashboard/likes/fullprofileview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../component/apihelper/urls.dart';
import '../../../component/reuseable_widgets/apploder.dart';
import '../../../component/reuseable_widgets/apptext.dart';
import '../../../component/reuseable_widgets/bottomTabBar.dart';
import '../../../ui/dashboard/likes/cubit/youliked/youlikedcubit.dart';
import '../../../ui/dashboard/likes/cubit/youliked/youlikedstate.dart';

class YouLike extends StatefulWidget {
  const YouLike({super.key});

  @override
  State<YouLike> createState() => _YouLikeState();
}

class _YouLikeState extends State<YouLike> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<YouLikedCubit>().youLiked(context);
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
        BlocProvider.of<YouLikedCubit>(context).loadMoreYouLiked();
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
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
      child: BlocBuilder<YouLikedCubit, YouLikedState>(
        builder: (context, state) {
          if (state.status == ApiStates.loading) {
            return AppLoader();
          }
          final results = state.response?.result ?? [];
          if (results.isEmpty) {
            return Center(
              child: AppText(
                fontWeight: FontWeight.w600,
                size: 14.sp,
                color: Colors.black,
                text: 'No you Likes Found',
              ),
            );
          }

          return MasonryGridView.count(
            controller: _scrollController,
            reverse: false,
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 2.h,
            crossAxisSpacing: 5.w,
            itemCount: results.length + (BlocProvider.of<YouLikedCubit>(context).hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              // Show loading indicator at the end if there are more users
              if (index == results.length) {
                return Container(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final result = results[index];
              final imageUrl = result.likedUserId?.profilePicture ?? '';
              final userName = '${result.likedUserId?.firstName ?? ''}, ${result.likedUserId?.age ?? ''}';
              final id = result.likedUserId?.id ?? '';
              
              // Debug logging for each user
              print("   🔍 You Liked - User $index:");
              print("   📝 Full result: ${result.toJson()}");
              print("   👤 User ID: $id");
              print("   🖼️ Image URL: $imageUrl");
              print("   📛 User Name: $userName");
              print("   📊 Liked User Data: ${result.likedUserId?.toJson()}");

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective effect
                  ..rotateX(-0.01) // Slight tilt effect
                  ..rotateY(0.01), // Slight tilt effect
                alignment: FractionalOffset.center,
                child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * .02,
                    imageUrl: imageUrl,
                    imageBuilder: (context, imageProvider) => GestureDetector(
                      onTap: () {
                        CustomNavigator.push(
                          context: context,
                          screen: AllDataView(id: id), // Pass the id here
                        );
                      },
                      child: Container(
                        height: 30.h,
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

                    placeholder: (context, url) =>  Center(
                      child: AppLoader(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: Image.asset('assets/images/nn.png').image,
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
                );
            },
          ).pOnly(left: 3.w, right: 3.w);
        },
      ),
    );
  }
}
