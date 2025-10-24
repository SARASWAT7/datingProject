import '../model/getsubdaat.dart'; // Ensure this is the correct path

abstract class SubscriptionState {}

class GetSubDataInitialState extends SubscriptionState {}

class GetSubDataLoadingState extends SubscriptionState {}

class GetSubDataSuccessState extends SubscriptionState {
  final GetSubDataResponse response;

  GetSubDataSuccessState(this.response);
}

class GetSubDataErrorState extends SubscriptionState {
  final String message;

  GetSubDataErrorState(this.message);
}

class SendPurchaseDetailsLoadingState extends SubscriptionState {}

class SendPurchaseDetailsSuccessState extends SubscriptionState {
  final String message;

  SendPurchaseDetailsSuccessState(this.message);
}

class SendPurchaseDetailsErrorState extends SubscriptionState {
  final String message;

  SendPurchaseDetailsErrorState(this.message);
}
