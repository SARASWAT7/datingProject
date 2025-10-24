import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:demoproject/ui/dashboard/notification/notimodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../component/apihelper/urls.dart';
import '../../../component/commonfiles/appcolor.dart';
import '../../../component/reuseable_widgets/appBar.dart';
import '../../../component/reuseable_widgets/apptext.dart';
import '../../../component/utils/assets.dart';
import 'cubit/noticubit.dart';
import 'cubit/notistate.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isToggled = false;

  @override
  void initState() {
    super.initState();
    context.read<NotificationListCubit>().NotiList(context);
  }
  @override
  Future<void> dispose() async {
    super.dispose();
    await DefaultCacheManager().emptyCache();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;

    return Scaffold(
      appBar: appBarWidgetThree(
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
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
        title: "Notification",
        titleColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<NotificationListCubit, NotificationListState>(
        builder: (context, state) {
          if (state.status == ApiStates.loading) {
            return Center(child: AppLoader());
          } else if (state.status == ApiStates.error) {
            return Center(
              child: Text(
                'No Notification',
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (state.status == ApiStates.success && state.response?.result != null) {
            List<Result> notifications = state.response!.result!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  // Container(
                  //   width: width * 0.9,
                  //   height: height * 0.06,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(20),
                  //     border: Border.all(color: const Color(0xffBDBDBD), width: 1.2),
                  //     color: Colors.transparent,
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 10),
                  //         child: AppText(
                  //           size: width * 0.04,
                  //           text: 'Push Notifications',
                  //           fontWeight: FontWeight.w400,
                  //         ),
                  //       ),
                  //       Spacer(),
                  //       Switch(
                  //         activeColor: AppColor.tinderclr,
                  //         inactiveThumbColor: Colors.grey.shade300,
                  //         inactiveTrackColor: Colors.white,
                  //         value: isToggled,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             isToggled = value;
                  //           });
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: height * 0.02),
                  Container(
                    height: height * 0.9,
                    width: width,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFC8D3),
                      borderRadius: BorderRadius.circular(45),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.01),
                        Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.read<NotificationListCubit>().delNotiall(context);
                            },
                            child: Text(
                              'Clear All',
                              style: TextStyle(
                                color: AppColor.activeiconclr,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                fontFamily: 'Nunito Sans',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = notifications[index];
                              return Slidable(
                                key: ValueKey(notification.id),
                                direction: Axis.horizontal,
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(

                                      onPressed: (context) {
                                        context.read<NotificationListCubit>().Deleteid(context, notification.id.toString());

                                      },
                                      backgroundColor: AppColor.tinderclr,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,

                                      label: 'Delete',

                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: width * 0.03),
                                  width: 100.w,
                                  height: height * 0.08,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: const Color(0xffBDBDBD), width: 1.0),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: width * 0.07,
                                        backgroundImage: notification.senderProfilePicture != null
                                            ? NetworkImage(notification.senderProfilePicture!)
                                            : AssetImage(Assets.girl) as ImageProvider,
                                      ).pOnly(left: 2.w),
                                      SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          AppText(
                                          hello: TextOverflow.ellipsis,
                                            size: width * 0.035,
                                            text: notification.title ?? 'No title',
                                            fontWeight: FontWeight.w700,
                                          ),
                                          AppText(

                                            hello: TextOverflow.ellipsis,
                                            size: width * 0.03,
                                            text: notification.message ?? 'No message',
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700,

                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                'No notifications available.',
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
