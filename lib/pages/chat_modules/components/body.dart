
import 'package:flutter/material.dart';

import '../models/ChatMessage.dart';
import 'chat_input_fields.dart';
import 'constants.dart';
import 'message.dart';
import 'package:get/get.dart';
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  ScrollController _scrollController = ScrollController();

  FocusNode _focusNode = FocusNode();

  double keyboardHeight = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _onFocusChange();

    Future.delayed(Duration(milliseconds: 100)).then((value) {

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 10),
        curve: Curves.easeOut,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 0),
        curve: Curves.easeOut,
      );
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final initialViewInsets = MediaQuery.of(context).viewInsets;
    //   if (initialViewInsets.bottom > 0) {
    //     keyboardHeight = initialViewInsets.bottom;
    //   }
    // });
    // WidgetsBinding.instance.addPersistentFrameCallback((_) {
    //   final double newHeight = MediaQuery.of(context).viewInsets.bottom;
    //   if (keyboardHeight != newHeight) {
    //     setState(() {
    //       keyboardHeight = newHeight;
    //     });
    //   }
    // });
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent+333,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset:true ,
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ListView.builder(
                  // reverse: true,
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: _scrollController,
                  itemCount: demeChatMessages.length,
                  itemBuilder: (context, index) => Message(message: demeChatMessages[index]),
                ),
              )),
          TextField(
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'type message'
            ),
          )

          // ChatInputField(focusNodel:_focusNode,)
        ],
      ),
    );
  }
  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const BackButton(),
          const CircleAvatar(
            backgroundImage: AssetImage('images/user_2.png'),
          ),
          const SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Kristin Watson', style: TextStyle(fontSize: 16)),
              Text('Active 3m ago', style: TextStyle(fontSize: 12))
            ],
          )
        ],
      ),
      // actions: [
      //   IconButton(onPressed: () {}, icon: Icon(Icons.call)),
      //   IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
      //   SizedBox(
      //     width: kDefaultPadding / 2,
      //   )
      // ],
    );
  }


}

