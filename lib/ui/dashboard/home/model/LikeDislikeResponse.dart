class LikeDislikeResponse {
  bool? success;
  String? message;
  Result? result;

  LikeDislikeResponse({this.success, this.message, this.result});

  LikeDislikeResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  NewLikes? newLikes;
  bool? isMatched;

  Result({this.newLikes, this.isMatched});

  Result.fromJson(Map<String, dynamic> json) {
    newLikes = json['newLikes'] != null
        ? new NewLikes.fromJson(json['newLikes'])
        : null;
    isMatched = json['isMatched'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.newLikes != null) {
      data['newLikes'] = this.newLikes!.toJson();
    }
    data['isMatched'] = this.isMatched;
    return data;
  }
}

class NewLikes {
  String? userId;
  String? likedUserId;
  bool? isRead;
  String? type;
  String? sId;
  String? createdAt;
  String? updatedAt;

  NewLikes(
      {this.userId,
        this.likedUserId,
        this.isRead,
        this.type,
        this.sId,
        this.createdAt,
        this.updatedAt});

  NewLikes.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    likedUserId = json['liked_user_id'];
    isRead = json['isRead'];
    type = json['type'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['liked_user_id'] = this.likedUserId;
    data['isRead'] = this.isRead;
    data['type'] = this.type;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
