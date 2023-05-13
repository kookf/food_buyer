import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/pages/chat_modules/components/file_message.dart';
import 'package:food_buyer/pages/chat_modules/components/leave_message.dart';
import 'package:food_buyer/pages/chat_modules/components/text_message.dart';
import 'package:food_buyer/services/address.dart';

import '../models/ChatMessage.dart';
import 'audio_message.dart';
import 'constants.dart';
import 'image_message.dart';
import 'video_message.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMessage message;
  @override
  Widget build(BuildContext context) {
    print(message.type);
    Widget messageContaint(ChatMessage message) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
        case ChatMessageType.image:
          return ImageMessage(message:message);
        case ChatMessageType.audio:
          return AudioMessage(message: message);
        case ChatMessageType.video:
          return VideoMessage(message: message);
        case ChatMessageType.file:
          return FileMessage(message: message);
        case ChatMessageType.leaveText:
          return LeaveMessage(message: message);
        default:
          return const SizedBox();
      }
    }
    return Container(
      margin: EdgeInsets.only(top: 0),
      // color: Colors.yellowAccent,
      child:  Padding(
        padding: const EdgeInsets.only(top: kDefaultPadding),
        child: Row(

          mainAxisAlignment: message.type==4?MainAxisAlignment.center:
          message.isSender ?
          MainAxisAlignment.end :
          MainAxisAlignment.start,
          children: [
            if (!message.isSender)
              ...[
                // MessageStatusDot(status: message.messageStatus),
              message.type==4?SizedBox():  Container(
                  margin: EdgeInsets.only(left: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.
                      all(Radius.circular(15))
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: CachedNetworkImage(
                    width: 30,
                    height: 30,
                    imageUrl: '${Address.homeHost}'
                        '${Address.storage}/${message.avatar}',

                  ),
                ),
                const SizedBox(
                  width: kDefaultPadding / 2,
                )
              ],
            messageContaint(message),
            if (message.isSender)
              message.type==4?SizedBox():  Container(
                margin: EdgeInsets.only(left: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.
                    all(Radius.circular(15))
                ),
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImage(
                  width: 30,
                  height: 30,
                  imageUrl: '${Address.homeHost}'
                      '${Address.storage}/${message.avatar}',

                ),
              )
            // MessageStatusDot(status: message.messageStatus)
          ],
        ),
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_sent:
          return kErrorColor;
        case MessageStatus.not_view:
          return Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1);
        case MessageStatus.viewed:
          return kPrimaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: kDefaultPadding / 2),
      height: 15,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 11,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
