class GetCommentsResponse {
  final bool? success;
  final String? message;
  final List<Result>? result;

  GetCommentsResponse({
    this.success,
    this.message,
    this.result,
  });

  GetCommentsResponse.fromJson(Map<String, dynamic> json)
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
  final String? reelId;
  final String? comment;
  final CommentUserId? commentUserId;
  final String? createdAt;
  final String? updatedAt;

  Result({
    this.id,
    this.reelId,
    this.comment,
    this.commentUserId,
    this.createdAt,
    this.updatedAt,
  });

  Result.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        reelId = json['reel_id'] as String?,
        comment = json['comment'] as String?,
        commentUserId = (json['comment_user_id'] as Map<String,dynamic>?) != null ? CommentUserId.fromJson(json['comment_user_id'] as Map<String,dynamic>) : null,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'reel_id' : reelId,
    'comment' : comment,
    'comment_user_id' : commentUserId?.toJson(),
    'createdAt' : createdAt,
    'updatedAt' : updatedAt
  };
}

class CommentUserId {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;

  CommentUserId({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePicture,
  });

  CommentUserId.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        firstName = json['first_name'] as String?,
        lastName = json['last_name'] as String?,
        profilePicture = json['profile_picture'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'first_name' : firstName,
    'last_name' : lastName,
    'profile_picture' : profilePicture
  };
}