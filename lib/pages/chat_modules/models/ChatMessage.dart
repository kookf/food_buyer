enum ChatMessageType { text, audio, image, video,file }

enum MessageStatus { not_sent, not_view, viewed }

class ChatMessage {
  final String text;  /// 文本
  final String time;  /// 时间
  final ChatMessageType messageType; /// 类型
  final MessageStatus messageStatus; /// 状态
  final bool isSender; /// 是否是发送者
  final String? fileImagePath; /// 图片
  final String? filePath;  ///文件
  final String? fileName;  ///文件
  final String? avatar;  ///头像
   var msgId;  ///消息id
   var userId;  /// from_user_id
   var room_key;  /// from_user_id

  ChatMessage({
    this.text = '',
    required this.time,
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
    this.fileImagePath,
    this.filePath,
    this.fileName,
    this.avatar,
    this.msgId,
    this.userId,
    this.room_key,
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

