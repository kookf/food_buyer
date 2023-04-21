import 'package:bot_toast/bot_toast.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/colors.dart';
import '../../components/keep_alive_wrapper.dart';
import '../../home_page.dart';
import '../../lang/message.dart';
import '../chat_modules/chat_list_page.dart';
import '../home_modules/home_page.dart';
import '../mine_modules/mine_page.dart';
import 'bottom_controller.dart';



class TabPage extends GetView{


   final pageController = PageController();

   TabPage({super.key});


   Future<bool> _isExit()async {
     if (controller.lastTime == null ||
         DateTime.now().difference(controller.lastTime!) > const Duration(seconds: 2)) {
       controller.lastTime = DateTime.now();
       BotToast.showText(text: '在按一次退出應用');
       return Future.value(false);
     }
     return Future.value(true);
   }


  void onTap(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
      controller.currentIndex = index;
      controller.update();
  }

  @override
  final BottomController controller = Get.put(BottomController());

  final List<Widget> _listPageData = [
    // const KeepAliveWrapper(child: HomeConver()),
    KeepAliveWrapper(child: HomePage()),
    KeepAliveWrapper(child: HomePage()),
    KeepAliveWrapper(child: ChatListPage()),
    KeepAliveWrapper(child: MinePage(),),
    KeepAliveWrapper(child: MinePage(),),
    // MineView(),
    // MinePage(),
  ];

  @override

  Widget build(BuildContext context) {
    return GetBuilder<BottomController>(builder: (_){
      return WillPopScope(
        onWillPop: _isExit,
      child:  Scaffold(
        // body: _listPageData[_currentIndex],
        // body: bodyList[currentIndex],

        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: _listPageData, // 禁止滑动
        ),
        bottomNavigationBar:CustomNavigationBar(
          currentIndex: controller.currentIndex,
        onTap: onTap,
        items: [
        CustomNavigationBarItem(
        icon: Image.asset('images/ic_bottom_home.png',color: Colors.black54,),
        selectedIcon: Image.asset('images/ic_bottom_home.png',width: 24,height: 24,color: Colors.blueAccent,),
        // title: Text("hello"),
      ),
          CustomNavigationBarItem(
            icon: Image.asset('images/ic_bottom_quotation.png',width: 24,height: 24,color: Colors.black54,),
            selectedIcon: Image.asset('images/ic_bottom_quotation.png',width: 24,height: 24,color: Colors.blueAccent,),
          ),
          CustomNavigationBarItem(
            icon: Image.asset('images/ic_bottom_chat.png',width: 24,height: 24,color: Colors.black54,),
            selectedIcon: Image.asset('images/ic_bottom_chat.png',width: 24,height: 24,color: Colors.blueAccent,),
          ),
          CustomNavigationBarItem(
            icon: Image.asset('images/ic_bottom_favourite.png',width: 24,height: 24,color: Colors.black54,),
            selectedIcon: Image.asset('images/ic_bottom_favourite.png',width: 24,height: 24,color: Colors.blueAccent,),
          ),
          CustomNavigationBarItem(
            icon: Image.asset('images/ic_bottom_menu.png',width: 24,height: 24,color: Colors.black54,),
            selectedIcon: Image.asset('images/ic_bottom_menu.png',width: 24,height: 24,color: Colors.blueAccent,),
          ),
          ],
      )

        // BottomNavigationBar(
        //
        //   currentIndex: controller.currentIndex,//配置对应的索引值选中
        //   onTap: onTap,
        //   backgroundColor: Colors.white,
        //   iconSize: 20.0,//icon的大小
        //   fixedColor:Colors.blueAccent,//选中颜色
        //   selectedFontSize: 12,
        //   unselectedItemColor: Colors.black54,
        //   type: BottomNavigationBarType.fixed,
        //   // selectedItemColor: Colors.black54,
        //   items: [
        //     BottomNavigationBarItem(
        //       icon: Image.asset('images/ic_bottom_home.png',width: 24,height: 24,color: Colors.black54,),
        //       activeIcon: Image.asset('images/ic_bottom_home.png',width: 24,height: 24,color: Colors.blueAccent,),
        //       label: I18nContent.bottomBarHome.tr,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Image.asset('images/ic_bottom_quotation.png',width: 24,height: 24,color: Colors.black54,),
        //       activeIcon: Image.asset('images/ic_bottom_quotation.png',width: 24,height: 24,color: Colors.blueAccent,),
        //       label: I18nContent.bottomBarTQuotation.tr,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Image.asset('images/ic_bottom_chat.png',width: 24,height: 24,color: Colors.black54,),
        //       activeIcon: Image.asset('images/ic_bottom_chat.png',width: 24,height: 24,color: Colors.blueAccent,),
        //       label: I18nContent.bottomBarChat.tr,
        //     ),
        //     BottomNavigationBarItem(
        //         icon: Image.asset('images/ic_bottom_favourite.png',width: 24,height: 24,color: Colors.black54,),
        //         activeIcon: Image.asset('images/ic_bottom_favourite.png',width: 24,height: 24,color: Colors.blueAccent,),
        //         label: I18nContent.bottomBarMine.tr
        //     ),
        //     BottomNavigationBarItem(
        //         icon: Image.asset('images/ic_bottom_menu.png',width: 24,height: 24,color: Colors.black54,),
        //         activeIcon: Image.asset('images/ic_bottom_menu.png',width: 24,height: 24,color: Colors.blueAccent,),
        //         label: ''
        //     ),
        //   ],
        // ),

      ),
      );

    });
  }
}
