import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/components/not_data_page.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/mine_modules/supplier_mine_page.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:get/get.dart';
import '../../common/foodbuyer_colors.dart';

class SupplierFollowPage extends StatefulWidget {
  const SupplierFollowPage({Key? key}) : super(key: key);

  @override
  State<SupplierFollowPage> createState() => _SupplierFollowPageState();
}

class _SupplierFollowPageState extends State<SupplierFollowPage> {


  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: false,
    controlFinishLoad: true,
  );
  
  bool edit = false;

  List dataArr = [];
  int page = 1;

  List deleteArr =[];

  requestDataWithList()async{

    var json = await DioManager().kkRequest(Address.supplierFollowList);
    SupplierFollowModel model = SupplierFollowModel.fromJson(json);
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
  /// 取消關注
  /// 取消关注供应商
  requestDataWithCancelFollow(var target_id)async{
    var params = {
      'target_id':target_id
    };
    var json = await DioManager().kkRequest(Address.supplierFollowDelete,bodyParams: params);
    requestDataWithList();
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
        title: Text('Follow的供應商'),
        actions: [
          TextButton(onPressed: (){
            edit =! edit;
            setState(() {
              
            });
          },child: edit==true?Text(I18nContent.searchCancel.tr):
          Text(I18nContent.searchEdit.tr)
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(child: EasyRefresh(
            onRefresh: ()async{
              page = 1;
              requestDataWithList();
            },
            controller: easyRefreshController,
            child: dataArr.isEmpty?NoDataPage(
              onTap: (){
                print('sdfsdf');
                requestDataWithList();
              },
            ) :ListView.builder(itemBuilder: (context,index){
              SupplierFollowList model = dataArr[index];
              return GestureDetector(
                  onTap: (){
                    Get.to(SupplierMinePage(model.supplierId!));
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 25),
                        height: 75,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            edit==true?GestureDetector(
                              onTap: (){
                                model.isSelect =! model.isSelect!;
                                setState(() {

                                });
                              },
                              child: model.isSelect==false?Image.asset(
                                'images/ic_filter_check.png',
                                width: 20,
                                height: 20,
                              ):
                              Image.asset('images/ic_check.png',
                              width: 20,height: 20,color: kDTCloud500,
                              ),
                            ):SizedBox(),
                            SizedBox(width: 15,),
                            Row(
                              children: [
                                Center(child:
                                Container(
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
                                        '${model.avatar}',
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: Get.width - 150,
                                      child: Text(
                                        '${model.supplierName}',style: Theme.of(context).
                                      textTheme.titleLarge,maxLines: 1,),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                        'HONGKONG',style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: kDTCloudGray
                                    )
                                    )
                                  ],
                                )
                              ],
                            ),

                          ],
                        ),
                      ),
                      Container(
                        height: 0.3,
                        color: kDTCloudGray,
                      )
                    ],
                  )
              );
            },itemCount: dataArr.length,),
          )),
          Container(
            color: Colors.white,
            height: 75,
            child: Center(
              child: MaterialButton(
                onPressed: () {
                  deleteArr.clear();

                  for(int i = 0;i<dataArr.length;i++){
                    SupplierFollowList model = dataArr[i];
                    if(model.isSelect==true){

                      deleteArr.add(model);
                    }else if(model.isSelect==false){
                      deleteArr.remove(model);
                    }
                  }
                  if(deleteArr.isEmpty){
                    BotToast.showText(text: '至少選擇一個供應商');
                    return;
                  }
                  Get.defaultDialog(
                      title: I18nContent.hint.tr,
                      content: Text('UnFollow Supplier'),
                      cancel: MaterialButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(I18nContent.searchCancel.tr),
                      ),
                      confirm: MaterialButton(
                        onPressed: () {
                          Get.back();
                          for(int i = 0;i<deleteArr.length;i++){
                            SupplierFollowList model = deleteArr[i];
                            requestDataWithCancelFollow(model.supplierId);
                          }

                        },
                        child: Text(
                          I18nContent.enterLabel.tr,
                          style: TextStyle(color: kDTCloud500),
                        ),
                      ));

                },
                color: kDTCloud700,
                minWidth: Get.width - 80,
                height: 45,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.
                    all(Radius.circular(22))),
                child: Text(I18nContent.delete,style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.white
                ),),
              ),
            ),
          )
        ],
      ),
    );
  }
}


class SupplierFollowModel {
  int? code;
  String? message;
  Data? data;

  SupplierFollowModel({this.code, this.message, this.data});

  SupplierFollowModel.fromJson(Map<String, dynamic> json) {
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
  List<SupplierFollowList>? list;
  int? totalRows;
  int? totalPage;

  Data({this.list, this.totalRows, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <SupplierFollowList>[];
      json['list'].forEach((v) {
        list!.add(SupplierFollowList.fromJson(v));
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

class SupplierFollowList {
  int? supplierId;
  String? nickName;
  String? avatar;
  String? supplierName;
  int? followCount;
  String? createdAt;
  String? updatedAt;
  bool? isSelect = false;

  SupplierFollowList(
      {this.supplierId,
        this.nickName,
        this.avatar,
        this.supplierName,
        this.followCount,
        this.createdAt,
        this.isSelect,
        this.updatedAt});

  SupplierFollowList.fromJson(Map<String, dynamic> json) {
    supplierId = json['supplier_id'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
    supplierName = json['supplier_name'];
    followCount = json['follow_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supplier_id'] = this.supplierId;
    data['nick_name'] = this.nickName;
    data['avatar'] = this.avatar;
    data['supplier_name'] = this.supplierName;
    data['follow_count'] = this.followCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
