import 'dart:async';
import 'dart:developer';
import 'package:demoproject/component/apihelper/advanced_performance_optimizer.dart';
import 'package:demoproject/component/apihelper/api_service.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/ui/dashboard/home/model/homeresponse.dart';
import 'package:demoproject/ui/dashboard/explore/model/exploremodel.dart';
import 'package:demoproject/ui/dashboard/home/repository/urlpath.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Ultra-fast data service with intelligent caching and preloading
class FastDataService {
  static final FastDataService _instance = FastDataService._internal();
  factory FastDataService() => _instance;
  FastDataService._internal();

  String token = "";

  /// Initialize service
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token") ?? "";
  }

  /// Get home data with smart caching
  Future<HomeResponse> getHomeData() async {
    await initialize();
    
    return await AdvancedPerformanceOptimizer.smartApiCall<HomeResponse>(
      'home_data',
      () async {
        log("🚀 Fetching home data from API...");
        final response = await ApiService(token: token).sendRequest.get(HomeUriPath.homeApi);
        log("✅ API response received: ${response.statusCode}");
        log("📊 Response data type: ${response.data.runtimeType}");
        log("📊 Response data keys: ${response.data is Map ? (response.data as Map).keys.toList() : 'Not a Map'}");
        
        try {
          final homeResponse = HomeResponse.fromJson(response.data);
          log("✅ HomeResponse parsed successfully: ${homeResponse.result?.users?.length ?? 0} users");
          return homeResponse;
        } catch (parseError) {
          log("❌ Error parsing HomeResponse: $parseError");
          log("❌ Parse error type: ${parseError.runtimeType}");
          log("❌ Response data: ${response.data}");
          rethrow;
        }
      },
      (data) {
        log("🔄 Converting cached data to HomeResponse...");
        try {
          final homeResponse = HomeResponse.fromJson(data);
          log("✅ Cached data converted successfully: ${homeResponse.result?.users?.length ?? 0} users");
          return homeResponse;
        } catch (parseError) {
          log("❌ Error converting cached data: $parseError");
          rethrow;
        }
      },
    );
  }

  /// Get explore data with smart caching
  Future<ExploreResponse> getExploreData() async {
    await initialize();
    
    return await AdvancedPerformanceOptimizer.smartApiCall<ExploreResponse>(
      'explore_data',
      () async {
        final response = await ApiService(token: token).sendRequest.get(UrlEndpoints.exploreApi);
        log("Explore data fetched from API");
        return ExploreResponse.fromJson(response.data);
      },
      (data) => ExploreResponse.fromJson(data),
    );
  }

  /// Preload critical data in background
  Future<void> preloadCriticalData() async {
    try {
      // Preload home and explore data in parallel
      try {
        await getHomeData();
        await getExploreData();
      } catch (e) {
        log("Preload error: $e");
      }
      log("Critical data preloaded successfully");
    } catch (e) {
      log("Error preloading critical data: $e");
    }
  }

  /// Get cached data if available, otherwise fetch fresh
  Future<HomeResponse?> getCachedHomeData() async {
    final cachedData = AdvancedPerformanceOptimizer.getCachedApiResponse('home_data');
    if (cachedData != null) {
      // If it's already a HomeResponse, return it directly
      if (cachedData is HomeResponse) {
        log("✅ Returning cached HomeResponse directly");
        return cachedData;
      }
      // Otherwise convert from JSON
      return HomeResponse.fromJson(cachedData);
    }
    return null;
  }

  /// Invalidate specific cache
  void invalidateCache(String endpoint) {
    AdvancedPerformanceOptimizer.clearCacheEntry(endpoint);
    log("Cache invalidated for: $endpoint");
  }

  /// Clear all caches
  void clearAllCaches() {
    AdvancedPerformanceOptimizer.clearAllCaches();
  }
}
