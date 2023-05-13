class Address{

  /// 測試服務
  // static const String homeHost = 'http://118.190.37.156';
  ///socket
  static const String webSocket = 'wss://app.foodbuyer.com.hk/wss';
  /// 正式服务
  static const String homeHost = 'https://app.foodbuyer.com.hk';

  static const String storage =  '/storage';
  /// 获取个人信息
  static const String userProfile = '/api/v1/user.profile';
  /// 修改用户信息
  static const String userSave = '/api/v1/user.save';
  /// 修改用户密码
  static const String changePassword = '/api/v1/user.change_password';

  static const String userLogin = '/api/p1/user.login';
  static const String userCreate = '/api/p1/user.create';
  static const String userCreateSupplier = '/api/p1/supplier.create';
  static const String userCreateCompany = '/api/p1/company.create';
  static const String chatList = '/api/v1/chat.list';
  static const String chatCreate= '/api/v1/chat.create';
  /// /api/v1/search.user  参数 keyword
  static const String searchUse = '/api/v1/search.user';

  /// 笔记列表
  static const String notePadList= '/api/v1/msg.notepad_list';
  /// 笔记添加
  static const String notePadAdd= '/api/v1/msg.notepad_add';
  /// 刪除
  static const String notePaDelete = '/api/v1/msg.notepad_delete';
  /// 聊天记录
  static const String msgList = '/api/v1/msg.list';
  /// 離開聊天室
  static const String leaveChatRoom = '/api/v1/chat.leave';
  /// 聊天室添加人員
  static const String chatUserAdd = '/api/v1/chat.user_add';
  /// 聊天室添加人員
  static const String chatChangeName = '/api/v1/chat.change_name';

  /// 用户头像设置
  static const String updateAvatar = '/api/v1/user.update_avatar';


  static const String host = '/api/v1/public';
  static const String hostAuth = '/api/v1/auth';
  static const String upload = '/api/v1/upload';
  /// 退出登录
   static const String loginOut = '/api/v1/login_out';
}