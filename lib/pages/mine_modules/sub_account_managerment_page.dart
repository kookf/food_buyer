import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../common/foodbuyer_colors.dart';
import '../../common/style.dart';

class SubAccountManagermentPage extends StatefulWidget {
  const SubAccountManagermentPage({Key? key}) : super(key: key);

  @override
  State<SubAccountManagermentPage> createState() =>
      _SubAccountManagermentPageState();
}

class _SubAccountManagermentPageState extends State<SubAccountManagermentPage> {


  TextEditingController emailController = TextEditingController();
  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: false,
    controlFinishLoad: true,
  );
  ///sub list
  int page = 1;
  List dataArr = [];

  requestDataWithList()async{

    var params = {
      'page':page,
    };
    var json = await DioManager().kkRequest(Address.supplierSubAccountList,params: params);
    SubAccountManagerModel model = SubAccountManagerModel.fromJson(json);
    if (page == 1) {
      dataArr.clear();
      dataArr.addAll(model.data!.list!);
      easyRefreshController.resetFooter();
    } else if (model.data!.list!.isNotEmpty) {
      dataArr.addAll(model.data!.list!);
      easyRefreshController.finishLoad(IndicatorResult.success);
    } else {
      easyRefreshController.finishLoad(IndicatorResult.noMore);
    }
    setState(() {

    });
  }
  /// sub create 
  requestDataWithCreate()async{
    var params = {
      'email':emailController.text
    };
    var json = await DioManager().kkRequest(Address.supplierSubAccountCreate,bodyParams: params);
    if(json['code'] == 200){
      requestDataWithList();
      Get.back();
    }
    BotToast.showText(text: json['message']['message']);
  }

  /// sub delete
  requestDataWithDelete(var userId)async{
    var params = {
      'user_id':userId
    };
    var json = await DioManager().kkRequest(Address.supplierSubAccountDelete,bodyParams: params);
    if(json['code'] == 200){
      requestDataWithList();
      // Get.back();
    }
    BotToast.showText(text: json['message']['message']);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub-Account'),
        // actions: [TextButton(onPressed: () {}, child: Text('Edit'))],
      ),
      body: Column(
        children: [
          Expanded(
              child: EasyRefresh(
                controller: easyRefreshController,
                onRefresh: () async {
                  page = 1;
                  requestDataWithList();
                },
                onLoad: ()async{
                  page++;
                  requestDataWithList();
                },
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 15),
                  itemBuilder: (BuildContext context, int index) {
                    SubAccountManagerList model = dataArr[index];
                    return SwipeActionCell(
                        key: ObjectKey(dataArr[index]),
                      trailingActions: <SwipeAction>[
                        SwipeAction(
                            title: "delete",
                            onTap: (CompletionHandler handler) async {
                              requestDataWithDelete(model.userId!);
                              await handler(true);
                              setState(() {});
                            },
                            color: Colors.red),
                      ],
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.only(left: 25, right: 25),
                                height: 75,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: kDTCloud50,
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(25)),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                              '${Address.storage}/'
                                                  '${model.avatar}',
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
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${model.nickName}',),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Hong Kong',
                                              style: TextStyle(
                                                  color: AppColor.smallTextColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      'images/ic_arrow_right.png',
                                      width: 10,
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              color: AppColor.lineColor,
                              height: 1,
                            )
                          ],
                        ),
                    );
                  },
                  itemCount: dataArr.length,
                ),
              )
          ),
          GestureDetector(
            onTap: (){
              Get.defaultDialog(
                title: I18nContent.hint,
                content:TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: '請輸入電郵'
                  ),
                  controller: emailController,
                ),
                confirm: MaterialButton(onPressed: (){
                  if(!GetUtils.isEmail(emailController.text)){
                    BotToast.showText(text: '請輸入正確的電郵');
                    return;
                  }
                  requestDataWithCreate();
                },child: Text(I18nContent.enterLabel.tr),),
                cancel:  MaterialButton(onPressed: (){
                  Get.back();
                },child: Text(I18nContent.searchCancel.tr),),
              );
            },
            child: Container(
              color: Colors.white,
              height: 80,
              margin: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
              child: Center(
                child: Container(
                  height: 65,
                  margin: EdgeInsets.only(left: 35, right: 25),
                  padding: EdgeInsets.only(right: 0),
                  child: DottedBorder(
                    color: Colors.grey,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(4),
                    strokeWidth: 0.5,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Add Sub-accounts',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.smallTextColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Image.asset(
                                'images/ic_add.png',
                                width: 25,
                                height: 25,
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


class SubAccountManagerModel {
  int? code;
  String? message;
  Data? data;

  SubAccountManagerModel({this.code, this.message, this.data});

  SubAccountManagerModel.fromJson(Map<String, dynamic> json) {
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
  List<SubAccountManagerList>? list;
  int? totalRows;
  int? totalPage;

  Data({this.list, this.totalRows, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <SubAccountManagerList>[];
      json['list'].forEach((v) {
        list!.add( SubAccountManagerList.fromJson(v));
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

class SubAccountManagerList {
  int? id;
  String? nickName;
  String? avatar;
  int? userId;

  SubAccountManagerList({this.id, this.nickName, this.avatar, this.userId});

  SubAccountManagerList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nick_name'] = this.nickName;
    data['avatar'] = this.avatar;
    data['user_id'] = this.userId;
    return data;
  }
}
