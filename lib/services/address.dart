class Address {
  /// 測試服務
  // static const String homeHost = 'http://118.190.37.156';
  ///socket
  static const String webSocket = 'wss://app.foodbuyer.com.hk/wss';

  /// 正式服务
  static const String homeHost = 'https://app.foodbuyer.com.hk/api/';
  static const String imageHomeHost = 'https://app.foodbuyer.com.hk/';


  static const String storage = '${Address.imageHomeHost}storage';

  /// 获取个人信息
  static const String userProfile = 'v1/user.profile';

  /// 修改用户信息
  static const String userSave = 'v1/user.save';

  /// 修改用户密码
  static const String changePassword = 'v1/user.change_password';
  /// 获取邮箱验证码
  static const String userEmailVerified = 'p1/user.email_verified';

  static const String userLogin = 'p1/user.login';
  static const String userCreate = 'p1/user.create';
  static const String userCreateSupplier = 'p1/supplier.create';
  static const String userCreateCompany = 'p1/company.create';
  static const String chatList = 'v1/chat.list';
  static const String searchChatMeg = 'v1/search.chat_msg';
  static const String chatTop = 'v1/chat.top';
  static const String cancelTop = 'v1/chat.cancel_top';
  static const String supplierCate = 'v1/supplier.cate';

  static const String chatLock = 'v1/chat.lock';
  static const String chatCancelLock = 'v1/chat.cancel_lock';

  static const String chatCreate = 'v1/chat.create';
  static const String chatReport = 'v1/chat.report';
  /// 退出登录
  static const String userLoginOut = 'v1/user.login_out';

  ///首页的列表
  static const String homeList = 'v1/post.list';
  /// 首頁詳情
  static const String postGet = 'v1/post.get';
  /// 創建post
  static const String postCreate = 'v1/post.create';
  /// 搜索
  static const String postSearch = 'v1/search.post';
  /// 搜索歷史
  static const String searchHistory = 'v1/search.history';
  /// 關注列表
  static const String postFollowList = 'v1/post.follow_list';

  /// 查看post類別
  static const String postCateList = 'v1/post.cate_list';
  /// 創建post類別
  static const String postCateCreate = 'v1/post.cate_create';
  /// 評論列表
  static const String postReplyList = 'v1/post.reply_list';
  /// 評論
  static const String postReplyCreate = 'v1/post.reply_create';
  /// 刪除評論
  static const String s = 'v1/post.reply_delete';
  /// 關注
  static const String postFollow = 'v1/post.follow';
  /// 取消關注
  static const String postFollowDelete = 'v1/post.follow_delete';
  /// 點贊
  static const String postLike = 'v1/post.zan';
  /// 取消點贊
  static const String postDeleteLike = 'v1/post.zan_delete';
  /// stripe config
  static const String stripeConfig = 'v1/stripe.config';
  /// stripe create
  static const String stripeCreate = 'v1/stripe.create';

  static const String supplierSubAccountList = 'v1/supplier.sub_accout_list';
  static const String supplierSubAccountCreate = 'v1/supplier.sub_accout_create';
  static const String supplierSubAccountDelete = 'v1/supplier.sub_accout_delete';

  ///  v1/search.user  参数 keyword
  static const String searchUse = 'v1/search.user';
  static const String searchSupplier = 'v1/search.supplier';
  /// 创建分类
  static const String cateCreate = 'v1/notepad.cate_create';
  /// 分類的列表
  static const String cateList = 'v1/notepad.cate_list';
  /// 笔记列表
  static const String notePadCates = 'v1/notepad.cates';
  /// 供應商個人詳情
  static const String supplierInfo = 'v1/supplier.info';
  /// 供應商商品列表
  static const String supplierProductList = 'v1/supplier.product_list';
  /// 供應商post list
  static const String supplierPostList = 'v1/supplier.post_list';
  /// 供应商关注
  static const String supplierFollow = 'v1/supplier.follow';
  /// 供应商关注列表
  static const String supplierFollowList = 'v1/supplier.follow_list';
  /// 供应商列表关注删除
  static const String supplierFollowDelete = 'v1/supplier.follow_delete';


  static const String notePadList= 'v1/notepad.list';

  /// 笔记添加
  static const String notePadAdd = 'v1/notepad.create';

  /// 刪除條目
  static const String notePaDelete = 'v1/notepad.delete';

  /// 聊天记录
  static const String chatRoom = 'v1/chat.room';
  static const String msgList = 'v1/msg.list';

  /// 離開聊天室
  static const String leaveChatRoom = 'v1/chat.leave';

  /// 聊天室添加人員
  static const String chatUserAdd = 'v1/chat.user_add';

  /// 聊天室添加人員
  static const String chatChangeName = 'v1/chat.change_name';

  /// 用户头像设置
  static const String updateAvatar = 'v1/user.update_avatar';

  static const String host = 'v1/public';
  static const String hostAuth = 'v1/auth';
  static const String upload = 'v1/upload';

  /// 退出登录
  static const String loginOut = 'v1/user.login_out';
}
