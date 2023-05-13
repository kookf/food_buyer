import 'dart:async';
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/colors.dart';
import '../../components/keep_alive_wrapper.dart';
import '../../home_page.dart';
import '../../lang/message.dart';
import '../../services/address.dart';
import '../../utils/event_utils.dart';
import '../../utils/persisten_storage.dart';
import '../../utils/websocket_kk.dart';
import '../chat_modules/chat_list_page.dart';
import '../chat_modules/models/ChatMessage.dart';
import '../favourite_modules/favourite_page.dart';
import '../filter_search_module/filter_search_page.dart';
import '../home_modules/home_page.dart';
import '../mine_modules/menu_page.dart';
import '../mine_modules/mine_page.dart';
import 'bottom_controller.dart';
class TabPage1 extends StatefulWidget {
  const TabPage1({Key? key}) : super(key: key);

  @override
  State<TabPage1> createState() => _TabPage1State();
}

class _TabPage1State extends State<TabPage1> {



  final List<Widget> _listPageData = [
    // const KeepAliveWrapper(child: HomeConver()),
     KeepAliveWrapper(child:HomePage(),) ,
     KeepAliveWrapper(child:FilterSearchPage(),),
     KeepAliveWrapper(child:ChatListPage() ),
     KeepAliveWrapper(child:FavouritePage(),),
     KeepAliveWrapper(child:MenuPage(),)

  ];

  final pageController = PageController();

  int currentIndex = 0;

  DateTime? lastTime;



  Future<bool> _isExit()async {
    if (lastTime == null ||
        DateTime.now().difference(lastTime!) > const Duration(seconds: 2)) {
      lastTime = DateTime.now();
      BotToast.showText(text: '在按一次退出應用');
      return Future.value(false);
    }
    return Future.value(true);
  }


