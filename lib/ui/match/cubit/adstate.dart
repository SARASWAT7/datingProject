import 'package:flutter/cupertino.dart';

import '../model/agreedisagreeresponse.dart';

@immutable
abstract class AgreeState {}

class AgreeInitial extends AgreeState {}

class AgreeLoading extends AgreeState {}

class AgreeSuccess extends AgreeState {
  final AgreeDisagreeResponse agreeResponse;

  AgreeSuccess({required this.agreeResponse});
}

class AgreeFailure extends AgreeState {
  final String message;

  AgreeFailure({required this.message});
}
