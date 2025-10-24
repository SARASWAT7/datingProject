class MyCommentsResponse {
  final bool? success;
  final String? message;
  final Result? result;

  MyCommentsResponse({
    this.success,
    this.message,
    this.result,
  });

  MyCommentsResponse.fromJson(Map<String, dynamic> json)
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
  final String? reelId;
  final String? comment;
  final String? commentUserId;
  final String? id;
  final String? createdAt;
  final String? updatedAt;

  Result({
    this.reelId,
    this.comment,
    this.commentUserId,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  Result.fromJson(Map<String, dynamic> json)
      : reelId = json['reel_id'] as String?,
        comment = json['comment'] as String?,
        commentUserId = json['comment_user_id'] as String?,
        id = json['_id'] as String?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?;

  Map<String, dynamic> toJson() => {
    'reel_id' : reelId,
    'comment' : comment,
    'comment_user_id' : commentUserId,
    '_id' : id,
    'createdAt' : createdAt,
    'updatedAt' : updatedAt
  };
}