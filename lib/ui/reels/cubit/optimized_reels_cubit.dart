import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demoproject/component/apihelper/fast_data_service.dart';
import 'package:demoproject/ui/dashboard/profile/repository/service.dart';
import '../optimized_reels_player.dart';

/// Optimized reels cubit with intelligent caching and preloading
class OptimizedReelsCubit extends Cubit<OptimizedReelsState> {
  final CorettaUserProfileRepo _repository;
  final FastDataService _fastDataService = FastDataService();
  
  // Caching and preloading
  final Map<int, List<ReelData>> _pageCache = {};
  final Map<String, ReelData> _reelCache = {};
  Timer? _preloadTimer;
  
  // Pagination
  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  OptimizedReelsCubit(this._repository) : super(const OptimizedReelsState()) {
    _startPreloading();
  }

  @override
  Future<void> close() {
    _preloadTimer?.cancel();
    return super.close();
  }

  /// Start background preloading
  void _startPreloading() {
    _preloadTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _preloadNextPage();
    });
  }

  /// Preload next page in background
  void _preloadNextPage() {
    if (!_isLoadingMore && _hasMoreData) {
      _loadReelsPage(_currentPage + 1, isPreload: true);
    }
  }

  /// Load initial reels with caching
  Future<void> loadInitialReels() async {
    try {
      emit(state.copyWith(status: ApiStates.loading));
      
      // Check cache first
      final cachedReels = _pageCache[1];
      if (cachedReels != null && cachedReels.isNotEmpty) {
        log("✅ Using cached reels for instant loading");
        emit(state.copyWith(
          status: ApiStates.success,
          reels: cachedReels,
          currentPage: 1,
        ));
        
        // Preload next page in background
        _preloadNextPage();
        return;
      }
      
      // Load fresh data
      await _loadReelsPage(1);
    } catch (e) {
      log("❌ Error loading initial reels: $e");
      emit(state.copyWith(
        status: ApiStates.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Load specific page of reels
  Future<void> _loadReelsPage(int page, {bool isPreload = false}) async {
    if (_isLoadingMore && !isPreload) return;
    
    try {
      if (!isPreload) {
        _isLoadingMore = true;
        emit(state.copyWith(isLoadingMore: true));
      }
      
      log("🔄 Loading reels page $page (preload: $isPreload)");
      
      final response = await _repository.getAllReels(
        pageNumber: page,
        pageSize: _pageSize,
      );
      
      final newReels = _convertToReelData(response.result ?? []);
      
      // Cache the page
      _pageCache[page] = newReels;
      
      // Cache individual reels
      for (final reel in newReels) {
        _reelCache[reel.videoId] = reel;
      }
      
      if (!isPreload) {
        final allReels = _getAllReels();
        emit(state.copyWith(
          status: ApiStates.success,
          reels: allReels,
          currentPage: page,
          isLoadingMore: false,
        ));
        
        _currentPage = page;
        _hasMoreData = newReels.length == _pageSize;
      }
      
      log("✅ Loaded ${newReels.length} reels for page $page");
    } catch (e) {
      log("❌ Error loading reels page $page: $e");
      if (!isPreload) {
        emit(state.copyWith(
          status: ApiStates.error,
          errorMessage: e.toString(),
          isLoadingMore: false,
        ));
      }
    } finally {
      if (!isPreload) {
        _isLoadingMore = false;
      }
    }
  }

  /// Load more reels (pagination)
  Future<void> loadMoreReels() async {
    if (_isLoadingMore || !_hasMoreData) return;
    
    log("🔄 Loading more reels...");
    await _loadReelsPage(_currentPage + 1);
  }

  /// Get all reels from cache
  List<ReelData> _getAllReels() {
    final allReels = <ReelData>[];
    for (int page = 1; page <= _currentPage; page++) {
      final pageReels = _pageCache[page];
      if (pageReels != null) {
        allReels.addAll(pageReels);
      }
    }
    return allReels;
  }

  /// Convert API response to ReelData
  List<ReelData> _convertToReelData(List<dynamic> apiReels) {
    return apiReels.map((reel) {
      return ReelData(
        videoUrl: reel.videoUrl ?? '',
        profilePicture: reel.profilePicture ?? '',
        userName: "${reel.firstName ?? ''} ${reel.lastName ?? ''}".trim(),
        caption: reel.caption ?? '',
        likeCount: reel.totalLikes ?? 0,
        commentCount: reel.totalComment ?? 0,
        userId: reel.userId ?? '',
        videoId: reel.videoId ?? '',
        likeStatus: reel.isLikedByMe ?? false,
      );
    }).toList();
  }

  /// Update like status for a reel
  void updateReelLike(int index, bool isLiked) {
    final reels = List<ReelData>.from(state.reels);
    if (index < reels.length) {
      final reel = reels[index];
      final updatedReel = ReelData(
        videoUrl: reel.videoUrl,
        profilePicture: reel.profilePicture,
        userName: reel.userName,
        caption: reel.caption,
        likeCount: isLiked ? reel.likeCount + 1 : (reel.likeCount - 1).clamp(0, double.infinity).toInt(),
        commentCount: reel.commentCount,
        userId: reel.userId,
        videoId: reel.videoId,
        likeStatus: isLiked,
      );
      
      reels[index] = updatedReel;
      _reelCache[reel.videoId] = updatedReel;
      
      emit(state.copyWith(reels: reels));
    }
  }

  /// Update comment count for a reel
  void updateReelComment(int index, int newCount) {
    final reels = List<ReelData>.from(state.reels);
    if (index < reels.length) {
      final reel = reels[index];
      final updatedReel = ReelData(
        videoUrl: reel.videoUrl,
        profilePicture: reel.profilePicture,
        userName: reel.userName,
        caption: reel.caption,
        likeCount: reel.likeCount,
        commentCount: newCount,
        userId: reel.userId,
        videoId: reel.videoId,
        likeStatus: reel.likeStatus,
      );
      
      reels[index] = updatedReel;
      _reelCache[reel.videoId] = updatedReel;
      
      emit(state.copyWith(reels: reels));
    }
  }

  /// Clear cache
  void clearCache() {
    _pageCache.clear();
    _reelCache.clear();
    _currentPage = 1;
    _hasMoreData = true;
    _isLoadingMore = false;
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'cachedPages': _pageCache.length,
      'cachedReels': _reelCache.length,
      'currentPage': _currentPage,
      'hasMoreData': _hasMoreData,
      'isLoadingMore': _isLoadingMore,
    };
  }
}

/// Optimized reels state
class OptimizedReelsState {
  final ApiStates status;
  final List<ReelData> reels;
  final String? errorMessage;
  final int currentPage;
  final bool isLoadingMore;

  const OptimizedReelsState({
    this.status = ApiStates.initial,
    this.reels = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.isLoadingMore = false,
  });

  OptimizedReelsState copyWith({
    ApiStates? status,
    List<ReelData>? reels,
    String? errorMessage,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return OptimizedReelsState(
      status: status ?? this.status,
      reels: reels ?? this.reels,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// API states enum
enum ApiStates { initial, loading, success, error }
