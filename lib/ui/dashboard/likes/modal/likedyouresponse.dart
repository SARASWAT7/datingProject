class LikedYouResponse {
  final bool? success;
  final String? message;
  final List<Result>? result;

  LikedYouResponse({
    this.success,
    this.message,
    this.result,
  });

  LikedYouResponse.fromJson(Map<String, dynamic> json)
    : success = json['success'] as bool?,
      message = json['message'] as String?,
      result = (json['result'] as List?)?.map((dynamic e) => Result.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'success' : success,
    'message' : message,
    'result' : result?.map((e) => e.toJson()).toList()
  };
}

class Result {
  final String? id;
  final String? userId;
  final LikedUserId? likedUserId;
  final bool? isRead;
  final String? type;
  final String? createdAt;
  final String? updatedAt;

  Result({
    this.id,
    this.userId,
    this.likedUserId,
    this.isRead,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  Result.fromJson(Map<String, dynamic> json)
    : id = json['_id'] as String?,
      userId = json['user_id'] as String?,
      likedUserId = (json['liked_user_id'] as Map<String,dynamic>?) != null ? LikedUserId.fromJson(json['liked_user_id'] as Map<String,dynamic>) : null,
      isRead = json['isRead'] as bool?,
      type = json['type'] as String?,
      createdAt = json['createdAt'] as String?,
      updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'user_id' : userId,
    'liked_user_id' : likedUserId?.toJson(),
    'isRead' : isRead,
    'type' : type,
    'createdAt' : createdAt,
    'updatedAt' : updatedAt
  };
}

class LikedUserId {
  final String? id;
  final String? firstName;
  final String? lastName;
  final int? age;
  final String? profilePicture;

  LikedUserId({
    this.id,
    this.firstName,
    this.lastName,
    this.age,
    this.profilePicture,
  });

  LikedUserId.fromJson(Map<String, dynamic> json)
    : id = json['_id'] as String?,
      firstName = json['first_name'] as String?,
      lastName = json['last_name'] as String?,
      age = json['age'] as int?,
      profilePicture = json['profile_picture'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'first_name' : firstName,
    'last_name' : lastName,
    'age' : age,
    'profile_picture' : profilePicture
  };
}