import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/services/address.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:get/get.dart';
import '../models/ChatMessage.dart';
import 'constants.dart';

class AudioMessage extends StatelessWidget {
  const AudioMessage({super.key, required this.message});
  final ChatMessage message;
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.55,
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.2,
        vertical: kDefaultPadding / 2.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.themeColor.withOpacity(message.isSender ? 1 : 0.08),
      ),
      child: Column(
        children: [
          message.isSender==true?SizedBox():Container(

            width: Get.width/2-5,
            // color: Colors.red,
            child: Text('${message.nick_name}',style: TextStyle(
                fontSize: 11,color: AppColor.smallTextColor
            ),),
          ),
          SizedBox(height: 5,),
          VoiceMessage(
            contactCircleColor: Colors.grey.shade200,
            contactFgColor: Colors.grey,
            audioSrc: '${Address.homeHost}${Address.storage}/${message.text}',
            meBgColor:message.isSender==true?AppColor.themeColor:
            AppColor.themeColor.withOpacity(0.1),
            played: false, // To show played badge or not.
            me: message.isSender, // Set message side.
            onPlay: () {

            }, // Do something when voice played.
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
          // Icon(Icons.play_arrow, color: message.isSender ? Colors.white : kPrimaryColor),
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          //     child: Stack(
          //       clipBehavior: Clip.none,
          //       alignment: Alignment.center,
          //       children: [
          //         Container(
          //           width: double.infinity,
          //           height: 2,
          //           color: message.isSender ? Colors.white : kPrimaryColor.withOpacity(0.4),
          //         ),
          //         Positioned(
          //           left: 0,
          //           child: Container(
          //             height: 8,
          //             width: 8,
          //             decoration: BoxDecoration(
          //               color: message.isSender ? Colors.white : kPrimaryColor.withOpacity(0.4),
          //               shape: BoxShape.circle,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Text('0.37', style: TextStyle(fontSize: 12, color: message.isSender ? Colors.white : null))
        ],
      ),
    );
  }
}
