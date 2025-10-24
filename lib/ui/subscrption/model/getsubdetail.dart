// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

class Getsubscriptiondetail {
  bool? status;
  String? message;
  Result? result;

  Getsubscriptiondetail({this.status, this.message, this.result});

  Getsubscriptiondetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result = /* User not subscribe for any plan */
        json['result'] != null || json['result'] != []
            ? new Result.fromJson(json['result'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? startPlanDate;
  String? expiryPlanDate;
  String? inappTxnId;
  String? inappPlanName;
  String? subscriptionsId;
  String? planeType;
  String? inappAmount;
  bool? isDeleted;
  bool? isActive;
  String? sId;
  String? userId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Result(
      {this.startPlanDate,
      this.expiryPlanDate,
      this.inappTxnId,
      this.inappPlanName,
      this.subscriptionsId,
      this.planeType,
      this.inappAmount,
      this.isDeleted,
      this.isActive,
      this.sId,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Result.fromJson(Map<String, dynamic> json) {
    startPlanDate = json['start_plan_date'];
    expiryPlanDate = json['expiry_plan_date'];
    inappTxnId = json['inapp_txn_id'];
    inappPlanName = json['inapp_plan_name'];
    subscriptionsId = json['subscriptions_id'];
    planeType = json['planeType'];
    inappAmount = json['inapp_amount'];
    isDeleted = json['isDeleted'];
    isActive = json['isActive'];
    sId = json['_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_plan_date'] = this.startPlanDate;
    data['expiry_plan_date'] = this.expiryPlanDate;
    data['inapp_txn_id'] = this.inappTxnId;
    data['inapp_plan_name'] = this.inappPlanName;
    data['subscriptions_id'] = this.subscriptionsId;
    data['planeType'] = this.planeType;
    data['inapp_amount'] = this.inappAmount;
    data['isDeleted'] = this.isDeleted;
    data['isActive'] = this.isActive;
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
