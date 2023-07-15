class SearchMessageModel {
  int? code;
  String? message;
  Data? data;

  SearchMessageModel({this.code, this.message, this.data});

  SearchMessageModel.fromJson(Map<String, dynamic> json) {
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
  List<SearchMessageList>? list;
  int? totalRows;
  int? totalPage;

  Data({this.list, this.totalRows, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <SearchMessageList>[];
      json['list'].forEach((v) {
        list!.add(SearchMessageList.fromJson(v));
      });
    }
    totalRows = json['total_rows'];
    totalPage = json['total_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['total_rows'] = this.totalRows;
    data['total_page'] = this.totalPage;
    return data;
  }
}

class SearchMessageList {
  int? msgId;
  String? nickName;
  String? avatar;
  int? type;
  String? createdAt;
  int? userId;
  String? msg;
  var fileName;
  String? roomKey;

  SearchMessageList(
      {this.msgId,
        this.nickName,
        this.avatar,
        this.type,
        this.createdAt,
        this.userId,
        this.msg,
        this.fileName,
        this.roomKey});

  SearchMessageList.fromJson(Map<String, dynamic> json) {
    msgId = json['msg_id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
    type = json['type'];
    createdAt = json['created_at'];
    userId = json['user_id'];
    msg = json['msg'];
    fileName = json['file_name'];
    roomKey = json['room_key'];
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
    data['file_name'] = this.fileName;
    data['room_key'] = this.roomKey;
    return data;
  }
}
