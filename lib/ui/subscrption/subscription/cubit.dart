// ignore_for_file: non_constant_identifier_names

import 'package:demoproject/ui/subscrption/subscription/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dashboard/profile/repository/service.dart';
import '../model/getsubdaat.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final CorettaUserProfileRepo _repository;

  SubscriptionCubit(this._repository) : super(GetSubDataInitialState());

  Future<void> getSubData() async {
    emit(GetSubDataLoadingState());

    try {
      final GetSubDataResponse response = await _repository.getSubscription();
      final String? planType = response.result?.userSubscription?.planType;
      final String? startPlanDate =
          response.result?.userSubscription?.startPlanDate;
      final String? expiryPlanDate =
          response.result?.userSubscription?.expiryPlanDate;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Clear old cache data first
      await prefs.remove('planType');
      await prefs.remove('startPlanDate');
      await prefs.remove('expiryPlanDate');
      
      // Set new data
      if (planType != null) {
        await prefs.setString('planType', planType);
        // Force cache refresh
        await prefs.setBool('subscription_updated', true);
      }
      if (startPlanDate != null)
        await prefs.setString('startPlanDate', startPlanDate);
      if (expiryPlanDate != null)
        await prefs.setString('expiryPlanDate', expiryPlanDate);

      emit(GetSubDataSuccessState(response));
    } on Exception catch (e) {
      emit(GetSubDataErrorState(e.toString()));
    }
  }

  Future<void> sendPurchaseDetails({
    required String transactionId,
    required String productId,
  }) async {
    emit(SendPurchaseDetailsLoadingState());

    try {
      final response = await _repository.sendPurchaseDetails(
        transactionId: transactionId,
        productId: productId,
      );

      emit(
        SendPurchaseDetailsSuccessState('Purchase details sent successfully'),
      );
    } catch (e) {
      emit(SendPurchaseDetailsErrorState(e.toString()));
    }
  }
}
