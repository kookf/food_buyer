class CommentModel {
  int? code;
  String? message;
  Data? data;

  CommentModel({this.code, this.message, this.data});

  CommentModel.fromJson(Map<String, dynamic> json) {
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
  List<CommentList>? list;
  int? totalRows;
  int? totalPage;

  Data({this.list, this.totalRows, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <CommentList>[];
      json['list'].forEach((v) {
        list!.add(new CommentList.fromJson(v));
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

class CommentList {
  int? id;
  String? nickName;
  var userId;
  String? avatar;
  String? body;
  int? isTop;
  int? isHot;
  int? replyCount;
  int? zanCount;
  String? createdAt;
  String? updatedAt;
  int? isZan;
  List<Replys>? replys;
  bool isExpand = false;

  CommentList(
      {this.id,
        this.nickName,
        this.userId,
        this.avatar,
        this.body,
        this.isTop,
        this.isHot,
        this.replyCount,
        this.zanCount,
        this.createdAt,
        this.updatedAt,
        this.isZan,

        this.replys});

  CommentList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
    userId = json['user_id'];
    body = json['body'];
    isTop = json['is_top'];
    isHot = json['is_hot'];
    replyCount = json['reply_count'];
    zanCount = json['zan_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isZan = json['is_zan'];
    if (json['replys'] != null) {
      replys = <Replys>[];
      json['replys'].forEach((v) {
        replys!.add(new Replys.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nick_name'] = this.nickName;
    data['avatar'] = this.avatar;
    data['body'] = this.body;
    data['is_top'] = this.isTop;
    data['is_hot'] = this.isHot;
    data['reply_count'] = this.replyCount;
    data['zan_count'] = this.zanCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_zan'] = this.isZan;
    if (this.replys != null) {
      data['replys'] = this.replys!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Replys {
  int? id;
  int? userId;
  String? nickName;
  String? avatar;
  String? body;
  String? replyNickName;
  int? replyUserId;
  int? replyCount;
  int? zanCount;
  String? createdAt;
  String? updatedAt;
  int? isZan;


  Replys(
      {this.id,
        this.userId,
        this.nickName,
        this.avatar,
        this.body,
        this.replyNickName,
        this.replyUserId,
        this.replyCount,
        this.zanCount,
        this.createdAt,
        this.updatedAt,
        this.isZan});

  Replys.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
    body = json['body'];
    replyNickName = json['reply_nick_name'];
    replyUserId = json['reply_user_id'];
    replyCount = json['reply_count'];
    zanCount = json['zan_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isZan = json['is_zan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['nick_name'] = this.nickName;
    data['avatar'] = this.avatar;
    data['body'] = this.body;
    data['reply_nick_name'] = this.replyNickName;
    data['reply_user_id'] = this.replyUserId;
    data['reply_count'] = this.replyCount;
    data['zan_count'] = this.zanCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_zan'] = this.isZan;
    return data;
  }
}
