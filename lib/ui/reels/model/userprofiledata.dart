class UserDataReelsResponse {
  final bool? success;
  final String? message;
  final Result? result;

  UserDataReelsResponse({
    this.success,
    this.message,
    this.result,
  });

  UserDataReelsResponse.fromJson(Map<String, dynamic> json)
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
  final LoggedInUserData? loggedInUserData;
  final ReelOwnerData? reelOwnerData;
  final List<ReelsData>? reelsData;

  Result({
    this.loggedInUserData,
    this.reelOwnerData,
    this.reelsData,
  });

  Result.fromJson(Map<String, dynamic> json)
      : loggedInUserData = (json['loggedInUserData'] as Map<String,dynamic>?) != null ? LoggedInUserData.fromJson(json['loggedInUserData'] as Map<String,dynamic>) : null,
        reelOwnerData = (json['reelOwnerData'] as Map<String,dynamic>?) != null ? ReelOwnerData.fromJson(json['reelOwnerData'] as Map<String,dynamic>) : null,
        reelsData = (json['reelsData'] as List?)?.map((dynamic e) => ReelsData.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'loggedInUserData' : loggedInUserData?.toJson(),
    'reelOwnerData' : reelOwnerData?.toJson(),
    'reelsData' : reelsData?.map((e) => e.toJson()).toList()
  };
}

class LoggedInUserData {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;
  final int? firebaseId;

  LoggedInUserData({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.firebaseId,
  });

  LoggedInUserData.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        firstName = json['first_name'] as String?,
        lastName = json['last_name'] as String?,
        profilePicture = json['profile_picture'] as String?,
        firebaseId = json['firebase_id'] as int?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'first_name' : firstName,
    'last_name' : lastName,
    'profile_picture' : profilePicture,
    'firebase_id' : firebaseId
  };
}

class ReelOwnerData {
  final String? firstName;
  final String? lastName;
  final String? profilePicture;
  final int? firebaseId;
  final String? bio;
  final int? totalreels;

  ReelOwnerData({
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.firebaseId,
    this.bio,
    this.totalreels,
  });

  ReelOwnerData.fromJson(Map<String, dynamic> json)
      : firstName = json['first_name'] as String?,
        lastName = json['last_name'] as String?,
        profilePicture = json['profile_picture'] as String?,
        firebaseId = json['firebase_id'] as int?,
        bio = json['bio'] as String?,
        totalreels = json['totalreels'] as int?;

  Map<String, dynamic> toJson() => {
    'first_name' : firstName,
    'last_name' : lastName,
    'profile_picture' : profilePicture,
    'firebase_id' : firebaseId,
    'bio' : bio,
    'totalreels' : totalreels
  };
}

class ReelsData {
  final String? reelId;
  final String? caption;
  final String? video;
  final String? createdAt;
  final int? totalComments;
  final int? totalLikes;
  final bool? isLikedByMe;

  ReelsData({
    this.reelId,
    this.caption,
    this.video,
    this.createdAt,
    this.totalComments,
    this.totalLikes,
    this.isLikedByMe,
  });

  ReelsData.fromJson(Map<String, dynamic> json)
      : reelId = json['reel_id'] as String?,
        caption = json['caption'] as String?,
        video = json['video'] as String?,
        createdAt = json['createdAt'] as String?,
        totalComments = json['totalComments'] as int?,
        totalLikes = json['totalLikes'] as int?,
        isLikedByMe = json['isLikedByMe'] as bool?;

  Map<String, dynamic> toJson() => {
    'reel_id' : reelId,
    'caption' : caption,
    'video' : video,
    'createdAt' : createdAt,
    'totalComments' : totalComments,
    'totalLikes' : totalLikes,
    'isLikedByMe' : isLikedByMe
  };
}