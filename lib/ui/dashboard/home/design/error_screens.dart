import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:demoproject/ui/dashboard/filter/filter.dart';

/// Beautiful error screens for different scenarios
class ErrorScreens {
  
  /// No more profiles error screen
  static Widget noMoreProfilesError({
    required BuildContext context,
    VoidCallback? onRefresh,
    VoidCallback? onAdjustFilters,
  }) {
    return Container(
      height: 70.h,
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
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated heart icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.pink.shade100,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite_outline_rounded,
                        size: 40.sp,
                        color: Colors.pink.shade400,
                      ),
                    ),
                  );
                },
              ),
              
              3.h.heightBox,
              
              // Main message
              AppText(
                fontWeight: FontWeight.w700,
                size: 18.sp,
                text: "You're all caught up! 💕",
                color: Colors.pink.shade700,
              ),
              
              1.h.heightBox,
              
              // Sub message
              AppText(
                fontWeight: FontWeight.w400,
                size: 12.sp,
                text: "No more profiles in your current area.",
                color: Colors.grey.shade600,
              ),
              
              0.5.h.heightBox,
              
              // Info box
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16.sp,
                      color: Colors.blue.shade600,
                    ),
                    SizedBox(width: 1.w),
                    AppText(
                      fontWeight: FontWeight.w500,
                      size: 10.sp,
                      text: "New users will appear here as they join!",
                      color: Colors.blue.shade700,
                    ),
                  ],
                ),
              ),
              
              3.h.heightBox,
              
              // Action buttons
              Row(
                children: [
                  // Adjust Filters button
                  Expanded(
                    child: SizedBox(
                      height: 50.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffFD5564),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: onAdjustFilters ?? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FilterScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.tune_rounded, size: 18.sp),
                            SizedBox(width: 1.w),
                            AppText(
                              fontWeight: FontWeight.w600,
                              size: 12.sp,
                              text: "Adjust Filters",
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 3.w),
                  
                  // Refresh button
                  Expanded(
                    child: SizedBox(
                      height: 50.h,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xffFD5564), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: onRefresh,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh_rounded, size: 18.sp, color: const Color(0xffFD5564)),
                            SizedBox(width: 1.w),
                            AppText(
                              fontWeight: FontWeight.w600,
                              size: 12.sp,
                              text: "Refresh",
                              color: const Color(0xffFD5564),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Network error screen
  static Widget networkError({
    required BuildContext context,
    VoidCallback? onRetry,
  }) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 32.sp,
                color: Colors.red.shade400,
              ),
              
              1.h.heightBox,
              
              AppText(
                fontWeight: FontWeight.w600,
                size: 14.sp,
                text: "No Internet Connection",
                color: Colors.red.shade700,
              ),
              
              0.5.h.heightBox,
              
              AppText(
                fontWeight: FontWeight.w400,
                size: 11.sp,
                text: "Please check your connection and try again",
                color: Colors.red.shade600,
              ),
              
              2.h.heightBox,
              
              SizedBox(
                width: double.infinity,
                height: 40.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onRetry,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh_rounded, size: 16.sp),
                      SizedBox(width: 1.w),
                      AppText(
                        fontWeight: FontWeight.w600,
                        size: 12.sp,
                        text: "Try Again",
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
    );
  }
  
  /// Loading error screen
  static Widget loadingError({
    required BuildContext context,
    VoidCallback? onRetry,
    String? message,
  }) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 32.sp,
                color: Colors.orange.shade400,
              ),
              
              1.h.heightBox,
              
              AppText(
                fontWeight: FontWeight.w600,
                size: 14.sp,
                text: "Failed to Load",
                color: Colors.orange.shade700,
              ),
              
              0.5.h.heightBox,
              
              AppText(
                fontWeight: FontWeight.w400,
                size: 11.sp,
                text: message ?? "Something went wrong. Please try again.",
                color: Colors.orange.shade600,
                textAlign: TextAlign.center,
              ),
              
              2.h.heightBox,
              
              SizedBox(
                width: double.infinity,
                height: 40.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onRetry,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh_rounded, size: 16.sp),
                      SizedBox(width: 1.w),
                      AppText(
                        fontWeight: FontWeight.w600,
                        size: 12.sp,
                        text: "Retry",
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
    );
  }
}
