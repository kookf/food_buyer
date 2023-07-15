import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:food_buyer/utils/event_utils.dart';
import 'package:get/get.dart';

import '../../../../common/foodbuyer_colors.dart';
import '../../../../services/address.dart';

class ChatInformationDetailPage extends StatefulWidget {

  String charRoom;
  ChatInformationDetailPage(this.charRoom,{Key? key}) : super(key: key);

  @override
  State<ChatInformationDetailPage> createState() => _ChatInformationDetailPageState();
}

class _ChatInformationDetailPageState extends State<ChatInformationDetailPage> {


  ChatInfomationDetailModel? _detailModel;
  requestWithDetail()async{
    var params = {
      'room_key':widget.charRoom,
    };
    var json = await DioManager().kkRequest(Address.chatRoom,bodyParams: params);
    ChatInfomationDetailModel model = ChatInfomationDetailModel.fromJson(json);
    _detailModel = model;
    setState(() {

    });
  }

  /// 鎖定聊天室
  requestDataWithLockRoom(var room_key)async{
    var params = {
      'room_key': room_key,
    };
    var json =
    await DioManager().kkRequest(Address.chatLock, bodyParams: params);
    if(json['code'] ==200){
      BotToast.showText(text: '鎖定成功');
    }else{
      BotToast.showText(text: json['message']);
    }

    EventBusUtil.fire('refreshLock');
    requestWithDetail();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestWithDetail();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18nContent.information.tr),
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment(0, 0.2),
            child: Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                color: kDTCloud50,
                borderRadius:
                BorderRadius.all(Radius.circular(60)),
              ),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                imageUrl:
                '${Address.storage}/'
                    '${_detailModel?.data?.avatar}',
                fit: BoxFit.contain,
                progressIndicatorBuilder:
                    (context, url, downloadProgress) =>
                    CircularProgressIndicator(
                        value: downloadProgress.progress),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(height: 5,),
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Text('${_detailModel?.data?.targetName}',
              style: Theme.of(context).textTheme.headlineSmall,),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('HONG KONG',style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: kDTCloudGray
            ),),
          ),

          Container(
            padding: EdgeInsets.only(left: 5),
            margin: EdgeInsets.only(left: 35,right: 35,top: 15),
            decoration: BoxDecoration(
              border: Border.all(width: 0.5,color: kDTCloudGray),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            // height: 115,
            child: TextField(
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: '请输入',
                  border: InputBorder.none
              ),
            ),
          ),
          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            height: 40,
            color: kDTCloud50,
            child: Text('General information',style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: kDTCloud700
            ),),
          ),
          SizedBox(height: 10,),
          Container(
            child: ListTile(
              leading: Image.asset('images/ic_picture.png',width: 45,height: 45,),
              title: Text('Media,Link',style: Theme.of(context).textTheme.bodyLarge,),
              trailing: Icon(Icons.arrow_forward_ios,size: 15,),
              onTap: (){

              },
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            height: 40,
            color: kDTCloud50,
            child: Text('Participants in the message',style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: kDTCloud700
            ),),
          ),
          SizedBox(height: 10,),
          Container(
            height: 130,
            color: Colors.white,
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemBuilder: (context,index){
              return Container(
                child:Container(
                  child: ListTile(
                    leading: Container(
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: const BoxDecoration(
                          color: kDTCloud50,
                          borderRadius:
                          BorderRadius.all(Radius.circular(60)),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: CachedNetworkImage(
                          imageUrl:
                          '${Address.storage}/'
                              '${_detailModel?.data?.userList?[index].avatar}',
                          fit: BoxFit.contain,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                      ),
                    ),
                    title: Text('${_detailModel?.data?.userList?[index].nickName}',style: Theme.of(context).textTheme.bodyLarge,),
                    // trailing: Icon(Icons.delete_forever,size: 15,),
                    onTap: (){
                    },
                  ),
                ) ,
              );
            },itemCount: _detailModel?.data?.userList?.length??0,),
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            height: 40,
            color: kDTCloud50,
            child: Text('Settings',style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: kDTCloud700
            ),),
          ),
          Container(
            child: ListTile(
              leading: Image.asset('images/ic_block_account.png',width: 45,height: 45,),
              title: Text('Block this Account',style: Theme.of(context).textTheme.bodyLarge,),
              trailing: Icon(Icons.arrow_forward_ios,size: 15,),
              onTap: (){
                requestDataWithLockRoom(widget.charRoom);
              },
            ),
          ),
          // Container(
          //   child: ListTile(
          //     leading: Image.asset('images/ic_report_account.png',width: 45,height: 45,),
          //     title: Text('Report this Account',style: Theme.of(context).textTheme.bodyLarge,),
          //     trailing: Icon(Icons.arrow_forward_ios,size: 15,),
          //     onTap: (){
          //
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ChatInfomationDetailModel {
  int? code;
  String? message;
  Data? data;

  ChatInfomationDetailModel({this.code, this.message, this.data});

  ChatInfomationDetailModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? roomId;
  String? roomName;
  String? roomKey;
  int? userId;
  String? nickName;
  String? avatar;
  String? supplierAvatar;
  String? supplierName;
  String? roomType;
  var chatLastMsgId;
  var chatLastAt;
  int? isTop;
  int? roomLock;
  String? targetName;
  String? targetAvatar;
  List<UserList>? userList;

  Data(
      {this.roomId,
        this.roomName,
        this.roomKey,
        this.userId,
        this.nickName,
        this.avatar,
        this.supplierAvatar,
        this.supplierName,
        this.roomType,
        this.chatLastMsgId,
        this.chatLastAt,
        this.isTop,
        this.roomLock,
        this.targetName,
        this.targetAvatar,
        this.userList});

  Data.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    roomName = json['room_name'];
    roomKey = json['room_key'];
    userId = json['user_id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
    supplierAvatar = json['supplier_avatar'];
    supplierName = json['supplier_name'];
    roomType = json['room_type'];
    chatLastMsgId = json['chat_last_msg_id'];
    chatLastAt = json['chat_last_at'];
    isTop = json['is_top'];
    roomLock = json['room_lock'];
    targetName = json['target_name'];
    targetAvatar = json['target_avatar'];
    if (json['user_list'] != null) {
      userList = <UserList>[];
      json['user_list'].forEach((v) {
        userList!.add(new UserList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['room_name'] = this.roomName;
    data['room_key'] = this.roomKey;
    data['user_id'] = this.userId;
    data['nick_name'] = this.nickName;
    data['avatar'] = this.avatar;
    data['supplier_avatar'] = this.supplierAvatar;
    data['supplier_name'] = this.supplierName;
    data['room_type'] = this.roomType;
    data['chat_last_msg_id'] = this.chatLastMsgId;
    data['chat_last_at'] = this.chatLastAt;
    data['is_top'] = this.isTop;
    data['room_lock'] = this.roomLock;
    data['target_name'] = this.targetName;
    data['target_avatar'] = this.targetAvatar;
    if (this.userList != null) {
      data['user_list'] = this.userList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserList {
  int? userId;
  String? nickName;
  String? avatar;

  UserList({this.userId, this.nickName, this.avatar});

  UserList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['nick_name'] = this.nickName;
    data['avatar'] = this.avatar;
    return data;
  }
}
