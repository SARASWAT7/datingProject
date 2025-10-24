import 'package:demoproject/component/apihelper/urls.dart';
import 'package:demoproject/ui/dashboard/profile/model/dataprivacyresponse.dart';
import 'package:equatable/equatable.dart';

class DataprivacyState extends Equatable {
  final ApiStates status;
  final DataPrivacyResponse? response;
  const DataprivacyState({this.response, this.status = ApiStates.normal});

  @override
  // TODO: implement props
  List<Object?> get props => [response, status];
  DataprivacyState copyWith(
      {DataPrivacyResponse? response, ApiStates? status}) {
    return DataprivacyState(
        response: response ?? this.response, status: status ?? this.status);
  }
}
