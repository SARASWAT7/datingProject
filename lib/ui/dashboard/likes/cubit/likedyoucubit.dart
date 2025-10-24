import 'dart:developer';

import 'package:demoproject/component/apihelper/toster.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/ui/dashboard/likes/cubit/likedyoustate.dart';
import 'package:demoproject/ui/dashboard/likes/modal/likedyouresponse.dart';
import 'package:demoproject/ui/dashboard/likes/repositiory/likedyourepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikedYouCubit extends Cubit<LikedYouState> {
  LikedYouCubit() : super(const LikedYouState());
  LikedYouRepository repo = LikedYouRepository();
  
  int currentPage = 1;
  final int pageLimit = 10;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  void likedyou(BuildContext context) async {
    emit(state.copyWith(status: ApiStates.loading));
    
    // Reset pagination
    currentPage = 1;
    hasMoreData = true;
    
    try {
      log("🚀 Starting likedyou in LikedYouCubit with page $currentPage");
      final response = await repo.likedyou(page: currentPage, limit: pageLimit);
      
      log("✅ Liked You API Response received successfully");
      log("📊 Users count: ${response.result?.length}");
      
      // Check if we have more data
      final usersCount = response.result?.length ?? 0;
      hasMoreData = usersCount >= pageLimit;
      
      emit(state.copyWith(status: ApiStates.success, response: response));
    } catch (e) {
      log("❌ Liked You API Error: $e");
      emit(state.copyWith(status: ApiStates.error));
      showToast(context, "No Likes You Found");
    }
  }

  void loadMoreLikedYou() async {
    if (isLoadingMore || !hasMoreData) return;
    
    try {
      isLoadingMore = true;
      currentPage++;
      
      log("📡 Loading more liked you users - page $currentPage");
      final response = await repo.likedyou(page: currentPage, limit: pageLimit);
      
      final newUsers = response.result ?? [];
      final currentUsers = state.response?.result ?? [];
      
      // Combine existing users with new users
      final combinedUsers = [...currentUsers, ...newUsers];
      
      // Check if we have more data
      hasMoreData = newUsers.length >= pageLimit;
      
      // Create updated response with combined users
      final updatedResponse = LikedYouResponse(
        success: response.success,
        message: response.message,
        result: combinedUsers,
      );
      
      log("✅ Loaded ${newUsers.length} more liked you users. Total: ${combinedUsers.length}");
      emit(state.copyWith(status: ApiStates.success, response: updatedResponse));
    } catch (e) {
      log("❌ Error loading more liked you users: $e");
      currentPage--; // Revert page on error
    } finally {
      isLoadingMore = false;
    }
  }
}
