import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/pages/chat_modules/components/chat_information_modules/add_chat_user_page.dart';
import 'package:food_buyer/pages/chat_modules/components/chat_information_modules/change_room_name_page.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:food_buyer/utils/event_utils.dart';
import 'package:get/get.dart';
import '../../chat_list_model.dart';

class ChatInformationPage extends StatefulWidget {

  final ChatListData? model;

   const ChatInformationPage({Key? key, this.model}) : super(key: key);

  @override
  State<ChatInformationPage> createState() => _ChatInformationPageState();
}

class _ChatInformationPageState extends State<ChatInformationPage> {

  List itemList = ['聊天室名稱','添加人員'];

  requestDataWithLeave(String roomKey)async{
    var params = {
      'room_key':roomKey,
    };
    var json = await DioManager().kkRequest(Address.leaveChatRoom,bodyParams: params);
    if(json['code'] == 200){
      Get.back();
      Get.back();
      Get.back();
      EventBusUtil.fire('chatListRefresh');
    }else{
      BotToast.showText(text: json['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppBar(
        title: Text('聊天信息'),
      ),
      body:Column(
        children: [
          Expanded(child: CustomScrollView(
            slivers: [
              SliverList(delegate: SliverChildBuilderDelegate(
                childCount: itemList.length,(context, index) {
                return GestureDetector(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              child: Text('${itemList[index]}'),
                            ),
                            Padding(padding: EdgeInsets.only(right: 15),
                              child: Icon(Icons.arrow_forward_ios,size: 15,),
                            )
                          ],
                        ),
                        Container(
                          height: 0.5,
                          color: AppColor.lineColor,
                        )
                      ],
                    ),
                  ),
                  onTap: (){
                    if(index==0) {
                      Get.to(ChangeRoomNamePage(model: widget.model,));
                    }
                    if(index==1){
                      Get.to(AddChatUserPage(model: widget.model,));
                    }
                  },
                );
              },
              ))
            ],
          ),),
          GestureDetector(
            onTap: (){
              Get.defaultDialog(
                title: '提示',
                content: Text('是否退出聊天室',),
                cancel: MaterialButton(onPressed: (){
                  Get.back();
                },child: Text('取消',style: TextStyle(
                  color: Colors.red
                ),),),
                confirm: MaterialButton(onPressed: (){
                  requestDataWithLeave('${widget.model?.roomKey}');

                },child: Text('確定',style: TextStyle(
                  color: AppColor.themeColor
                ),),)
                
              );

            },
            child:Container(
              color: Colors.white,
              alignment: Alignment.center,
              height: 55,
              child: Text('退出聊天室',style: TextStyle(color: Colors.red),),
            ),
          )
        ],
      ) ,
    );
  }
}
