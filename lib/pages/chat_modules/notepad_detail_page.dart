import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';

class NotePadDetailPage extends StatefulWidget {
  int cateId;
  String cateName;


  NotePadDetailPage({required this.cateName,
    required this.cateId,Key? key}) : super(key: key);

  @override
  State<NotePadDetailPage> createState() => _NotePadDetailPageState();
}

class _NotePadDetailPageState extends State<NotePadDetailPage> {


  NotePadDetailModel? _notePadDetailModel;
  requestData()async{

    var params = {
      'cate_id':widget.cateId,
      'page':1,
      'page_size':100,
    };
    var json = await DioManager().kkRequest(Address.notePadList,bodyParams: params);
    NotePadDetailModel model = NotePadDetailModel.fromJson(json);

    _notePadDetailModel = model;

    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDTCloud50,
      appBar: AppBar(
        title: Text('Information'),
      ),
      body: EasyRefresh(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child:Container(
                padding: EdgeInsets.all(15),
                color: Colors.white,
                // height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.cateName}',style: Theme.of(context).textTheme.titleLarge,),
                  ],
                ),
              ) ,
            ),
            SliverToBoxAdapter(
              child:Container(
                padding: EdgeInsets.all(15),
                color: Colors.transparent,
                // height: 100,
                child: Text('Message',style: Theme.of(context).textTheme.headlineSmall!.
                copyWith(color: Colors.black),),
              ) ,
            ),
            SliverToBoxAdapter(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context,index){
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(kRadialReactionRadius)),
                    color: Colors.white,

                  ),
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Center(
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(30)),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: CachedNetworkImage(
                            imageUrl:
                            '${Address.storage}/'
                                '${_notePadDetailModel?.data?.list![index].avatar}',
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text('${_notePadDetailModel?.data?.list![index].nickName}'),
                          Text('${_notePadDetailModel?.data?.list![index].msg}'),

                        ],
                      ))
                    ],
                  ),
                );
              },
                itemCount: _notePadDetailModel?.data?.list?.length??0,),
            )
          ],
        ),
      ),
    );
  }
}
class NotePadDetailModel {
  int? code;
  String? message;
  Data? data;

  NotePadDetailModel({this.code, this.message, this.data});

  NotePadDetailModel.fromJson(Map<String, dynamic> json) {
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
  List<NotePadDetailItem>? list;
  int? totalRows;
  int? totalPage;

  Data({this.list, this.totalRows, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <NotePadDetailItem>[];
      json['list'].forEach((v) {
        list!.add(NotePadDetailItem.fromJson(v));
      });
    }
    totalRows = json['total_rows'];
    totalPage = json['total_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['total_rows'] = this.totalRows;
    data['total_page'] = this.totalPage;
    return data;
  }
}

class NotePadDetailItem {
  int? notepadId;
  int? msgId;
  String? nickName;
  String? avatar;
  int? type;
  String? msgTime;
  String? notepadTime;
  int? userId;
  String? msg;
  var fileName;

  NotePadDetailItem(
      {this.notepadId,
        this.msgId,
        this.nickName,
        this.avatar,
        this.type,
        this.msgTime,
        this.notepadTime,
        this.userId,
        this.msg,
        this.fileName});

  NotePadDetailItem.fromJson(Map<String, dynamic> json) {
    notepadId = json['notepad_id'];
    msgId = json['msg_id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
    type = json['type'];
    msgTime = json['msg_time'];
    notepadTime = json['notepad_time'];
    userId = json['user_id'];
    msg = json['msg'];
    fileName = json['file_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notepad_id'] = this.notepadId;
    data['msg_id'] = this.msgId;
    data['nick_name'] = this.nickName;
    data['avatar'] = this.avatar;
    data['type'] = this.type;
    data['msg_time'] = this.msgTime;
    data['notepad_time'] = this.notepadTime;
    data['user_id'] = this.userId;
    data['msg'] = this.msg;
    data['file_name'] = this.fileName;
    return data;
  }
}