  void onTap(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    currentIndex = index;
    setState(() {

    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loginWebSocket();
    initWebSocket();
  }
  // 2.身份验证
  // socket.send('{"user_id":'+ user_id +',"key":"'+ socket_key +'","type":0}');
  // -1 心跳 0登录 1 文字消息 2 图片消息 3 文件消息
  var socket_status = 0;
  var userId;

  var eventBus;

  initWebSocket()async{
    WebSocketUtility().autoClose = true;
    userId = await PersistentStorage().getStorage('id');
    var socketKey = await PersistentStorage().getStorage('socket_key');
    // WebSocketSingleton().connect(Address.webSocket);
    // WebSocketSingleton().initHeartBeat();
    var params = {
      'user_id':userId,
      'key':socketKey,
      'type':0,
    };
    var json = jsonEncode(params);
    print(json);
    WebSocketUtility().initWebSocket(onOpen: () {
      WebSocketUtility().initHeartBeat();
      WebSocketUtility().sendMessage(json);
    }, onMessage: (event) {
      var json = jsonDecode(event);
      print('服务端返回的json===${json}');
      bool isSender;
      if(json['user_id'] == userId){
        isSender = true;
      }else{
        isSender = false;
      }
      List <ChatMessage> mesArr = [];
      switch (json['type']){
        case -1:
        // print('心条type-1');
          break;
        case 0:
          if(json['code'] == 200){
            print('webSocket连接成功');
            // BotToast.showText(text: 'webSocket连接成功');
            if(socket_status==0){
              socket_status = 1;
            }
          }else{
            print('webSocket连接失败');
          }
          break;
        case 1:
          String time = json['time'];
          mesArr.insert(0,ChatMessage(
              text: json['msg'],
              time: time,
              messageType: ChatMessageType.text,
              messageStatus: MessageStatus.viewed,
              msgId: json['msg_id'],
              userId: json['user_id'],
              room_key: json['room_key'],
              avatar: json['avatar'],
              nick_name: json['nick_name'],
              isSender: isSender));

          var params = {
            'arr':mesArr,
            'type':1,
          };

          EventBusUtil.fire(params);


          print('listtext =========${mesArr.length}');
          break;
        case 2:
          String time = json['time'];
          mesArr.insert(0,ChatMessage(
            // text: json['msg'],
              time: time,
              messageType: ChatMessageType.image,
              messageStatus: MessageStatus.viewed,
              fileImagePath: '${json['msg']}',
              msgId: json['msg_id'],
              avatar: json['avatar'],
              nick_name: json['nick_name'],
              userId: json['user_id'],
              isSender: isSender));
          var params = {
            'arr':mesArr,
            'type':2,
          };
          EventBusUtil.fire(params);
          print('mesArr =========${mesArr}');
          break;
        case 3:
          String time = json['time'];
          mesArr.insert(0,ChatMessage(
            // text: json['msg'],
              time: time,
              messageType: ChatMessageType.file,
              messageStatus: MessageStatus.viewed,
              filePath: '${json['msg']}',
              msgId: json['msg_id'],
              userId: json['user_id'],
              avatar: json['avatar'],
              nick_name: json['nick_name'],
              fileName: json['file_name'],
              isSender: isSender));
          var params = {
            'arr':mesArr,
            'type':3,
          };
          EventBusUtil.fire(params);
          print('mesArr =========${mesArr}');
          break;
        case 4:
        ///聊天室人员离开 ，接收到该消息，刷新人员结构
          String time = json['time'];
          mesArr.insert(0,ChatMessage(
              text: json['msg'],
              time: time,
              messageType: ChatMessageType.leaveText,
              messageStatus: MessageStatus.viewed,
              msgId: json['msg_id'],
              userId: json['user_id'],
              room_key: json['room_key'],
              avatar: json['avatar'],
              nick_name: json['nick_name'],
              type: 4,
              isSender: true));

          var params = {
            'arr':mesArr,
            'type':4,
            'user_nums':json['user_nums'],
          };
          EventBusUtil.fire(params);
          break;
        case 5:
        ///发送语音
          String time = json['time'];
          mesArr.insert(0,ChatMessage(
              text: json['msg'],
              time: time,
              messageType: ChatMessageType.audio,
              messageStatus: MessageStatus.viewed,
              msgId: json['msg_id'],
              userId: json['user_id'],
              room_key: json['room_key'],
              avatar: json['avatar'],
              nick_name: json['nick_name'],
              fileName: json['file_name'],
              type: 5,
              isSender: isSender));

          var params = {
            'arr':mesArr,
            'type':5
          };
          EventBusUtil.fire(params);
          break;

        case 10:
          ///创建聊天室或者 添加人员。。接收到该消息，有匹配的 room_key,刷新人员结构。
        ///。没有匹配 添加一个聊天室。
          List userList = json['user_list'];
          var params = {
            'userList':userList,
            'type':10,
          };
          EventBusUtil.fire(params);
          break;
        case 11:

        //   List userList = json['user_list'];
        //   var params = {
        //     'userList':userList,
        //     'type':11,
        //   };
        //   EventBusUtil.fire(params);
        //   break;

      }
    }, onError: (e) {
      print('bottom error =====${e}');
      BotToast.showText(text: '與webSocket服務器斷開了連接');
    },);


    // WebSocketSingleton().connect(Address.webSocket);
    // WebSocketSingleton().initHeartBeat();
    // var params = {
    //   'user_id':userId,
    //   'key':socketKey,
    //   'type':0,
    // };
    // var json = jsonEncode(params);
    // print(json);
    // WebSocketSingleton().send(json);
    // WebSocketSingleton().onMessage.listen((event) {
    //   var json = jsonDecode(event);
    //   print('服务端返回的json===${json}');
    //   bool isSender;
    //   if(json['user_id'] == userId){
    //     isSender = true;
    //   }else{
    //     isSender = false;
    //   }
    //   List <ChatMessage> mesArr = [];
    //
    //   switch (json['type']){
    //     case -1:
    //     // print('心条type-1');
    //       break;
    //     case 0:
    //       if(json['code'] == 200){
    //         BotToast.showText(text: 'webSocket连接成功');
    //         if(socket_status==0){
    //           socket_status = 1;
    //         }
    //       }else{
    //         BotToast.showText(text: 'webSocket连接失败');
    //       }
    //       break;
    //     case 1:
    //       String time = json['time'];
    //
    //       mesArr.insert(0,ChatMessage(
    //           text: json['msg'],
    //           time: time.substring(10),
    //           messageType: ChatMessageType.text,
    //           messageStatus: MessageStatus.viewed,
    //           msgId: json['msg_id'],
    //           userId: json['user_id'],
    //           room_key: json['room_key'],
    //           isSender: isSender));
    //       eventBus.fire(EventFn(mesArr));
    //
    //       print('listtext =========${mesArr.length}');
    //       break;
    //     case 2:
    //       String time = json['time'];
    //       mesArr.insert(0,ChatMessage(
    //         // text: json['msg'],
    //           time: time.substring(10),
    //           messageType: ChatMessageType.image,
    //           messageStatus: MessageStatus.viewed,
    //           fileImagePath: '${json['msg']}',
    //           msgId: json['msg_id'],
    //           userId: json['user_id'],
    //           isSender: isSender));
    //       eventBus.fire(EventFn(mesArr));
    //       print('mesArr =========${mesArr}');
    //       break;
    //     case 3:
    //       String time = json['time'];
    //       mesArr.insert(0,ChatMessage(
    //         // text: json['msg'],
    //           time: time.substring(10),
    //           messageType: ChatMessageType.file,
    //           messageStatus: MessageStatus.viewed,
    //           filePath: '${json['msg']}',
    //           msgId: json['msg_id'],
    //           userId: json['user_id'],
    //           fileName: json['file_name'],
    //           isSender: isSender));
    //       eventBus.fire(EventFn(mesArr));
    //
    //       print('mesArr =========${mesArr}');
    //
    //       break;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
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
            currentIndex: currentIndex,
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
  }
}





// class TabPage extends GetView{
//
//    final pageController = PageController();
//
//    TabPage({super.key});
//
//
//    Future<bool> _isExit()async {
//      if (controller.lastTime == null ||
//          DateTime.now().difference(controller.lastTime!) > const Duration(seconds: 2)) {
//        controller.lastTime = DateTime.now();
//        BotToast.showText(text: '在按一次退出應用');
//        return Future.value(false);
//      }
//      return Future.value(true);
//    }
//
//
//   void onTap(int index) {
//     pageController.jumpToPage(index);
//   }
//
//   void onPageChanged(int index) {
//       controller.currentIndex = index;
//       controller.update();
//   }
//
//   @override
//   final BottomController controller = Get.put(BottomController());
//
//   final List<Widget> _listPageData = [
//     // const KeepAliveWrapper(child: HomeConver()),
//     KeepAliveWrapper(child: HomePage()),
//     KeepAliveWrapper(child: FilterSearchPage()),
//     // KeepAliveWrapper(child: ChatListPage()),
//     ChatListPage(),
//     KeepAliveWrapper(child: FavouritePage(),),
//     KeepAliveWrapper(child: MenuPage(),),
//     // MineView(),
//     // MinePage(),
//   ];
//
//   @override
//
//   Widget build(BuildContext context) {
//     return GetBuilder<BottomController>(builder: (_){
//       return WillPopScope(
//         onWillPop: _isExit,
//       child:  Scaffold(
//         // body: _listPageData[_currentIndex],
//         // body: bodyList[currentIndex],
//         body: PageView(
//           controller: pageController,
//           onPageChanged: onPageChanged,
//           physics: const NeverScrollableScrollPhysics(),
//           children: _listPageData, // 禁止滑动
//         ),
//         bottomNavigationBar:CustomNavigationBar(
//           currentIndex: controller.currentIndex,
//         onTap: onTap,
//         items: [
//         CustomNavigationBarItem(
//         icon: Image.asset('images/ic_bottom_home.png',color: Colors.black54,),
//         selectedIcon: Image.asset('images/ic_bottom_home.png',width: 24,height: 24,color: Colors.blueAccent,),
//         // title: Text("hello"),
//       ),
//           CustomNavigationBarItem(
//             icon: Image.asset('images/ic_bottom_quotation.png',width: 24,height: 24,color: Colors.black54,),
//             selectedIcon: Image.asset('images/ic_bottom_quotation.png',width: 24,height: 24,color: Colors.blueAccent,),
//           ),
//           CustomNavigationBarItem(
//             icon: Image.asset('images/ic_bottom_chat.png',width: 24,height: 24,color: Colors.black54,),
//             selectedIcon: Image.asset('images/ic_bottom_chat.png',width: 24,height: 24,color: Colors.blueAccent,),
//           ),
//           CustomNavigationBarItem(
//             icon: Image.asset('images/ic_bottom_favourite.png',width: 24,height: 24,color: Colors.black54,),
//             selectedIcon: Image.asset('images/ic_bottom_favourite.png',width: 24,height: 24,color: Colors.blueAccent,),
//           ),
//           CustomNavigationBarItem(
//             icon: Image.asset('images/ic_bottom_menu.png',width: 24,height: 24,color: Colors.black54,),
//             selectedIcon: Image.asset('images/ic_bottom_menu.png',width: 24,height: 24,color: Colors.blueAccent,),
//           ),
//           ],
//       )
//
//         // BottomNavigationBar(
//         //
//         //   currentIndex: controller.currentIndex,//配置对应的索引值选中
//         //   onTap: onTap,
//         //   backgroundColor: Colors.white,
//         //   iconSize: 20.0,//icon的大小
//         //   fixedColor:Colors.blueAccent,//选中颜色
//         //   selectedFontSize: 12,
//         //   unselectedItemColor: Colors.black54,
//         //   type: BottomNavigationBarType.fixed,
//         //   // selectedItemColor: Colors.black54,
//         //   items: [
//         //     BottomNavigationBarItem(
//         //       icon: Image.asset('images/ic_bottom_home.png',width: 24,height: 24,color: Colors.black54,),
//         //       activeIcon: Image.asset('images/ic_bottom_home.png',width: 24,height: 24,color: Colors.blueAccent,),
//         //       label: I18nContent.bottomBarHome.tr,
//         //     ),
//         //     BottomNavigationBarItem(
//         //       icon: Image.asset('images/ic_bottom_quotation.png',width: 24,height: 24,color: Colors.black54,),
//         //       activeIcon: Image.asset('images/ic_bottom_quotation.png',width: 24,height: 24,color: Colors.blueAccent,),
//         //       label: I18nContent.bottomBarTQuotation.tr,
//         //     ),
//         //     BottomNavigationBarItem(
//         //       icon: Image.asset('images/ic_bottom_chat.png',width: 24,height: 24,color: Colors.black54,),
//         //       activeIcon: Image.asset('images/ic_bottom_chat.png',width: 24,height: 24,color: Colors.blueAccent,),
//         //       label: I18nContent.bottomBarChat.tr,
//         //     ),
//         //     BottomNavigationBarItem(
//         //         icon: Image.asset('images/ic_bottom_favourite.png',width: 24,height: 24,color: Colors.black54,),
//         //         activeIcon: Image.asset('images/ic_bottom_favourite.png',width: 24,height: 24,color: Colors.blueAccent,),
//         //         label: I18nContent.bottomBarMine.tr
//         //     ),
//         //     BottomNavigationBarItem(
//         //         icon: Image.asset('images/ic_bottom_menu.png',width: 24,height: 24,color: Colors.black54,),
//         //         activeIcon: Image.asset('images/ic_bottom_menu.png',width: 24,height: 24,color: Colors.blueAccent,),
//         //         label: ''
//         //     ),
//         //   ],
//         // ),
//
//       ),
//       );
//
//     });
//   }
// }
