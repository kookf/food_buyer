import 'dart:async';
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/chat_modules/models/message_model.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:food_buyer/utils/persisten_storage.dart';
import 'package:image_pickers/image_pickers.dart';
import '../../../common/colors.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/websocket_kk.dart';
import '../chat_list_model.dart';
import '../models/ChatMessage.dart';
import 'chat_information_modules/chat_information_page.dart';
import 'chat_input_fields.dart';
import 'constants.dart';
import 'message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'dart:io';
import 'package:get/utils.dart';
class ChatPage extends StatefulWidget {

  String roomKey;
  ChatListData model1;

  ChatPage(this.roomKey,this.model1,{Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  final _listenable = IndicatorStateListenable();
  double? _viewportDimension;

  bool isSpeak = false;


  TextEditingController messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  FocusNode _focusNode = FocusNode();

  bool _shrinkWrap = false;

  // 2.身份验证
  // socket.send('{"user_id":'+ user_id +',"key":"'+ socket_key +'","type":0}');
  // -1 心跳 0登录 1 文字消息 2 图片消息 3 文件消息
  var socket_status = 0;
  var userId;

  List<ChatMessage> ChatMessages = [];


  List <ChatMessage> mesArr = [];
  int page = 1;

  requestDataWithMsg()async{
    var params = {
      'page':page,
      'paage_size':10,
      'room_key':widget.roomKey,
    };
    var json = await DioManager().kkRequest(Address.msgList,bodyParams: params);
    MessageModel messageModel = MessageModel.fromJson(json);

    for(int i = 0;i<messageModel.data!.list!.length;i++){
      bool isSender;
      ChatMessageType? messageType;

      if(await PersistentStorage().getStorage('id')==messageModel.data!.list![i].userId){
        isSender = true;
      }else{
        isSender = false;
      }
      if(messageModel.data!.list![i].type==1){
        messageType = ChatMessageType.text;
      }else if(messageModel.data!.list![i].type==2){
        messageType = ChatMessageType.image;
      }else if(messageModel.data!.list![i].type==3){
        messageType = ChatMessageType.file;
      }else if(messageModel.data!.list![i].type==4){
        messageType = ChatMessageType.leaveText;
      }else if(messageModel.data!.list![i].type==5){
        messageType = ChatMessageType.audio;
      }

      print(messageModel.data!.list![i].type);
      mesArr.add(ChatMessage(
          text: '${messageModel.data!.list![i].msg}',
          time: '${messageModel.data!.list![i].createdAt!}',
          messageType: messageType!,
          messageStatus: MessageStatus.viewed,
          isSender: isSender,
          nick_name: '${messageModel.data!.list![i].nickName}',
          fileImagePath: '${messageModel.data!.list![i].msg}',
          filePath: '${messageModel.data!.list![i].msg}',
          fileName: messageModel.data!.list![i].file_name,
           avatar: messageModel.data!.list![i].avatar,
        msgId:messageModel.data!.list![i].msgId ,
        userId:messageModel.data!.list![i].userId ,
        type: messageModel.data!.list![i].type,
      ));
    }

    setState(() {

    });
  }

  StreamSubscription? eventBusFn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initWeb();
    // initWebSocket();
    // initMessage();
    requestDataWithMsg();

    // _focusNode.addListener(_onFocusChange);
    // _onFocusChange();
    _listenable.addListener(_onHeaderChange);
    listerData();

    // eventBusFn = eventBus.on<EventFn>().listen((event) {
    //     //  event为 event.obj 即为 eventBus.dart 文件中定义的 EventFn 类中监听的数据
    //     print('event.obj hh ===== ${event.obj}');
    //     mesArr.insertAll(0,event.obj);
    //     print(mesArr.length);
    //     setState(() {
    //
    //     });
    //   });
  }
  int userLength = -1;
  listerData(){
    eventBusFn = EventBusUtil.listen((event) {

      print('+++++++++++++++++++${event}');

      if(event is String){
        return;
      }
        var type = event['type'];
        if(event['type'] == 10){
          List userList = event['userList'];
          userLength = userList.length;
          setState(() {

          });

          return;
        }
      if(type == 4){
        // List userList = event['userList'];
        // userLength = userList.length;
        print('event.obj type 4 ===== ${event}');
        userLength = event['user_nums'];
        mesArr.insertAll(0,event['arr']);
        print(mesArr.length);
        EventBusUtil.fire('chatListRefresh');
        setState(() {

        });
        return;
      }
      if(type == 1){
        print('event.obj hh ===== ${event}');
        mesArr.insertAll(0,event['arr']);
        print(mesArr.length);
      }else if(type ==2){
        print('event.obj hh ===== ${event}');
        mesArr.insertAll(0,event['arr']);
        print(mesArr.length);
      }else if(type ==3){
        print('event.obj hh ===== ${event}');
        mesArr.insertAll(0,event['arr']);
        print(mesArr.length);
      }else if(type==5){
        print('event.obj hh ===== ${event}');
        mesArr.insertAll(0,event['arr']);
        print(mesArr.length);
      }

      setState(() {

      });
    });

  }
  void _onHeaderChange() {
    final state = _listenable.value;
    if (state != null) {
      final position = state.notifier.position;
      _viewportDimension ??= position.viewportDimension;
      final shrinkWrap = state.notifier.position.maxScrollExtent == 0;
      if (_shrinkWrap != shrinkWrap &&
          _viewportDimension == position.viewportDimension) {
        setState(() {
          _shrinkWrap = shrinkWrap;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();

    eventBusFn!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset:true ,
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
              child:EasyRefresh(
                header: ListenerHeader(
                  listenable: _listenable,
                  triggerOffset: 100000,
                  clamping: false,
                ),
                onRefresh: () {},
                clipBehavior: Clip.none,

                // footer: MaterialFooter(),
                controller: easyRefreshController,
                onLoad: () async {
                  page++;
                  await Future.delayed(const Duration(seconds: 1));
                  if (!mounted) {
                    return;
                  }
                  requestDataWithMsg();
                  // return IndicatorResult.success;
                  // easyRefreshController.finishLoad(
                  //     IndicatorResult.success);
                  easyRefreshController.finishLoad();

                  // easyRefreshController.resetFooter();
                  // return IndicatorResult.success;
                  setState(() {
                  });

                },
                child:CustomScrollView(
                  reverse: true,
                  shrinkWrap: _shrinkWrap,
                  clipBehavior: Clip.none,
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: _scrollController,
                  slivers: [
                    SliverPadding(padding: EdgeInsets.only(left: 5,right: 5),
                    sliver:SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return Message(message:mesArr[index]);
                        },
                        childCount: mesArr.length,
                      ),
                    ),)
                  ],
                  // itemCount: ChatMessages.length,
                  // itemBuilder: (context, index) =>
                  //     Message(message:ChatMessages[index]),
                ),
              )
          ),

          // Container(
          //   color: Colors.red,
          //   height: 70+MediaQuery.of(context).padding.bottom,
          //   child: Row(
          //     children: [
          //       Image.asset('images/ic_chat_photo.png',width: 25,
          //           height: 25,),
          //       Image.asset('images/ic_chat_add.png',width: 25,height: 25,),
          //       Image.asset('images/ic_chat_audio.png',width: 25,height: 25,),
          //       Container(
          //         height: 55,
          //         width: 200,
          //         color: Colors.yellowAccent,
          //         child: TextField(
          //           decoration: InputDecoration(
          //             border: InputBorder.none
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // )
          ChatInputField(focusNode:_focusNode,
            controller: messageController,sendVoid: (){
            sendMessage();
            },imageSendVoid: (){
              sendImageMessage();
            },fileSendVoid: (){
            sendFileMessage();
            },voiceVoid: (){
              isSpeak=!isSpeak;
              setState(() {

              });
            },isSpeak: isSpeak,stopRecord: (path,sec){
              sendVAudioMessage(path);
            print('body===${path},sec===${sec}');
            },)
        ],
      ),
    );
  }
  /// 滾動到底部
  scrollViewBottom(){
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent+
          MediaQuery.of(context).padding.bottom,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }
  ///發送test信息
  sendMessage()async{
    if(messageController.text.isEmpty){
      return;
    }
    var params = {
      'room_key':widget.roomKey,
      'msg':messageController.text,
      'type':1,
    };
    var json = jsonEncode(params);
    print(json);

    WebSocketUtility().sendMessage(json);
    messageController.text = '';

    setState(() {

    });
  }
  /// 發送image
  sendImageMessage()async{
    selectImages();
  }
  /// 獲取圖片地址
  Future requestDataWithPath(var value)async{
    MultipartFile multipartFile = MultipartFile.fromFileSync(
      '${value[0].path}',
    );
    FormData formData = FormData.fromMap({
      'dir':'image',
      'type':'image',
      'file':multipartFile,
    });
    var json = await DioManager().kkRequest(Address.upload,bodyParams:formData);
    return json;
  }
  /// 上传图片
  selectImages() async {
    ImagePickers.pickerPaths(
      galleryMode: GalleryMode.image,
      showGif: false,
      selectCount: 1,
      showCamera: true,
      cropConfig: CropConfig(enableCrop: true, height: 1, width: 1),
      compressSize: 300,
      uiConfig: UIConfig(
        uiThemeColor: AppColor.themeColor,
      ),
    ).then((value) {
      requestDataWithPath(value).then((json1) {
        var params = {
          'room_key':widget.roomKey,
          'msg':json1['data']['path'],
          'type':2,
          'file_name':json1['data']['file_name'],
        };
        var json = jsonEncode(params);
        print('发送图片===============${json}');

        WebSocketUtility().sendMessage(json);

      });
      scrollViewBottom();
    });
  }

  /// 獲取文件地址
  Future requestDataWithFilePath(var value)async{

    // if(listFilePaths.isEmpty){
    //   BotToast.showText(text: '');
    //   return;
    // }
    print('value audio ==== ${value}');

    MultipartFile multipartFile = MultipartFile.fromFileSync(
      '${value[0].path}',
      // filename: 'fileName.${value[0].path.split('.').last}',
    );
    FormData formData = FormData.fromMap({
      'dir':'',
      'type':'file',
      'file':multipartFile,
    });
    var json = await DioManager().kkRequest(Address.upload,
        bodyParams:formData);
    return json;
  }

  /// 獲取audio 地址
  Future requestDataWithAudio(var value)async{

    print('value audio ==== ${value}');

    MultipartFile multipartFile = MultipartFile.fromFileSync(
      '${value}',
      // filename: 'fileName.${value[0].path.split('.').last}',
    );
    FormData formData = FormData.fromMap({
      'dir':'',
      'type':'audio',
      'file':multipartFile,
    });
    var json = await DioManager().kkRequest(Address.upload,
        bodyParams:formData);
    return json;
  }

  /// 發送文件
  sendFileMessage()async{

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    requestDataWithFilePath(result?.files).then((json1) {
      var params = {
        'room_key':widget.roomKey,
        'msg':json1['data']['path'],
        'type':3,
        'file_name':json1['data']['file_name'],
      };
      var json = jsonEncode(params);
      print('发送文件===============${json}');

      WebSocketUtility().sendMessage(json);
    });

    // ChatMessages.insert(0,ChatMessage(
    //     time: '時間',
    //     messageType: ChatMessageType.file,
    //     messageStatus: MessageStatus.viewed,
    //     isSender: true,
    //     filePath: result?.files[0].path));
    scrollViewBottom();
  }

  ///发送语音
  sendVAudioMessage(String path){
    requestDataWithAudio(path).then((json1) {
      var params = {
        'room_key':widget.roomKey,
        'msg':json1['data']['path'],
        'type':5,
        'file_name':json1['data']['file_name'],
      };
      var json = jsonEncode(params);
      print('语音文件===============${json}');

      WebSocketUtility().sendMessage(json);
    });

    // mesArr.insert(0,ChatMessage(
    //     text: 'json[]',
    //     time: 'time',
    //     messageType: ChatMessageType.audio,
    //     messageStatus: MessageStatus.viewed,
    //     msgId: 11,
    //     userId: 11,
    //     room_key: 11,
    //     avatar: '11',
    //     nick_name: 11,
    //     type: 5,
    //     isSender: true));

    setState(() {

    });
  }


  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(onPressed: (){
            Get.back(result: 'chatListRefresh');
          }, icon: Icon(Icons.arrow_back_ios)),

          // const BackButton(),
          // Container(
          //   color: Colors.white,
          //   alignment: Alignment.center,
          //   height: 50,
          //   width: 50,
          //   child: GridView.builder(
          //     padding: EdgeInsets.all(0),
          //     shrinkWrap: true,
          //     physics: NeverScrollableScrollPhysics(),
          //     itemBuilder: (context,index){
          //       return Container(
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.all(Radius.circular(30)),
          //         ),
          //         clipBehavior: Clip.hardEdge,
          //         child: CachedNetworkImage(
          //           imageUrl: '${Address.homeHost}${Address.storage}/'
          //               '${widget.model1.userList![index].avatar}',
          //           progressIndicatorBuilder: (context, url, downloadProgress) =>
          //               CircularProgressIndicator(value: downloadProgress.progress),
          //           errorWidget: (context, url, error) => const Icon(Icons.error),
          //         ),
          //       );
          //     },itemCount: widget.model1.userList!.length,
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 2,
          //         crossAxisSpacing: 3,
          //         mainAxisSpacing: 3,
          //         childAspectRatio: 1
          //     ),
          //   ),
          // ),
          // const CircleAvatar(
          //   backgroundImage: AssetImage('images/user_2.png'),
          // ),
          const SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[

             userLength==-1?Text(widget.model1.roomName==''?
                'unnamed (${widget.model1.userList!.length}member)':'${widget.model1.roomName}'
                  ' (${widget.model1.userList!.length}member)',
                  style: TextStyle(fontSize: 16)):Text(widget.model1.roomName==''?
            'unnamed (${userLength}member)':'${widget.model1.roomName}'
                ' (${userLength}member)',
                style: TextStyle(fontSize: 16)),
              // Text('Active 3m ago', style: TextStyle(fontSize: 12))
            ],
          )
        ],
      ),
      actions: [
        IconButton(onPressed: () {
          Get.to(ChatInformationPage(model: widget.model1,));
        }, icon: Image.asset('images/ic_dot3.png',width: 15,height: 15,)),
        // IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
        SizedBox(
          width: kDefaultPadding / 2,
        )
      ],
    );
  }

}

