// ignore_for_file: use_build_context_synchronously, unused_local_variable
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:demoproject/component/apihelper/normalmessage.dart';
import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/component/apihelper/internet_connectivity_service.dart';
import 'package:demoproject/component/apihelper/performance_optimizer.dart';
import 'package:demoproject/component/apihelper/advanced_performance_optimizer.dart';
import 'package:demoproject/component/apihelper/fast_data_service.dart';
import 'package:demoproject/component/apihelper/crash_handler.dart';
import 'package:demoproject/component/apihelper/smart_cache_manager.dart';
import 'package:demoproject/main.dart';
import 'package:demoproject/ui/dashboard/chat/model/datacreationmodel.dart';
import 'package:demoproject/ui/dashboard/chat/repository/service.dart';
import 'package:demoproject/ui/dashboard/home/cubit/homecubit/homestate.dart';
import 'package:demoproject/ui/dashboard/home/match/match.dart';
import 'package:demoproject/ui/dashboard/chat/design/chatroom.dart';
import 'package:demoproject/ui/dashboard/home/repository/homerepository.dart';
import 'package:demoproject/ui/dashboard/home/model/homeresponse.dart';
import 'package:demoproject/ui/dashboard/profile/repository/service.dart';
import 'package:demoproject/component/utils/fcm_token_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../subscrption/subscription/cubit.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(const HomePageState());
  HomeRepository repo = HomeRepository();
  FastDataService fastDataService = FastDataService();
  final int pageLimit = 10; // Reduced from 20 to 10 for faster loading

  @override
  Future<void> close() {
    // Clean up background timer when cubit is disposed
    stopBackgroundRefresh();
    return super.close();
  }

  Future<String> gettoken() async {
    try {
      String? token = await FCMTokenHelper.getTokenWithRetry();
      return token ?? "token not found";
    } catch (e) {
      log("Error getting FCM token: $e");
      return "token not found";
    }
  }

  /// Clear image cache to prevent old user images from showing
  Future<void> clearImageCache() async {
    try {
      await SmartCacheManager.clearAllCache();
      log("🧹 Image cache cleared successfully");
    } catch (e) {
      log("❌ Error clearing image cache: $e");
    }
  }

  /// Clear cache for specific user images
  Future<void> clearUserImageCache(List<String> imageUrls) async {
    try {
      await SmartCacheManager.clearUserImages(imageUrls);
    } catch (e) {
      log("❌ Error clearing user image cache: $e");
    }
  }

  /// Smart cache management - clear old data when loading new users
  Future<void> manageCacheForNewUsers(HomeResponse response) async {
    try {
      // Get current user IDs and their images
      final currentUserIds =
          response.result?.users
              ?.map((user) => user.id)
              .whereType<String>()
              .toList() ??
          [];
      final newUserIds =
          response.result?.users
              ?.map((user) => user.id)
              .whereType<String>()
              .toList() ??
          [];

      // Create user image map for smart cache management
      final userImageMap = <String, List<String>>{};
      if (state.response?.result?.users != null) {
        for (var user in state.response!.result!.users!) {
          if (user.id != null && user.media != null) {
            userImageMap[user.id!] = user.media!.whereType<String>().toList();
          }
        }
      }

      // Use smart cache manager
      await SmartCacheManager.manageCacheForNewUsers(
        currentUserIds: currentUserIds.whereType<String>().toList(),
        newUserIds: newUserIds.whereType<String>().toList(),
        userImageMap: userImageMap,
      );

      log("🧹 Smart cache management completed for new users");
    } catch (e) {
      log("❌ Error managing cache for new users: $e");
    }
  }

  Future<void> updateUserDatatoFirebase() async {
    try {
      String token = await gettoken();
      final getprofile = await CorettaUserProfileRepo().profile();
      final chatresponse = await CorettaChatRepository().registerUser(
        FirebaseUserCreation(
          email: getprofile.result?.email ?? "",
          userId: getprofile.result?.firebaseId?.toInt() ?? 0,
          name: getprofile.result?.firstName ?? "",
          mobile: getprofile.result?.phone.toString() ?? "",
          profilePic: getprofile.result?.profilePicture ?? "",
          deviceToken: token,
        ),
      );
      SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.setString(
        "chatToken",
        FirebaseUserCreation(
          deviceToken: token,
          email: getprofile.result?.email ?? "",
          userId: getprofile.result?.firebaseId?.toInt() ?? 0,
          name: getprofile.result?.firstName ?? "",
          mobile: getprofile.result?.phone.toString() ?? "",
          profilePic: getprofile.result?.profilePicture ?? "",
        ).getBody(),
      );
      log(
        "$chatresponse  ${FirebaseUserCreation(deviceToken: token, email: getprofile.result?.email ?? "", userId: getprofile.result?.firebaseId?.toInt() ?? 0, name: getprofile.result?.firstName ?? "", mobile: getprofile.result?.phone.toString() ?? "", profilePic: getprofile.result?.profilePicture ?? "").getBody()} ======++++++++++++++++>++++++++++++++SṢ",
      );

      await saveUserData(
        getprofile.result?.profilePicture ?? "",
        getprofile.result?.firebaseId?.toInt() ?? 0,
        getprofile.result?.firstName ?? "",
      );
    } catch (e) {
      log("${e} zssss");
    }
  }

  Future<void> saveUserData(
    String profilePicture,
    int userId,
    String name,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("profilePicture", profilePicture);
    await preferences.setInt("userId", userId);
    await preferences.setString("name", name);
  }

  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String profilePicture = preferences.getString("profilePicture") ?? "";
    int userId = preferences.getInt("userId") ?? 0;
    String name = preferences.getString("name") ?? "";

    return {"profilePicture": profilePicture, "userId": userId, "name": name};
  }

  void homeApi(BuildContext context) async {
    emit(state.copyWith(status: ApiStates.loading));

    // 🧹 CACHE MANAGEMENT: Clear old cache on fresh load
    await SmartCacheManager.clearOldCache();

    // Reset pagination
    emit(
      state.copyWith(currentPage: 1, hasMoreData: true, isLoadingMore: false),
    );

    await InternetConnectivityService.executeWithConnectivityCheck(context, () async {
      try {
        // Check cache first for instant loading
        try {
          final cachedData = await fastDataService.getCachedHomeData();
          if (cachedData != null &&
              cachedData.result?.users?.isNotEmpty == true) {
            emit(
              state.copyWith(
                status: ApiStates.success,
                response: cachedData,
                currentIndex: 0,
                currentPage: 1,
                hasMoreData: true,
              ),
            );

            // Preload next user images from cached data
            _preloadNextUserImages(0);

            // CRITICAL: Ensure Firebase ID is saved even when using cached data
            updateUserDatatoFirebase()
                .then((_) {
                  log("✅ Firebase ID saved from cached data path");
                })
                .catchError((e) {
                  log("⚠️ Error saving Firebase ID from cached path: $e");
                });

            // Proactively load more users to prevent "no users found"
            Future.delayed(Duration(seconds: 2), () {
              if (state.hasMoreData && !state.isLoadingMore) {
                log("🔄 Proactively loading more users after initial load...");
                loadMoreUsers();
              }
            });

            // Continue with background refresh
            _refreshDataInBackground(context);
            return;
          }
        } catch (cacheError) {
          // Clear cache if there's an issue
          fastDataService.clearAllCaches();
          // Continue with fresh data fetch
        }

        // Try fast data service first with retry logic
        HomeResponse? response;
        try {
          response = await fastDataService.getHomeData();
        } catch (fastDataError) {
          // Check if it's an unauthorized error
          if (fastDataError.toString().contains('401') ||
              fastDataError.toString().contains('unAuthorized') ||
              fastDataError.toString().contains('unauthorized')) {
            // Wait a bit and try again
            await Future.delayed(Duration(seconds: 1));
          }

          // Fallback to direct repository call
          try {
            final homeRepo = HomeRepository();
            response = await homeRepo.homePageApi(
              page: state.currentPage,
              limit: pageLimit,
            );
          } catch (repoError) {
            // If it's still unauthorized, try one more time with delay
            if (repoError.toString().contains('401') ||
                repoError.toString().contains('unAuthorized') ||
                repoError.toString().contains('unauthorized')) {
              await Future.delayed(Duration(seconds: 2));

              try {
                final homeRepo = HomeRepository();
                response = await homeRepo.homePageApi(
                  page: state.currentPage,
                  limit: pageLimit,
                );
              } catch (finalError) {
                throw finalError;
              }
            } else {
              throw repoError;
            }
          }
        }

        // Validate response before proceeding
        if (response.result?.users == null || response.result!.users!.isEmpty) {
          // Don't show error immediately - this might be a temporary state
          // Set hasMoreData to true to allow retries and show background message
          emit(
            state.copyWith(
              status: ApiStates.success,
              hasMoreData: true,
              response: response,
            ),
          );
          log("⚠️ No users in current batch - will retry later");
          return;
        }

        // 🧹 CACHE MANAGEMENT: Clear old user images to prevent showing wrong users
        await manageCacheForNewUsers(response);

        // CRITICAL: Ensure Firebase ID is saved before any group/chat operations
        // Run updateUserDatatoFirebase first to save Firebase ID from profile API
        try {
          await updateUserDatatoFirebase();
          log("✅ Firebase ID saved successfully from profile API");
        } catch (e) {
          log("⚠️ Error saving Firebase ID: $e");
          // Continue even if Firebase update fails
        }

        // Run other background operations in parallel (don't block UI)
        Future.wait([_getSubscriptionData(context).catchError((e) {})]);

        // Advanced preloading for next users (with memory optimization)
        if (response.result?.users?.isNotEmpty == true) {
          try {
            // Preload first 3 users' images for ultra-smooth experience
            for (int i = 0; i < 3 && i < response.result!.users!.length; i++) {
              final user = response.result!.users![i];
              if (user.media?.isNotEmpty == true) {
                // Limit media preloading to first 3 images per user to save memory
                final limitedMedia = user.media!.take(3).toList();
                AdvancedPerformanceOptimizer.preloadImagesBatch(limitedMedia);
              }
            }

            // Preload next user data for instant transitions (limit to first 5 users)
            final limitedUsers = response.result!.users!.take(5).toList();
            AdvancedPerformanceOptimizer.preloadNextUserData(limitedUsers, 0);
          } catch (preloadError) {
            // Don't fail the entire request if preloading fails
          }
        }

        // Check if we have more data
        final usersCount = response.result?.users?.length ?? 0;
        // Always assume there might be more data unless we explicitly know there isn't
        // This allows the app to continue checking for new users
        final hasMoreData =
            true; // Always true to allow continuous checking for new users

        // Emit success state with error handling
        try {
          emit(
            state.copyWith(
              status: ApiStates.success,
              response: response,
              currentIndex: 0,
              currentPage: 1,
              hasMoreData: hasMoreData,
            ),
          );
        } catch (emitError) {
          // Try to emit a minimal success state
          emit(
            state.copyWith(
              status: ApiStates.success,
              response: response,
              currentIndex: 0,
              currentPage: 1,
              hasMoreData: hasMoreData,
            ),
          );
        }

        // Proactively load more users to prevent "no users found"
        Future.delayed(Duration(seconds: 3), () {
          if (state.hasMoreData && !state.isLoadingMore) {
            log("🔄 Proactively loading more users after fresh data load...");
            loadMoreUsers();
          }
        });
      } catch (e) {
        log("Home cubit error: $e");

        // Record error to crashlytics
        CrashHandler.recordError(e, null);

        emit(state.copyWith(status: ApiStates.error));

        // Handle different types of errors
        if (e.toString().contains('Session expired') ||
            e.toString().contains('Authentication failed') ||
            e.toString().contains('401')) {
          // Handle authentication errors
          if (context.mounted) {
            NormalMessage().normalerrorstate(
              context,
              "Session expired. Please login again.",
            );
          }
        } else if (e.toString().contains('Connection lost') ||
            e.toString().contains('Connection closed') ||
            e.toString().contains('SocketException') ||
            e.toString().contains('HandshakeException') ||
            e.toString().contains('TimeoutException')) {
          // Handle network connectivity issues
          InternetConnectivityService.handleNetworkError(context, e);
        } else if (e.toString().contains('Server error') ||
            e.toString().contains('500') ||
            e.toString().contains('502') ||
            e.toString().contains('503')) {
          // Handle server errors
          if (context.mounted) {
            NormalMessage().normalerrorstate(
              context,
              "Server error. Please try again later.",
            );
          }
        } else if (e.toString().contains('No data received') ||
            e.toString().contains('Invalid response format')) {
          // Handle data parsing issues
          if (context.mounted) {
            NormalMessage().normalerrorstate(
              context,
              "Data loading error. Please try again.",
            );
          }
        } else {
          // For other errors, show a generic error message
          if (context.mounted) {
            NormalMessage().normalerrorstate(
              context,
              "Failed to load data. Please try again.",
            );
          }
        }
      }
    });
  }

  // Background data refresh without blocking UI
  Future<void> _refreshDataInBackground(BuildContext context) async {
    try {
      log("🔄 Refreshing data in background...");
      final homeRepo = HomeRepository();
      final response = await homeRepo.homePageApi(
        page: state.currentPage,
        limit: pageLimit,
      );

      if (response.result?.users?.isNotEmpty == true) {
        log("✅ Background refresh successful");
        // Update state with fresh data
        emit(
          state.copyWith(
            status: ApiStates.success,
            response: response,
            currentIndex: state.currentIndex,
          ),
        );
      }
    } catch (e) {
      log("❌ Background refresh failed: $e");
      // Don't show error for background refresh failures
    }
  }

  Future<void> _getSubscriptionData(BuildContext context) async {
    try {
      final subscriptionCubit = context.read<SubscriptionCubit>();
      await subscriptionCubit.getSubData();
    } catch (e) {
      log("Subscription data error: $e");
      // Don't fail the entire request if subscription fails
    }
  }

  void _preloadNextUserImages(int currentIndex) {
    try {
      final users = state.response?.result?.users ?? [];
      final nextIndex = currentIndex + 1;

      if (nextIndex < users.length) {
        final nextUser = users[nextIndex];
        if (nextUser.media?.isNotEmpty == true) {
          PerformanceOptimizer.preloadNextUserImages(nextUser.media!);
        }
      }
    } catch (e) {
      // Ignore preload errors - not critical
    }
  }

  // Load more users when reaching the 9th user
  void loadMoreUsers() async {
    if (state.isLoadingMore || !state.hasMoreData) {
      log(
        "🚫 Skipping load more - isLoadingMore: ${state.isLoadingMore}, hasMoreData: ${state.hasMoreData}",
      );
      return;
    }

    try {
      emit(state.copyWith(isLoadingMore: true));
      final nextPage = state.currentPage + 1;

      log("📡 Loading more users - page $nextPage");
      final response = await repo.homePageApi(page: nextPage, limit: pageLimit);

      // 🧹 CACHE MANAGEMENT: Clear old user images when loading new users
      await manageCacheForNewUsers(response);

      final newUsers = response.result?.users ?? [];
      final currentUsers = state.response?.result?.users ?? [];

      log(
        "📊 New users received: ${newUsers.length}, Current users: ${currentUsers.length}",
      );

      // Combine existing users with new users
      final combinedUsers = [...currentUsers, ...newUsers];

      // Always assume there might be more data to allow continuous checking
      final hasMoreData = true;

      log(
        "📊 Combined users: ${combinedUsers.length}, Has more data: $hasMoreData",
      );

      // Create updated response with combined users
      final updatedResponse = HomeResponse(
        success: response.success,
        message: response.message,
        result: Result(success: response.result?.success, users: combinedUsers),
      );

      log(
        "✅ Loaded ${newUsers.length} more users. Total: ${combinedUsers.length}",
      );

      // Update the current index if we were at -1 (end of users)
      final updatedCurrentIndex = state.currentIndex == -1
          ? 0
          : state.currentIndex;

      emit(
        state.copyWith(
          status: ApiStates.success,
          response: updatedResponse,
          currentPage: nextPage,
          hasMoreData: hasMoreData,
          isLoadingMore: false,
          currentIndex: updatedCurrentIndex,
        ),
      );

      log(
        "🔄 Updated current index from ${state.currentIndex} to $updatedCurrentIndex",
      );
      log(
        "📊 New total users: ${combinedUsers.length}, Has more data: $hasMoreData",
      );

      // REMOVED: Auto-triggering next page load to prevent infinite API calls
      // This was causing continuous API hits on every 9th user
      // Users will be loaded on-demand when needed instead
    } catch (e) {
      log("❌ Error loading more users: $e");
      log("❌ Error type: ${e.runtimeType}");

      // Don't set hasMoreData to false immediately - retry once
      emit(state.copyWith(isLoadingMore: false));

      // Retry after a short delay if it's a network error
      if (e.toString().contains('Connection') ||
          e.toString().contains('timeout') ||
          e.toString().contains('SocketException')) {
        log("🔄 Retrying load more users after network error...");
        Future.delayed(Duration(seconds: 2), () {
          if (state.hasMoreData && !state.isLoadingMore) {
            loadMoreUsers();
          }
        });
      }
    }
  }

  // OPTIMIZED: Check if we need to load more users (less aggressive to prevent continuous API calls)
  void checkAndLoadMoreUsers() {
    final currentIndex = state.currentIndex;
    final totalUsers = state.response?.result?.users?.length ?? 0;

    log(
      "🔍 Checking pagination - Current index: $currentIndex, Total users: $totalUsers, Has more data: ${state.hasMoreData}, Is loading: ${state.isLoadingMore}",
    );

    // OPTIMIZED: Only load more when we're actually near the end (within 1 user of the end)
    // This prevents continuous API calls on every 9th user
    if (currentIndex >= totalUsers - 1 &&
        state.hasMoreData &&
        !state.isLoadingMore) {
      log(
        "🔄 Triggering load more users - Current index: $currentIndex, Total: $totalUsers",
      );
      loadMoreUsers();
    }
  }

  void filter(BuildContext context, Map<String, dynamic> data) async {
    emit(state.copyWith(status: ApiStates.loading));

    await InternetConnectivityService.executeWithConnectivityCheck(
      context,
      () async {
        try {
          data.removeWhere((key, value) {
            if (value is String) {
              return value.isEmpty;
            } else if (value is List) {
              return value.isEmpty;
            } else if (value is int) {
              return value == 0;
            } else {
              return value != null;
            }
          });
          Map<String, dynamic> setting = data;

          final response = await repo.filter(setting);

          emit(
            state.copyWith(
              status: ApiStates.success,
              response: response,
              currentIndex: 2,
            ),
          );
        } catch (e) {
          log("${e} zssss");
          emit(state.copyWith(status: ApiStates.error));
          InternetConnectivityService.handleNetworkError(context, e);
        }
      },
    );
  }

  Future<Map> getUserToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // log(jsonDecode(jsonEncode(pref.getString("chatToken") ?? "")));
    Map<String, dynamic> data = jsonDecode(pref.getString("chatToken") ?? "");
    log(data.toString());
    return data;
  }

  /// Get authentication token from SharedPreferences
  Future<String> getAuthToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? "";
      log(
        "🔑 Auth token retrieved: ${token.isNotEmpty ? 'Present' : 'Missing'}",
      );
      return token;
    } catch (e) {
      log("❌ Error retrieving auth token: $e");
      return "";
    }
  }

  void likeSidlike(
    BuildContext context,
    String userId,
    String type,
    String token,
    String likeuserName, {
    String? otherFirebaseId,
    String? otherDisplayName,
    String? otherProfileImage,
  }) async {
    log("🚀 Ultra-fast like/dislike: $likeuserName");

    // Validate token first
    if (token.isEmpty) {
      log("❌ Token is empty, attempting to refresh...");
      token = await getAuthToken();
      if (token.isEmpty) {
        log("❌ Still no token available, cannot perform like/dislike");
        NormalMessage.instance.normalerrorstate(
          context,
          "Authentication token is missing. Please login again.",
        );
        return;
      }
    }

    // INSTANT UI update - move to next user immediately for ultra-smooth experience
    final currentUsers = state.response?.result?.users ?? [];
    final nextIndex = currentUsers.length > state.currentIndex + 1
        ? state.currentIndex + 1
        : -1;

    // Check if we're at the last user BEFORE updating the state
    final isAtLastUser = state.currentIndex >= currentUsers.length - 1;
    final isNearEnd =
        state.currentIndex >=
        currentUsers.length - 3; // Within 3 users of the end
    final hasMoreData = state.hasMoreData;
    final isLoadingMore = state.isLoadingMore;

    log(
      "🔍 Like/Dislike - Current index: ${state.currentIndex}, Total users: ${currentUsers.length}, Is at last user: $isAtLastUser, Is near end: $isNearEnd, Has more data: $hasMoreData, Is loading: $isLoadingMore",
    );

    // Simple cache clearing - no complex error handling
    try {
      final oldIndex = state.currentIndex;
      if (oldIndex >= 0 && oldIndex < currentUsers.length) {
        final currentUser = currentUsers[oldIndex];
        if (currentUser.media != null && currentUser.media!.isNotEmpty) {
          await clearUserImageCache(currentUser.media!);
        }
      }
    } catch (e) {
      // Ignore cache errors - not critical
    }

    // Move to next user instantly (optimistic UI)
    emit(state.copyWith(status: ApiStates.success, currentIndex: nextIndex));

    // Preload next user's images immediately
    if (nextIndex >= 0) {
      _preloadNextUserImages(nextIndex);
    }

    // OPTIMIZED: Only trigger one loading method to prevent multiple API calls
    if (isAtLastUser && hasMoreData && !isLoadingMore) {
      log("🔄 At last user, triggering immediate load more...");
      handleLastUserAction();
    } else if (isNearEnd && hasMoreData && !isLoadingMore) {
      log("🔄 Near end of users, triggering proactive load more...");
      loadMoreUsers();
    } else {
      // Check if we need to load more users (for normal cases)
      checkAndLoadMoreUsers();
    }

    // REMOVED: proactiveLoadMoreUsers() call to prevent duplicate API calls
    // The above logic already handles proactive loading when needed

    // Run API call in background without blocking UI
    _performLikeDislikeInBackground(
      context,
      userId,
      type,
      token,
      likeuserName,
      nextIndex,
      otherFirebaseId: otherFirebaseId,
      otherDisplayName: otherDisplayName,
      otherProfileImage: otherProfileImage,
    );
  }

  /// Background like/dislike API call
  Future<void> _performLikeDislikeInBackground(
    BuildContext context,
    String userId,
    String type,
    String token,
    String likeuserName,
    int nextIndex, {
    String? otherFirebaseId,
    String? otherDisplayName,
    String? otherProfileImage,
  }) async {
    try {
      // Validate token before making API call
      if (token.isEmpty) {
        log("❌ Token is empty, cannot perform like/dislike action");
        NormalMessage.instance.normalerrorstate(
          context,
          "Authentication token is missing. Please login again.",
        );
        return;
      }

      log(
        "🔑 Like/Dislike API - Token: ${token.isNotEmpty ? 'Present' : 'Missing'}, User: $likeuserName, Type: $type",
      );

      final response = await repo.likeDislikeApi(
        userId,
        type,
        token,
        likeuserName,
      );

      // Check if user matched
      if ((response.result?.isMatched ?? false) == true) {
        log("💕 Match found with $likeuserName!");
        // Show match screen
        Navigator.push(
          navigatorKey.currentState!.context,
          MaterialPageRoute(builder: (_) => MatchScreen1(userId: userId)),
        ).catchError((error) {
          log("Match screen error: $error");
        });
      } else {
        log("✅ Like/Dislike action completed successfully for $likeuserName");
      }
    } catch (e) {
      log("❌ Like/Dislike API error: $e");

      // Special-case: server says this pair is already matched
      final errorText = e.toString().toLowerCase();
      if (errorText.contains('already a match')) {
        // Directly open chat with this user for a smooth dating flow
        // await _openChatWithUser(
        //   otherFirebaseId ?? userId,
        //   otherDisplayName ?? likeuserName,
        //   otherImageOverride: otherProfileImage,
        // );
        // Do not treat as failure; simply return
        return;
      }

      // Handle specific error types
      if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        log("🔑 Authentication error - token may be invalid or expired");
        NormalMessage.instance.normalerrorstate(
          context,
          "Authentication failed. Please login again.",
        );
      } else if (e.toString().contains('403') ||
          e.toString().contains('Forbidden')) {
        log("🚫 Access forbidden - user may not have permission");
        NormalMessage.instance.normalerrorstate(
          context,
          "Access denied. Please check your account status.",
        );
      } else {
        // Generic error message
        NormalMessage.instance.normalerrorstate(
          context,
          "Failed to perform action. Please try again.",
        );
      }
    }
  }

  /// Open chat screen with an already matched user
  Future<void> _openChatWithUser(
    String otherUserId,
    String otherUserName, {
    String? otherImageOverride,
  }) async {
    try {
      // Get my chat token info (id, name, image)
      final Map myData = await getUserToken();
      final String myUserId = myData['userID']?.toString() ?? '';
      final String myImage = myData['profilePic']?.toString() ?? '';
      final String myName = myData['name']?.toString() ?? '';

      // Try to find other user's profile image from current list
      final currentUsers = state.response?.result?.users ?? [];
      String otherImage = otherImageOverride ?? '';
      String otherDisplayName = otherUserName;
      for (final u in currentUsers) {
        try {
          if ((u.id?.toString() ?? '') == otherUserId) {
            otherDisplayName = (u.firstName ?? otherUserName).toString();
            final media = u.media;
            if (media != null && media is List && (media as List).isNotEmpty) {
              otherImage = (media as List).first.toString();
            }
            break;
          }
        } catch (_) {}
      }

      final ctx = navigatorKey.currentState?.context;
      if (ctx == null) return;

      Navigator.push(
        ctx,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            otherUserId: otherUserId,
            userId: myUserId,
            profileImage: otherImage,
            userName: otherDisplayName,
            pageNavId: 0,
            myImage: myImage,
            name: myName,
          ),
        ),
      );
    } catch (err) {
      log('Open chat error: $err');
      final ctx = navigatorKey.currentState?.context;
      if (ctx != null) {
        NormalMessage.instance.normalerrorstate(
          ctx,
          'Already a match. Please open Chat tab to continue.',
        );
      }
    }
  }

  /// Method to handle when user reaches the end of the list
  void onReachedEnd() {
    log("🔚 User reached end of list - checking for more data...");
    log(
      "🔚 Current state - hasMoreData: ${state.hasMoreData}, isLoadingMore: ${state.isLoadingMore}",
    );

    if (state.hasMoreData && !state.isLoadingMore) {
      log("🔄 Triggering load more from end of list...");
      loadMoreUsers();
    } else if (!state.hasMoreData) {
      log("🔚 No more data available");
    } else {
      log("🔚 Already loading more data");
    }
  }

  /// Method to handle when user likes/dislikes the last user in current batch
  void handleLastUserAction() {
    log("🔚 Last user action detected - checking for more data...");
    log(
      "🔚 Current state - hasMoreData: ${state.hasMoreData}, isLoadingMore: ${state.isLoadingMore}",
    );

    if (state.hasMoreData && !state.isLoadingMore) {
      log("🔄 Triggering load more after last user action...");
      loadMoreUsers();
    } else if (!state.hasMoreData) {
      log("🔚 No more data available after last user action");
    } else {
      log("🔚 Already loading more data after last user action");
    }
  }

  /// OPTIMIZED: Proactively load more users when user is approaching the end (less aggressive)
  void proactiveLoadMoreUsers() {
    final currentIndex = state.currentIndex;
    final totalUsers = state.response?.result?.users?.length ?? 0;

    log(
      "🔮 Proactive loading check - Current index: $currentIndex, Total users: $totalUsers",
    );

    // OPTIMIZED: Only load more when user is at the last user to prevent continuous API calls
    // This prevents the issue where API was called on every 9th user
    if (currentIndex >= totalUsers - 1 &&
        state.hasMoreData &&
        !state.isLoadingMore) {
      log("🔮 Proactively loading more users to prevent 'no users found'...");
      loadMoreUsers();
    }
  }

  Timer? _backgroundTimer;

  /// Start periodic background refresh to check for new users (PRODUCTION SAFE)
  void startBackgroundRefresh() {
    // Cancel any existing timer first
    _backgroundTimer?.cancel();

    // Check for new users every 60 seconds (reduced frequency for production)
    _backgroundTimer = Timer.periodic(Duration(seconds: 60), (timer) {
      // Only run if app is in foreground and no users available
      final totalUsers = state.response?.result?.users?.length ?? 0;
      if (totalUsers == 0 && !state.isLoadingMore && !isClosed) {
        log("🔄 Background refresh: Checking for new users...");
        _backgroundRefresh();
      } else {
        timer.cancel(); // Stop timer if we have users or cubit is closed
        _backgroundTimer = null;
      }
    });
  }

  /// Stop background refresh timer
  void stopBackgroundRefresh() {
    _backgroundTimer?.cancel();
    _backgroundTimer = null;
  }

  int _backgroundRefreshAttempts = 0;
  static const int _maxBackgroundRefreshAttempts = 5;

  /// Background refresh without context dependency (PRODUCTION SAFE)
  void _backgroundRefresh() async {
    try {
      // Rate limiting: Don't refresh more than 5 times in background
      if (_backgroundRefreshAttempts >= _maxBackgroundRefreshAttempts) {
        log("🔄 Background refresh: Max attempts reached, stopping...");
        stopBackgroundRefresh();
        return;
      }

      _backgroundRefreshAttempts++;
      log(
        "🔄 Background refresh attempt $_backgroundRefreshAttempts/$_maxBackgroundRefreshAttempts",
      );

      final repo = HomeRepository();
      final response = await repo.homePageApi(page: 1, limit: pageLimit);

      if (response.result?.users != null &&
          response.result!.users!.isNotEmpty) {
        // Reset attempts counter on success
        _backgroundRefreshAttempts = 0;

        // Update state with new users
        emit(
          state.copyWith(
            status: ApiStates.success,
            response: response,
            hasMoreData: true,
          ),
        );
        log(
          "🔄 Background refresh: Found ${response.result!.users!.length} new users!",
        );

        // Stop background refresh since we found users
        stopBackgroundRefresh();
      } else {
        log("🔄 Background refresh: No new users found");
      }
    } catch (e) {
      log("🔄 Background refresh error: $e");

      // If it's a network error, wait longer before next attempt
      if (e.toString().contains('Connection') ||
          e.toString().contains('timeout')) {
        log("🔄 Network error detected, waiting 2 minutes before next attempt");
        await Future.delayed(Duration(minutes: 2));
      }
    }
  }

  /// Handle the case when user reaches the end but there might be more data
  void handleEndOfUsers() {
    final currentIndex = state.currentIndex;
    final totalUsers = state.response?.result?.users?.length ?? 0;

    log(
      "🔚 End of users reached - Current index: $currentIndex, Total users: $totalUsers",
    );
    log(
      "🔚 Has more data: ${state.hasMoreData}, Is loading: ${state.isLoadingMore}",
    );

    // If we're at the end and have more data, try to load more
    if (currentIndex >= totalUsers - 1 &&
        state.hasMoreData &&
        !state.isLoadingMore) {
      log("🔄 At end but have more data, loading more users...");
      loadMoreUsers();
    } else if (currentIndex >= totalUsers - 1 && !state.hasMoreData) {
      log("🔚 Truly at end - no more data available");
    }
  }
}
