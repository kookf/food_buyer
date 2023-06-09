import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:food_buyer/common/foodbuyer_theme.dart';
import 'package:food_buyer/pages/bottom_nav_moudules/bottom_tab_controller.dart';
import 'package:food_buyer/pages/bottom_nav_moudules/guide_page.dart';
import 'package:food_buyer/pages/home_modules/home_page.dart';
import 'package:food_buyer/pages/login_modules/login_page.dart';
import 'package:food_buyer/utils/persisten_storage.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'common/app_theme.dart';
import 'components/voice_widget.dart';
import 'home_page.dart';
import 'lang/message.dart';

void main() async{

  runApp(const MyApp());
  initData();
}


void initData()async{
  requestPermission();
  await PersistentStorage().setStorage('language', 'english');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'food_buyer',
      theme: FoodBuyerTheme().buildThemeData(),
      // 1 设置localizationsDelegates
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // 2 设置 supportedLocales 表示支持的国际化语言
      supportedLocales: const [
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'), //
        Locale.fromSubtags(languageCode: 'en'),
      ],
      translations: Messages(), // 你的翻译
      locale: const Locale('en', 'US'), // 默认指定的语言翻译
      fallbackLocale: const Locale('zh', 'Hant'), // 添
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: GuidePage(),
    );
  }
}
//申请权限
requestPermission() async {
  //多个权限申请
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    // Permission.location,
    Permission.storage,
    Permission.mediaLibrary,
    Permission.microphone,
  ].request();
  debugPrint('权限状态  ==== $statuses');

}