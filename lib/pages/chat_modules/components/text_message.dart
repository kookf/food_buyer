import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/pages/chat_modules/components/long_menu_item.dart';
import 'package:food_buyer/pages/chat_modules/create_notepad_page.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import '../models/ChatMessage.dart';
import 'constants.dart';
import 'package:get/get.dart';

import 'drop_menu_route.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    required this.message,
  }) : super(key: key);
  final ChatMessage message;

  requestDataWithAddNotPad()async{
    var params = {
      'from_user_id':message.userId,
      'msg_id':message.msgId
    };
    var json = await DioManager().kkRequest(Address.notePadAdd,
    bodyParams: params);
    if(json['code'] == 200){
      BotToast.showText(text: '添加成功');
    }else{
      BotToast.showText(text: json['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (olpdt)async{
        print(' olpdt.globalPosition.dx, ==${ olpdt.globalPosition.dx}');
        print(' olpdt.globalPosition.dy, ==${ olpdt.globalPosition.dy}');
        print(' Get.height, ==${ Get.height}');

        var itemView = LongMenuItem(addToNotepadVoid: (){
          Get.to(CreateNotePadPage(message));
          return;
          requestDataWithAddNotPad();
        },);
        if(olpdt.globalPosition.dy+280>=Get.height){
          Navigator.push(context,DropDownMenuRoute(
              position: Rect.fromCenter(center: Offset(olpdt.globalPosition.dx,
                  olpdt.globalPosition.dy-280), width: 0, height: 10),//弹窗位置信息
              menuWidth:250,//弹窗宽度
              menuHeight: 280,//弹窗高度
              offset: 100,//偏移量
              itemView:itemView//这里的PopSubjectWidget就是弹窗布局
          ));
        }else{
          Navigator.push(context,DropDownMenuRoute(
              position: Rect.fromCenter(center: olpdt.globalPosition, width: 0, height: 10),//弹窗位置信息
              menuWidth:250,//弹窗宽度
              menuHeight: 280,//弹窗高度
              offset: 100,//偏移量
              itemView:itemView//这里的PopSubjectWidget就是弹窗布局
          ));
        }
        // Get.dialog(LongMenuItem());
      },
      child:Column(
        children: [
          message.isSender==true?SizedBox():Container(

            width: Get.width/2-5,
            // color: Colors.red,
            child: Text('${message.nick_name}',style: TextStyle(
              fontSize: 11,color: AppColor.smallTextColor
            ),),
          ),
          SizedBox(height: 5,),
          Container(
            width: 200,

            margin: EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75,
                vertical: kDefaultPadding / 2),
            decoration: BoxDecoration(
                color: AppColor.themeColor.withOpacity(message.isSender ? 1 : 0.08),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: TextStyle(color: message.isSender ?
                  Colors.white : Theme.of(context).textTheme.bodyText1?.color),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  alignment: message.isSender?Alignment.centerRight:Alignment.centerRight,
                  width: 200,
                  // color: Colors.red,
                  child: Text(message.time,
                    style: TextStyle(color: message.isSender?
                  Colors.white:Colors.grey,fontSize: 11),),
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}
