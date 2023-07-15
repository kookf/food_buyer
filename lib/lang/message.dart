import 'package:get/get.dart';

class I18nContent {
  /// bottoast 提示框
  static const String updateSuccessfully = 'Update successfully';
  static const String verifyEmail = 'Verify email';

  static const String appTitleLabel = 'FoodBuyer';
  static const String notData = 'Not data';
  static const String errorText = 'Please enter the correct information';

  static const String selectLanguage = 'Select Language';
  static const String selectRegion = 'Select Region';
  static const String change = 'Change';
  static const String enterLabel = 'Enter';
  static const String hongKongCountry = 'HongKong';
  static const String macao = 'Macao';
  static const String china = 'China';


  static const String chineseTraditionalLabel = 'Chinese Traditional';
  static const String englishLabel = 'English';
  static const String chineseS = 'Chinese Simplified';
  static const String loginOutChatRom = 'Leave Chat Room';

  static const String loginLabel = 'Sign In';
  static const String signupLabel = 'Sign up';
  static const String createNewAccLabel = 'Create New Account';
  static const String emailAddressLabel = 'Email Address';
  static const String phoneLabel = 'Phone';
  static const String pleaseEnterYourEmail = 'Please enter your email address';
  static const String pleaseEnterYourPhone = 'Please enter your Phone';
  static const String passWord = 'Password';
  static const String pleaseEnterYourPassword = 'Please enter your password';

  ///register
  ///
  static const String selectAccountLabel = 'Select Account';
  static const String buyerLabel = 'Buyer';
  static const String supplier = 'Supplier';
  static const String executive = 'Executive';

  static const String sendLabel = 'Send';
  static const String confirm = 'Confirm';
  static const String delete = 'Delete';
  static const String reload = 'Reload';
  static const String registrationCompleted = 'Registration Completed';
  static const String resendLabel = 'Resend code';

  static const String message = 'Messages';
  static const String goToProfile = 'Go to Profile';

  /// signup individual buyer
  static const String individualBuyer = 'Individual buyer';
  static const String signupIndividualBuyerLabel = 'Sign up Individual buyer';
  static const String userNameDisPlayInChatroom =
      'User name (Display in Chatroom)';
  static const String individualLogoOptional = 'Individual Logo (Optional)';
  static const String companyDescriptionOptional =
      'Company Description (Optional)';
  static const String primaryContactName = 'Primary contact name ';
  static const String contactNumber = 'Contact phone number';
  static const String location = 'Location';
  static const String primaryContactEmail = 'Primary contact email';
  static const String primaryContactPassword = 'Primary password';
  static const String confirmedPassword = 'Confirmed password';
  static const String advertisementOptional = 'Advertisement (Optional) ';
  static const String termsAndAgreement = 'Terms and agreement  ';
  static const String sendRequest = 'Send Request';
  static const String next = 'Next';
  static const String registerSuccessful = 'Register Successful';

  /// signup enterprise buyer
  static const String enterPriseBuyerLabel = ' Enterprise buyer';
  static const String businessRegistrationNumber =
      'Business registration number';
  static const String uploadBusinessRegistration =
      'Upload business registration';
  static const String companyLogo = 'Company Logo(Optional)';

  /// signup supplier
  static const String companyNameLocal = 'Company Name(Local language)';
  static const String companyNameEn = 'Company Name(English)';

  static const String bottomBarHome = 'home';
  static const String bottomBarTQuotation = 'quotation';
  static const String bottomBarChat = 'chat';
  static const String bottomBarFavourite = 'favourite';
  static const String bottomBarMine = 'mine';

  static const String chatTitle = 'Chat';
  static const String searchChat = 'Search';
  static const String searchEdit = 'Edit';
  static const String addChat = 'Add Chat';
  static const String searchCancel = 'Cancel';
  static const String chatIndividual = 'Individual';
  static const String chatQuotation = 'Quotation';
  static const String favourite = 'Favourite';

