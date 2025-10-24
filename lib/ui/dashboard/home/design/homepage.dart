import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../component/apihelper/urls.dart';
import '../../../../component/reuseable_widgets/apperror.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/apploder.dart';
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
    BlocProvider.of<HomePageCubit>(context).homeApi(context);

    super.initState();
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
            return SingleChildScrollView(
              child: SizedBox(
                height: 60.h,
                child: Center(
                  child: AppText(
                    fontWeight: FontWeight.w500,
                    size: 12.sp,
                    text: "No Data Found",
                  ).centered(),
                ),
              ),
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
                            SizedBox(
                              height: 60.h,
                              child: Center(
                                child: AppText(
                                  fontWeight: FontWeight.w500,
                                  size: 12.sp,
                                  text: "No More Users Found",
                                ),
                              ),
                            )
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
