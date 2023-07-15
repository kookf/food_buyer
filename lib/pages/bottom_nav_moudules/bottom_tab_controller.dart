import 'dart:async';
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/pages/favourite_modules/follow_list_modules/follow_list_page.dart';
import 'package:get/get.dart';
import '../../common/colors.dart';
import '../../common/foodbuyer_colors.dart';
import '../../components/keep_alive_wrapper.dart';
import '../../home_page.dart';
import '../../lang/message.dart';
import '../../services/address.dart';
import '../../utils/event_utils.dart';
import '../../utils/persisten_storage.dart';
import '../../utils/websocket_kk.dart';
import '../chat_modules/chat_list_page.dart';
import '../chat_modules/models/ChatMessage.dart';
import '../filter_search_module/filter_search_page.dart';
import '../home_modules/home_page.dart';
import '../mine_modules/menu_page.dart';
import '../mine_modules/supplier_follow_page.dart';
import '../mine_modules/supplier_mine_page.dart';
import 'bottom_controller.dart';
import 'dart:io' show Platform;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}


class TabPage1 extends StatefulWidget {
  const TabPage1({Key? key}) : super(key: key);

  @override
  State<TabPage1> createState() => _TabPage1State();
}

class _TabPage1State extends State<TabPage1> {
  final List<Widget> _listPageData = [
    // const KeepAliveWrapper(child: HomeConver()),
    KeepAliveWrapper(
      child: HomePage(),
    ),
    KeepAliveWrapper(
      child: FilterSearchPage(),
    ),
    KeepAliveWrapper(child: ChatListPage()),

    // KeepAliveWrapper(
    //   child: FollowListPage(),
    // ),
    KeepAliveWrapper(
      child: SupplierFollowPage(),
    ),
    KeepAliveWrapper(
      child: MenuPage(),
    )
  ];

  final pageController = PageController();

  int currentIndex = 0;

  DateTime? lastTime;



  Future<bool> _isExit() async {
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

    setState(() {});
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
    initWebSocket();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.snackbar('提示', '歡迎登錄');

    });
  }




  // 2.身份验证
  // socket.send('{"user_id":'+ user_id +',"key":"'+ socket_key +'","type":0}');
  // -1 心跳 0登录 1 文字消息 2 图片消息 3 文件消息
  var socket_status = 0;
  var userId;

  var eventBus;

  initWebSocket() async {
    WebSocketUtility().autoClose = true;
    userId = await PersistentStorage().getStorage('id');
    var socketKey = await PersistentStorage().getStorage('socket_key');
    // WebSocketSingleton().connect(Address.webSocket);
    // WebSocketSingleton().initHeartBeat();
    var params = {
      'user_id': userId,
      'key': socketKey,
      'type': 0,
    };
    var json = jsonEncode(params);
    print(json);
    WebSocketUtility().initWebSocket(
      onOpen: () {
        WebSocketUtility().initHeartBeat();
        WebSocketUtility().sendMessage(json);
      },
      onMessage: (event) {
        var json = jsonDecode(event);
        print('服务端返回的json===${json}');
        bool isSender;
        if (json['user_id'] == userId) {
          isSender = true;
        } else {
          isSender = false;
        }
        List<ChatMessage> mesArr = [];
        switch (json['type']) {
          case -1:
            // print('心条type-1');
            break;
          case 0:
            if (json['code'] == 200) {
              print('webSocket连接成功');
              // BotToast.showText(text: 'webSocket连接成功');
              if (socket_status == 0) {
                socket_status = 1;
              }
            } else {
              print('webSocket连接失败');
            }
            break;
          case 1:
            String time = json['time'];
            mesArr.insert(
                0,
                ChatMessage(
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
              'arr': mesArr,
              'type': 1,
            };

            EventBusUtil.fire(params);

            print('listtext =========${mesArr.length}');
            break;
          case 2:
            String time = json['time'];
            mesArr.insert(
                0,
                ChatMessage(
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
              'arr': mesArr,
              'type': 2,
            };
            EventBusUtil.fire(params);
            print('mesArr =========${mesArr}');
            break;
          case 3:
            String time = json['time'];
            mesArr.insert(
                0,
                ChatMessage(
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
              'arr': mesArr,
              'type': 3,
            };
            EventBusUtil.fire(params);
            print('mesArr =========${mesArr}');
            break;
          case 4:

            ///聊天室人员离开 ，接收到该消息，刷新人员结构
            String time = json['time'];
            mesArr.insert(
                0,
                ChatMessage(
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
              'arr': mesArr,
              'type': 4,
              'user_nums': json['user_nums'],
            };
            EventBusUtil.fire(params);
            break;
          case 5:

            ///发送语音
            String time = json['time'];
            mesArr.insert(
                0,
                ChatMessage(
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

            var params = {'arr': mesArr, 'type': 5};
            EventBusUtil.fire(params);
            break;

          case 10:

            ///创建聊天室或者 添加人员。。接收到该消息，有匹配的 room_key,刷新人员结构。
            ///。没有匹配 添加一个聊天室。
            List userList = json['user_list'];
            var params = {
              'userList': userList,
              'type': 10,
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
      },
      onError: (e) {
        print('bottom error =====${e}');
        BotToast.showText(text: '與webSocket服務器斷開了連接');
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _isExit,
      child: Scaffold(
          // body: _listPageData[_currentIndex],
          // body: bodyList[currentIndex],
          body: PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            children: _listPageData, // 禁止滑动
          ),
          bottomNavigationBar: CustomNavigationBar(
            iconSize: 28,
            currentIndex: currentIndex,
            onTap: onTap,
            items: [
              CustomNavigationBarItem(
                icon: Image.asset(
                  width: 24,
                  height: 24,
                  'images/ic_bottom_home.png',
                  color: Colors.black54,
                ),
                selectedIcon: Container(
                  decoration: BoxDecoration(
                    color: kDTCloud500,
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/ic_bottom_home.png',
                      width: 18,
                      height: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                // title: Text("hello"),
              ),
              CustomNavigationBarItem(
                icon: Image.asset(
                  'images/ic_bottom_quotation.png',
                  width: 24,
                  height: 24,
                  color: Colors.black54,
                ),
                selectedIcon: Container(
                  decoration: BoxDecoration(
                      color: kDTCloud500,
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/ic_bottom_quotation.png',
                      width: 18,
                      height: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: Image.asset(
                  'images/ic_bottom_chat.png',
                  width: 24,
                  height: 24,
                  color: Colors.black54,
                ),
                selectedIcon: Container(
                  decoration: BoxDecoration(
                      color: kDTCloud500,
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/ic_bottom_chat.png',
                      width: 18,
                      height: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: Image.asset(
                  'images/ic_bottom_favourite.png',
                  width: 24,
                  height: 24,
                  color: Colors.black54,
                ),
                selectedIcon: Container(
                  decoration: BoxDecoration(
                      color: kDTCloud500,
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/ic_bottom_favourite.png',
                      width: 18,
                      height: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: Image.asset(
                  'images/ic_bottom_menu.png',
                  width: 24,
                  height: 24,
                  color: Colors.black54,
                ),
                selectedIcon: Container(
                  decoration: BoxDecoration(
                      color: kDTCloud500,
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/ic_bottom_menu.png',
                      width: 18,
                      height: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
          ),
    );
  }
}