  static const String accountProfile = 'Account Profile';
  static const String done = 'Done';

  ///Home
  static const String beginChat = 'Begin chat';
  static const String following = 'Following';
  static const String all = 'All';
  static const String latest = 'Latest';
  static const String mostView = 'Most View';
  static const String saySomething = 'say something';
  static const String tagLabel = 'tag';

  /// post
  static const String post = 'Post';
  static const String selectPicture = 'Select Picture';
  static const String selectAPicture = 'Select a Picture';
  static const String selectMultipleImages = 'Select multiple images';
  static const String selectVideo = 'Select Video';
  static const String uploadAVideoLinkMainImage = 'Upload a video link main image';
  /// filter search
  static const String filterSearch = 'Filter Search';
  static const String description = 'Description';
  static const String boardcast = 'Boardcast';
  static const String about = 'About';
  static const String files = 'Files';

  ///chat
  static const String addNewNotePad = 'Add New Notepad';
  static const String users = 'Users';
  static const String chatRoom = 'Chat room';
  static const String leftTheChatRoom = 'left the chat room';
  static const String createCategory = 'Create Category';
  /// setting
  static const String createPost = 'Create Post';
  static const String settings = 'Settings';
  static const String loginOut = 'Login Out';
  static const String areYouSureToLogOut = 'Are you sure to log out';
  static const String hint = 'Hint';

