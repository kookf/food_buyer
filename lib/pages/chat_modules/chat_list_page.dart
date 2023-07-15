import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
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
import 'searc_message_modules/search_message_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);
  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with SingleTickerProviderStateMixin {
  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: false,
    controlFinishLoad: true,
  );
  late TabController tabController;

  final List<String> _tabs = <String>[
    I18nContent.chatTitle.tr,
    'Notepad',
  ];

  TextEditingController searchController = TextEditingController();

  /// 搜索
  requestDataWithSearch()async{
    var params = {
      'page': 1,
      'keyword': searchController.text,
    };
    var json =
    await DioManager().kkRequest(Address.searchChatMeg, bodyParams: params);
  }
  /// 置顶
  requestDataWithTop(var room_key)async{
    var params = {
      'room_key': room_key,
    };
    var json =
    await DioManager().kkRequest(Address.chatTop, bodyParams: params);

    requestDataWithChatList();
  }
  /// 取消置顶
  requestDataWithCancelTop(var room_key)async{
    var params = {
      'room_key': room_key,
    };
    var json =
    await DioManager().kkRequest(Address.cancelTop, bodyParams: params);

    requestDataWithChatList();
  }
  /// 鎖定聊天室
  requestDataWithLockRoom(var room_key)async{
    var params = {
      'room_key': room_key,
    };
    var json =
    await DioManager().kkRequest(Address.chatLock, bodyParams: params);
    requestDataWithChatList();
  }
  /// 取消鎖定
  requestDataWithCancelRoom(var room_key)async{
    var params = {
      'room_key': room_key,
    };
    var json =
    await DioManager().kkRequest(Address.chatCancelLock, bodyParams: params);

    requestDataWithChatList();
  }
  ///获取聊天人列表
  List chatList = [];
  int page = 1;
  requestDataWithChatList() async {
    var params = {
      'page': page,
      // 'last_msg': {'':''},
    };
    var json =
        await DioManager().kkRequest(Address.chatList, bodyParams: params);
    ChatListModel model = ChatListModel.fromJson(json);
    if (page == 1) {
      chatList.clear();
      chatList.addAll(model.data!);
      easyRefreshController.resetFooter();
    } else if (model.data!.isNotEmpty) {
      chatList.addAll(model.data!);
      easyRefreshController.finishLoad(IndicatorResult.success);
    } else {
      easyRefreshController.finishLoad(IndicatorResult.noMore);
    }
    // chatList.clear();
    // chatList.addAll(model.data!);
    // easyRefreshController.finishRefresh(IndicatorResult.fail);
    setState(() {});
  }

  /// 创建一个聊天室
  requestDataWithCreateChat(int targetId) async {
    var params = {'target_id': targetId};
    var json =
        await DioManager().kkRequest(Address.chatCreate, bodyParams: params);
    if (json['code'] == 200) {
      BotToast.showText(text: json['message']);
    } else {
      BotToast.showText(text: json['message']);
    }
  }

  StreamSubscription? eventBusFn;

  void initOnLister() {
    eventBusFn = EventBusUtil.listen((event) {
      //  event为 event.obj 即为 eventBus.dart 文件中定义的 EventFn 类中监听的数据
      print('chat list  ===== $event');
      if (event == 'chatListRefresh') {
        requestDataWithChatList();
        return;
      }
      int type = event['type'];

      if (type == 10) {
        requestDataWithChatList();
      }

      chatMessage = event['arr'][0];
      for (int i = 0; i < chatList.length; i++) {
        ChatListData model = chatList[i];
        var roomKey = model.roomKey;
        print('${roomKey}  ===  ${chatMessage!.room_key}');
        if (roomKey == chatMessage!.room_key) {
          model.chatlastMsg = '您有一條新的消息';
        } else {
          // model.chatlastMsg = '暂无最新消息';
        }
      }
      setState(() {});
    });
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
              onPressed: () async {
                var data = await Get.to(AddChatFromPhone());
                if (data == 'refresh') {
                  requestDataWithChatList();
                }
                // requestDataWithCreateChat(13);
              },
              child: Text(
                I18nContent.addChat.tr,
                style: const TextStyle(color: Colors.black),
              )),
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
                      controller: searchController,
                      onSubmitted: (value){
                        // requestDataWithSearch();
                        Get.to(SearchMessagePage(value));
                        // requestDataWithChatList();
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        hintText: I18nContent.searchChat.tr,
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
              child: TabBarView(controller: tabController, children: [
            EasyRefresh(
              controller: easyRefreshController,
              // onRefresh: () async {
              //   page = 1;
              //   requestDataWithChatList();
              // },
              // onLoad: ()async{
              //   page++;
              //   requestDataWithChatList();
              // },
              child: chatList.isEmpty
                  ? NoDataPage(onTap: (){
                    requestDataWithChatList();
              },)
                  : CustomScrollView(slivers: [
                      SliverList(delegate: _mySliverChildBuildList())
                    ]),
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
        labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
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
      ThemeData baseColor = Theme.of(context);
      ChatListData model1 = chatList[index];
      return SwipeActionCell(
        trailingActions: <SwipeAction>[
          SwipeAction(
              title:model1.is_top==1?"取消置頂":'置頂',
              onTap: (CompletionHandler handler) async {
                if(model1.is_top==1){
                  requestDataWithCancelTop(model1.roomKey);
                }else{
                  requestDataWithTop(model1.roomKey);
                }
                // requestDataWithDeleteNotePad(model.notepads?[a].notepadId);
                await handler(false);
                // model.notepads?.removeAt(a);
                // setState(() {});
              },
              color: kDTCloud300),
          SwipeAction(
              title:model1.room_lock==1?"取消鎖定":'鎖定',
              widthSpace: 110,
              onTap: (CompletionHandler handler)async{
                if(model1.room_lock==1){
                  requestDataWithCancelRoom(model1.roomKey);
                }else{
                  requestDataWithLockRoom(model1.roomKey);
                }
            await handler(false);
          }),
        ],
        key: ObjectKey(chatList[index]),
        child: GestureDetector(
          onTap: () async {
            var data = await Get.to(
                ChatPage(model1.roomKey!,
                    roomName: model1.roomName!,
                    member: model1.userList!.length,
                    target_name:model1.target_name,roomLock: model1.room_lock,));
            if (data == 'chatListRefresh') {
              requestDataWithChatList();
            }
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
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              width: 35,
                              height: 35,
                              imageUrl: '${Address.storage}/'
                                  '${model1.target_avatar}',
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                          );
                        },
                        itemCount: model1.userList!.length > 1
                            ? 1
                            : model1.userList!.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                            childAspectRatio: 1),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.only(top: 20),
                                   child: Text(
                                     '${model1.target_name}'
                                         '',
                                     style: baseColor.textTheme.titleLarge!
                                         .copyWith(color: Colors.black),maxLines: 1,
                                     overflow: TextOverflow.ellipsis,),
                                 ),
                               model1.is_top==1?Image.asset('images/ic_top.png',width: 15,height: 15,):
                                   SizedBox(),
                               ],
                             ),
                              Container(
                                margin: EdgeInsets.only(top: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '',
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                    ),
                                    model1.chat_msg_not_read_nums==0?SizedBox():
                                    Container(
                                      height: 20,
                                      width: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(25)),
                                        color: kDTCloud500
                                      ),
                                      child: Text('${model1.chat_msg_not_read_nums}',
                                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                        color: Colors.white
                                      ),),
                                    )
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
        ),

      );


    }, childCount: chatList.length);
  }
}
