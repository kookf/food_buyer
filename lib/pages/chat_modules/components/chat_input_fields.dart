
import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_record_plus/flutter_plugin_record.dart';
import 'package:food_buyer/common/colors.dart';

import '../../../components/custom_overlay.dart';
import '../../../components/voice_widget.dart';
import 'constants.dart';

typedef startRecord = Future Function();
typedef stopRecord =  Function(String? path,double sec);


class ChatInputField extends StatefulWidget {

  final Function? startRecord;
  final Function? stopRecord;


  VoidCallback sendVoid;
  VoidCallback imageSendVoid;
  VoidCallback fileSendVoid;
  VoidCallback voiceVoid;
  bool isSpeak;



  final TextEditingController? controller;
  final FocusNode? focusNode;

  ChatInputField({
    this.controller,
    this.focusNode,
    required this.sendVoid,
    required this.imageSendVoid,
    required this.fileSendVoid,
    required this.voiceVoid,
    required this.isSpeak,
    this.startRecord,
    this.stopRecord,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {

  // 倒计时总时长
  int _countTotal = 12;
  /// 录音时长
  int seconds = 0;

  double starty = 0.0;
  double offset = 0.0;
  bool isUp = false;
  String textShow = "按住说话";
  String toastShow = "手指上滑,取消发送";
  String voiceIco = "images/voice_volume_1.png";

  ///默认隐藏状态
  bool voiceState = true;
  FlutterPluginRecord? recordPlugin;
  Timer? _timer;
  int _count = 0;
  OverlayEntry? overlayEntry;

  @override
  void dispose() {
    // TODO: implement dispose
    recordPlugin?.dispose();
    _timer?.cancel();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    recordPlugin =  FlutterPluginRecord();
    _init();
    ///初始化方法的监听
    recordPlugin?.responseFromInit.listen((data) {
      if (data) {
        print("初始化成功");
      } else {
        print("初始化失败");
      }
    });

    /// 开始录制或结束录制的监听
    recordPlugin?.response.listen((data) {
      if (data.msg == "onStop") {
        ///结束录制时会返回录制文件的地址方便上传服务器
        // print("onStop  " + data.path!);
        // print("seconds  " + '${seconds}');

        if (stopRecord != null) {
          print('stopRecord ===${data.audioTimeLength!}');
          if(data.audioTimeLength!<=3){
            return;
          }
          widget.stopRecord!(data.path, data.audioTimeLength);
        }
      } else if (data.msg == "onStart") {
        print("onStart --");
        if (widget.startRecord != null) {
          widget.startRecord!();
        }
      }
    });

    ///录制过程监听录制的声音的大小 方便做语音动画显示图片的样式
    recordPlugin!.responseFromAmplitude.listen((data) {
      var voiceData = double.parse(data.msg ?? '');
      setState(() {
        if (voiceData > 0 && voiceData < 0.1) {
          voiceIco = "images/voice_volume_2.png";
        } else if (voiceData > 0.2 && voiceData < 0.3) {
          voiceIco = "images/voice_volume_3.png";
        } else if (voiceData > 0.3 && voiceData < 0.4) {
          voiceIco = "images/voice_volume_4.png";
        } else if (voiceData > 0.4 && voiceData < 0.5) {
          voiceIco = "images/voice_volume_5.png";
        } else if (voiceData > 0.5 && voiceData < 0.6) {
          voiceIco = "images/voice_volume_6.png";
        } else if (voiceData > 0.6 && voiceData < 0.7) {
          voiceIco = "images/voice_volume_7.png";
        } else if (voiceData > 0.7 && voiceData < 1) {
          voiceIco = "images/voice_volume_7.png";
        } else {
          voiceIco = "images/voice_volume_1.png";
        }
        if (overlayEntry != null) {
          overlayEntry!.markNeedsBuild();
        }
      });

      print("振幅大小   " + voiceData.toString() + "  " + voiceIco);
    });
  }


  ///显示录音悬浮布局
  buildOverLayView(BuildContext context) {
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(builder: (content) {
        return CustomOverlay(
          icon: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: _countTotal - _count < 11
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      (_countTotal - _count).toString(),
                      style: TextStyle(
                        fontSize: 70.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                    :  Image.asset(
                  voiceIco,
                  width: 100,
                  height: 100,
                ),
              ),
              Container(
//                      padding: const EdgeInsets.only(right: 20, left: 20, top: 0),
                child: Text(
                  toastShow,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        );
      });
      Overlay.of(context)!.insert(overlayEntry!);
    }
  }

  showVoiceView() {
    setState(() {
      textShow = "松开结束";
      voiceState = false;
    });

    ///显示录音悬浮布局
    buildOverLayView(context);

    start();
  }

  hideVoiceView() {
    if (_timer!.isActive) {
      if (_count < 2) {
        BotToast.showText(text: '说话时间太短');
        // CommonToast.showView(
        //     context: context,
        //     msg: '说话时间太短',
        //     icon: Text(
        //       '!',
        //       style: TextStyle(fontSize: 80, color: Colors.white),
        //     ));
        isUp = true;
      }
      print('_count == ${_count}');
      seconds = _count;
      _timer?.cancel();
      _count = 0;
    }

    setState(() {
      textShow = "按住说话";
      voiceState = true;
    });

    stop();
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }

    if (isUp) {
      print("取消发送");
    } else {
      print("进行发送");
    }
  }

  moveVoiceView() {
    // print(offset - start);
    setState(() {
      isUp = starty - offset > 100 ? true : false;
      if (isUp) {
        textShow = "松开手指,取消发送";
        toastShow = textShow;
      } else {
        textShow = "松开结束";
        toastShow = "手指上滑,取消发送";
      }
    });
  }

  ///初始化语音录制的方法
  void _init() async {
    recordPlugin?.init();
  }

  ///开始语音录制的方法
  void start() async {
    recordPlugin?.start();
  }

  ///停止语音录制的方法
  void stop() {
    recordPlugin?.stop();
  }

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
              GestureDetector(
                onTap: (){
                  print('mic');
                  widget.voiceVoid();
                },
                child: Icon(Icons.mic, color: kPrimaryColor),
              ),
              SizedBox(width: kDefaultPadding),
              widget.isSpeak==false ?
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
                          focusNode: widget.focusNode,
                          controller: widget.controller,
                          decoration: InputDecoration(border: InputBorder.none, hintText: 'Type Message'),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          widget.fileSendVoid();
                        },
                        child: Icon(
                          Icons.attach_file,
                          color: Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.64),
                        ),
                      ),
                      SizedBox(width: kDefaultPadding / 4),
                      GestureDetector(
                        onTap: (){
                          widget.imageSendVoid();
                        },
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.64),
                        ),
                      )
                    ],
                  ),
                ),
              ):
              Expanded(child:GestureDetector(
                onLongPressStart: (details) {
                  starty = details.globalPosition.dy;
                  _timer = Timer.periodic
                    (Duration(milliseconds: 1000), (t) {
                    _count++;
                    print('_count is 👉 $_count');
                    if (_count == _countTotal) {
                      hideVoiceView();
                    }
                  });
                  showVoiceView();
                },
                onLongPressEnd: (details) {
                  hideVoiceView();
                },
                onLongPressMoveUpdate: (details) {
                  offset = details.globalPosition.dy;
                  moveVoiceView();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColor.themeColor,
                    borderRadius: BorderRadius.all(Radius.circular(20 ))
                  ),
                  child:Text('Long press speech',style: TextStyle(
                    color: Colors.white
                  ),),
                ),
              ),),

              SizedBox(width: 10,),
              IconButton(onPressed: (){
                widget.sendVoid();
              }, icon: Image.asset('images/ic_chat_send.png',width: 35,height: 35,))
            ],
          )),
    );
  }
}




