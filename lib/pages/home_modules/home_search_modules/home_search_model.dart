class HomeSearchModel {
  int? code;
  String? message;
  Data? data;

  HomeSearchModel({this.code, this.message, this.data});

  HomeSearchModel.fromJson(Map<String, dynamic> json) {
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
  List<HomeSearchList>? list;
  int? totalRows;
  int? totalPage;

  Data({this.list, this.totalRows, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <HomeSearchList>[];
      json['list'].forEach((v) {
        list!.add(new HomeSearchList.fromJson(v));
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

class HomeSearchList {
  int? id;
  int? userId;
  String? name;
  String? avatar;
  String? nickName;
  String? supplierName;
  String? title;
  String? body;
  String? res;
  int? resType;
  String? resLink;
  int? zanCount;
  int? isProduct;
  var price;
  int? replyCount;
  int? followCount;
  int? sort;
  String? createdAt;

  HomeSearchList(
      {this.id,
        this.userId,
        this.name,
        this.avatar,
        this.nickName,
        this.supplierName,
        this.title,
        this.body,
        this.res,
        this.resType,
        this.resLink,
        this.zanCount,
        this.isProduct,
        this.price,
        this.replyCount,
        this.followCount,
        this.sort,
        this.createdAt});

  HomeSearchList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    avatar = json['avatar'];
    nickName = json['nick_name'];
    supplierName = json['supplier_name'];
    title = json['title'];
    body = json['body'];
    res = json['res'];
    resType = json['res_type'];
    resLink = json['res_link'];
    zanCount = json['zan_count'];
    isProduct = json['is_product'];
    price = json['price'];
    replyCount = json['reply_count'];
    followCount = json['follow_count'];
    sort = json['sort'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['nick_name'] = this.nickName;
    data['supplier_name'] = this.supplierName;
    data['title'] = this.title;
    data['body'] = this.body;
    data['res'] = this.res;
    data['res_type'] = this.resType;
    data['res_link'] = this.resLink;
    data['zan_count'] = this.zanCount;
    data['is_product'] = this.isProduct;
    data['price'] = this.price;
    data['reply_count'] = this.replyCount;
    data['follow_count'] = this.followCount;
    data['sort'] = this.sort;
    data['created_at'] = this.createdAt;
    return data;
  }
}
