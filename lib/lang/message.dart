import 'package:get/get.dart';

class I18nContent{

  static const String appTitleLabel = 'FoodBuyer';
  static const String notData = 'not Data';
  static const String errorText = 'Please enter the correct information';


  static const String selectLanguage = 'Select Language';
  static const String enterLabel = 'Enter';
  static const String chineseTraditionalLabel = 'Chinese Traditional';
  static const String englishLabel = 'English';


  static const String loginLabel = 'Sign In';
  static const String signupLabel = 'Sign up';
  static const String createNewAccLabel = 'Create New Account';
  static const String emailAddressLabel = 'emailAddress';
  static const String phoneLabel = 'Phone';
  static const String pleaseEnterYourEmail = 'Please enter your email';
  static const String pleaseEnterYourPhone = 'Please enter your Phone';
  static const String passWord = 'Password';
  static const String pleaseEnterYourPassword = 'Please enter your Password';

  ///register
  ///
  static const String selectAccountLabel = 'Select Account';
  static const String buyerLabel = 'Buyer';
  static const String supplier = 'Supplier';

  static const String sendLabel = 'Send';
  static const String confirm = 'Confirm';
  static const String registrationCompleted = 'Registration Completed';
  static const String resendLabel = 'Resend code';
  /// signup individual buyer
  static const String individualBuyer = 'Individual buyer';
  static const String signupIndividualBuyerLabel = 'Sign up Individual buyer';
  static const String userNameDisPlayInChatroom = 'User name (Display in Chatroom)';
  static const String individualLogoOptional = 'Individual Logo (Optional)';
  static const String companyDescriptionOptional = 'Company Description (Optional)';
  static const String primaryContactName  = 'Primary contact name ';
  static const String contactNumber  = 'Contact phone number';
  static const String location  = 'Location';
  static const String primaryContactEmail  = 'Primary contact email';
  static const String primaryContactPassword  = 'Primary password';
  static const String confirmedPassword  = 'Confirmed password';
  static const String advertisementOptional   = 'Advertisement (Optional) ';
  static const String termsAndAgreement   = 'Terms and agreement  ';
  static const String sendRequest   = 'Send Request';
  /// signup enterprise buyer
  static const String enterPriseBuyerLabel = ' Enterprise buyer';
  static const String businessRegistrationNumber = 'Business registration number';
  static const String uploadBusinessRegistration = 'Upload business registration';
  static const String companyLogo = 'Company Logo(Optional)';
  /// signup supplier
  static const String companyNameLocal = 'Company Name(Local language)';
  static const String companyNameEn = 'Company Name(English)';



  static const String bottomBarHome = 'home';
  static const String bottomBarTQuotation = 'quotation';
  static const String bottomBarChat= 'chat';
  static const String bottomBarFavourite= 'favourite';
  static const String bottomBarMine = 'mine';

  static const String chatTitle = 'title';
  static const String searchChat = 'search';
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
  ///chat
  static const String addNewNotePad = 'Add New Notepad';
  static const String users = 'Users';



}



