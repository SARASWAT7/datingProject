class UserModel {
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final String email;
  final List<String> groupId;
  final String deviceToken;

  UserModel({
    required this.deviceToken,
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.email,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'deviceToken': deviceToken,
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'email': email,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      deviceToken: map['deviceToken'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      groupId: List<String>.from(map['groupId']),
    );
  }
}
