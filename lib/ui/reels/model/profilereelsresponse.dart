class ProfileReelsResponse {
  final bool? success;
  final String? message;
  final Result? result;

  ProfileReelsResponse({
    this.success,
    this.message,
    this.result,
  });

  ProfileReelsResponse.fromJson(Map<String, dynamic> json)
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
  final UserDetails? userDetails;
  final List<ReelsDetails>? reelsDetails;

  Result({
    this.userDetails,
    this.reelsDetails,
  });

  Result.fromJson(Map<String, dynamic> json)
      : userDetails = (json['userDetails'] as Map<String,dynamic>?) != null ? UserDetails.fromJson(json['userDetails'] as Map<String,dynamic>) : null,
        reelsDetails = (json['reelsDetails'] as List?)?.map((dynamic e) => ReelsDetails.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'userDetails' : userDetails?.toJson(),
    'reelsDetails' : reelsDetails?.map((e) => e.toJson()).toList()
  };
}

class UserDetails {
  final int? totalreels;
  final String? id;
  final String? profilePicture;
  final String? firstName;
  final String? lastName;
  final String? bio;

  UserDetails({
    this.totalreels,
    this.id,
    this.profilePicture,
    this.firstName,
    this.lastName,
    this.bio,
  });

  UserDetails.fromJson(Map<String, dynamic> json)
      : totalreels = json['totalreels'] as int?,
        id = json['_id'] as String?,
        profilePicture = json['profile_picture'] as String?,
        firstName = json['first_name'] as String?,
        lastName = json['last_name'] as String?,
        bio = json['bio'] as String?;

  Map<String, dynamic> toJson() => {
    'totalreels' : totalreels,
    '_id' : id,
    'profile_picture' : profilePicture,
    'first_name' : firstName,
    'last_name' : lastName,
    'bio' : bio
  };
}

class ReelsDetails {
  final String? reelId;
  final String? caption;
  final String? video;
  final int? totalLikes;
  final int? totalComments;
  final bool? isLikedByMe;
  final String? createdAt;

  ReelsDetails({
    this.reelId,
    this.caption,
    this.video,
    this.totalLikes,
    this.totalComments,
    this.isLikedByMe,
    this.createdAt,
  });

  ReelsDetails.fromJson(Map<String, dynamic> json)
      : reelId = json['reel_id'] as String?,
        caption = json['caption'] as String?,
        video = json['video'] as String?,
        totalLikes = json['totalLikes'] as int?,
        totalComments = json['totalComments'] as int?,
        isLikedByMe = json['isLikedByMe'] as bool?,
        createdAt = json['createdAt'] as String?;

  Map<String, dynamic> toJson() => {
    'reel_id' : reelId,
    'caption' : caption,
    'video' : video,
    'totalLikes' : totalLikes,
    'totalComments' : totalComments,
    'isLikedByMe' : isLikedByMe,
    'createdAt' : createdAt
  };
}