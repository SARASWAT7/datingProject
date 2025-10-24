class GetUserByUserIDModel {
  final bool? success;
  final String? message;
  final Result? result;

  GetUserByUserIDModel({
    this.success,
    this.message,
    this.result,
  });

  GetUserByUserIDModel.fromJson(Map<String, dynamic> json)
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
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? password;
  final String? dob;
  final int? age;
  final int? ageFrom;
  final int? ageTo;
  final int? height;
  final String? gender;
  final String? deviceToken;
  final String? accessToken;
  final String? deviceType;
  final String? profilePicture;
  final String? about;
  final bool? isActive;
  final bool? isDeleted;
  final bool? isOnline;
  final bool? isPrivate;
  final bool? keepLoggedIn;
  final bool? phoneVerified;
  final bool? emailVerified;
  final String? profileVerified;
  final bool? otpVerified;
  final String? loginWay;
  final String? country;
  final String? state;
  final String? isd;
  final String? latitude;
  final String? longitude;
  final List<String>? media;
  final String? relationshipStatus;
  final List<String>? interestedIn;
  final List<String>? mySexualOrientations;
  final String? degree;
  final String? profession;
  final List<String>? languages;
  final String? exercise;
  final String? smoking;
  final String? drinking;
  final String? religion;
  final String? haveKids;
  final String? politic;
  final String? pet;
  final String? quote;
  final String? sunSign;
  final List<String>? passions;
  final List<dynamic>? mySubscriptions;
  final int? profileCompletionPercentage;
  final int? questionAnswerPercentage;
  final dynamic lastLoginTime;
  final dynamic deletedTime;
  final bool? deleted;
  final String? createdAt;
  final String? updatedAt;
  final String? city;
  final int? distance;
  final bool? isCompleted;
  final bool? showBio;
  final int? firebaseId;
  final String? bio;

  Result({
    this.id,
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
    this.keepLoggedIn,
    this.phoneVerified,
    this.emailVerified,
    this.profileVerified,
    this.otpVerified,
    this.loginWay,
    this.country,
    this.state,
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
    this.city,
    this.distance,
    this.isCompleted,
    this.showBio,
    this.firebaseId,
    this.bio,
  });

  Result.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        firstName = json['first_name'] as String?,
        lastName = json['last_name'] as String?,
        phone = json['phone'] as String?,
        email = json['email'] as String?,
        password = json['password'] as String?,
        dob = json['dob'] as String?,
        age = json['age'] as int?,
        ageFrom = json['age_from'] as int?,
        ageTo = json['age_to'] as int?,
        height = json['height'] as int?,
        gender = json['gender'] as String?,
        deviceToken = json['device_token'] as String?,
        accessToken = json['access_token'] as String?,
        deviceType = json['device_type'] as String?,
        profilePicture = json['profile_picture'] as String?,
        about = json['about'] as String?,
        isActive = json['is_active'] as bool?,
        isDeleted = json['is_deleted'] as bool?,
        isOnline = json['is_online'] as bool?,
        isPrivate = json['is_private'] as bool?,
        keepLoggedIn = json['keep_loggedIn'] as bool?,
        phoneVerified = json['phone_verified'] as bool?,
        emailVerified = json['email_verified'] as bool?,
        profileVerified = json['profile_verified'] as String?,
        otpVerified = json['otp_verified'] as bool?,
        loginWay = json['login_way'] as String?,
        country = json['country'] as String?,
        state = json['state'] as String?,
        isd = json['isd'] as String?,
        latitude = json['latitude'] as String?,
        longitude = json['longitude'] as String?,
        media = (json['media'] as List?)?.map((dynamic e) => e as String).toList(),
        relationshipStatus = json['relationship_status'] as String?,
        interestedIn = (json['interested_in'] as List?)?.map((dynamic e) => e as String).toList(),
        mySexualOrientations = (json['my_sexual_orientations'] as List?)?.map((dynamic e) => e as String).toList(),
        degree = json['degree'] as String?,
        profession = json['profession'] as String?,
        languages = (json['languages'] as List?)?.map((dynamic e) => e as String).toList(),
        exercise = json['exercise'] as String?,
        smoking = json['smoking'] as String?,
        drinking = json['drinking'] as String?,
        religion = json['religion'] as String?,
        haveKids = json['have_kids'] as String?,
        politic = json['politic'] as String?,
        pet = json['pet'] as String?,
        quote = json['quote'] as String?,
        sunSign = json['sun_sign'] as String?,
        passions = (json['passions'] as List?)?.map((dynamic e) => e as String).toList(),
        mySubscriptions = json['my_subscriptions'] as List?,
        profileCompletionPercentage = json['profile_completion_percentage'] as int?,
        questionAnswerPercentage = json['question_answer_percentage'] as int?,
        lastLoginTime = json['last_login_time'],
        deletedTime = json['deleted_time'],
        deleted = json['deleted'] as bool?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?,
        city = json['city'] as String?,
        distance = json['distance'] as int?,
        isCompleted = json['is_completed'] as bool?,
        showBio = json['show_bio'] as bool?,
        firebaseId = json['firebase_id'] as int?,
        bio = json['bio'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'first_name' : firstName,
    'last_name' : lastName,
    'phone' : phone,
    'email' : email,
    'password' : password,
    'dob' : dob,
    'age' : age,
    'age_from' : ageFrom,
    'age_to' : ageTo,
    'height' : height,
    'gender' : gender,
    'device_token' : deviceToken,
    'access_token' : accessToken,
    'device_type' : deviceType,
    'profile_picture' : profilePicture,
    'about' : about,
    'is_active' : isActive,
    'is_deleted' : isDeleted,
    'is_online' : isOnline,
    'is_private' : isPrivate,
    'keep_loggedIn' : keepLoggedIn,
    'phone_verified' : phoneVerified,
    'email_verified' : emailVerified,
    'profile_verified' : profileVerified,
    'otp_verified' : otpVerified,
    'login_way' : loginWay,
    'country' : country,
    'state' : state,
    'isd' : isd,
    'latitude' : latitude,
    'longitude' : longitude,
    'media' : media,
    'relationship_status' : relationshipStatus,
    'interested_in' : interestedIn,
    'my_sexual_orientations' : mySexualOrientations,
    'degree' : degree,
    'profession' : profession,
    'languages' : languages,
    'exercise' : exercise,
    'smoking' : smoking,
    'drinking' : drinking,
    'religion' : religion,
    'have_kids' : haveKids,
    'politic' : politic,
    'pet' : pet,
    'quote' : quote,
    'sun_sign' : sunSign,
    'passions' : passions,
    'my_subscriptions' : mySubscriptions,
    'profile_completion_percentage' : profileCompletionPercentage,
    'question_answer_percentage' : questionAnswerPercentage,
    'last_login_time' : lastLoginTime,
    'deleted_time' : deletedTime,
    'deleted' : deleted,
    'createdAt' : createdAt,
    'updatedAt' : updatedAt,
    'city' : city,
    'distance' : distance,
    'is_completed' : isCompleted,
    'show_bio' : showBio,
    'firebase_id' : firebaseId,
    'bio' : bio
  };
}