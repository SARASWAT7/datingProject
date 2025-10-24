import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:demoproject/service/app_update_service.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';

class UpdateDialog extends StatefulWidget {
  final bool isForceUpdate;
  
  const UpdateDialog({
    Key? key,
    this.isForceUpdate = false,
  }) : super(key: key);

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  String currentVersion = '';
  String appName = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      currentVersion = await AppUpdateService.getCurrentVersion();
      appName = await AppUpdateService.getAppName();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back button if it's a force update
        return !widget.isForceUpdate;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App Icon
              Container(
                height: 12.h,
                width: 12.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [AppColor.activeiconclr, AppColor.tinderclr],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.activeiconclr.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.system_update,
                  size: 6.h,
                  color: Colors.white,
                ),
              ),
              
              SizedBox(height: 2.h),
              
              // Title
              AppText(
                text: 'Update Available',
                size: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              
              SizedBox(height: 1.h),
              
              // Subtitle
              AppText(
                text: 'A new version of $appName is available',
                size: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]!,
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 1.h),
              
              // Current version info
              if (!isLoading)
                AppText(
                  text: 'Current Version: $currentVersion',
                  size: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500]!,
                ),
              
              SizedBox(height: 2.h),
              
              // Update features
              Container(
                padding: EdgeInsets.all(15.sp),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildFeatureItem(
                      icon: Icons.bug_report,
                      title: 'Bug Fixes',
                    ),
                    SizedBox(height: 1.h),
                    _buildFeatureItem(
                      icon: Icons.security,
                      title: 'Security Updates',
                    ),
                    SizedBox(height: 1.h),
                    _buildFeatureItem(
                      icon: Icons.new_releases,
                      title: 'New Features',
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 2.h),
              
              // Update button
              SizedBox(
                width: double.infinity,
                height: 5.h,
                child: ElevatedButton(
                  onPressed: _updateApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.activeiconclr,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text('Update Now'),
                ),
              ),
              
              // Skip button (only if not force update)
              if (!widget.isForceUpdate) ...[
                SizedBox(height: 1.h),
                TextButton(
                  onPressed: _skipUpdate,
                  child: AppText(
                    text: 'Skip for now',
                    size: 12.sp,
                    color: Colors.grey[600]!,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColor.activeiconclr,
          size: 16.sp,
        ),
        SizedBox(width: 2.w),
        AppText(
          text: title,
          size: 12.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ],
    );
  }

  Future<void> _updateApp() async {
    try {
      await AppUpdateService.launchAppStore();
    } catch (e) {
      _showErrorDialog('Failed to open app store. Please try again.');
    }
  }

  Future<void> _skipUpdate() async {
    await AppUpdateService.dismissUpdate();
    Navigator.of(context).pop();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
