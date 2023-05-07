import 'dart:convert';

/// user_id : 12
/// nick_name : "Kun"
/// avatar : null

UserList userListFromJson(String str) => UserList.fromJson(json.decode(str));
String userListToJson(UserList data) => json.encode(data.toJson());
class UserList {
  UserList({
      this.userId, 
      this.nickName, 
      this.avatar,});

  UserList.fromJson(dynamic json) {
    userId = json['user_id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
  }
  num? userId;
  String? nickName;
  dynamic avatar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['nick_name'] = nickName;
    map['avatar'] = avatar;
    return map;
  }

}