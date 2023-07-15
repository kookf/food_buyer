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
  List<NotePodListItem>? list;
  int? totalRows;
  int? totalPage;

  Data({this.list, this.totalRows, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <NotePodListItem>[];
      json['list'].forEach((v) {
        list!.add(new NotePodListItem.fromJson(v));
      });
    }
    totalRows = json['total_rows'];
    totalPage = json['total_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['total_rows'] = this.totalRows;
    data['total_page'] = this.totalPage;
    return data;
  }
}

class NotePodListItem {
  int? cateId;
  String? cateName;
  List<Notepads>? notepads;

  NotePodListItem({this.cateId, this.cateName, this.notepads});

  NotePodListItem.fromJson(Map<String, dynamic> json) {
    cateId = json['cate_id'];
    cateName = json['cate_name'];
    if (json['notepads'] != null) {
      notepads = <Notepads>[];
      json['notepads'].forEach((v) {
        notepads!.add(new Notepads.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cate_id'] = this.cateId;
    data['cate_name'] = this.cateName;
    if (this.notepads != null) {
      data['notepads'] = this.notepads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notepads {
  int? notepadId;
  int? msgId;
  String? nickName;
  String? avatar;
  int? type;
  String? msgTime;
  String? notepadTime;
  int? userId;
  String? msg;
  var fileName;

  Notepads(
      {this.notepadId,
        this.msgId,
        this.nickName,
        this.avatar,
        this.type,
        this.msgTime,
        this.notepadTime,
        this.userId,
        this.msg,
        this.fileName});

  Notepads.fromJson(Map<String, dynamic> json) {
    notepadId = json['notepad_id'];
    msgId = json['msg_id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
    type = json['type'];
    msgTime = json['msg_time'];
    notepadTime = json['notepad_time'];
    userId = json['user_id'];
    msg = json['msg'];
    fileName = json['file_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notepad_id'] = this.notepadId;
    data['msg_id'] = this.msgId;
    data['nick_name'] = this.nickName;
    data['avatar'] = this.avatar;
    data['type'] = this.type;
    data['msg_time'] = this.msgTime;
    data['notepad_time'] = this.notepadTime;
    data['user_id'] = this.userId;
    data['msg'] = this.msg;
    data['file_name'] = this.fileName;
    return data;
  }
}
