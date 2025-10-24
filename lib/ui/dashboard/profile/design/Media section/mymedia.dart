import 'package:cached_network_image/cached_network_image.dart';
import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/profile/profilecubit.dart';
import 'package:demoproject/ui/dashboard/profile/cubit/profile/profilestate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';
import '../../../../../component/alert_box.dart';
import '../../../../../component/reuseable_widgets/appBar.dart';
import '../../../../../component/reuseable_widgets/appText.dart';
import '../../../../../component/reuseable_widgets/apploder.dart';
import '../../../../../component/reuseable_widgets/reusebottombar.dart';
import 'cachemanager.dart';

class MyMedia extends StatefulWidget {
  const MyMedia({super.key});

  @override
  State<MyMedia> createState() => _MyMediaState();
}

class _MyMediaState extends State<MyMedia> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getprofile(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidgetThree(
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
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
        title: 'My Photos',
        titleColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                final state = context.read<ProfileCubit>().state;
                if (state.isDelete) {
                  if ((state.selectedPhoto?.isNotEmpty ?? false)) {
                    int totalItems = state.profileResponse?.result?.media?.length ?? 0;
                    int selectedItems = state.selectedPhoto?.length ?? 0;
                    int remainingItems = totalItems - selectedItems;

                    if (remainingItems < 6) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertBox2(
                          title: 'At least Six Photos must remain. Please select fewer Photos to delete.',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertBox3(
                            title: 'Are you sure you want to delete these images?',
                            onYesPressed: () {
                              Navigator.of(context).pop();
                              context.read<ProfileCubit>().deleteMedia(context);
                            },
                            onNoPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No items selected for deletion.'),
                      ),
                    );
                  }
                } else {
                  context.read<ProfileCubit>().deleteupdate(true);
                }
              },
              child: Center(
                child: Image.asset(
                  'assets/images/delete.png',
                  width: 30.0,
                  height: 30.0,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ApiState.isLoading) {
            return AppLoader();
          }
          if ((state.profileResponse?.result?.media?.isEmpty ?? true)) {
            return Center(
              child: AppText(
                fontWeight: FontWeight.w600,
                size: 14.sp,
                color: Colors.black,
                text: 'No Data Found',
              ),
            );
          } else {
            final mediaList = state.profileResponse?.result?.media ?? [];

            return MasonryGridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount: mediaList.length,
              itemBuilder: (context, index) {
                final image = mediaList[index];

                return GestureDetector(
                  onTap: () {
                    if (state.isDelete) {
                      context.read<ProfileCubit>().updatePhotoList(image);
                    }
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child:
                        CachedNetworkImage(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width,
                          imageUrl: image,
                          cacheKey: "media_$index",
                          cacheManager: CustomCacheManager(),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 30.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 18,
                                  offset: const Offset(5, 5),
                                ),
                              ],
                            ),
                          ),
                          placeholder: (context, url) => Center(child: AppLoader()),
                          errorWidget: (context, url, error) => AppText(
                            fontWeight: FontWeight.w400,
                            size: 14.sp,
                            text: 'No Data',
                          ),
                        ),

                      ),
                      if (state.isDelete)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(
                            (state.selectedPhoto?.contains(image) ?? false)
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: (state.selectedPhoto?.contains(image) ?? false)
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


