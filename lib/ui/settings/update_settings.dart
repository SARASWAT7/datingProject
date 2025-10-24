import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:demoproject/service/app_update_service.dart';
import 'package:demoproject/service/update_manager.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';
import 'package:flutter/foundation.dart';

class UpdateSettings extends StatefulWidget {
  const UpdateSettings({Key? key}) : super(key: key);

  @override
  State<UpdateSettings> createState() => _UpdateSettingsState();
}

class _UpdateSettingsState extends State<UpdateSettings> {
  String currentVersion = '';
  String appName = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      currentVersion = await AppUpdateService.getCurrentVersion();
      appName = await AppUpdateService.getAppName();
      setState(() {});
    } catch (e) {
      debugPrint('Error loading app info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Updates'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Info Card
            Container(
              padding: EdgeInsets.all(20.sp),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 8.h,
                        width: 8.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [AppColor.activeiconclr, AppColor.tinderclr],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.system_update,
                          size: 4.h,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: appName,
                              size: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            SizedBox(height: 0.5.h),
                            AppText(
                              text: 'Version $currentVersion',
                              size: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600]!,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 3.h),
            
            // Update Options
            AppText(
              text: 'Update Options',
              size: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            
            SizedBox(height: 2.h),
            
            // Check for Updates Button
            Container(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: _checkForUpdates,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.activeiconclr,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(isLoading ? 'Checking...' : 'Check for Updates'),
              ),
            ),
            
            SizedBox(height: 2.h),
            
            // Manual Update Button
            Container(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: _openAppStore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200]!,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Open App Store'),
              ),
            ),
            
            SizedBox(height: 3.h),
            
            // Update Information
            Container(
              padding: EdgeInsets.all(15.sp),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[700],
                        size: 20.sp,
                      ),
                      SizedBox(width: 2.w),
                      AppText(
                        text: 'Update Information',
                        size: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700]!,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  AppText(
                    text: '• Updates are checked automatically when you open the app',
                    size: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue[600]!,
                  ),
                  SizedBox(height: 0.5.h),
                  AppText(
                    text: '• Critical updates may require immediate installation',
                    size: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue[600]!,
                  ),
                  SizedBox(height: 0.5.h),
                  AppText(
                    text: '• You can skip non-critical updates temporarily',
                    size: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue[600]!,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 2.h),
            
            // Reset Update Dismissal (for testing)
            if (kDebugMode) ...[
              Container(
                width: double.infinity,
                height: 5.h,
                child: ElevatedButton(
                  onPressed: _resetUpdateDismissal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[200]!,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text('Reset Update Dismissal (Debug)'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _checkForUpdates() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      await UpdateManager.manualUpdateCheck(context);
    } catch (e) {
      _showErrorDialog('Failed to check for updates. Please try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _openAppStore() async {
    try {
      await AppUpdateService.launchAppStore();
    } catch (e) {
      _showErrorDialog('Failed to open app store. Please try again.');
    }
  }

  Future<void> _resetUpdateDismissal() async {
    try {
      await UpdateManager.resetUpdateDismissal();
      _showSuccessDialog('Update dismissal has been reset. You will be notified of updates again.');
    } catch (e) {
      _showErrorDialog('Failed to reset update dismissal.');
    }
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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
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
