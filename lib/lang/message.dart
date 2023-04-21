import 'package:get/get.dart';

class I18nContent{
  static const String appTitleLabel = 'FoodBuyer';

  static const String selectLanguage = 'Select Language';
  static const String enterLabel = 'Enter';
  static const String chineseTraditionalLabel = 'Chinese Traditional';
  static const String englishLabel = 'English';


  static const String loginLabel = 'Sign In';
  static const String createNewAccLabel = 'Create New Account';
  static const String emailAddressLabel = 'emailAddress';
  static const String pleaseEnterYourEmail = 'Please enter your email';
  static const String passWord = 'Password';
  static const String pleaseEnterYourPassword = 'Please enter your Password';

  ///register
  ///
  static const String selectAccountLabel = 'Select Account';
  static const String buyerLabel = 'Buyer';
  static const String supplier = 'Supplier';

  static const String sendLabel = 'Send';
  static const String resendLabel = 'Resend code';



  static const String bottomBarHome = 'home';
  static const String bottomBarTQuotation = 'quotation';
  static const String bottomBarChat= 'chat';
  static const String bottomBarFavourite= 'favourite';
  static const String bottomBarMine = 'mine';

  static const String chatTitle = 'title';
  static const String searchChat = 'search';
  static const String searchEdit = 'Edit';
  static const String chatIndividual = 'Individual';
  static const String chatQuotation = 'Quotation';

}



class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    //1-配置中文繁體
    'zh_CN':{
      I18nContent.bottomBarHome:"首頁",
      I18nContent.selectLanguage:'選擇語言',
      I18nContent.enterLabel:'確定',
      I18nContent.chineseTraditionalLabel:'中文繁體',
      I18nContent.loginLabel:"登入",
      I18nContent.englishLabel:"英文",
      I18nContent.emailAddressLabel:'郵箱地址',
      I18nContent.createNewAccLabel:"創建一個新賬戶",
      I18nContent.pleaseEnterYourEmail :'請輸入郵箱地址',
      I18nContent.pleaseEnterYourPassword :'請輸入密碼',

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
      I18nContent.chatIndividual:'個人',
      I18nContent.chatQuotation:'語錄',
    },
    //2-配置英文
    'en_US':{
      I18nContent.bottomBarHome:"Home",
      I18nContent.loginLabel:"Sign In",
      I18nContent.selectLanguage:'Select Language',
      I18nContent.enterLabel:'Enter',
      I18nContent.chineseTraditionalLabel:'Chinese Traditional',
      I18nContent.englishLabel:'English',
      I18nContent.emailAddressLabel : 'Email address',
      I18nContent.createNewAccLabel:"Create New Account",
      I18nContent.pleaseEnterYourEmail :'Please enter your email',

      I18nContent.buyerLabel :'Buyer',
      I18nContent.buyerLabel :'Supplier',
      I18nContent.selectAccountLabel :'Select Account',
      I18nContent.sendLabel :'Send',
      I18nContent.resendLabel :'Resend code',


      I18nContent.pleaseEnterYourPassword :'Please enter your Password',
      I18nContent.passWord : 'Password',
      I18nContent.bottomBarTQuotation:"Quotation",
      I18nContent.bottomBarChat:"Chat",
      I18nContent.bottomBarFavourite:"Favourite",
      I18nContent.bottomBarMine:"Me",
      I18nContent.chatTitle:'Chat',
      I18nContent.searchChat:'Search',
      I18nContent.searchEdit:'Edit',
      I18nContent.chatIndividual:'Individual',
      I18nContent.chatQuotation:'Quotation',
    }
  };
}