class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    //1-配置中文繁體
    'zh_CN':{

      /// signup individual buyer
      ///
      I18nContent.individualBuyer:'個人買家',
      I18nContent.signupIndividualBuyerLabel:'註冊個人買家',
      I18nContent.userNameDisPlayInChatroom:'使用者名稱（顯示在聊天室中）',
      I18nContent.individualLogoOptional:'個人Logo(可選)',
      I18nContent.companyDescriptionOptional:'公司描述(可選)',
      I18nContent.primaryContactName:'主要聯係名',
      I18nContent.contactNumber:'聯係電話',
      I18nContent.registrationCompleted:'注冊完成',

      I18nContent.location:'位置',
      I18nContent.primaryContactEmail:'主要聯郵箱',
      I18nContent.primaryContactPassword:'主要密碼',
      I18nContent.advertisementOptional:'高級(可選)',
      /// signup enterprise buyer
      I18nContent.businessRegistrationNumber:'商业登记号码',
      I18nContent.sendRequest:'發送',


      I18nContent.bottomBarHome:"首頁",
      I18nContent.selectLanguage:'選擇語言',
      I18nContent.enterLabel:'確定',
      I18nContent.chineseTraditionalLabel:'中文繁體',
      I18nContent.loginLabel:"登入",
      I18nContent.signupLabel:'注冊',
      I18nContent.englishLabel:"英文",
      I18nContent.emailAddressLabel:'郵箱地址',
      I18nContent.createNewAccLabel:"創建一個新賬戶",
      I18nContent.pleaseEnterYourEmail :'請輸入郵箱地址',
      I18nContent.pleaseEnterYourPassword :'請輸入密碼',

      I18nContent.enterPriseBuyerLabel:'企業買家',
      I18nContent.buyerLabel:'買方',
      I18nContent.supplier:'供應商',
      I18nContent.selectAccountLabel: '選擇一個賬戶',
      I18nContent.sendLabel :'發送',
      I18nContent.resendLabel :'重新發送',


      I18nContent.passWord:'密碼',
      I18nContent.bottomBarTQuotation:"問題",
      I18nContent.bottomBarChat:"聊天",
      I18nContent.bottomBarFavourite:"喜愛",
      I18nContent.bottomBarMine:"菜單",
      I18nContent.chatTitle:'聊天',
      I18nContent.searchChat:'搜索',
      I18nContent.searchEdit:'編輯',
      I18nContent.searchCancel:'取消',
      I18nContent.chatIndividual:'個人',
      I18nContent.chatQuotation:'語錄',
      I18nContent.favourite:'喜愛',
      /// 开始聊天
      I18nContent.beginChat:'開始聊天',
      I18nContent.addNewNotePad:'添加一個筆記,',

      /// setting.
      I18nContent.accountProfile:'個人資料',
      I18nContent.done:'完成',

    },
    //2-配置英文
    'en_US':{
      I18nContent.bottomBarHome:"Home",
      I18nContent.loginLabel:"Sign In",
      I18nContent.signupLabel:"Sign up",
      I18nContent.selectLanguage:'Select Language',
      I18nContent.enterLabel:'Enter',
      I18nContent.chineseTraditionalLabel:'Chinese Traditional',
      I18nContent.englishLabel:'English',
      I18nContent.emailAddressLabel : 'Email address',
      I18nContent.createNewAccLabel:"Create New Account",
      I18nContent.pleaseEnterYourEmail :'Please enter your email',
      I18nContent.registrationCompleted:'Registration Completed',

      I18nContent.individualBuyer:'Individual Buyer',
      I18nContent.buyerLabel :'Buyer',
      I18nContent.supplier :'Supplier',
      I18nContent.enterPriseBuyerLabel:'Enterprise Buyer',
      I18nContent.selectAccountLabel :'Select Account',
      I18nContent.sendLabel :'Send',
      I18nContent.resendLabel :'Resend code',

      I18nContent.businessRegistrationNumber:'Business registration number',

      I18nContent.sendRequest:'Send Request',


      I18nContent.pleaseEnterYourPassword :'Please enter your Password',
      I18nContent.passWord : 'Password',
      I18nContent.bottomBarTQuotation:"Quotation",
      I18nContent.bottomBarChat:"Chat",
      I18nContent.bottomBarFavourite:"Favourite",
      I18nContent.bottomBarMine:"Me",
      I18nContent.chatTitle:'Chat',

      I18nContent.searchChat:'Search',
      I18nContent.searchEdit:'Edit',
      I18nContent.searchCancel:'Cancel',
      I18nContent.chatIndividual:'Individual',
      I18nContent.chatQuotation:'Quotation',
      I18nContent.favourite:'Favourite',

      ///setting
      I18nContent.accountProfile:'Account Profile',
      I18nContent.done : 'Done',
      ///Home
      I18nContent.beginChat:'Begin Chat',
      ///chat
      I18nContent.addNewNotePad:'Add New Notepad'



    }
  };
}


