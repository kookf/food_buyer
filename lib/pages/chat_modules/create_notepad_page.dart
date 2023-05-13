import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:get/get.dart';
import '../../common/style.dart';
import '../../services/address.dart';
import '../../services/dio_manager.dart';
import 'models/ChatMessage.dart';

class CreateNotePadPage extends StatefulWidget {

  final ChatMessage message;


  const CreateNotePadPage(this.message,{Key? key}) : super(key: key);

  @override
  State<CreateNotePadPage> createState() => _CreateNotePadPageState();
}

class _CreateNotePadPageState extends State<CreateNotePadPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contentController.text = widget.message.text;
  }

  requestDataWithAddNotPad()async{
    var params = {
      'from_user_id':widget.message.userId,
      'msg_id':widget.message.msgId,
      'title':titleController.text,
    };
    var json = await DioManager().kkRequest(Address.notePadAdd,
        bodyParams: params);
    if(json['code'] == 200){
      BotToast.showText(text: '添加成功');
      Get.back();
    }else{
      BotToast.showText(text: json['message']);
    }
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppBar(
        title: Text('Create Notepad'),
        actions: [
          TextButton(onPressed: (){
            Get.back();
          }, child: Text(I18nContent.searchCancel))
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Expanded(child:  Container(
            color: Colors.white,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Padding(padding: EdgeInsets.only(left: 15,top: 15 ),
                  child: Text('Title',style: size18BlackW700,),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 15),
                  margin: EdgeInsets.only(left: 15,right: 15,top: 15),
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5,
                          color: AppColor.lineColor
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(borderRadius))
                  ),
                  child: TextField(
                    autofocus: true,
                    controller: titleController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                    ),
                  ),

                ),
                Padding(padding: EdgeInsets.only(left: 15,top: 15 ),
                  child: Text('Messages',style: size18BlackW700,),
                ),
                Container(
                  // alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 15),
                  margin: EdgeInsets.only(left: 15,right: 15,top: 15),
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5,
                          color: AppColor.lineColor
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(borderRadius))
                  ),
                  child: TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Messages',
                    ),
                    maxLines: 5,
                  ),

                )
              ],
            ),
          ),),
          Container(
             color: Colors.white,
             height: 55,
             child: Center(
               child: MaterialButton(
                 onPressed: () {
                   if(titleController.text.isEmpty){
                     BotToast.showText(text: 'The title cannot be empty');
                     return;
                   }
                   if(contentController.text.isEmpty){
                     BotToast.showText(text: 'The content cannot be empty');
                     return;
                   }
                   requestDataWithAddNotPad();
                 },
                 color: AppColor.themeColor,
                 minWidth: Get.width - 80,
                 height: 45,
                 shape: const RoundedRectangleBorder(
                     borderRadius: BorderRadius.
                     all(Radius.circular(22))),
                 child: Text(
                   I18nContent.addNewNotePad,
                   style: TextStyle(
                     color: Colors.white,
                   ),
                 ),
               ),
             ),
           )

          ],
        ),
      ),

    );
  }
}