  static const String information = 'Information';
}

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        //1-配置中文繁體
        'zh_Hant': {
      ///
      I18nContent.updateSuccessfully: '更新成功',
      I18nContent.selectRegion: '選擇地区',
      I18nContent.change: '更改',
      I18nContent.verifyEmail: '驗證電郵',

      I18nContent.notData:'暫無內容',
      /// signup individual buyer
      ///
      I18nContent.individualBuyer: '個人買家',
      I18nContent.signupIndividualBuyerLabel: '註冊個人買家',
      I18nContent.userNameDisPlayInChatroom: '使用者名稱（顯示在聊天室中）',
      I18nContent.individualLogoOptional: '個人Logo(可選)',
      I18nContent.companyDescriptionOptional: '公司描述(可選)',
      I18nContent.primaryContactName: '主要聯係名',
      I18nContent.contactNumber: '聯係電話',
      I18nContent.registrationCompleted: '注冊完成',
      I18nContent.loginOutChatRom: '離開聊天室',

      I18nContent.next: '繼續',

      I18nContent.location: '位置',
      I18nContent.primaryContactEmail: '主要聯郵箱',
      I18nContent.primaryContactPassword: '主要密碼',
      I18nContent.advertisementOptional: '高級(可選)',

      /// signup enterprise buyer
      I18nContent.businessRegistrationNumber: '商业登记号码',
      I18nContent.sendRequest: '發送',

      I18nContent.bottomBarHome: "首頁",
      I18nContent.selectLanguage: '選擇語言',
      I18nContent.enterLabel: '確定',
      I18nContent.chineseTraditionalLabel: '中文繁體',
      I18nContent.chineseS: '中文簡體',
      I18nContent.loginLabel: "登入",
      I18nContent.signupLabel: '注冊',
      I18nContent.englishLabel: "英文",
      I18nContent.emailAddressLabel: '郵箱地址',
      I18nContent.createNewAccLabel: "創建一個新賬戶",
      I18nContent.pleaseEnterYourEmail: '請輸入郵箱地址',
      I18nContent.pleaseEnterYourPassword: '請輸入密碼',
      I18nContent.confirmedPassword: '確認密碼',

      I18nContent.enterPriseBuyerLabel: '企業買家',
      I18nContent.buyerLabel: '買方',
      I18nContent.supplier: '供應商',
      I18nContent.selectAccountLabel: '選擇一個賬戶',
      I18nContent.sendLabel: '發送',
      I18nContent.resendLabel: '重新發送',

      I18nContent.passWord: '密碼',
      I18nContent.bottomBarTQuotation: "問題",
      I18nContent.bottomBarChat: "聊天",
      I18nContent.bottomBarFavourite: "喜愛",
      I18nContent.bottomBarMine: "菜單",
      I18nContent.chatTitle: '聊天',
      I18nContent.searchChat: '搜索',
      I18nContent.searchEdit: '編輯',
      I18nContent.searchCancel: '取消',
      I18nContent.chatIndividual: '個人',
      I18nContent.chatQuotation: '語錄',
      I18nContent.favourite: '喜愛',
      /// 首頁
      I18nContent.all:'全部',
      I18nContent.latest:'最新',
      I18nContent.mostView:'最多查看',
      I18nContent.saySomething:'說點什麼吧',
      I18nContent.tagLabel:'標籤',

      /// 开始聊天
      I18nContent.beginChat: '開始聊天',
      I18nContent.addNewNotePad: '添加一個筆記,',
      I18nContent.leftTheChatRoom: '離開了聊天室',

      I18nContent.searchChat:'搜索',

      /// post create
      I18nContent.selectAPicture:'選擇一個張圖片',
      /// filter
      I18nContent.description:'描述',
      /// setting.
      I18nContent.accountProfile: '個人資料',
      I18nContent.done: '完成',
      I18nContent.createPost: '创建Post',
      I18nContent.settings: '設置',
      I18nContent.areYouSureToLogOut: '是否確認登出',
    },
        //1-配置中文简体
        'zh_CN': {
          ///
          I18nContent.updateSuccessfully: '更新成功',
          I18nContent.selectRegion: '选择地区',
          I18nContent.change: '更改',
          I18nContent.verifyEmail: '验证邮箱',
          I18nContent.loginOutChatRom: '離開聊天室',

          I18nContent.notData:'暂无内容',
          /// signup individual buyer
          I18nContent.individualBuyer: '个人卖家',
          I18nContent.signupIndividualBuyerLabel: '注册个人卖家',
          I18nContent.userNameDisPlayInChatroom: '使用者名稱（显示在聊天室中）',
          I18nContent.individualLogoOptional: '个人Logo(可选)',
          I18nContent.companyDescriptionOptional: '公司描述(可选)',
          I18nContent.primaryContactName: '主要联系人',
          I18nContent.contactNumber: '联系电话',
          I18nContent.registrationCompleted: '注册完成',

          I18nContent.next: '继续',

          I18nContent.location: '位置',
          I18nContent.primaryContactEmail: '主要联系邮箱',
          I18nContent.primaryContactPassword: '主要密码',
          I18nContent.advertisementOptional: '高級(可选)',

          /// signup enterprise buyer
          I18nContent.businessRegistrationNumber: '商业登记号码',
          I18nContent.sendRequest: '发送',

          I18nContent.bottomBarHome: "首页",
          I18nContent.selectLanguage: '选择语言',
          I18nContent.enterLabel: '确定',
          I18nContent.chineseTraditionalLabel: '中文繁体',
          I18nContent.chineseS: '中文简体',
          I18nContent.loginLabel: "登入",
          I18nContent.signupLabel: '注冊',
          I18nContent.englishLabel: "英文",
          I18nContent.emailAddressLabel: '邮箱地址',
          I18nContent.createNewAccLabel: "创建一个新账号",
          I18nContent.pleaseEnterYourEmail: '请输入邮箱地址',
          I18nContent.pleaseEnterYourPassword: '请输入密码',
          I18nContent.confirmedPassword: '确认密码',


          I18nContent.enterPriseBuyerLabel: '企业卖家',
          I18nContent.buyerLabel: '卖方',
          I18nContent.supplier: '供应商',
          I18nContent.selectAccountLabel: '选择一个账户',
          I18nContent.sendLabel: '发送',
          I18nContent.resendLabel: '重新发送',

          I18nContent.passWord: '密码',
          I18nContent.bottomBarTQuotation: "问题",
          I18nContent.bottomBarChat: "聊天",
          I18nContent.bottomBarFavourite: "喜爱",
          I18nContent.bottomBarMine: "菜单",
          I18nContent.chatTitle: '聊天',
          I18nContent.searchChat: '搜索',
          I18nContent.searchEdit: '编辑',
          I18nContent.searchCancel: '取消',
          I18nContent.chatIndividual: '个人',
          I18nContent.chatQuotation: '语录',
          I18nContent.favourite: '喜爱',
          /// 首頁
          I18nContent.all:'全部',
          I18nContent.latest:'最新',
          I18nContent.mostView:'最多查看',
          I18nContent.saySomething:'说点什么吧',
          I18nContent.tagLabel:'标签',

          /// 开始聊天
          I18nContent.beginChat: '开始聊天',
          I18nContent.addNewNotePad: '添加一个笔记,',
          I18nContent.leftTheChatRoom: '离开了聊天室',

          I18nContent.searchChat:'搜索',

          /// post create
          I18nContent.selectAPicture:'选择一张图片',
          /// filter
          I18nContent.description:'描述',
          /// setting.
          I18nContent.accountProfile: '个人资料',
          I18nContent.done: '完成',
          I18nContent.createPost: '创建Post',
          I18nContent.settings: '设置',
          I18nContent.areYouSureToLogOut: '是否确认登出',
        },
        //2-配置英文
        'en_US': {
          ///修改成功
          // I18nContent.updateSuccessfully: 'Update Successfully',
          //
          // I18nContent.bottomBarHome: "Home",
          // I18nContent.loginLabel: "Sign In",
          // I18nContent.signupLabel: "Sign up",
          // I18nContent.selectLanguage: 'Select Language',
          // I18nContent.enterLabel: 'Enter',
          // I18nContent.chineseTraditionalLabel: 'Chinese Traditional',
          // I18nContent.englishLabel: 'English',
          // I18nContent.emailAddressLabel: 'Email address',
          // I18nContent.createNewAccLabel: "Create New Account",
          // I18nContent.pleaseEnterYourEmail: 'Please enter your email',
          // I18nContent.registrationCompleted: 'Registration Completed',
          //
          // I18nContent.individualBuyer: 'Individual Buyer',
          // I18nContent.buyerLabel: 'Buyer',
          // I18nContent.supplier: 'Supplier',
          // I18nContent.enterPriseBuyerLabel: 'Enterprise Buyer',
          // I18nContent.selectAccountLabel: 'Select Account',
          // I18nContent.sendLabel: 'Send',
          // I18nContent.resendLabel: 'Resend code',
          //
          // I18nContent.businessRegistrationNumber:
          //     'Business registration number',
          //
          // I18nContent.sendRequest: 'Send Request',
          //
          // I18nContent.pleaseEnterYourPassword: 'Please enter your Password',
          // I18nContent.passWord: 'Password',
          // I18nContent.bottomBarTQuotation: "Quotation",
          // I18nContent.bottomBarChat: "Chat",
          // I18nContent.bottomBarFavourite: "Favourite",
          // I18nContent.bottomBarMine: "Me",
          // I18nContent.chatTitle: 'Chat',
          //
          // I18nContent.searchChat: 'Search',
          // I18nContent.searchEdit: 'Edit',
          // I18nContent.searchCancel: 'Cancel',
          // I18nContent.chatIndividual: 'Individual',
          // I18nContent.chatQuotation: 'Quotation',
          // I18nContent.favourite: 'Favourite',
          //
          // ///setting
          // I18nContent.accountProfile: 'Account Profile',
          // I18nContent.done: 'Done',
          //
          // ///Home
          // I18nContent.beginChat: 'Begin Chat',
          //
          // ///chat
          // I18nContent.addNewNotePad: 'Add New Notepad',
          // I18nContent.leftTheChatRoom: 'left the chatRoom',
          // I18nContent.createPost: 'Create Post',
        }
      };
}
