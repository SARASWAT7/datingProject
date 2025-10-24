class GetSubDataResponse {
  final bool? success;
  final String? message;
  final Result? result;

  GetSubDataResponse({
    this.success,
    this.message,
    this.result,
  });

  GetSubDataResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        message = json['message'] as String?,
        result = (json['result'] as Map<String,dynamic>?) != null ? Result.fromJson(json['result'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'success' : success,
    'message' : message,
    'result' : result?.toJson()
  };
}

class Result {
  final UserSubscription? userSubscription;

  Result({
    this.userSubscription,
  });

  Result.fromJson(Map<String, dynamic> json)
      : userSubscription = (json['userSubscription'] as Map<String,dynamic>?) != null ? UserSubscription.fromJson(json['userSubscription'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'userSubscription' : userSubscription?.toJson()
  };
}

class UserSubscription {
  final String? id;
  final String? userId;
  final String? startPlanDate;
  final String? expiryPlanDate;
  final String? inappTxnId;
  final String? inappPlanName;
  final String? subscriptionsId;
  final String? planType;
  final String? inappAmount;
  final bool? isDeleted;
  final bool? isActive;
  final String? deviceType;
  final List<dynamic>? purchasedItems;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  UserSubscription({
    this.id,
    this.userId,
    this.startPlanDate,
    this.expiryPlanDate,
    this.inappTxnId,
    this.inappPlanName,
    this.subscriptionsId,
    this.planType,
    this.inappAmount,
    this.isDeleted,
    this.isActive,
    this.deviceType,
    this.purchasedItems,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  UserSubscription.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        userId = json['user_id'] as String?,
        startPlanDate = json['start_plan_date'] as String?,
        expiryPlanDate = json['expiry_plan_date'] as String?,
        inappTxnId = json['inapp_txn_id'] as String?,
        inappPlanName = json['inapp_plan_name'] as String?,
        subscriptionsId = json['subscriptions_id'] as String?,
        planType = json['plan_type'] as String?,
        inappAmount = json['inapp_amount'] as String?,
        isDeleted = json['isDeleted'] as bool?,
        isActive = json['isActive'] as bool?,
        deviceType = json['device_type'] as String?,
        purchasedItems = json['purchased_items'] as List?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?,
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'user_id' : userId,
    'start_plan_date' : startPlanDate,
    'expiry_plan_date' : expiryPlanDate,
    'inapp_txn_id' : inappTxnId,
    'inapp_plan_name' : inappPlanName,
    'subscriptions_id' : subscriptionsId,
    'plan_type' : planType,
    'inapp_amount' : inappAmount,
    'isDeleted' : isDeleted,
    'isActive' : isActive,
    'device_type' : deviceType,
    'purchased_items' : purchasedItems,
    'createdAt' : createdAt,
    'updatedAt' : updatedAt,
    '__v' : v
  };
}