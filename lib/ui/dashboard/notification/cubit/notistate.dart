import 'package:equatable/equatable.dart';

import '../../../../component/apihelper/urls.dart';
import '../deleteallmodel.dart';
import '../notimodel.dart';
import '../userdelete.dart';

class NotificationListState extends Equatable {
  final ApiStates status;
  final NotificationResponse? response;
  final NotificationDeleteResponse? deleteResponse;
  final AllNotificationDeleteResponse? deleteAllResponse;

  const NotificationListState({
    this.response,
    this.deleteResponse,
    this.deleteAllResponse,
    this.status = ApiStates.normal,
  });

  @override
  List<Object?> get props => [response, deleteResponse, deleteAllResponse, status];

  NotificationListState copyWith({
    NotificationResponse? response,
    NotificationDeleteResponse? deleteResponse,
    AllNotificationDeleteResponse? deleteAllResponse,
    ApiStates? status,
  }) {
    return NotificationListState(
      response: response ?? this.response,
      deleteResponse: deleteResponse ?? this.deleteResponse,
      deleteAllResponse: deleteAllResponse ?? this.deleteAllResponse,
      status: status ?? this.status,
    );
  }
}
