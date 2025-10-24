class AllNotificationDeleteResponse {
  final bool? success;
  final String? message;

  AllNotificationDeleteResponse({
    this.success,
    this.message,
  });

  AllNotificationDeleteResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'success' : success,
    'message' : message
  };
}