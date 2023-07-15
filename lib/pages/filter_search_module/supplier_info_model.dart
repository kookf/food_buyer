class SupplierInfoModel {
  int? code;
  String? message;
  Data? data;

  SupplierInfoModel({this.code, this.message, this.data});

  SupplierInfoModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  String? avatar;
  String? nickName;
  String? supplierName;
  var supplier_id;
  var brNo;
  var brFile;
  var user_id;
  var is_follow;
  String? introduce;
  String? logo;
  String? contactName;
  String? contactNumber;
  String? contactEmail;

  Data(
      {this.id,
        this.name,
        this.supplier_id,
        this.avatar,
        this.nickName,
        this.supplierName,
        this.brNo,
        this.brFile,
        this.introduce,
        this.logo,
        this.contactName,
        this.contactNumber,
        this.user_id,
        this.is_follow,
        this.contactEmail});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    nickName = json['nick_name'];
    supplierName = json['supplier_name'];
    brNo = json['br_no'];
    brFile = json['br_file'];
    introduce = json['introduce'];
    logo = json['logo'];
    contactName = json['contact_name'];
    contactNumber = json['contact_number'];
    contactEmail = json['contact_email'];
    user_id = json['user_id'];
    supplier_id = json['supplier_id'];
    is_follow = json['is_follow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['nick_name'] = this.nickName;
    data['supplier_name'] = this.supplierName;
    data['br_no'] = this.brNo;
    data['br_file'] = this.brFile;
    data['introduce'] = this.introduce;
    data['logo'] = this.logo;
    data['contact_name'] = this.contactName;
    data['contact_number'] = this.contactNumber;
    data['contact_email'] = this.contactEmail;
    return data;
  }
}
