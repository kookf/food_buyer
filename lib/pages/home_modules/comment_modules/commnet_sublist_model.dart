class CommentSubModel {
  int? code;
  String? message;
  Data? data;

  CommentSubModel({this.code, this.message, this.data});

  CommentSubModel.fromJson(Map<String, dynamic> json) {
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
  List<CommentSubList>? list;
  int? totalRows;
  int? totalPage;

  Data({this.list, this.totalRows, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <CommentSubList>[];
      json['list'].forEach((v) {
        list!.add(new CommentSubList.fromJson(v));
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

class CommentSubList {
  int? id;
  int? userId;
  String? nickName;
  String? avatar;
  String? body;
  int? isTop;
  int? isHot;
  String? replyNickName;
  int? replyUserId;
  int? replyCount;
  int? zanCount;
  String? createdAt;
  String? updatedAt;
  int? isZan;

  CommentSubList(
      {this.id,
        this.userId,
        this.nickName,
        this.avatar,
        this.body,
        this.isTop,
        this.isHot,
        this.replyNickName,
        this.replyUserId,
        this.replyCount,
        this.zanCount,
        this.createdAt,
        this.updatedAt,
        this.isZan});

  CommentSubList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
    body = json['body'];
    isTop = json['is_top'];
    isHot = json['is_hot'];
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
    data['is_top'] = this.isTop;
    data['is_hot'] = this.isHot;
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
