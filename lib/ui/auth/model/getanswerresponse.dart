class AllAnswerResponse {
  bool? success;
  String? message;
  List<Result>? result;

  AllAnswerResponse({this.success, this.message, this.result});

  AllAnswerResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? sId;
  String? answer;
  String? comment;
  String? userId;
  String? questionId;
  String? createdAt;
  String? updatedAt;

  Result(
      {this.sId,
      this.answer,
      this.comment,
      this.userId,
      this.questionId,
      this.createdAt,
      this.updatedAt});

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    answer = json['answer'];
    comment = json['comment'];
    userId = json['user_id'];
    questionId = json['question_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['answer'] = this.answer;
    data['comment'] = this.comment;
    data['user_id'] = this.userId;
    data['question_id'] = this.questionId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}