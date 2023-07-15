import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../services/address.dart';
import '../../../../services/dio_manager.dart';
import '../../../../utils/event_utils.dart';
import '../../chat_list_model.dart';
import 'package:get/get.dart';

class AddChatUserPage extends StatefulWidget {
  // final ChatListData? model;

  final String roomKey;
  const AddChatUserPage({Key? key, required this.roomKey}) : super(key: key);

  @override
  State<AddChatUserPage> createState() => _AddChatUserPageState();
}

class _AddChatUserPageState extends State<AddChatUserPage> {
  TextEditingController editingController = TextEditingController();

  requestDataWithChangeRoomName() async {
    var params = {
      'room_key': widget.roomKey,
      'phone': editingController.text,
    };
    var json =
        await DioManager().kkRequest(Address.chatUserAdd, params: params);
    if (json['code'] == 200) {
      BotToast.showText(text: '添加人員成功');
      EventBusUtil.fire('chatListRefresh');
      Get.back();
      Get.back();
    } else {
      BotToast.showText(text: json['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加人員'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: TextField(
              autofocus: true,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(25) //限制长度
              ],
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.phone,
              controller: editingController,
              onSubmitted: (value) {
                if (editingController.text.isEmpty) {
                  BotToast.showText(text: '請輸入對方手機號碼');
                  return;
                }
                requestDataWithChangeRoomName();
              },
              decoration: InputDecoration(
                // border: InputBorder.none,
                hintText: '請輸入人員手機號',
              ),
            ),
          )
        ],
      ),
    );
  }
}
