 import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/custom_image_view.dart';
import 'package:demoproject/component/reuseable_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../component/reuseable_widgets/apptext.dart';
import '../../../../component/reuseable_widgets/customNavigator.dart';
import '../../../reels/reelsplayer/allrealspage.dart';
import '../../../reels/cubit/simple_reels_cubit.dart';
import '../../../dashboard/profile/repository/service.dart';
import '../../live/liveusers.dart';
import '../../live/cubit/liveCubit.dart';
import '../../home/repository/homerepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeHeader extends StatelessWidget {
  final GestureTapCallback onPressed;
  const HomeHeader({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
        width: 100.w,
        height: 7.h,
        decoration: BoxDecoration(),
        child: Row(
          children: [
            2.w.widthBox,
            Column(
              children: [
                GestureDetector(
                  onTap: (){
                    CustomNavigator.push(
                      context: context, 
                      screen: BlocProvider<LiveCubit>(
                        create: (context) => LiveCubit(HomeRepository()),
                        child: LiveUserList(),
                      )
                    );
                  },
                  child: CustomImageView(
                    imagePath: "assets/images/livehome.png",
                    height: 3.h,
                    width: 3.h,
                    color: Colors.green,
                  ),
                ),
                .5.h.heightBox,
                AppText(fontWeight: FontWeight.w500, size: 14.sp, text: "Live")
              ],
            ),
            const Spacer(),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    print("🚀 Reels button tapped");
                    print("🚀 Context mounted: ${context.mounted}");
                    try {
                      print("🚀 Creating SimpleReelsCubit...");
                      final cubit = SimpleReelsCubit(CorettaUserProfileRepo());
                      print("🚀 SimpleReelsCubit created: ${cubit.runtimeType}");
                      
                      print("🚀 Creating AllReels widget...");
                      final allReelsWidget = AllReels();
                      print("🚀 AllReels widget created: ${allReelsWidget.runtimeType}");
                      
                      print("🚀 Creating BlocProvider...");
                      final blocProvider = BlocProvider(
                        create: (context) => cubit,
                        child: allReelsWidget,
                      );
                      print("🚀 BlocProvider created: ${blocProvider.runtimeType}");
                      
                      print("🚀 Navigating to reels page...");
                      CustomNavigator.push(
                        context: context,
                        screen: blocProvider,
                      );
                      print("🚀 Navigation completed");
                    } catch (e) {
                      print("❌ Error navigating to reels: $e");
                      print("❌ Stack trace: ${StackTrace.current}");
                    }
                  },
                  child: CustomImageView(
                    imagePath: "assets/images/reels.png",
                    height: 3.h,
                    width: 3.h,
                    color: null,
                  ),
                ),

                .5.h.heightBox,
                AppText(fontWeight: FontWeight.w500, size: 14.sp, text: "Reels")
              ],
            ).onTap(onPressed),
            2.w.widthBox,
          ],
        ),
            ),
      );
  }
}

class DescreiptionContiner extends StatelessWidget {
  final String title;
  final List<Widget> childrens;
  final bool showContainer;

  const DescreiptionContiner(
      {super.key,
      required this.title,
      this.showContainer = true,
      required this.childrens});

  @override
  Widget build(BuildContext context) {
    return showContainer
        ? Container(
            width: DynamicSize.width(context),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                2.h.heightBox,
                Container(
                  height: 6.h,
                  width: 55.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white),
                  child: AppText(
                    fontWeight: FontWeight.w700,
                    size: 16.sp,
                    text: title,
                    color:AppColor.iconsColor,
                  ).centered(),
                ).centered(),
                Column(
                  children: childrens,
                )
              ],
            ),
          )
        : SpaceWidget();
  }
}

class MoreAboutMeOptions extends StatelessWidget {
  final IconData icons;
  final double widthText;
  final String title;
  const MoreAboutMeOptions(
      {super.key,
      required this.icons,
      required this.widthText,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return
      Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icons,
          color: AppColor.tinderclr,
          size: 20.sp,
        ),
        2.w.widthBox,
        SizedBox(
          width: widthText,
          child: AppText(
               textAlign: TextAlign.start,
              color:AppColor.black,
              fontWeight: FontWeight.w600,
              size: 16.sp,
              maxlin: 2,
              text: title),
        )
      ],
    );
  }
}
/*  ,
         */