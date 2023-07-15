import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:get/get.dart';

import '../../../lang/message.dart';
import 'post_create_cate_page.dart';
class PostCatePage extends StatefulWidget {

  int isProduct;
  PostCatePage({required this.isProduct,Key? key}) : super(key: key);

  @override
  State<PostCatePage> createState() => _PostCatePageState();
}

class _PostCatePageState extends State<PostCatePage> {

  PostCateModel? _postCateModel;
  requestDataWithPostCateList()async{

    var params = {
      'is_product':widget.isProduct,
      'pid':0,
    };
    var json = await DioManager().kkRequest(Address.postCateList,params: params);
    PostCateModel model = PostCateModel.fromJson(json);
    _postCateModel = model;
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithPostCateList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('選擇 Category'),
        actions: [
          TextButton(onPressed: ()async{
           var data = await Get.to(const PostCreateCatePage());
           if(data == 'refresh'){
             requestDataWithPostCateList();
           }
          }, child: Text('Create'))
        ],
      ),
      body:SafeArea(
        child:  Column(
          children: [
            Expanded(child: ListView.builder(itemBuilder: (context,index){
              PostCateList? model = _postCateModel?.data?.list?[index];
              return GestureDetector(
                onTap: (){
                  model?.isSelect =! model.isSelect;

                  setState(() {

                  });
                  // var params = {
                  //   'cateName':'${_postCateModel?.data?.list?[index].cateName}',
                  //   'cateId':_postCateModel?.data?.list?[index].cateId,
                  // };
                  // Get.back(result:params);
                },
                child: Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: 55,
                      padding: EdgeInsets.only(left: 15,right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${_postCateModel?.data?.list?[index].cateName}'),
                          Image.asset('images/ic_checked.png',
                            width: 15,height: 15,
                            color: _postCateModel?.data?.list?[index].isSelect==false?
                            Colors.grey.shade300:
                            kDTCloud900,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 0.5,
                      color: kDTCloudGray,
                    )
                  ],
                ),
              );
            },
              itemCount: _postCateModel?.data?.list?.length??0,),),
            Container(
              height: 55,
              child: Center(
                child: MaterialButton(
                  onPressed: () {
                    List namArr = [];
                    List cateIdArr = [];
                    for(int i = 0;i<_postCateModel!.data!.list!.length;i++){
                      if(_postCateModel!.data!.list![i].isSelect){
                        namArr.add('${_postCateModel!.data!.list![i].cateName}');
                        cateIdArr.add('${_postCateModel!.data!.list![i].cateId}');
                        // arr.add({
                        //   'name':'${_postCateModel!.data!.list![i].cateName}',
                        //   'id':'${_postCateModel!.data!.list![i].cateId}',
                        // });
                      }
                    }
                    if(namArr.isEmpty){
                      BotToast.showText(text: '至少選擇一個Category');
                      return;
                    }
                    Get.back(result: {
                      'nameArr':namArr,
                      'cateIdArr':cateIdArr,
                    });
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: kDTCloud900,
                  minWidth: Get.width - 80,
                  height: 45,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22))),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

class PostCateModel {
  int? code;
  String? message;
  Data? data;

  PostCateModel({this.code, this.message, this.data});

  PostCateModel.fromJson(Map<String, dynamic> json) {
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
  List<PostCateList>? list;
  int? totalRows;
  int? totalPage;

  Data({this.list, this.totalRows, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <PostCateList>[];
      json['list'].forEach((v) {
        list!.add(new PostCateList.fromJson(v));
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

class PostCateList {
  int? cateId;
  String? cateName;
  int? isProduct;
  int? pid;
  bool isSelect = false;
  PostCateList({this.cateId, this.cateName, this.isProduct, this.pid});

  PostCateList.fromJson(Map<String, dynamic> json) {
    cateId = json['cate_id'];
    cateName = json['cate_name'];
    isProduct = json['is_product'];
    pid = json['pid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cate_id'] = this.cateId;
    data['cate_name'] = this.cateName;
    data['is_product'] = this.isProduct;
    data['pid'] = this.pid;
    return data;
  }
}
