import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/lang/message.dart';

import '../../../common/foodbuyer_colors.dart';
import '../../../components/not_data_page.dart';
import '../../../services/address.dart';
import '../../../services/dio_manager.dart';
import '../chat_list_model.dart';
import 'package:get/get.dart';

import '../models/ChatMessage.dart';
class ForwardPage extends StatefulWidget {

  ChatMessage message;

  ForwardPage(this.message,{Key? key}) : super(key: key);

  @override
  State<ForwardPage> createState() => _ForwardPageState();
}

class _ForwardPageState extends State<ForwardPage> {


  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: false,
    controlFinishLoad: true,
  );

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithChatList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('選擇一個聊天室'),
      ),
      body:EasyRefresh(
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
    );
  }

  SliverChildBuilderDelegate _mySliverChildBuildList() {
    return SliverChildBuilderDelegate((context, index) {
      ThemeData baseColor = Theme.of(context);
      ChatListData model1 = chatList[index];
      return GestureDetector(
        onTap: () async {
          Get.dialog(
            Center(
              child: Container(
                height: 150,
                width: Get.width-100,
                child: Material(
                  type: MaterialType.card,
                  child: Container(
                    padding: EdgeInsets.only(left: 5,top: 15,right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('是否發送 ${model1.target_name}：'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.message.text),
                        ),
                        Expanded(child: Row(
                          children: [
                            Expanded(child: MaterialButton(onPressed: (){
                              Get.back();
                            },
                              child: Text(I18nContent.searchCancel.tr),)),
                            Expanded(child: MaterialButton(onPressed: (){

                            },
                              child: Text(I18nContent.sendLabel.tr,
                                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Colors.white
                                ),
                              ),color: kDTCloud500,))
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            )
          );
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
                                model1.roomName == ''
                                    ? Text(
                                  '${model1.target_name}'
                                      '',
                                  style: baseColor.textTheme.titleLarge!
                                      .copyWith(color: Colors.black),maxLines: 1,
                                  overflow: TextOverflow.ellipsis,)
                                    : Text(
                                  '${model1.roomName}',
                                  style: baseColor.textTheme.titleLarge!
                                      .copyWith(color: Colors.black),),
                                model1.is_top==1?Image.asset('images/ic_top.png',width: 15,height: 15,):
                                SizedBox(),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${model1.chatlastMsg}',
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 1,
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
