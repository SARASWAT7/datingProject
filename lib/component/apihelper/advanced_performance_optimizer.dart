import 'dart:async';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'dart:developer';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';
import 'package:flutter/material.dart';
import 'package:demoproject/component/reuseable_widgets/apploder.dart';

/// Advanced performance optimization service for ultra-fast data loading
class AdvancedPerformanceOptimizer {
  static final AdvancedPerformanceOptimizer _instance = AdvancedPerformanceOptimizer._internal();
  factory AdvancedPerformanceOptimizer() => _instance;
  AdvancedPerformanceOptimizer._internal();

  // Cache management
  static final Map<String, dynamic> _dataCache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheDuration = Duration(minutes: 10); // Extended cache time
  
  // Image preloading
  static final Map<String, ImageProvider> _imageCache = {};
  static final List<String> _preloadingQueue = [];
  
  // API call optimization
  static final Map<String, Completer> _pendingRequests = {};

  /// Cache API response with smart invalidation
  static void cacheApiResponse(String endpoint, dynamic data) {
    _dataCache[endpoint] = data;
    _cacheTimestamps[endpoint] = DateTime.now();
    log("Cached API response for: $endpoint");
  }

  /// Get cached API response if valid
  static dynamic getCachedApiResponse(String endpoint) {
    if (_dataCache.containsKey(endpoint) && _cacheTimestamps.containsKey(endpoint)) {
      if (DateTime.now().difference(_cacheTimestamps[endpoint]!) < _cacheDuration) {
        log("Using cached data for: $endpoint");
        return _dataCache[endpoint];
      } else {
        // Cache expired
        _dataCache.remove(endpoint);
        _cacheTimestamps.remove(endpoint);
        log("Cache expired for: $endpoint");
      }
    }
    return null;
  }

  /// Smart API call with deduplication and caching
  static Future<T> smartApiCall<T>(
    String endpoint,
    Future<T> Function() apiCall,
    T Function(dynamic) fromJson,
  ) async {
    // Check cache first
    final cachedData = getCachedApiResponse(endpoint);
    if (cachedData != null) {
      // If cached data is already the correct type, return it directly
      if (cachedData is T) {
        log("✅ Returning cached object directly for: $endpoint");
        return cachedData;
      }
      // Otherwise convert it
      return fromJson(cachedData);
    }

    // Check if request is already in progress
    if (_pendingRequests.containsKey(endpoint)) {
      log("Request already in progress for: $endpoint, waiting...");
      return await _pendingRequests[endpoint]!.future as T;
    }

    // Create new request
    final completer = Completer<T>();
    _pendingRequests[endpoint] = completer;

    try {
      final result = await apiCall();
      cacheApiResponse(endpoint, result);
      completer.complete(result);
      return result;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _pendingRequests.remove(endpoint);
    }
  }

  /// Preload multiple images efficiently
  static Future<void> preloadImagesBatch(List<String> imageUrls) async {
    final futures = imageUrls.map((url) => _preloadSingleImage(url));
    await Future.wait(futures, eagerError: false);
  }

  /// Preload single image with caching
  static Future<void> _preloadSingleImage(String imageUrl) async {
    if (imageUrl.isEmpty || _imageCache.containsKey(imageUrl)) return;
    
    try {
      final imageProvider = CachedNetworkImageProvider(imageUrl);
      // Don't await the resolve as it's not a Future
      imageProvider.resolve(ImageConfiguration.empty);
      _imageCache[imageUrl] = imageProvider;
      log("Preloaded image: $imageUrl");
    } catch (e) {
      log("Failed to preload image: $imageUrl - $e");
    }
  }

  /// Optimized image widget with advanced caching
  static Widget buildUltraFastImage({
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
      memCacheWidth: (width * 1.2).toInt(), // Slightly larger cache for quality
      memCacheHeight: (height * 1.2).toInt(),
      maxWidthDiskCache: width.toInt() * 3, // Larger disk cache
      maxHeightDiskCache: height.toInt() * 3,
      cacheKey: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: placeholder ?? (context, url) => _buildOptimizedPlaceholder(width, height, borderRadius),
      errorWidget: errorWidget ?? (context, url, error) => _buildOptimizedErrorWidget(width, height, borderRadius),
    );
  }

  /// Optimized placeholder with shimmer effect
  static Widget _buildOptimizedPlaceholder(double width, double height, BorderRadius? borderRadius) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  /// Optimized error widget
  static Widget _buildOptimizedErrorWidget(double width, double height, BorderRadius? borderRadius) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Colors.grey[100],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              color: Colors.grey[400],
              size: 40,
            ),
            SizedBox(height: 8),
            Text(
              'Image unavailable',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Preload next user's data for instant transitions
  static Future<void> preloadNextUserData(List<dynamic> users, int currentIndex) async {
    try {
      final nextIndex = currentIndex + 1;
      if (nextIndex < users.length) {
        final nextUser = users[nextIndex];
        
        // Preload images
        if (nextUser.media?.isNotEmpty == true) {
          await preloadImagesBatch(nextUser.media!);
        }
        
        log("Preloaded next user data at index: $nextIndex");
      }
    } catch (e) {
      log("Error preloading next user data: $e");
    }
  }

  /// Clear all caches
  static void clearAllCaches() {
    _dataCache.clear();
    _cacheTimestamps.clear();
    _imageCache.clear();
    _preloadingQueue.clear();
    log("All caches cleared");
  }

  /// Clear specific cache entry
  static void clearCacheEntry(String endpoint) {
    _dataCache.remove(endpoint);
    _cacheTimestamps.remove(endpoint);
    log("Cache entry cleared for: $endpoint");
  }

  /// Get cache statistics
  static Map<String, dynamic> getCacheStats() {
    return {
      'dataCacheSize': _dataCache.length,
      'imageCacheSize': _imageCache.length,
      'pendingRequests': _pendingRequests.length,
    };
  }
}
