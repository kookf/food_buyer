import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:food_buyer/utils/event_utils.dart';
import 'package:get/get.dart';
import '../../chat_list_model.dart';

class ChangeRoomNamePage extends StatefulWidget {

  final ChatListData? model;
  const ChangeRoomNamePage({Key? key, this.model}) : super(key: key);

  @override
  State<ChangeRoomNamePage> createState() => _ChangeRoomNamePageState();
}

class _ChangeRoomNamePageState extends State<ChangeRoomNamePage> {


  TextEditingController editingController = TextEditingController();


  requestDataWithChangeRoomName()async{
    var params = {
      'room_key':widget.model!.roomKey,
      'room_name':editingController.text,
    };
    var json = await DioManager().kkRequest(Address.chatChangeName,params: params);
    if(json['code'] == 200){
      BotToast.showText(text: '修改成功');
      EventBusUtil.fire('chatListRefresh');
      Get.back();
      Get.back();
      Get.back();
    }else{
      BotToast.showText(text: json['message']);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editingController.text = '${widget.model?.roomName}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('修改房間名稱'),
      ),
      body: Column(
        children: [
         Container(
           padding: EdgeInsets.only(left: 15,right: 15),
           child:  TextField(
             autofocus: true,
             inputFormatters: <TextInputFormatter>[
               LengthLimitingTextInputFormatter(20) //限制长度
             ],
             textInputAction: TextInputAction.done,
             controller: editingController,
             onSubmitted: (value){
               if(editingController.text.isEmpty){
                 BotToast.showText(text: '請輸入房間名稱');
                 return ;
               }
               requestDataWithChangeRoomName();
             },

             decoration: InputDecoration(
               // border: InputBorder.none,
                 hintText: '請輸入房間名稱',

             ),
           ),
         )
        ],
      ),
    );
  }
}
