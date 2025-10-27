import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:demoproject/component/apihelper/smart_cache_manager.dart';
import 'package:demoproject/component/commonfiles/appcolor.dart';
import 'package:demoproject/component/reuseable_widgets/apptext.dart';

class CacheSettings extends StatefulWidget {
  const CacheSettings({Key? key}) : super(key: key);

  @override
  State<CacheSettings> createState() => _CacheSettingsState();
}

class _CacheSettingsState extends State<CacheSettings> {
  bool isLoading = false;
  String cacheSize = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadCacheInfo();
  }

  Future<void> _loadCacheInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      final size = await SmartCacheManager.getCacheSize();
      final sizeInMB = (size / 1024 / 1024).toStringAsFixed(1);
      setState(() {
        cacheSize = "${sizeInMB} MB";
      });
    } catch (e) {
      setState(() {
        cacheSize = "Error loading cache info";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _clearAllCache() async {
    setState(() {
      isLoading = true;
    });

    try {
      await SmartCacheManager.clearAllCache();
      await _loadCacheInfo();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('All cache cleared successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing cache: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _clearOldCache() async {
    setState(() {
      isLoading = true;
    });

    try {
      await SmartCacheManager.clearOldCache();
      await _loadCacheInfo();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Old cache entries cleared!'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing old cache: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Cache Management',
          size: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.black,
        ),
        backgroundColor: AppColor.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cache Info
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.storage, color: Colors.blue, size: 30.sp),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: 'Current Cache Size',
                        size: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      SizedBox(height: 0.5.h),
                      AppText(
                        text: cacheSize,
                        size: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600]!,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Clear All Cache Button
            Container(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : _clearAllCache,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(isLoading ? 'Clearing...' : 'Clear All Cache'),
              ),
            ),

            SizedBox(height: 2.h),

            // Clear Old Cache Button
            Container(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : _clearOldCache,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(isLoading ? 'Clearing...' : 'Clear Old Cache'),
              ),
            ),

            SizedBox(height: 2.h),

            // Refresh Button
            Container(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : _loadCacheInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Refresh Cache Info'),
              ),
            ),

            SizedBox(height: 3.h),

            // Information
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
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
                        text: 'Cache Information',
                        size: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700]!,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  AppText(
                    text: '• Clear All Cache: Removes all cached images and data',
                    size: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600]!,
                  ),
                  SizedBox(height: 0.5.h),
                  AppText(
                    text: '• Clear Old Cache: Removes cache entries older than 1 day',
                    size: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600]!,
                  ),
                  SizedBox(height: 0.5.h),
                  AppText(
                    text: '• Cache helps load images faster but can show old user data',
                    size: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600]!,
                  ),
                  SizedBox(height: 0.5.h),
                  AppText(
                    text: '• Clear cache if you see wrong user images',
                    size: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.red[600]!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
