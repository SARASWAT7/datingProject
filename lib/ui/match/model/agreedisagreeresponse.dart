class AgreeDisagreeResponse {
  final bool? success;
  final String? message;
  final Result? result;

  AgreeDisagreeResponse({
    this.success,
    this.message,
    this.result,
  });

  AgreeDisagreeResponse.fromJson(Map<String, dynamic> json)
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
  final num? agreeCount;
  final num? disagreeCount;
  final num? matchPercentage;
  final num? findOut;
  final List<AgreeAnswer>? agreeAnswer;
  final List<DisagreeAnswer>? disagreeAnswer;
  final String? profilePic;

  Result({
    this.agreeCount,
    this.disagreeCount,
    this.matchPercentage,
    this.findOut,
    this.agreeAnswer,
    this.disagreeAnswer,
    this.profilePic,
  });

  Result.fromJson(Map<String, dynamic> json)
      : agreeCount = json['agreeCount'] as num?,
        disagreeCount = json['disagreeCount'] as num?,
        matchPercentage = json['matchPercentage'] as num?,
        findOut = json['findOut'] as num?,
        agreeAnswer = (json['agreeAnswer'] as List?)?.map((dynamic e) => AgreeAnswer.fromJson(e as Map<String,dynamic>)).toList(),
        disagreeAnswer = (json['disagreeAnswer'] as List?)?.map((dynamic e) => DisagreeAnswer.fromJson(e as Map<String,dynamic>)).toList(),
        profilePic = json['profile_pic'] as String?;

  Map<String, dynamic> toJson() => {
    'agreeCount' : agreeCount,
    'disagreeCount' : disagreeCount,
    'matchPercentage' : matchPercentage,
    'findOut' : findOut,
    'agreeAnswer' : agreeAnswer?.map((e) => e.toJson()).toList(),
    'disagreeAnswer' : disagreeAnswer?.map((e) => e.toJson()).toList(),
    'profile_pic' : profilePic
  };
}

class AgreeAnswer {
  final MatchedQuestion? matchedQuestion;
  final String? userAnswer;
  final String? matchUserAnswer;

  AgreeAnswer({
    this.matchedQuestion,
    this.userAnswer,
    this.matchUserAnswer,
  });

  AgreeAnswer.fromJson(Map<String, dynamic> json)
      : matchedQuestion = (json['matchedQuestion'] as Map<String,dynamic>?) != null ? MatchedQuestion.fromJson(json['matchedQuestion'] as Map<String,dynamic>) : null,
        userAnswer = json['user_answer'] as String?,
        matchUserAnswer = json['matchUser_answer'] as String?;

  Map<String, dynamic> toJson() => {
    'matchedQuestion' : matchedQuestion?.toJson(),
    'user_answer' : userAnswer,
    'matchUser_answer' : matchUserAnswer
  };
}

class MatchedQuestion {
  final String? question;

  MatchedQuestion({
    this.question,
  });

  MatchedQuestion.fromJson(Map<String, dynamic> json)
      : question = json['question'] as String?;

  Map<String, dynamic> toJson() => {
    'question' : question
  };
}

class DisagreeAnswer {
  final UnmatchedQuestion? unmatchedQuestion;
  final String? userAnswer;
  final String? matchUserAnswer;

  DisagreeAnswer({
    this.unmatchedQuestion,
    this.userAnswer,
    this.matchUserAnswer,
  });

  DisagreeAnswer.fromJson(Map<String, dynamic> json)
      : unmatchedQuestion = (json['unmatchedQuestion'] as Map<String,dynamic>?) != null ? UnmatchedQuestion.fromJson(json['unmatchedQuestion'] as Map<String,dynamic>) : null,
        userAnswer = json['user_answer'] as String?,
        matchUserAnswer = json['matchUser_answer'] as String?;

  Map<String, dynamic> toJson() => {
    'unmatchedQuestion' : unmatchedQuestion?.toJson(),
    'user_answer' : userAnswer,
    'matchUser_answer' : matchUserAnswer
  };
}

class UnmatchedQuestion {
  final String? question;

  UnmatchedQuestion({
    this.question,
  });

  UnmatchedQuestion.fromJson(Map<String, dynamic> json)
      : question = json['question'] as String?;

  Map<String, dynamic> toJson() => {
    'question' : question
  };
}