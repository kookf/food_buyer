class SupplierCateModel {
  int? code;
  String? message;
  Data? data;

  SupplierCateModel({this.code, this.message, this.data});

  SupplierCateModel.fromJson(Map<String, dynamic> json) {
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
  List<CateList>? list;

  Data({this.list});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <CateList>[];
      json['list'].forEach((v) {
        list!.add(CateList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CateList {
  int? cateId;
  String? cateName;
  List<SubCateList>? subCateList;

  CateList({this.cateId, this.cateName, this.subCateList});

  CateList.fromJson(Map<String, dynamic> json) {
    cateId = json['cate_id'];
    cateName = json['cate_name'];
    if (json['sub_cate_list'] != null) {
      subCateList = <SubCateList>[];
      json['sub_cate_list'].forEach((v) {
        subCateList!.add(new SubCateList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cate_id'] = this.cateId;
    data['cate_name'] = this.cateName;
    if (this.subCateList != null) {
      data['sub_cate_list'] = this.subCateList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCateList {
  int? id;
  var supplierId;
  String? name;
  var code;
  int? pid;
 var sort;
  int? show;
  int? status;
  int? depth;
  String? createdAt;
  String? updatedAt;
  var deletedAt;

  SubCateList(
      {this.id,
        this.supplierId,
        this.name,
        this.code,
        this.pid,
        this.sort,
        this.show,
        this.status,
        this.depth,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  SubCateList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supplierId = json['supplier_id'];
    name = json['name'];
    code = json['code'];
    pid = json['pid'];
    sort = json['sort'];
    show = json['show'];
    status = json['status'];
    depth = json['depth'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['supplier_id'] = this.supplierId;
    data['name'] = this.name;
    data['code'] = this.code;
    data['pid'] = this.pid;
    data['sort'] = this.sort;
    data['show'] = this.show;
    data['status'] = this.status;
    data['depth'] = this.depth;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
