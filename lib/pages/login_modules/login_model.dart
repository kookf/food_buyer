class LoginModel {
  int? code;
  String? message;
  Data? data;

  LoginModel({this.code, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  int? type;
  String? nickName;
  String? name;
  String? phone;
  var avatar;
  int? status;
  String? socketKey;
  String? token;

  Data(
      {this.id,
        this.type,
        this.nickName,
        this.name,
        this.phone,
        this.avatar,
        this.status,
        this.socketKey,
        this.token});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    nickName = json['nick_name'];
    name = json['name'];
    phone = json['phone'];
    avatar = json['avatar'];
    status = json['status'];
    socketKey = json['socket_key'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['nick_name'] = this.nickName;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['avatar'] = this.avatar;
    data['status'] = this.status;
    data['socket_key'] = this.socketKey;
    data['token'] = this.token;
    return data;
  }
}
