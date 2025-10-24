class GetQuestionsResponse {
  final bool? success;
  final String? message;
  final List<Result>? result;

  GetQuestionsResponse({
    this.success,
    this.message,
    this.result,
  });

  GetQuestionsResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        message = json['message'] as String?,
        result = (json['result'] as List?)?.map((dynamic e) => Result.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'success' : success,
    'message' : message,
    'result' : result?.map((e) => e.toJson()).toList()
  };
}

class Result {
  final String? id;
  final String? question;
  final List<String>? options;
  final String? type;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  Result({
    this.id,
    this.question,
    this.options,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Result.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        question = json['question'] as String?,
        options = (json['options'] as List?)?.map((dynamic e) => e as String).toList(),
        type = json['type'] as String?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?,
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
    '_id' : id,
    'question' : question,
    'options' : options,
    'type' : type,
    'createdAt' : createdAt,
    'updatedAt' : updatedAt,
    '__v' : v
  };
}