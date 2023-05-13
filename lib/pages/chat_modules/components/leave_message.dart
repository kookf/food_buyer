import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/lang/message.dart';

import '../../../common/colors.dart';
import '../models/ChatMessage.dart';
import 'package:get/get.dart';

import 'constants.dart';
class LeaveMessage extends StatelessWidget {

  final ChatMessage message;
  const LeaveMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      alignment: Alignment.center,
      width: Get.width-150,
      color: Colors.white,
      child: Text('${message.nick_name} ${message.time} ${I18nContent.leftTheChatRoom.tr}',
        style: TextStyle(
            fontSize: 11,color: AppColor.smallTextColor
        ),),
    );
  }
}
