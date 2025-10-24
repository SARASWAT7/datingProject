import 'dart:developer';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:flutter/material.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';

/// Performance optimization service for faster loading and better caching
class PerformanceOptimizer {
  static final PerformanceOptimizer _instance = PerformanceOptimizer._internal();
  factory PerformanceOptimizer() => _instance;
  PerformanceOptimizer._internal();

  /// Cache for storing user data to avoid repeated API calls
  static final Map<String, dynamic> _userCache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);

  /// Preload images for better performance
  static Future<void> preloadUserImages(List<String> imageUrls, BuildContext context) async {
    try {
      for (String imageUrl in imageUrls) {
        if (imageUrl.isNotEmpty) {
          await precacheImage(
            CachedNetworkImageProvider(imageUrl),
            context,
          );
        }
      }
    } catch (e) {
      log('Error preloading images: $e');
    }
  }

  /// Cache user data for faster access
  static void cacheUserData(String userId, dynamic userData) {
    _userCache[userId] = userData;
    _cacheTimestamps[userId] = DateTime.now();
  }

  /// Get cached user data if available and not expired
  static dynamic getCachedUserData(String userId) {
    if (_userCache.containsKey(userId) && _cacheTimestamps.containsKey(userId)) {
      final cacheTime = _cacheTimestamps[userId]!;
      if (DateTime.now().difference(cacheTime) < _cacheExpiry) {
        return _userCache[userId];
      } else {
        // Remove expired cache
        _userCache.remove(userId);
        _cacheTimestamps.remove(userId);
      }
    }
    return null;
  }

  /// Clear expired cache entries
  static void clearExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = <String>[];
    
    _cacheTimestamps.forEach((key, timestamp) {
      if (now.difference(timestamp) > _cacheExpiry) {
        expiredKeys.add(key);
      }
    });
    
    for (String key in expiredKeys) {
      _userCache.remove(key);
      _cacheTimestamps.remove(key);
    }
  }

  /// Clear all cache
  static void clearAllCache() {
    _userCache.clear();
    _cacheTimestamps.clear();
  }

  /// Optimized image widget with better caching
  static Widget buildOptimizedImage({
    required String imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget Function(BuildContext, String)? placeholder,
    Widget Function(BuildContext, String, Object)? errorWidget,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: (width * 2).round(), // High quality cache
      memCacheHeight: (height * 2).round(),
      maxWidthDiskCache: (width * 3).round(), // Large disk cache
      maxHeightDiskCache: (height * 3).round(),
      cacheKey: imageUrl, // Ensure proper caching
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: placeholder ?? (context, url) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Colors.grey[200],
        ),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.grey[400],
          ),
        ),
      ),
      errorWidget: errorWidget ?? (context, url, error) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Colors.grey[100],
        ),
        child: Center(
          child: Icon(
            Icons.person,
            color: Colors.grey[400],
            size: 40,
          ),
        ),
      ),
    );
  }

  /// Preload next user's images for smooth transitions
  static Future<void> preloadNextUserImages(List<String> imageUrls) async {
    try {
      for (String imageUrl in imageUrls) {
        if (imageUrl.isNotEmpty) {
          // Preload in background without blocking UI
          CachedNetworkImageProvider(imageUrl).resolve(ImageConfiguration.empty);
        }
      }
    } catch (e) {
      log('Error preloading next user images: $e');
    }
  }

  /// Optimize API calls by batching requests
  static Future<List<T>> batchApiCalls<T>(
    List<Future<T> Function()> apiCalls, {
    int maxConcurrent = 3,
  }) async {
    final results = <T>[];
    
    for (int i = 0; i < apiCalls.length; i += maxConcurrent) {
      final batch = apiCalls.skip(i).take(maxConcurrent);
      final batchResults = await Future.wait(batch.map((call) => call()));
      results.addAll(batchResults);
    }
    
    return results;
  }

  /// Get cache statistics for monitoring
  static Map<String, dynamic> getCacheStats() {
    return {
      'cachedUsers': _userCache.length,
      'cacheSize': _userCache.toString().length,
      'oldestCache': _cacheTimestamps.values.isNotEmpty 
          ? _cacheTimestamps.values.reduce((a, b) => a.isBefore(b) ? a : b)
          : null,
    };
  }
}
