class NotePadModel {
  int? code;
  String? message;
  Data? data;

  NotePadModel({this.code, this.message, this.data});

  NotePadModel.fromJson(Map<String, dynamic> json) {
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
  List<NotePadItem>? list;
  int? totalRows;
  int? totalPage;

  Data({this.list, this.totalRows, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <NotePadItem>[];
      json['list'].forEach((v) {
        list!.add(NotePadItem.fromJson(v));
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

class NotePadItem {
  int? msgId;
  String? nickName;
  var avatar;
  int? type;
  String? msgTime;
  String? notepaddTime;
  int? userId;
  String? msg;
  String? file_name;
  var notepad_id;

  NotePadItem(
      {this.msgId,
        this.nickName,
        this.avatar,
        this.type,
        this.msgTime,
        this.notepaddTime,
        this.userId,
        this.file_name,
        this.notepad_id,
        this.msg});

  NotePadItem.fromJson(Map<String, dynamic> json) {
    msgId = json['msg_id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
    type = json['type'];
    msgTime = json['msg_time'];
    notepaddTime = json['notepadd_time'];
    userId = json['user_id'];
    msg = json['msg'];
    file_name = json['file_name'];
    notepad_id = json['notepad_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg_id'] = this.msgId;
    data['nick_name'] = this.nickName;
    data['avatar'] = this.avatar;
    data['type'] = this.type;
    data['msg_time'] = this.msgTime;
    data['notepadd_time'] = this.notepaddTime;
    data['user_id'] = this.userId;
    data['msg'] = this.msg;
    return data;
  }
}
