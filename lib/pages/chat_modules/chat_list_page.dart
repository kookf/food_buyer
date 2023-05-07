import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/chat_modules/chat_list_model.dart';
import 'package:food_buyer/pages/chat_modules/models/ChatMessage.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:get/get.dart';
import '../../common/colors.dart';
import '../../common/style.dart';
import '../../components/not_data_page.dart';
import '../../utils/event_utils.dart';
import '../../utils/hexcolor.dart';
import 'addchat_from_phone.dart';
import 'components/body.dart';
import 'note_pad_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);
  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with SingleTickerProviderStateMixin {

  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: false,
  );
  late TabController tabController;

  final List<String> _tabs = <String>[
    I18nContent.chatTitle.tr,
    'Notepad',
  ];

  ///获取聊天人列表
  List chatList = [];
  int page = 1;
  requestDataWithChatList()async{
    var params = {
      'page':page,
    };
    var json = await DioManager().kkRequest(Address.chatList,bodyParams: params);
    ChatListModel model = ChatListModel.fromJson(json);
    chatList.clear();
    chatList.addAll(model.data!);
    // easyRefreshController.finishRefresh(IndicatorResult.success);
    setState(() {

    });
  }
  /// 创建一个聊天室
  requestDataWithCreateChat(int targetId)async{
    var params = {
      'target_id':targetId
    };
    var json = await DioManager().kkRequest(Address.chatCreate,
    bodyParams: params);
    if(json['code'] == 200){
      BotToast.showText(text: json['message']);
    }else{
      BotToast.showText(text: json['message']);
    }
  }

  StreamSubscription? eventBusFn;
  void initOnLister(){
    eventBusFn = EventBusUtil.listen((event) {
      //  event为 event.obj 即为 eventBus.dart 文件中定义的 EventFn 类中监听的数据
      print('chat list event.obj hh ===== $event');

      chatMessage = event[0];

      for(int i = 0;i<chatList.length;i++){

        ChatListData model = chatList[i];
        var roomKey = model.roomKey;
        print('${roomKey}  ===  ${chatMessage!.room_key}');
        if(roomKey == chatMessage!.room_key){
          model.chatlastMsg = chatMessage!.text;

        }else {
          // model.chatlastMsg = '暂无最新消息';
        }
      }
      setState(() {

      });
    });

    // eventBusFn = eventBus.on<EventFn>().listen((event) {
    //   //  event为 event.obj 即为 eventBus.dart 文件中定义的 EventFn 类中监听的数据
    //   print('chat list event.obj hh ===== ${event.obj}');
    //
    //   chatMessage = event.obj[0];
    //
    //   for(int i = 0;i<chatList.length;i++){
    //
    //     ChatListData model = chatList[i];
    //     var roomKey = model.roomKey;
    //     print('${roomKey}  ===  ${chatMessage!.room_key}');
    //     if(roomKey == chatMessage!.room_key){
    //       model.chatlastMsg = chatMessage!.text;
    //
    //     }else {
    //       // model.chatlastMsg = '暂无最新消息';
    //     }
    //   }
    //   setState(() {
    //
    //   });
    // });
  }


  ChatMessage? chatMessage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithChatList();
    initOnLister();


    tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventBusFn!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18nContent.chatTitle.tr),
        actions: [
          TextButton(
              onPressed: ()async {
                var data = await Get.to(AddChatFromPhone());
                if(data == 'refresh'){
                  requestDataWithChatList();
                }
                // requestDataWithCreateChat(13);
              },
              child: Text(
                I18nContent.addChat.tr,
                style: const TextStyle(color: Colors.black),
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 15),
                margin: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  color: AppColor.searchBgColor,
                ),
                height: 55,
                child: Row(
                  children: [
                    Image.asset(
                      'images/ic_search.png',
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: TextField(
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        hintText: I18nContent.searchChat.tr,
                        hintStyle:
                            const TextStyle(fontSize: 16,
                                color: Colors.black),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
          buildTabBar(),
          SizedBox(
            height: 5,
          ),
          Expanded(
              child: TabBarView(controller: tabController,
                  children: [
                  EasyRefresh(
                    controller: easyRefreshController,
                  onRefresh: ()async{
                   requestDataWithChatList();
                  }, child: chatList.isEmpty?NoDataPage(): CustomScrollView(
                      slivers: [
                        SliverList(delegate: _mySliverChildBuildList())]
                  ),
               ),

                NotePadPage()
          ]))
        ],
      ),
    );
  }

  Widget buildTabBar() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 5),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(),
        isScrollable: false,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500,
            fontSize: 17),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
        unselectedLabelColor: AppColor.smallTextColor,
        labelColor: AppColor.themeColor,
        tabs: _tabs.map((String name) => Tab(text: name)).toList(),
        controller: tabController,
      ),
    );
  }

  SliverChildBuilderDelegate _mySliverChildBuildList() {
    return SliverChildBuilderDelegate((context, index) {

      ChatListData model1 = chatList[index];
      return GestureDetector(
        onTap: () {
          Get.to(ChatPage(model1.roomKey!,model1));
          // Get.to(Cc());
        },
        child: Column(
          children: [
            Container(
              height: 80,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                   Container(
                     color: Colors.white,
                     height: 50,
                     width: 50,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: CachedNetworkImage(
                          width: 25,
                          height: 25,
                          imageUrl: '${Address.homeHost}${Address.storage}/'
                              '${model1.userList![index].avatar}',
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              CircularProgressIndicator(value: downloadProgress.progress),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      );
                    },itemCount: model1.userList!.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          childAspectRatio: 1
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: Container(

                    padding: const EdgeInsets.only(right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        model1.roomName==''?Text(
                          '${I18nContent.users.tr}：${model1.userList!.map((e) => e.nickName)}',
                          style: size18BlackW700,
                        ):Text(
                          '${model1.roomName}',
                          style: size18BlackW700,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${model1.chatlastMsg}',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 11,fontWeight: FontWeight.w500
                                ),maxLines: 1,
                              ),
                              Text(
                                model1.chat_last_at==null?'':
                                '${model1.chat_last_at}',
                                style: TextStyle(
                                    fontSize: 11, color: AppColor.smallTextColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Container(
              color: Colors.grey,
              width: Get.width,
              height: 0.3,
            )
          ],
        ),
      );
    }, childCount: chatList.length);
  }
}
