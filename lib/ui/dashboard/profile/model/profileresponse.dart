import 'package:demoproject/ui/auth/model/verifyotpwithphoneresponse.dart';

class ProfileResponse {
  bool? success;
  String? message;
  User? result;

  ProfileResponse({this.success, this.message, this.result});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    result = json['result'] != null ? new User.fromJson(json['result']) : null;
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
