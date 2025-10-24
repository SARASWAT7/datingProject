// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class SubscriptionHistoryResponse {
  bool? status;
  String? message;
  List<Result>? result;

  SubscriptionHistoryResponse({this.status, this.message, this.result});

  SubscriptionHistoryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
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
  String? deviceType;
  int? iV;
  List<PurchasedItems>? purchasedItems;

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
      this.deviceType,
      this.iV,
      this.purchasedItems});

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
    deviceType = json['device_type'];
    iV = json['__v'];
    if (json['purchased_items'] != null) {
      purchasedItems = <PurchasedItems>[];
      json['purchased_items'].forEach((v) {
        purchasedItems!.add(new PurchasedItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_type'] = this.deviceType;
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
    if (this.purchasedItems != null) {
      data['purchased_items'] =
          this.purchasedItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PurchasedItems {
  String? purchaseAt;
  String? sId;
  String? addon;
  String? price;

  PurchasedItems({this.purchaseAt, this.sId, this.addon, this.price});

  PurchasedItems.fromJson(Map<String, dynamic> json) {
    purchaseAt = json['purchaseAt'];
    sId = json['_id'];
    addon = json['addon'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purchaseAt'] = this.purchaseAt;
    data['_id'] = this.sId;
    data['addon'] = this.addon;
    data['price'] = this.price;
    return data;
  }
}
