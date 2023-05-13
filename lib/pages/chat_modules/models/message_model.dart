class MessageModel {
  int? code;
  String? message;
  Data? data;

  MessageModel({this.code, this.message, this.data});

  MessageModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<MessageModelList>? list;
  int? totalRows;
  int? totalPage;

  Data({this.list, this.totalRows, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <MessageModelList>[];
      json['list'].forEach((v) {
        list!.add(new MessageModelList.fromJson(v));
      });
    }
    totalRows = json['total_rows'];
    totalPage = json['total_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['total_rows'] = totalRows;
    data['total_page'] = totalPage;
    return data;
  }
}

class MessageModelList {
  int? msgId;
  String? nickName;
  var avatar;
  var type;
  String? createdAt;
  int? userId;
  String? msg;
  String? file_name;

  MessageModelList(
      {this.msgId,
        this.nickName,
        this.avatar,
        this.type,
        this.createdAt,
        this.userId,
        this.file_name,
        this.msg});

  MessageModelList.fromJson(Map<String, dynamic> json) {
    msgId = json['msg_id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
    type = json['type'];
    createdAt = json['created_at'];
    userId = json['user_id'];
    msg = json['msg'];
    file_name = json['file_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg_id'] = this.msgId;
    data['nick_name'] = this.nickName;
    data['avatar'] = this.avatar;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['user_id'] = this.userId;
    data['msg'] = this.msg;
    return data;
  }
}
