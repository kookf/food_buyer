class ChatListModel {
  int? code;
  String? message;
  List<ChatListData>? data;

  ChatListModel({this.code, this.message, this.data});

  ChatListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ChatListData>[];
      json['data'].forEach((v) {
        data!.add(ChatListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatListData {
  int? roomId;
  String? roomName;
  String? roomKey;
  String? roomType;
  String? target_name;
  String? target_avatar;
  int? chatLastMsgId;
  var chat_last_at;
  var chatlastMsg;
  var is_top;
  var room_lock;
  var user_id;
  var chat_msg_not_read_nums;
  List<UserList>? userList;

  ChatListData(
      {this.roomId,
      this.roomName,
      this.roomKey,
      this.roomType,
      this.chat_last_at,
      this.target_name,
      this.target_avatar,
      this.user_id,
      this.chatLastMsgId,
      this.chatlastMsg,
      this.is_top,
      this.room_lock,
      this.chat_msg_not_read_nums,
      this.userList});

  ChatListData.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    roomName = json['room_name'];
    roomKey = json['room_key'];
    roomType = json['room_type'];
    target_name = json['target_name'];
    target_avatar = json['target_avatar'];
    is_top = json['is_top'];
    user_id = json['user_id'];
    chat_msg_not_read_nums = json['chat_msg_not_read_nums'];
    room_lock = json['room_lock'];
    chat_last_at = json['chat_last_at'];
    chatLastMsgId = json['chat_last_msg_id'];
    chatlastMsg = '';
    if (json['user_list'] != null) {
      userList = <UserList>[];
      json['user_list'].forEach((v) {
        userList!.add(new UserList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['room_name'] = this.roomName;
    data['room_key'] = this.roomKey;
    data['room_type'] = this.roomType;
    data['chat_last_msg_id'] = this.chatLastMsgId;
    if (this.userList != null) {
      data['user_list'] = this.userList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserList {
  int? userId;
  String? nickName;
  var avatar;
  var target_name;

  UserList({this.userId, this.nickName,
    this.avatar,
    this.target_name,

  });

  UserList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
    target_name = json['target_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['nick_name'] = this.nickName;
    data['avatar'] = this.avatar;
    return data;
  }
}
