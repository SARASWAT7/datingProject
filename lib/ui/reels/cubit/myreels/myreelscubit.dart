import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../component/apihelper/urls.dart';
import '../../../../component/apihelper/enhanced_error_handler.dart';
import '../../../../component/apihelper/crash_handler.dart';
import '../../../dashboard/profile/repository/service.dart';
import 'myreelsstate.dart';

class ProfileReelsCubit extends Cubit<ProfileReelsState> {
  final CorettaUserProfileRepo _repository;

  ProfileReelsCubit(this._repository) : super(const ProfileReelsState());

  Future<void> fetchProfileReels(BuildContext context) async {
    try {
      emit(state.copyWith(status: ApiStates.loading));
      final response = await _repository.getMyReels();

      print("Fetched Reels: ${response.result}");

      emit(state.copyWith(status: ApiStates.success, response: response));
    } catch (e) {
      print("❌ Error in fetchProfileReels: $e");
      
      // Record error to crashlytics
      CrashHandler.recordError(e, null);
      
      // Handle different types of errors
      if (e.toString().contains('Session expired') || 
          e.toString().contains('Authentication failed') ||
          e.toString().contains('401')) {
        // Handle authentication errors
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Session expired. Please login again to view your reels."
        ));
        if (context.mounted) {
          EnhancedErrorHandler.handleAuthError(context);
        }
      } else if (e.toString().contains('Connection lost') ||
                 e.toString().contains('Connection closed') ||
                 e.toString().contains('Network error')) {
        // Handle network connectivity issues
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Network error. Please check your internet connection and try again."
        ));
        if (context.mounted) {
          EnhancedErrorHandler.handleNetworkError(context, e);
        }
      } else if (e.toString().contains("You haven't uploaded any reels yet") ||
                 e.toString().contains('404')) {
        // Handle no reels scenarios
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "You haven't uploaded any reels yet."
        ));
      } else if (e.toString().contains('Server error') ||
                 e.toString().contains('500') ||
                 e.toString().contains('502') ||
                 e.toString().contains('503')) {
        // Handle server errors
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Server error. Please try again later."
        ));
      } else {
        // For other errors, show a generic error message
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Failed to load your reels. Please try again."
        ));
      }
    }
  }



  Future<void> userProfileReels(BuildContext context, String userId) async {
    try {
      emit(state.copyWith(status: ApiStates.loading));
      final userProfileResponse = await _repository.getUserReels(userId);

      print("Fetched Reels: ${userProfileResponse.result}");

      emit(state.copyWith(status: ApiStates.success, userProfileResponse: userProfileResponse));
    } catch (e) {
      print("❌ Error in userProfileReels: $e");
      
      // Record error to crashlytics
      CrashHandler.recordError(e, null);
      
      // Handle different types of errors
      if (e.toString().contains('Session expired') || 
          e.toString().contains('Authentication failed') ||
          e.toString().contains('401')) {
        // Handle authentication errors
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Session expired. Please login again to view user reels."
        ));
        if (context.mounted) {
          EnhancedErrorHandler.handleAuthError(context);
        }
      } else if (e.toString().contains('Connection lost') ||
                 e.toString().contains('Connection closed') ||
                 e.toString().contains('Network error')) {
        // Handle network connectivity issues
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Network error. Please check your internet connection and try again."
        ));
        if (context.mounted) {
          EnhancedErrorHandler.handleNetworkError(context, e);
        }
      } else if (e.toString().contains('Invalid user ID') ||
                 e.toString().contains('User not found') ||
                 e.toString().contains('404')) {
        // Handle user not found scenarios
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "User not found or has no reels."
        ));
      } else if (e.toString().contains('Server error') ||
                 e.toString().contains('500') ||
                 e.toString().contains('502') ||
                 e.toString().contains('503')) {
        // Handle server errors
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Server error. Please try again later."
        ));
      } else {
        // For other errors, show a generic error message
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Failed to load user reels. Please try again."
        ));
      }
    }
  }

}