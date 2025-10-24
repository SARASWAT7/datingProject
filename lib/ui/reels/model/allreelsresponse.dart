class AllReelsResponse {
  final bool? success;
  final String? message;
  final List<Result>? result;

  AllReelsResponse({
    this.success,
    this.message,
    this.result,
  });

  AllReelsResponse.fromJson(Map<String, dynamic> json)
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
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;
  final String? videoUrl;
  final String? videoId;
  final int? totalLikes;
  final int? totalComment;
  final String? caption;
  final String? createdAt;
  final bool? isLikedByMe;

  Result({
    this.userId,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.videoUrl,
    this.videoId,
    this.totalLikes,
    this.totalComment,
    this.caption,
    this.createdAt,
    this.isLikedByMe,
  });

  Result.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] as String?,
        firstName = json['first_name'] as String?,
        lastName = json['last_name'] as String?,
        profilePicture = json['profile_picture'] as String?,
        videoUrl = json['videoUrl'] as String?,
        videoId = json['video_id'] as String?,
        totalLikes = json['totalLikes'] as int?,
        totalComment = json['totalComment'] as int?,
        caption = json['caption'] as String?,
        createdAt = json['createdAt'] as String?,
        isLikedByMe = json['isLikedByMe'] as bool?;

  Map<String, dynamic> toJson() => {
    'userId' : userId,
    'first_name' : firstName,
    'last_name' : lastName,
    'profile_picture' : profilePicture,
    'videoUrl' : videoUrl,
    'video_id' : videoId,
    'totalLikes' : totalLikes,
    'totalComment' : totalComment,
    'caption' : caption,
    'createdAt' : createdAt,
    'isLikedByMe' : isLikedByMe
  };
}