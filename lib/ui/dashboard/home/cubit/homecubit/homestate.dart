// ignore_for_file: must_be_immutable

import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/ui/dashboard/home/model/homeresponse.dart';
import 'package:equatable/equatable.dart';

class HomePageState extends Equatable {
  final int currentIndex;
  final ApiStates status;
  final HomeResponse? response;
  final String? errorMessage;
  final int currentPage;
  final bool isLoadingMore;
  final bool hasMoreData;

  const HomePageState({
    this.currentIndex = 0, 
    this.response, 
    this.status = ApiStates.normal, 
    this.errorMessage,
    this.currentPage = 1,
    this.isLoadingMore = false,
    this.hasMoreData = true,
  });
  
  @override
  List<Object?> get props => [status, response, currentIndex, currentPage, isLoadingMore, hasMoreData, errorMessage];

  HomePageState copyWith({
    ApiStates? status, 
    int? currentIndex, 
    HomeResponse? response,    
    String? errorMessage,
    int? currentPage,
    bool? isLoadingMore,
    bool? hasMoreData,
  }) {
    return HomePageState(
      status: status ?? this.status,
      currentIndex: currentIndex ?? this.currentIndex,
      response: response ?? this.response,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }
}
