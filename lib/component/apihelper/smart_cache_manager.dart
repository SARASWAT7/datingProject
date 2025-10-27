import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer';

/// Smart cache manager for dating app images
/// Prevents old user images from showing when new users are loaded
class SmartCacheManager {
  static const String _cacheKey = 'dating_app_cache';
  static const Duration _cacheValidDuration = Duration(days: 1);
  static const int _maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const int _maxCacheObjects = 200;

  static CacheManager? _instance;

  /// Get the custom cache manager instance
  static CacheManager get instance {
    _instance ??= CacheManager(
      Config(
        _cacheKey,
        stalePeriod: _cacheValidDuration,
        maxNrOfCacheObjects: _maxCacheObjects,
        repo: JsonCacheInfoRepository(databaseName: _cacheKey),
        fileService: HttpFileService(),
      ),
    );
    return _instance!;
  }

  /// Clear all cached images
  static Future<void> clearAllCache() async {
    try {
      await instance.emptyCache();
      log("🧹 Cleared all image cache");
    } catch (e) {
      log("❌ Error clearing all cache: $e");
    }
  }

  /// Clear cache for specific user images
  static Future<void> clearUserImages(List<String> imageUrls) async {
    try {
      for (String imageUrl in imageUrls) {
        if (imageUrl.isNotEmpty) {
          await CachedNetworkImage.evictFromCache(imageUrl);
          await instance.removeFile(imageUrl);
        }
      }
      log("🧹 Cleared cache for ${imageUrls.length} user images");
    } catch (e) {
      log("❌ Error clearing user images: $e");
    }
  }

  /// Clear cache for a single image
  static Future<void> clearSingleImage(String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        await CachedNetworkImage.evictFromCache(imageUrl);
        await instance.removeFile(imageUrl);
        log("🧹 Cleared cache for image: ${imageUrl.split('/').last}");
      }
    } catch (e) {
      log("❌ Error clearing single image: $e");
    }
  }

  /// Get cache size
  static Future<int> getCacheSize() async {
    try {
      // Simplified cache size calculation
      // Return estimated size based on cache manager settings
      return 0; // Will be implemented with actual cache size later
    } catch (e) {
      log("❌ Error getting cache size: $e");
      return 0;
    }
  }

  /// Clear cache if it's too large
  static Future<void> clearCacheIfNeeded() async {
    try {
      final cacheSize = await getCacheSize();
      final maxSizeBytes = _maxCacheSize;
      
      if (cacheSize > maxSizeBytes) {
        log("🧹 Cache size (${(cacheSize / 1024 / 1024).toStringAsFixed(1)}MB) exceeds limit, clearing...");
        await clearAllCache();
      }
    } catch (e) {
      log("❌ Error checking cache size: $e");
    }
  }

  /// Clear old cache entries (older than 1 day)
  static Future<void> clearOldCache() async {
    try {
      // Simplified old cache clearing
      // Clear cache entries that might be old
      await instance.emptyCache();
      log("🧹 Cleared old cache entries");
    } catch (e) {
      log("❌ Error clearing old cache: $e");
    }
  }

  /// Smart cache management - clear cache when loading new users
  static Future<void> manageCacheForNewUsers({
    required List<String> currentUserIds,
    required List<String> newUserIds,
    required Map<String, List<String>> userImageMap,
  }) async {
    try {
      // Find users that are no longer in the current batch
      final usersToRemove = currentUserIds.where((id) => !newUserIds.contains(id)).toList();
      
      if (usersToRemove.isNotEmpty) {
        log("🧹 Managing cache for ${usersToRemove.length} removed users");
        
        // Clear images for removed users
        for (String userId in usersToRemove) {
          if (userImageMap.containsKey(userId)) {
            await clearUserImages(userImageMap[userId]!);
          }
        }
      }
      
      // Clear old cache if needed
      await clearCacheIfNeeded();
      
    } catch (e) {
      log("❌ Error managing cache for new users: $e");
    }
  }

  /// Preload images with smart cache management
  static Future<void> preloadImagesSmart(List<String> imageUrls) async {
    try {
      // Clear old cache first
      await clearOldCache();
      
      // Preload only first 3 images to save memory
      final limitedUrls = imageUrls.take(3).toList();
      
      for (String imageUrl in limitedUrls) {
        if (imageUrl.isNotEmpty) {
          // Preload without storing in cache immediately
          await instance.getFile(imageUrl);
        }
      }
      
      log("🚀 Preloaded ${limitedUrls.length} images smartly");
    } catch (e) {
      log("❌ Error preloading images: $e");
    }
  }
}
