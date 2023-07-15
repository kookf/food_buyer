class FollowModel {
  int? code;
  String? message;
  Data? data;

  FollowModel({this.code, this.message, this.data});

  FollowModel.fromJson(Map<String, dynamic> json) {
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
  List<FollowList>? list;
  int? totalRows;
  int? totalPage;

  Data({this.list, this.totalRows, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <FollowList>[];
      json['list'].forEach((v) {
        list!.add(FollowList.fromJson(v));
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

class FollowList {
  int? id;
  String? nickName;
  String? avatar;
  String? title;
  String? body;
  String? res;
  int? resType;
  int? isProduct;
  var price;
  int? replyCount;
  int? zanCount;
  int? followCount;
  String? createdAt;
  String? updatedAt;

  FollowList(
      {this.id,
        this.nickName,
        this.avatar,
        this.title,
        this.body,
        this.res,
        this.resType,
        this.isProduct,
        this.price,
        this.replyCount,
        this.zanCount,
        this.followCount,
        this.createdAt,
        this.updatedAt});

  FollowList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
    title = json['title'];
    body = json['body'];
    res = json['res'];
    resType = json['res_type'];
    isProduct = json['is_product'];
    price = json['price'];
    replyCount = json['reply_count'];
    zanCount = json['zan_count'];
    followCount = json['follow_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nick_name'] = this.nickName;
    data['avatar'] = this.avatar;
    data['title'] = this.title;
    data['body'] = this.body;
    data['res'] = this.res;
    data['res_type'] = this.resType;
    data['is_product'] = this.isProduct;
    data['price'] = this.price;
    data['reply_count'] = this.replyCount;
    data['zan_count'] = this.zanCount;
    data['follow_count'] = this.followCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
