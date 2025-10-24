import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:demoproject/service/app_update_service.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';

class UpdateScreen extends StatefulWidget {
  final bool isForceUpdate;
  
  const UpdateScreen({
    Key? key,
    this.isForceUpdate = false,
  }) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
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
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Icon
                Container(
                  height: 20.h,
                  width: 20.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [AppColor.activeiconclr, AppColor.tinderclr],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.activeiconclr.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.system_update,
                    size: 10.h,
                    color: Colors.white,
                  ),
                ),
                
                SizedBox(height: 4.h),
                
                // Title
                AppText(
                  text: 'Update Available',
                  size: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                
                SizedBox(height: 2.h),
                
                // Subtitle
                AppText(
                  text: 'A new version of $appName is available',
                  size: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]!,
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 1.h),
                
                // Current version info
                if (!isLoading)
                  AppText(
                    text: 'Current Version: $currentVersion',
                    size: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500]!,
                  ),
                
                SizedBox(height: 4.h),
                
                // Update features list
                Container(
                  padding: EdgeInsets.all(20.sp),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      _buildFeatureItem(
                        icon: Icons.bug_report,
                        title: 'Bug Fixes',
                        description: 'Improved app stability and performance',
                      ),
                      SizedBox(height: 2.h),
                      _buildFeatureItem(
                        icon: Icons.security,
                        title: 'Security Updates',
                        description: 'Enhanced security and privacy protection',
                      ),
                      SizedBox(height: 2.h),
                      _buildFeatureItem(
                        icon: Icons.new_releases,
                        title: 'New Features',
                        description: 'Exciting new features and improvements',
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 4.h),
                
                // Update button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _updateApp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.activeiconclr,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Update Now'),
                  ),
                ),
                
                // Skip button (only if not force update)
                if (!widget.isForceUpdate) ...[
                  SizedBox(height: 2.h),
                  TextButton(
                    onPressed: _skipUpdate,
                    child: AppText(
                      text: 'Skip for now',
                      size: 14.sp,
                      color: Colors.grey[600]!,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                
                SizedBox(height: 2.h),
                
                // Note
                AppText(
                  text: 'Please update to continue using the app',
                  size: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500]!,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: AppColor.activeiconclr.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColor.activeiconclr,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: title,
                size: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              SizedBox(height: 0.5.h),
              AppText(
                text: description,
                size: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600]!,
              ),
            ],
          ),
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
