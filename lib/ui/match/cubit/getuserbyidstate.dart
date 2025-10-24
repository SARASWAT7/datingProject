import 'package:flutter/cupertino.dart';

import '../model/getuserbyidmodel.dart';

@immutable
abstract class GetUserByIdState {}

class GetUserByIdInitialState extends GetUserByIdState {}

class GetUserByIdSuccess extends GetUserByIdState {
  final GetUserByUserIDModel homeResponse;
  GetUserByIdSuccess(this.homeResponse);

}

class GetUserByIdLoading extends GetUserByIdState {}

class GetUserByIdError extends GetUserByIdState {
  final String message;
  GetUserByIdError(this.message);
}
