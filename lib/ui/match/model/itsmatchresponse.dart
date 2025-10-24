class IItsMatchResponse {
  final bool? success;
  final String? message;
  final Result? result;

  IItsMatchResponse({
    this.success,
    this.message,
    this.result,
  });

  IItsMatchResponse.fromJson(Map<String, dynamic> json)
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
  final List<AllMatches>? allMatches;

  Result({
    this.allMatches,
  });

  Result.fromJson(Map<String, dynamic> json)
      : allMatches = (json['allMatches'] as List?)?.map((dynamic e) => AllMatches.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'allMatches' : allMatches?.map((e) => e.toJson()).toList()
  };
}

class AllMatches {
  final String? id;
  final String? firstName;
  final int? age;
  final String? profilePicture;

  AllMatches({
    this.id,
    this.firstName,
    this.age,
    this.profilePicture,
  });

  AllMatches.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        firstName = json['first_name'] as String?,
        age = json['age'] as int?,
        profilePicture = json['profile_picture'] as String?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'first_name' : firstName,
    'age' : age,
    'profile_picture' : profilePicture
  };
}