class GetUserFireBaseId {
  bool? success;
  String? message;
  Result? result;

  GetUserFireBaseId({this.success, this.message, this.result});

  GetUserFireBaseId.fromJson(Map<String, dynamic> json) {
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
  bool? success;
  String? message;
  User? user;

  Result({this.success, this.message, this.user});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  Loc? loc;
  String? sId;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? password;
  String? dob;
  int? age;
  int? ageFrom;
  int? ageTo;
  int? height;
  String? gender;
  String? deviceToken;
  String? accessToken;
  String? deviceType;
  String? profilePicture;
  String? about;
  bool? isActive;
  bool? isDeleted;
  bool? isOnline;
  bool? isPrivate;
  bool? isCompleted;
  int? firebaseId;
  bool? keepLoggedIn;
  bool? phoneVerified;
  bool? emailVerified;
  String? profileVerified;
  bool? otpVerified;
  String? loginWay;
  String? country;
  String? state;
  String? city;
  String? isd;
  String? latitude;
  String? longitude;
  List<String>? media;
  String? relationshipStatus;
  List<String>? interestedIn;
  List<String>? mySexualOrientations;
  String? degree;
  String? profession;
  List<String>? languages;
  String? exercise;
  String? smoking;
  String? drinking;
  String? religion;
  String? haveKids;
  String? politic;
  String? pet;
  bool? showBio;
  String? bio;
  String? quote;
  String? sunSign;
  List<String>? passions;
  List<Null>? mySubscriptions;
  int? profileCompletionPercentage;
  int? questionAnswerPercentage;
  Null? lastLoginTime;
  Null? deletedTime;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  String? referralCode;

  User(
      {this.loc,
      this.sId,
      this.firstName,
      this.lastName,
      this.phone,
      this.email,
      this.password,
      this.dob,
      this.age,
      this.ageFrom,
      this.ageTo,
      this.height,
      this.gender,
      this.deviceToken,
      this.accessToken,
      this.deviceType,
      this.profilePicture,
      this.about,
      this.isActive,
      this.isDeleted,
      this.isOnline,
      this.isPrivate,
      this.isCompleted,
      this.firebaseId,
      this.keepLoggedIn,
      this.phoneVerified,
      this.emailVerified,
      this.profileVerified,
      this.otpVerified,
      this.loginWay,
      this.country,
      this.state,
      this.city,
      this.isd,
      this.latitude,
      this.longitude,
      this.media,
      this.relationshipStatus,
      this.interestedIn,
      this.mySexualOrientations,
      this.degree,
      this.profession,
      this.languages,
      this.exercise,
      this.smoking,
      this.drinking,
      this.religion,
      this.haveKids,
      this.politic,
      this.pet,
      this.showBio,
      this.bio,
      this.quote,
      this.sunSign,
      this.passions,
      this.mySubscriptions,
      this.profileCompletionPercentage,
      this.questionAnswerPercentage,
      this.lastLoginTime,
      this.deletedTime,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.referralCode});

  User.fromJson(Map<String, dynamic> json) {
    loc = json['loc'] != null ? new Loc.fromJson(json['loc']) : null;
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    dob = json['dob'];
    age = json['age'];
    ageFrom = json['age_from'];
    ageTo = json['age_to'];
    height = json['height'];
    gender = json['gender'];
    deviceToken = json['device_token'];
    accessToken = json['access_token'];
    deviceType = json['device_type'];
    profilePicture = json['profile_picture'];
    about = json['about'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    isOnline = json['is_online'];
    isPrivate = json['is_private'];
    isCompleted = json['is_completed'];
    firebaseId = json['firebase_id'];
    keepLoggedIn = json['keep_loggedIn'];
    phoneVerified = json['phone_verified'];
    emailVerified = json['email_verified'];
    profileVerified = json['profile_verified'];
    otpVerified = json['otp_verified'];
    loginWay = json['login_way'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    isd = json['isd'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    media = json['media'].cast<String>();
    relationshipStatus = json['relationship_status'];
    interestedIn = json['interested_in'].cast<String>();
    mySexualOrientations = json['my_sexual_orientations'].cast<String>();
    degree = json['degree'];
    profession = json['profession'];
    languages = json['languages'].cast<String>();
    exercise = json['exercise'];
    smoking = json['smoking'];
    drinking = json['drinking'];
    religion = json['religion'];
    haveKids = json['have_kids'];
    politic = json['politic'];
    pet = json['pet'];
    showBio = json['show_bio'];
    bio = json['bio'];
    quote = json['quote'];
    sunSign = json['sun_sign'];
    passions = json['passions'].cast<String>();

    profileCompletionPercentage = json['profile_completion_percentage'];
    questionAnswerPercentage = json['question_answer_percentage'];
    lastLoginTime = json['last_login_time'];
    deletedTime = json['deleted_time'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    referralCode = json['referralCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.loc != null) {
      data['loc'] = this.loc!.toJson();
    }
    data['_id'] = this.sId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['age_from'] = this.ageFrom;
    data['age_to'] = this.ageTo;
    data['height'] = this.height;
    data['gender'] = this.gender;
    data['device_token'] = this.deviceToken;
    data['access_token'] = this.accessToken;
    data['device_type'] = this.deviceType;
    data['profile_picture'] = this.profilePicture;
    data['about'] = this.about;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['is_online'] = this.isOnline;
    data['is_private'] = this.isPrivate;
    data['is_completed'] = this.isCompleted;
    data['firebase_id'] = this.firebaseId;
    data['keep_loggedIn'] = this.keepLoggedIn;
    data['phone_verified'] = this.phoneVerified;
    data['email_verified'] = this.emailVerified;
    data['profile_verified'] = this.profileVerified;
    data['otp_verified'] = this.otpVerified;
    data['login_way'] = this.loginWay;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['isd'] = this.isd;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['media'] = this.media;
    data['relationship_status'] = this.relationshipStatus;
    data['interested_in'] = this.interestedIn;
    data['my_sexual_orientations'] = this.mySexualOrientations;
    data['degree'] = this.degree;
    data['profession'] = this.profession;
    data['languages'] = this.languages;
    data['exercise'] = this.exercise;
    data['smoking'] = this.smoking;
    data['drinking'] = this.drinking;
    data['religion'] = this.religion;
    data['have_kids'] = this.haveKids;
    data['politic'] = this.politic;
    data['pet'] = this.pet;
    data['show_bio'] = this.showBio;
    data['bio'] = this.bio;
    data['quote'] = this.quote;
    data['sun_sign'] = this.sunSign;
    data['passions'] = this.passions;

    data['profile_completion_percentage'] = this.profileCompletionPercentage;
    data['question_answer_percentage'] = this.questionAnswerPercentage;
    data['last_login_time'] = this.lastLoginTime;
    data['deleted_time'] = this.deletedTime;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['referralCode'] = this.referralCode;
    return data;
  }
}

class Loc {
  String? type;
  List<int>? coordinates;

  Loc({this.type, this.coordinates});

  Loc.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}
