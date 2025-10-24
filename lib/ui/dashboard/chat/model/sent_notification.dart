// ignore_for_file: camel_case_types, unnecessary_new, prefer_collection_literals, unnecessary_this

class sentNotification {
  bool? status;
  String? message;

  sentNotification({this.status, this.message});

  sentNotification.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;

    return data;
  }
}
