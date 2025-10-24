class NotificationDeleteResponse {
  final bool? success;
  final String? message;
  final Result? result;

  NotificationDeleteResponse({
    this.success,
    this.message,
    this.result,
  });

  NotificationDeleteResponse.fromJson(Map<String, dynamic> json)
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
  final String? id;
  final String? title;
  final String? type;
  final String? senderId;
  final String? senderFirebase;
  final String? receiverId;
  final String? senderProfilePicture;
  final String? channelName;
  final String? token;
  final String? message;
  final bool? isRead;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  Result({
    this.id,
    this.title,
    this.type,
    this.senderId,
    this.senderFirebase,
    this.receiverId,
    this.senderProfilePicture,
    this.channelName,
    this.token,
    this.message,
    this.isRead,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Result.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        title = json['title'] as String?,
        type = json['type'] as String?,
        senderId = json['sender_id'] as String?,
        senderFirebase = json['sender_firebase'] as String?,
        receiverId = json['receiver_id'] as String?,
        senderProfilePicture = json['sender_profile_picture'] as String?,
        channelName = json['channelName'] as String?,
        token = json['token'] as String?,
        message = json['message'] as String?,
        isRead = json['is_read'] as bool?,
        isActive = json['is_active'] as bool?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?,
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'title' : title,
    'type' : type,
    'sender_id' : senderId,
    'sender_firebase' : senderFirebase,
    'receiver_id' : receiverId,
    'sender_profile_picture' : senderProfilePicture,
    'channelName' : channelName,
    'token' : token,
    'message' : message,
    'is_read' : isRead,
    'is_active' : isActive,
    'createdAt' : createdAt,
    'updatedAt' : updatedAt,
    '__v' : v
  };
}