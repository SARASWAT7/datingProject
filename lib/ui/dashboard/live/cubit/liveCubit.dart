import 'dart:developer';
import 'package:demoproject/component/apihelper/common.dart';
import 'package:demoproject/ui/dashboard/home/repository/homerepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'liveState.dart';
import 'liveresponse.dart';

class LiveCubit extends Cubit<LiveState> {
  final HomeRepository repo;
  int currentPage = 1;
  final int pageLimit = 10;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int totalUsersCount = 0; // Store total count from API

  LiveCubit(this.repo) : super(const LiveState());

  void getProfile(BuildContext context) async {
    try {
      emit(state.copyWith(status: ApiState.isLoading));
      
      currentPage = 1;
      hasMoreData = true;

      final response = await repo.getLiveData(page: currentPage, limit: pageLimit);
      final usersCount = response.result?.users?.length ?? 0;
      
      // Store total count from API response
      totalUsersCount = response.result?.usersCount ?? 0;
      
      // Simple logic: if we get less than pageLimit, no more data
      hasMoreData = usersCount >= pageLimit;

      log("📊 Live Users - Total users available: $totalUsersCount, Current page users: $usersCount");
      emit(state.copyWith(status: ApiState.success, liveResponse: response));
    } catch (e) {
      log("❌ Live API Error: $e");
      emit(state.copyWith(status: ApiState.error));
    }
  }

  void loadMoreUsers() async {
    if (isLoadingMore || !hasMoreData) {
      log("🚫 Live Users - Skipping load more - isLoadingMore: $isLoadingMore, hasMoreData: $hasMoreData");
      return;
    }
    
    try {
      isLoadingMore = true;
      final nextPage = currentPage + 1;
      
      log("📡 Live Users - Loading more users - page $nextPage");
      final response = await repo.getLiveData(page: nextPage, limit: pageLimit);
      
      final newUsers = response.result?.users ?? [];
      final currentUsers = state.liveResponse?.result?.users ?? [];
      
      log("📊 Live Users - New users received: ${newUsers.length}, Current users: ${currentUsers.length}");
      
      // Combine existing users with new users
      final combinedUsers = [...currentUsers, ...newUsers];
      
      // Check if we have more data - be more lenient with the check
      hasMoreData = newUsers.length >= pageLimit;
      
      log("📊 Live Users - Combined users: ${combinedUsers.length}, Has more data: $hasMoreData");
      
      // If no new users returned, show message that only current users are active
      if (newUsers.isEmpty) {
        log("🔄 Live Users - No more users available, showing 'Only X users are active' message");
        hasMoreData = false;
      }
      
      // Create updated response with combined users
      final updatedResponse = LiveResponse(
        success: response.success,
        message: response.message,
        result: Result(
          success: response.result?.success,
          usersCount: combinedUsers.length,
          users: combinedUsers,
        ),
      );
      
      currentPage = nextPage;
      
      emit(state.copyWith(status: ApiState.success, liveResponse: updatedResponse));
      log("✅ Live Users - Loaded ${newUsers.length} more users. Total: ${combinedUsers.length}");
      
    } catch (e) {
      log("❌ Live Users - Error loading more users: $e");
      log("❌ Live Users - Error type: ${e.runtimeType}");
      
      // Don't set hasMoreData to false immediately - retry once
      if (e.toString().contains('Connection') || 
          e.toString().contains('timeout') ||
          e.toString().contains('SocketException')) {
        log("🔄 Live Users - Retrying load more users after network error...");
        Future.delayed(Duration(seconds: 2), () {
          if (hasMoreData && !isLoadingMore) {
            loadMoreUsers();
          }
        });
      } else {
        hasMoreData = false;
      }
    } finally {
      isLoadingMore = false;
    }
  }
}
