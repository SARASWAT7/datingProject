// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:lottie/lottie.dart';

import '../../../../component/apihelper/urls.dart';
import '../../../../component/reuseable_widgets/apperror.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/apploder.dart';
// Premium upsell removed as per request
import '../cubit/homecubit/homecubit.dart';
import '../cubit/homecubit/homestate.dart';
import 'homepagedata.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to safely access context after widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        BlocProvider.of<HomePageCubit>(context).homeApi(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        BlocProvider.of<HomePageCubit>(context).homeApi(context);
      },
        child: BlocBuilder<HomePageCubit, HomePageState>(
          builder: (context, state) {

          if (state.status == ApiStates.loading) {
            return AppLoader();
          } else if (state.status == ApiStates.error) {
            return AppErrorError(
              onPressed: () {
                BlocProvider.of<HomePageCubit>(context).homeApi(context);
              },
            );
          } else if (state.response?.result?.users == null ||
              state.response!.result!.users!.isEmpty) {
            // Start background refresh when no users are available
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                context.read<HomePageCubit>().startBackgroundRefresh();
              }
            });
            return SingleChildScrollView(
              child: _noMoreUsersWidget(context),
            );
          } else {
            return SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    if (state.currentIndex >=
                        state.response!.result!.users!.length)
                      Column(
                        children: [
                          if (state.isLoadingMore)
                            SizedBox(
                              height: 60.h,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 10.h),
                                    AppText(
                                      fontWeight: FontWeight.w500,
                                      size: 12.sp,
                                      text: "Loading more users...",
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (!state.hasMoreData)
                            _noMoreUsersWidget(context)
                          else
                            Builder(
                              builder: (context) {
                                // Trigger load more when user reaches the end
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  context.read<HomePageCubit>().onReachedEnd();
                                });
                                
                                return SizedBox(
                                  height: 60.h,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 10.h),
                                        AppText(
                                          fontWeight: FontWeight.w500,
                                          size: 12.sp,
                                          text: "Loading more users...",
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      )
                    else
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        child: state.currentIndex < state.response!.result!.users!.length
                            ? HomeApiData(
                                key: ValueKey(state.currentIndex),
                                index: state.currentIndex,
                                response:
                                    state.response!.result!.users![state.currentIndex],
                              )
                            : SizedBox(
                                height: 60.h,
                                child: Center(
                                  child: AppText(
                                    fontWeight: FontWeight.w500,
                                    size: 12.sp,
                                    text: "No users available",
                                  ),
                                ),
                              ),
                      ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

  Widget _noMoreUsersWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade50,
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Prevent overflow
              children: [
                // Animated Lottie loader - extra large and centered
                Center(
                  child: Lottie.asset(
                    'assets/images/dating.json',
                    width: 100.w,
                    height: 100.w,
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                  ),
                ),
                
                SizedBox(height: 2.h),
                
                // Main message - smaller text
                AppText(
                  fontWeight: FontWeight.w700,
                  size: 16.sp,
                  text: "No more profiles found 💕",
                  color: Colors.pink.shade700,
                ),
                
                SizedBox(height: 0.5.h),
                
                // Sub message - smaller text
                AppText(
                  fontWeight: FontWeight.w400,
                  size: 14.sp,
                  text: "Check back later for new matches!",
                  color: Colors.grey.shade600,
                ),
                
                SizedBox(height: 2.h),
                
                // Refresh button - smaller
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFD5564),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      context.read<HomePageCubit>().homeApi(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh_rounded, size: 20.sp),
                        SizedBox(width: 1.w),
                        AppText(
                          fontWeight: FontWeight.w600,
                          size: 16.sp,
                          text: "Refresh",
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
