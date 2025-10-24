import 'dart:async';
import 'dart:developer';
import 'package:demoproject/component/apihelper/fast_data_service.dart';
import 'package:demoproject/component/apihelper/advanced_performance_optimizer.dart';

/// Startup optimization service for ultra-fast app initialization
class StartupOptimizer {
  static final StartupOptimizer _instance = StartupOptimizer._internal();
  factory StartupOptimizer() => _instance;
  StartupOptimizer._internal();

  static bool _isInitialized = false;
  static final FastDataService _fastDataService = FastDataService();

  /// Initialize app with critical data preloading
  static Future<void> initializeApp() async {
    if (_isInitialized) {
      log("✅ App already initialized");
      return;
    }

    log("🚀 Starting ultra-fast app initialization...");
    
    try {
      // Initialize fast data service
      await _fastDataService.initialize();
      
      // Preload critical data in background
      _preloadCriticalDataInBackground();
      
      _isInitialized = true;
      log("✅ App initialization completed");
    } catch (e) {
      log("❌ App initialization error: $e");
    }
  }

  /// Preload critical data without blocking startup
  static void _preloadCriticalDataInBackground() {
    Timer(Duration(milliseconds: 500), () async {
      try {
        log("🔄 Preloading critical data in background...");
        
        // Preload home and explore data
        await _fastDataService.preloadCriticalData();
        
        log("✅ Critical data preloaded successfully");
      } catch (e) {
        log("❌ Background preload error: $e");
      }
    });
  }

  /// Get initialization status
  static bool get isInitialized => _isInitialized;

  /// Force refresh all caches
  static Future<void> refreshAllCaches() async {
    log("🔄 Refreshing all caches...");
    
    // Clear existing caches
    AdvancedPerformanceOptimizer.clearAllCaches();
    _fastDataService.clearAllCaches();
    
    // Preload fresh data
    await _fastDataService.preloadCriticalData();
    
    log("✅ All caches refreshed");
  }

  /// Get performance statistics
  static Map<String, dynamic> getPerformanceStats() {
    return {
      'isInitialized': _isInitialized,
      'cacheStats': AdvancedPerformanceOptimizer.getCacheStats(),
    };
  }
}
