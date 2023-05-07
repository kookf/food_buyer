import 'package:flutter/material.dart';

import 'constants.dart';


class ChatInputField extends StatelessWidget {

  VoidCallback sendVoid;
  VoidCallback imageSendVoid;
  VoidCallback fileSendVoid;

  final TextEditingController? controller;
  final FocusNode? focusNode;

    ChatInputField({
    this.controller,
     this.focusNode,
     required this.sendVoid,
     required this.imageSendVoid,
     required this.fileSendVoid,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [BoxShadow(blurRadius: 32, offset: Offset(0, 4), color: Color(0xff087949).withOpacity(0.3))]),
      child: SafeArea(
          child: Row(
        children: [
          // Icon(Icons.mic, color: kPrimaryColor),
          SizedBox(width: kDefaultPadding),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.07),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  // Icon(
                  //   Icons.sentiment_satisfied_alt_outlined,
                  //   color: Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.64),
                  // ),
                  SizedBox(width: kDefaultPadding / 2),
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      controller: controller,
                      decoration: InputDecoration(border: InputBorder.none, hintText: 'Type Message'),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      fileSendVoid();
                    },
                    child: Icon(
                      Icons.attach_file,
                      color: Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.64),
                    ),
                  ),
                  SizedBox(width: kDefaultPadding / 4),
                  GestureDetector(
                    onTap: (){
                      imageSendVoid();
                    },
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.64),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: 10,),
          IconButton(onPressed: (){
            sendVoid();
          }, icon: Image.asset('images/ic_chat_send.png',width: 35,height: 35,))
        ],
      )),
    );
  }
}
