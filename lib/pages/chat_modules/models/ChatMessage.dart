enum ChatMessageType { text, audio, image, video,file,leaveText }

enum MessageStatus { not_sent, not_view, viewed }

class ChatMessage {
   var text;  /// 文本
   var time;  /// 时间
  final ChatMessageType? messageType; /// 类型
  final MessageStatus? messageStatus; /// 状态
  final bool isSender; /// 是否是发送者
  final String? fileImagePath; /// 图片
  final String? filePath;  ///文件
  final String? fileName;  ///文件
  final String? avatar;  ///头像
   var msgId;  ///消息id
   var userId;  /// from_user_id
   var room_key;  /// from_user_id
   var nick_name;  /// nicheng
   var level_nick_name;  /// level_nick_name
   var type;

  ChatMessage({
    this.text = '',
     this.time,
     this.messageType,
     this.messageStatus,
     required this.isSender,
    this.fileImagePath,
    this.filePath,
    this.fileName,
    this.avatar,
    this.msgId,
    this.userId,
    this.room_key,
    this.nick_name,
    this.level_nick_name,
    this.type,
  });


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['time'] = this.time;
    data['isSender'] = this.isSender;
    data['fileImagePath'] = this.fileImagePath;
    data['filePath'] = this.filePath;
    data['msgId'] = this.filePath;

    return data;
  }
}

