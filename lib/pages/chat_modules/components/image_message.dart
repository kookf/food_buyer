import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/services/address.dart';
import 'package:image_pickers/image_pickers.dart';
import '../../../common/colors.dart';
import '../../../services/dio_manager.dart';
import '../create_notepad_page.dart';
import '../models/ChatMessage.dart';
import 'constants.dart';
import 'drop_menu_route.dart';
import 'long_menu_item.dart';
import 'package:get/get.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    Key? key,
    required this.message,
  }) : super(key: key);
  final ChatMessage message;

  requestDataWithAddNotPad() async {
    var params = {'from_user_id': message.userId, 'msg_id': message.msgId};
    var json =
        await DioManager().kkRequest(Address.notePadAdd, bodyParams: params);
    if (json['code'] == 200) {
      BotToast.showText(text: '添加成功');
    } else {
      BotToast.showText(text: json['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ImagePickers.previewImage(
            '${Address.homeHost}/storage/${message.fileImagePath}');
      },
      onLongPressStart: (olpdt) {
        print(' olpdt.globalPosition.dx, ==${olpdt.globalPosition.dx}');
        print(' olpdt.globalPosition.dy, ==${olpdt.globalPosition.dy}');
        print(' Get.height, ==${Get.height}');

        var itemView = LongMenuItem(
          addToNotepadVoid: () {
            // requestDataWithAddNotPad();
            Get.to(CreateNotePadPage(message: message,));
            return;

          },
        );

        if (olpdt.globalPosition.dy + 280 >= Get.height) {
          Navigator.push(
              context,
              DropDownMenuRoute(
                  position: Rect.fromCenter(
                      center: Offset(olpdt.globalPosition.dx,
                          olpdt.globalPosition.dy - 280),
                      width: 0,
                      height: 10), //弹窗位置信息
                  menuWidth: 250, //弹窗宽度
                  menuHeight: 280, //弹窗高度
                  offset: 100, //偏移量
                  itemView: itemView //这里的PopSubjectWidget就是弹窗布局
                  ));
        } else {
          Navigator.push(
              context,
              DropDownMenuRoute(
                  position: Rect.fromCenter(
                      center: olpdt.globalPosition,
                      width: 0,
                      height: 10), //弹窗位置信息
                  menuWidth: 250, //弹窗宽度
                  menuHeight: 280, //弹窗高度
                  offset: 100, //偏移量
                  itemView: itemView //这里的PopSubjectWidget就是弹窗布局
                  ));
        }
      },
      child: Column(
        children: [
          message.isSender == true
              ? SizedBox()
              : Container(
                  width: Get.width / 2 - 5,
                  // color: Colors.red,
                  child: Text(
                    '${message.nick_name}',
                    style:
                        TextStyle(fontSize: 11, color: AppColor.smallTextColor),
                  ),
                ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 200,
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 0.75,
                vertical: kDefaultPadding / 2),
            decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(message.isSender ? 1 : 0.08),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                    placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                    imageUrl:
                        '${Address.imageHomeHost}/storage/${message.fileImagePath}'),
                // Image.network(message.fileImagePath!),
                // Text(
                //   message.text,
                //   style: TextStyle(color: message.isSender ?
                //   Colors.white : Theme.of(context).textTheme.bodyText1?.color),
                // ),
                Container(
                  alignment: message.isSender
                      ? Alignment.centerRight
                      : Alignment.centerRight,
                  width: 200,
                  // color: Colors.red,
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    message.time,
                    style: TextStyle(
                        color: message.isSender ? Colors.white : Colors.grey,
                        fontSize: 12),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
