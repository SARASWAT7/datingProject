import 'dart:developer';

import 'package:demoproject/ui/dashboard/likes/modal/youlikeresponse.dart';
import 'package:demoproject/ui/dashboard/likes/repositiory/likedyourepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../component/apihelper/toster.dart';
import '../../../../../component/apihelper/urls.dart';
import 'youlikedstate.dart';

class YouLikedCubit extends Cubit<YouLikedState> {
  YouLikedCubit() : super(YouLikedState(status: ApiStates.initial));

  final LikedYouRepository repo = LikedYouRepository();
  
  int currentPage = 1;
  final int pageLimit = 10;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  void youLiked(BuildContext context) async {
    emit(state.copyWith(status: ApiStates.loading));
    
    // Reset pagination
    currentPage = 1;
    hasMoreData = true;
    
    try {
      log("🚀 Starting youLiked in YouLikedCubit with page $currentPage");
      final response = await repo.youLiked(page: currentPage, limit: pageLimit);
      
      log("✅ You Liked API Response received successfully");
      log("📊 Users count: ${response.result?.length}");
      
      // Check if we have more data
      final usersCount = response.result?.length ?? 0;
      hasMoreData = usersCount >= pageLimit;
      
      emit(state.copyWith(status: ApiStates.success, response: response));
    } catch (e) {
      log("❌ You Liked API Error: $e");
      emit(state.copyWith(status: ApiStates.error));
      showToast(context, "No You Likes Found");
    }
  }

  void loadMoreYouLiked() async {
    if (isLoadingMore || !hasMoreData) return;
    
    try {
      isLoadingMore = true;
      currentPage++;
      
      log("📡 Loading more you liked users - page $currentPage");
      final response = await repo.youLiked(page: currentPage, limit: pageLimit);
      
      final newUsers = response.result ?? [];
      final currentUsers = state.response?.result ?? [];
      
      // Combine existing users with new users
      final combinedUsers = [...currentUsers, ...newUsers];
      
      // Check if we have more data
      hasMoreData = newUsers.length >= pageLimit;
      
      // Create updated response with combined users
      final updatedResponse = YouLikedResponse(
        success: response.success,
        message: response.message,
        result: combinedUsers,
      );
      
      log("✅ Loaded ${newUsers.length} more you liked users. Total: ${combinedUsers.length}");
      emit(state.copyWith(status: ApiStates.success, response: updatedResponse));
    } catch (e) {
      log("❌ Error loading more you liked users: $e");
      currentPage--; // Revert page on error
    } finally {
      isLoadingMore = false;
    }
  }
}
