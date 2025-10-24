class FilterResponse {
  bool? success;
  String? message;
  Result? result;

  FilterResponse({this.success, this.message, this.result});

  FilterResponse.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? userId;
  bool? profileVerified;
  int? height;
  String? minPhoto;
  String? bio;
  List<String>? passions;
  String? exercise;
  String? drinking;
  String? smoking;
  List<String>? languages;
  String? education;
  String? haveKids;
  String? sunSign;
  String? religion;
  String? politic;
  String? pet;
  String? createdAt;
  String? updatedAt;

  Result(
      {this.sId,
      this.userId,
      this.profileVerified,
      this.height,
      this.minPhoto,
      this.bio,
      this.passions,
      this.exercise,
      this.drinking,
      this.smoking,
      this.languages,
      this.education,
      this.haveKids,
      this.sunSign,
      this.religion,
      this.politic,
      this.pet,
      this.createdAt,
      this.updatedAt});

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    profileVerified = json['profile_verified'];
    height = json['height'];
    minPhoto = json['min_photo'];
    bio = json['has_bio'];
    passions = json['passions'].cast<String>();
    exercise = json['exercise'];
    drinking = json['drinking'];
    smoking = json['smoking'];
    languages = json['languages'].cast<String>();
    education = json['education'];
    haveKids = json['have_kids'];
    sunSign = json['sun_sign'];
    religion = json['religion'];
    politic = json['politic'];
    pet = json['pet'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['profile_verified'] = this.profileVerified;
    data['height'] = this.height;
    data['min_photo'] = this.minPhoto;
    data['has_bio'] = this.bio;
    data['passions'] = this.passions;
    data['exercise'] = this.exercise;
    data['drinking'] = this.drinking;
    data['smoking'] = this.smoking;
    data['languages'] = this.languages;
    data['education'] = this.education;
    data['have_kids'] = this.haveKids;
    data['sun_sign'] = this.sunSign;
    data['religion'] = this.religion;
    data['politic'] = this.politic;
    data['pet'] = this.pet;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
