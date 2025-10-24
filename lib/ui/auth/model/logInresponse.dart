class LogInResponse {
  bool? success;
  String? message;
  Result? result;

  LogInResponse({this.success, this.message, this.result});

  LogInResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? verificationType;



  Result({this.verificationType, });

  Result.fromJson(Map<String, dynamic> json) {
    verificationType = json['verification_type'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verification_type'] = this.verificationType;


    return data;
  }
}
