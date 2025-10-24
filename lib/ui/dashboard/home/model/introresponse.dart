class GetIntro {
  final bool? success;
  final String? message;
  final Result? result;

  GetIntro({
    this.success,
    this.message,
    this.result,
  });

  GetIntro.fromJson(Map<String, dynamic> json)
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
  final String? message;
  final String? userId;
  final String? receiverUserId;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  Result({
    this.message,
    this.userId,
    this.receiverUserId,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Result.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String?,
        userId = json['user_id'] as String?,
        receiverUserId = json['receiver_user_id'] as String?,
        id = json['_id'] as String?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?,
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
    'message' : message,
    'user_id' : userId,
    'receiver_user_id' : receiverUserId,
    '_id' : id,
    'createdAt' : createdAt,
    'updatedAt' : updatedAt,
    '__v' : v
  };
}