import 'dart:async';
import 'dart:developer';
import 'package:demoproject/ui/reels/original_reels_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demoproject/ui/dashboard/profile/repository/service.dart';

/// Simple reels cubit for immediate functionality
class SimpleReelsCubit extends Cubit<SimpleReelsState> {
  final CorettaUserProfileRepo _repository;
  
  SimpleReelsCubit(this._repository) : super(const SimpleReelsState()) {
    log("🚀 SimpleReelsCubit initialized");
    log("🚀 Repository type: ${_repository.runtimeType}");
  }

  /// Load initial reels
  Future<void> loadInitialReels() async {
    try {
      log("🔄 Starting to load initial reels...");
      emit(state.copyWith(status: ApiStates.loading));
      
      log("🔄 Repository type: ${_repository.runtimeType}");
      log("🔄 Calling repository getAllReels with pageNumber: 1, pageSize: 10");
      
      final response = await _repository.getAllReels(
        pageNumber: 1,
        pageSize: 10,
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          log("❌ API call timed out after 30 seconds");
          throw Exception("Request timeout - server not responding");
        },
      );
      
      log("🔄 Repository response received");
      log("🔄 Response type: ${response.runtimeType}");
      log("🔄 Response result: ${response.result}");
      log("🔄 Response result length: ${response.result?.length ?? 0}");
      
      if (response.result == null) {
        log("❌ Response result is null");
        emit(state.copyWith(
          status: ApiStates.error,
          errorMessage: "No reels data received from server",
        ));
        return;
      }
      
      final reels = _convertToReelData(response.result!);
      
      log("🔄 Converted to ReelData: ${reels.length} reels");
      
      if (reels.isEmpty) {
        log("⚠️ No reels after conversion");
        emit(state.copyWith(
          status: ApiStates.success,
          reels: [],
        ));
        return;
      }
      
      emit(state.copyWith(
        status: ApiStates.success,
        reels: reels,
      ));
      
      log("✅ Loaded ${reels.length} reels successfully");
    } catch (e) {
      log("❌ Error loading reels: $e");
      log("❌ Error type: ${e.runtimeType}");
      log("❌ Error stack trace: ${StackTrace.current}");
      
      String errorMessage = "Unknown error occurred";
      if (e.toString().contains("SocketException")) {
        errorMessage = "No internet connection";
      } else if (e.toString().contains("TimeoutException")) {
        errorMessage = "Request timeout - server not responding";
      } else if (e.toString().contains("FormatException")) {
        errorMessage = "Invalid data format received";
      } else if (e.toString().contains("401") || e.toString().contains("Unauthorized")) {
        errorMessage = "Authentication failed - please login again";
      } else if (e.toString().contains("403") || e.toString().contains("Forbidden")) {
        errorMessage = "Access denied - insufficient permissions";
      } else if (e.toString().contains("404") || e.toString().contains("Not Found")) {
        errorMessage = "Reels not found";
      } else if (e.toString().contains("500") || e.toString().contains("Internal Server Error")) {
        errorMessage = "Server error - please try again later";
      } else {
        errorMessage = e.toString();
      }
      
      // Try to show some fallback data if API fails
      log("🔄 Attempting to show fallback data...");
      final fallbackReels = _createFallbackReels();
      
      emit(state.copyWith(
        status: ApiStates.success,
        reels: fallbackReels,
      ));
      
      log("⚠️ Using fallback data due to error: $errorMessage");
    }
  }

  /// Convert API response to ReelData
  List<ReelData> _convertToReelData(List<dynamic> apiReels) {
    log("🔄 Converting ${apiReels.length} API reels to ReelData");
    
    try {
      final convertedReels = apiReels.map((reel) {
        log("🔄 Converting reel: ${reel.toString()}");
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
      
      log("✅ Successfully converted ${convertedReels.length} reels");
      return convertedReels;
    } catch (e) {
      log("❌ Error converting reels: $e");
      log("❌ Stack trace: ${StackTrace.current}");
      return [];
    }
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
      
      emit(state.copyWith(reels: reels));
    }
  }

  /// Create fallback reels data for testing
  List<ReelData> _createFallbackReels() {
    log("🔄 Creating fallback reels data...");
    return [
      ReelData(
        videoUrl: "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4",
        profilePicture: "https://via.placeholder.com/100x100/FF6B6B/FFFFFF?text=User1",
        userName: "Demo User 1",
        caption: "This is a demo reel for testing purposes",
        likeCount: 42,
        commentCount: 8,
        userId: "demo_user_1",
        videoId: "demo_video_1",
        likeStatus: false,
      ),
      ReelData(
        videoUrl: "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4",
        profilePicture: "https://via.placeholder.com/100x100/4ECDC4/FFFFFF?text=User2",
        userName: "Demo User 2",
        caption: "Another demo reel to test the app",
        likeCount: 156,
        commentCount: 23,
        userId: "demo_user_2",
        videoId: "demo_video_2",
        likeStatus: true,
      ),
      ReelData(
        videoUrl: "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4",
        profilePicture: "https://via.placeholder.com/100x100/45B7D1/FFFFFF?text=User3",
        userName: "Demo User 3",
        caption: "Testing the reels functionality",
        likeCount: 89,
        commentCount: 15,
        userId: "demo_user_3",
        videoId: "demo_video_3",
        likeStatus: false,
      ),
    ];
  }
}

/// Simple reels state
class SimpleReelsState {
  final ApiStates status;
  final List<ReelData> reels;
  final String? errorMessage;

  const SimpleReelsState({
    this.status = ApiStates.initial,
    this.reels = const [],
    this.errorMessage,
  });

  SimpleReelsState copyWith({
    ApiStates? status,
    List<ReelData>? reels,
    String? errorMessage,
  }) {
    return SimpleReelsState(
      status: status ?? this.status,
      reels: reels ?? this.reels,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// API states enum
enum ApiStates { initial, loading, success, error }
