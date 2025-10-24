// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this, non_constant_identifier_names
class GetToken {
  bool? success;
  String? message;
  Result? result;

  GetToken({this.success, this.message, this.result});

  GetToken.fromJson(Map<String, dynamic> json) {
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
  ChannelToken? channelToken;

  Result({this.channelToken});

  Result.fromJson(Map<String, dynamic> json) {
    channelToken = json['channelToken'] != null
        ? new ChannelToken.fromJson(json['channelToken'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.channelToken != null) {
      data['channelToken'] = this.channelToken!.toJson();
    }
    return data;
  }
}

class ChannelToken {
  bool? success;
  String? channelName;
  String? token;
  int? expTime;
  int? uid;

  ChannelToken(
      {this.success, this.channelName, this.token, this.expTime, this.uid});

  ChannelToken.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    channelName = json['channelName'];
    token = json['token'];
    expTime = json['exp_Time'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['channelName'] = this.channelName;
    data['token'] = this.token;
    data['exp_Time'] = this.expTime;
    data['uid'] = this.uid;
    return data;
  }
}