// class ChatInputField extends StatelessWidget {
//
//   VoidCallback sendVoid;
//   VoidCallback imageSendVoid;
//   VoidCallback fileSendVoid;
//   VoidCallback voiceVoid;
//   bool isSpeak;
//
//
//   final TextEditingController? controller;
//   final FocusNode? focusNode;
//
//     ChatInputField({
//     this.controller,
//      this.focusNode,
//      required this.sendVoid,
//      required this.imageSendVoid,
//      required this.fileSendVoid,
//      required this.voiceVoid,
//       required this.isSpeak,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
//       decoration: BoxDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           boxShadow: [BoxShadow(blurRadius: 32, offset: Offset(0, 4), color: Color(0xff087949).withOpacity(0.3))]),
//       child: SafeArea(
//           child: Row(
//         children: [
//           GestureDetector(
//             onTap: (){
//               print('mic');
//               voiceVoid();
//             },
//             child: Icon(Icons.mic, color: kPrimaryColor),
//           ),
//           SizedBox(width: kDefaultPadding),
//           isSpeak==false ?
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
//               decoration: BoxDecoration(
//                 color: kPrimaryColor.withOpacity(0.07),
//                 borderRadius: BorderRadius.circular(40),
//               ),
//               child: Row(
//                 children: [
//                   // Icon(
//                   //   Icons.sentiment_satisfied_alt_outlined,
//                   //   color: Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.64),
//                   // ),
//                   SizedBox(width: kDefaultPadding / 2),
//                   Expanded(
//                     child: TextField(
//                       focusNode: focusNode,
//                       controller: controller,
//                       decoration: InputDecoration(border: InputBorder.none, hintText: 'Type Message'),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: (){
//                       fileSendVoid();
//                     },
//                     child: Icon(
//                       Icons.attach_file,
//                       color: Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.64),
//                     ),
//                   ),
//                   SizedBox(width: kDefaultPadding / 4),
//                   GestureDetector(
//                     onTap: (){
//                       imageSendVoid();
//                     },
//                     child: Icon(
//                       Icons.camera_alt_outlined,
//                       color: Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.64),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ):
//               Expanded(child:GestureDetector(
//                 onLongPressStart: (details) {
//                   starty = details.globalPosition.dy;
//                   _timer = Timer.periodic(Duration(milliseconds: 1000), (t) {
//                     _count++;
//                     print('_count is 👉 $_count');
//                     if (_count == _countTotal) {
//                       hideVoiceView();
//                     }
//                   });
//                   showVoiceView();
//                 },
//                 onLongPressEnd: (details) {
//                   hideVoiceView();
//                 },
//                 onLongPressMoveUpdate: (details) {
//                   offset = details.globalPosition.dy;
//                   moveVoiceView();
//                 },
//                 child:  Container(
//                   alignment: Alignment.center,
//                   height: 45,
//                   color: Colors.grey,
//                   child:Text('按住讲话'),
//                 ),
//               ),),
//
//           SizedBox(width: 10,),
//           IconButton(onPressed: (){
//             sendVoid();
//           }, icon: Image.asset('images/ic_chat_send.png',width: 35,height: 35,))
//         ],
//       )),
//     );
//   }
// }
