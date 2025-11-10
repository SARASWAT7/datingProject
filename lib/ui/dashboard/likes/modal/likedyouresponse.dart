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
  final UserId? userId;
  final String? likedUserId;
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
      userId = (json['user_id'] as Map<String,dynamic>?) != null ? UserId.fromJson(json['user_id'] as Map<String,dynamic>) : null,
      likedUserId = json['liked_user_id'] as String?,
      isRead = json['isRead'] as bool?,
      type = json['type'] as String?,
      createdAt = json['createdAt'] as String?,
      updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'user_id' : userId?.toJson(),
    'liked_user_id' : likedUserId,
    'isRead' : isRead,
    'type' : type,
    'createdAt' : createdAt,
    'updatedAt' : updatedAt
  };
}

class UserId {
  final String? id;
  final String? firstName;
  final String? lastName;
  final int? age;
  final String? profilePicture;
  final int? firebaseId;

  UserId({
    this.id,
    this.firstName,
    this.lastName,
    this.age,
    this.profilePicture,
    this.firebaseId,
  });

  UserId.fromJson(Map<String, dynamic> json)
    : id = json['_id'] as String?,
      firstName = json['first_name'] as String?,
      lastName = json['last_name'] as String?,
      age = json['age'] as int?,
      profilePicture = json['profile_picture'] as String?,
      firebaseId = json['firebase_id'] as int?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'first_name' : firstName,
    'last_name' : lastName,
    'age' : age,
    'profile_picture' : profilePicture,
    'firebase_id' : firebaseId
  };
}