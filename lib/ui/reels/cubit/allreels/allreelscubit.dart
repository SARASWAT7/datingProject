// import 'package:bloc/bloc.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../../../../component/apihelper/normalmessage.dart';
// import '../../../../component/apihelper/urls.dart';
// import '../../../dashboard/profile/repository/service.dart';
// import 'allreelsstate.dart';
//
// class AllReelsCubit extends Cubit<AllReelsState> {
//   final CorettaUserProfileRepo _repository;
//
//   AllReelsCubit(this._repository) : super(const AllReelsState());
//
//   Future<void> fetchAllReels(BuildContext context) async {
//     try {
//       emit(state.copyWith(status: ApiStates.loading));
//       final response = await _repository.getAllReels();
//
//       print("Fetched Reels: ${response.result}");
//
//       emit(state.copyWith(status: ApiStates.success, response: response));
//     } catch (e) {
//       emit(state.copyWith(
//           status: ApiStates.error, errorMessage: e.toString()));
//     }
//   }
//
//   Future<void> getComment(BuildContext context ,String videoId) async {
//     try {
//       emit(state.copyWith(status: ApiStates.loading));
//       final responseCmt = await _repository.getComment(videoId);
//
//       emit(state.copyWith(status: ApiStates.success, responseCmt: responseCmt));
//     } catch (e) {
//       emit(state.copyWith(
//           status: ApiStates.error, errorMessage: e.toString()));
//     }
//   }
//
//
//   Future<void> sendMyComment(BuildContext context ,String videoId ,String comment) async {
//     try {
//       emit(state.copyWith(status: ApiStates.loading));
//       final myCommentsResponse = await _repository.sendComment(videoId,comment);
//       emit(state.copyWith(status: ApiStates.success, myCommentsResponse: myCommentsResponse));
//
//     } catch (e) {
//       emit(state.copyWith(
//           status: ApiStates.error, errorMessage: e.toString()));
//     }
//   }
//
// }

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../component/apihelper/urls.dart';
import '../../../../component/apihelper/enhanced_error_handler.dart';
import '../../../../component/apihelper/crash_handler.dart';
import '../../../dashboard/profile/repository/service.dart';
import '../../../subscrption/design/subscriptionpopup.dart';
import 'allreelsstate.dart';

class AllReelsCubit extends Cubit<AllReelsState> {
  final CorettaUserProfileRepo _repository;

  AllReelsCubit(this._repository) : super(const AllReelsState());

  Future<void> fetchAllReels(
    BuildContext context, {
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      emit(state.copyWith(status: ApiStates.loading));

      final response = await _repository.getAllReels(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      print("Fetched Reels: ${response.result}");

      emit(
        state.copyWith(
          status: ApiStates.success,
          response: response,
          currentPage: pageNumber + 1,
        ),
      );
    } catch (e) {
      print("❌ Error in fetchAllReels: $e");
      
      // Record error to crashlytics
      CrashHandler.recordError(e, null);
      
      // Handle different types of errors
      if (e.toString().contains('Session expired') || 
          e.toString().contains('Authentication failed') ||
          e.toString().contains('401')) {
        // Handle authentication errors
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Session expired. Please login again to view reels."
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
      } else if (e.toString().contains('Server error') ||
                 e.toString().contains('500') ||
                 e.toString().contains('502') ||
                 e.toString().contains('503')) {
        // Handle server errors
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Server error. Please try again later."
        ));
      } else if (e.toString().contains('No reels available') ||
                 e.toString().contains('404')) {
        // Handle no data scenarios
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "No reels available at the moment. Please try again later."
        ));
      } else {
        // For other errors, show a generic error message
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Failed to load reels. Please try again."
        ));
      }
    }
  }

  Future<void> getComment(BuildContext context, String videoId) async {
    try {
      emit(state.copyWith(status: ApiStates.loading));
      final responseCmt = await _repository.getComment(videoId);

      emit(state.copyWith(status: ApiStates.success, responseCmt: responseCmt));
    } catch (e) {
      print("❌ Error in getComment: $e");
      
      // Record error to crashlytics
      CrashHandler.recordError(e, null);
      
      // Handle different types of errors
      if (e.toString().contains('Session expired') || 
          e.toString().contains('Authentication failed') ||
          e.toString().contains('401')) {
        // Handle authentication errors
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Session expired. Please login again to view comments."
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
      } else if (e.toString().contains('No comments available') ||
                 e.toString().contains('404')) {
        // Handle no comments scenarios
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "No comments available for this video."
        ));
      } else {
        // For other errors, show a generic error message
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Failed to load comments. Please try again."
        ));
      }
    }
  }

  Future<void> sendMyComment(
    BuildContext context,
    String videoId,
    String comment,
  ) async {
    try {
      emit(state.copyWith(status: ApiStates.loading));
      final myCommentsResponse = await _repository.sendComment(
        videoId,
        comment,
      );
      emit(
        state.copyWith(
          status: ApiStates.success,
          myCommentsResponse: myCommentsResponse,
        ),
      );
    } catch (e) {
      print("❌ Error in sendMyComment: $e");
      
      // Record error to crashlytics
      CrashHandler.recordError(e, null);
      
      // Handle different types of errors
      if (e.toString().contains('Session expired') || 
          e.toString().contains('Authentication failed') ||
          e.toString().contains('401')) {
        // Handle authentication errors
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Session expired. Please login again to post comments."
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
      } else if (e.toString().contains('Comment cannot be empty') ||
                 e.toString().contains('Comment is too long') ||
                 e.toString().contains('Invalid comment')) {
        // Handle validation errors
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: e.toString()
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
          errorMessage: "Failed to post comment. Please try again."
        ));
      }
    }
  }

  Future<void> sendLike(
    BuildContext context,
    String videoId,
    String type,
  ) async {
    try {
      emit(state.copyWith(status: ApiStates.loading));
      final response = await _repository.sendLikes(videoId, type);

      emit(state.copyWith(status: ApiStates.success));
    } catch (e) {
      print("❌ Error in sendLike: $e");
      
      // Record error to crashlytics
      CrashHandler.recordError(e, null);
      
      // Handle different types of errors
      if (e.toString().contains('Session expired') || 
          e.toString().contains('Authentication failed') ||
          e.toString().contains('401')) {
        // Handle authentication errors
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: "Session expired. Please login again to like videos."
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
      } else if (e.toString().contains('Invalid video ID') ||
                 e.toString().contains('Invalid like type') ||
                 e.toString().contains('Invalid like request')) {
        // Handle validation errors
        emit(state.copyWith(
          status: ApiStates.error, 
          errorMessage: e.toString()
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
          errorMessage: "Failed to like video. Please try again."
        ));
      }
    }
  }
}
