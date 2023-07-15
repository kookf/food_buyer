import 'dart:ffi';

import 'package:bot_toast/bot_toast.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:get/get.dart';

import '../../../utils/event_utils.dart';
class CommentPage extends StatefulWidget {

  int postId;
  int? replyUserId;
  int? rootId;
  String? name;
  CommentPage({required this.postId,this.replyUserId,this.rootId,
    this.name,
    Key? key}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> with TickerProviderStateMixin{


  TextEditingController bodyController = TextEditingController();

  requestDataWithReplyCreate()async{
    var params = {
      'post_id':widget.postId,
      'body':bodyController.text,
      'root_id':widget.rootId,
      'reply_user_id':widget.replyUserId,
    };
    var json = await DioManager().kkRequest(Address.postReplyCreate,bodyParams:params);
    if(json['code'] == 200){
      BotToast.showText(text: '發表成功');
      bodyController.text = '';
    }else{
      BotToast.showText(text: json['messagee']);
    }

    EventBusUtil.fire('postCommentListRefresh');
    Get.back();

  }

  double commentWidth = Get.width -40;
  double sendOpacity = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        width: Get.width,
        padding: const EdgeInsets.all(10),
        height: 80,
        child:Align(
          alignment: Alignment.topLeft,
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                alignment: Alignment.centerLeft,
                height: 45,
                margin: EdgeInsets.only(top: 15),
                padding: const EdgeInsets.only(left: 15,right: 15),
                width: commentWidth,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.all(Radius.circular(25))
                ),
                duration: kThemeAnimationDuration,
                child:  TextField(
                  controller: bodyController,
                  autofocus: true,
                  onChanged: (value){
                    if(value.isNotEmpty){
                      commentWidth  = Get.width - 130;
                      sendOpacity = 1;
                    }else if(value.isEmpty){
                      commentWidth  = Get.width -40;
                      sendOpacity = 0;
                    }
                    setState(() {

                    });
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:widget.name==null?I18nContent.saySomething.tr:
                      '回復 @${widget.name}'
                  ),
                ),
              ),
              const SizedBox(width: 15,),

              Align(
                alignment: Alignment.centerRight,
                child: AnimatedOpacity(
             duration: kRadialReactionDuration,
             opacity: sendOpacity,
             child: Container(
                 margin: EdgeInsets.only(top: 15),
                 child: MaterialButton(onPressed: (){
                   requestDataWithReplyCreate();
                   },
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.all(Radius.circular(kRadialReactionRadius))
                   ),
                   color: kDTCloud700,
                   height: 35,
                   minWidth: 80,
                   child: Text('Send',style: Theme.of(context).
                   textTheme.bodySmall!.copyWith(
                       color: Colors.white
                   ),),
                 ),
             ),),
              ),

             // SizedBox(),
             //  Visibility(visible: commentWidth==
             //      Get.width-80?false:true,
             //    child: Container(
             //      margin: EdgeInsets.only(top: 15),
             //      child: MaterialButton(onPressed: (){
             //      requestDataWithReplyCreate();},
             //      color: kDTCloud700,height: 35,
             //      child: Text('Send',style: Theme.of(context).
             //      textTheme.bodySmall!.copyWith(
             //          color: Colors.white
             //      ),),
             //  ),
             //    ),
             //  ),
            ],
          ),
        ),
      ),
    );
  }
}
