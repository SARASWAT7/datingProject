class ContactUsResponse {
  bool? success;
  String? message;
  Result? result;

  ContactUsResponse({this.success, this.message, this.result});

  ContactUsResponse.fromJson(Map<String, dynamic> json) {
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
  String? message;
  String? contactFor;
  String? userId;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Result(
      {this.message,
      this.contactFor,
      this.userId,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Result.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    contactFor = json['contact_for'];
    userId = json['user_id'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['contact_for'] = this.contactFor;
    data['user_id'] = this.userId;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
