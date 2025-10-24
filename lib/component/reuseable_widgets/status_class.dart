class ErrorStatus {
  String message;
  int? code;

  ErrorStatus({required this.message,  this.code});
}

class ResponseStatus {
  int? statusCode;
  dynamic responseData;

  ResponseStatus({required this.statusCode, required this.responseData});
}