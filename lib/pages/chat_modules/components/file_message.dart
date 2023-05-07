import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/pages/chat_modules/components/long_menu_item.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/address.dart';
import '../../../services/dio_manager.dart';
import '../models/ChatMessage.dart';
import 'constants.dart';
import 'package:get/get.dart';

import 'drop_menu_route.dart';

class FileMessage extends StatelessWidget {

  const FileMessage({
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
      BotToast.showText(text: json['message']);
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
          requestDataWithAddNotPad();
        },);

        if(olpdt.globalPosition.dy+280>=Get.height){
          Navigator.push(context,DropDownMenuRoute(
              position: Rect.fromCenter(center: Offset(olpdt.globalPosition.dx,
                  olpdt.globalPosition.dy-280), width: 0, height: 10),//弹窗位置信息
              menuWidth:250,//弹窗宽度
              menuHeight: 280,//弹窗高度
              offset: 100,//偏移量
              itemView:itemView //这里的PopSubjectWidget就是弹窗布局
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
      onTap: ()async{
        await launch('${Address.homeHost}/storage/${message.filePath}');

      },
      child: Container(
        width: 200,
        margin: EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75,
            vertical: kDefaultPadding / 2),
        decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(message.isSender ? 1 : 0.08),
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Image.asset('images/chat_file.png',width: 35,
                height: 35,color: Colors.white,),
              SizedBox(width: 5,),
              Expanded(child: Text(
                '${message.fileName}',
                style: TextStyle(color: message.isSender ?
                Colors.blue : Theme.of(context).textTheme.bodyText1?.color),
              ),)
            ],),
            Container(
              alignment: message.isSender?Alignment.centerRight:Alignment.centerRight,
              width: 200,
              // color: Colors.red,
              child: Text(message.time,style: TextStyle(color: message.isSender?
              Colors.white:Colors.grey,fontSize: 12),),
            )
          ],
        ),
      ),
    );
  }
}
