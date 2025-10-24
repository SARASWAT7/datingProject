import 'dart:convert';

class FirebaseUserCreation {
  String email;
  int userId;
  String name;
  String mobile;
  String profilePic;
  String deviceToken;
  FirebaseUserCreation({
    required this.email,
    required this.userId,
    required this.deviceToken,
    required this.name,
    required this.mobile,
    required this.profilePic,
  });
  Map<String, dynamic> toMap() {
    return {
      'userID': userId,
      "deviceToken": deviceToken,
      'profilePic': profilePic,
      'email': email,
      'name': name,
      'mobile': mobile,
      'timestamp': DateTime.now().microsecondsSinceEpoch.toString()
    };
  }

  String getBody() => json.encode(toMap());
}
