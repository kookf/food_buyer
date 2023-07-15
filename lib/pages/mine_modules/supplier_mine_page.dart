import 'package:bot_toast/bot_toast.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/components/not_data_page.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/filter_search_module/supplier_info_model.dart';
import 'package:food_buyer/pages/mine_modules/supplier_detail_page.dart';
import 'package:food_buyer/utils/hexcolor.dart';
import 'package:get/get.dart';

import '../../common/foodbuyer_colors.dart';
import '../../common/style.dart';
import '../../services/address.dart';
import '../../services/dio_manager.dart';
import '../../utils/time_ago.dart';
import '../chat_modules/components/body.dart';
import '../home_modules/home_detail_page.dart';
import '../home_modules/home_model.dart';
import 'account_profile_page.dart';

class SupplierMinePage extends StatefulWidget {


  int supplierId;

  SupplierMinePage(this.supplierId,{Key? key}) : super(key: key);

  @override
  State<SupplierMinePage> createState() => _SupplierMinePageState();
}

final List<String> _tabs = <String>[
  'About',
  'Product',
  'Posts',
];
late TabController tabController;

class _SupplierMinePageState extends State<SupplierMinePage>
    with SingleTickerProviderStateMixin {


  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: false,
    controlFinishLoad: true,
  );

  int selectIndex = 0;

  SupplierInfoModel? _supplierInfoModel;
  requestDataWithInfo()async{
    var params = {
      'supplier_id':widget.supplierId,
    };
    var json = await DioManager().kkRequest(Address.supplierInfo,bodyParams: params);
    SupplierInfoModel model = SupplierInfoModel.fromJson(json);
    _supplierInfoModel = model;
    setState(() {

    });
  }

  List dataArr = [];
  int page = 1;
  requestDataWithProductList()async{
    var params = {
      'supplier_id':widget.supplierId,
      'page':page
    };
    var json = await DioManager().kkRequest(Address.supplierProductList,params: params);
    HomeModel model = HomeModel.fromJson(json);
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

  List dataPostArr = [];
  int postPage = 1;
  requestDataWithPostList()async{
    var params = {
      'supplier_id':widget.supplierId,
      'page':postPage
    };
    var json = await DioManager().kkRequest(Address.supplierPostList,params: params);
    HomeModel model = HomeModel.fromJson(json);
    if (page == 1) {
      dataPostArr.clear();
      dataPostArr.addAll(model.data!.list!);
      easyRefreshController.resetFooter();
    } else if (model.data!.list!.isNotEmpty) {
      dataPostArr.addAll(model.data!.list!);
      easyRefreshController.finishLoad(IndicatorResult.success);
    } else {
      easyRefreshController.finishLoad(IndicatorResult.noMore);
    }
    setState(() {

    });
  }

  /// 创建一个聊天室
  requestDataWithCreateChat(int targetId) async {
    var params = {'target_id': targetId};
    var json =
    await DioManager().kkRequest(Address.chatCreate, bodyParams: params);
    if (json['code'] == 200) {
      BotToast.showText(text: json['message']);
      // Get.back(result: 'refresh');
      Get.to(ChatPage(json['data']['room_key'],
        roomName: json['data']['target_name'], member: 2, ));
    } else {
      BotToast.showText(text: json['message']);
    }
  }

  /// 关注供应商
  requestDataWithFollow(var target_id)async{
    var params = {
      'target_id':target_id
    };
    var json = await DioManager().kkRequest(Address.supplierFollow,bodyParams: params);
    requestDataWithInfo();

  }
  /// 取消关注供应商
  requestDataWithCancelFollow(var target_id)async{
    var params = {
      'target_id':target_id
    };
    var json = await DioManager().kkRequest(Address.supplierFollowDelete,bodyParams: params);
    requestDataWithInfo();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithInfo();
    tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                height: Get.height / 3 + 25 ,
                child: Stack(
                  children: [
                    Container(
                      width: Get.width,
                      height: 200,
                      color: Colors.white,
                      child: Image.asset(
                        'images/ic_mine_bg.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.to(SupplierDetailPage(_supplierInfoModel));
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 15),
                        alignment: Alignment.centerRight,
                        width: Get.width,
                        height: 35,
                        color: Colors.transparent,
                        child: Image.asset('images/ic_threedot.png',width: 15,height: 15,),
                      ),
                    ),
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
                              '${_supplierInfoModel?.data?.avatar}',
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
                    Container(
                        margin: EdgeInsets.only(top: 220),
                        alignment: Alignment(0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: Get.width -30,
                              // height: 50,
                              child: Text(
                                '${_supplierInfoModel?.data?.supplierName}',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'HONG KONG',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        child: MaterialButton(
                          onPressed: () {
                            requestDataWithCreateChat(_supplierInfoModel!.data!.user_id!);
                          },
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          color: AppColor.themeColor,
                          height: 55,
                          child: Text(
                            I18nContent.message.tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          onPressed: () {
                            
                          },
                          color: kDTCloud100,
                          height: 55,
                          child: Image.asset(
                            'images/ic_shard.png',
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          onPressed: () {
                            if(_supplierInfoModel?.data?.is_follow==0){
                              requestDataWithFollow(_supplierInfoModel?.data?.id);

                            }else{
                              requestDataWithCancelFollow(_supplierInfoModel?.data?.id);
                            }
                          },
                          color:_supplierInfoModel?.data?.is_follow==0?
                          kDTCloud100:
                          kDTCloud500,
                          // color: HexColor('#e9e9e9'),
                          height: 55,
                          child: Image.asset(
                            'images/ic_like.png',
                            width: 25,
                            height: 25,
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildStickBox()
          ];
      },
        body:   selectIndex==0?aboutList():
        selectIndex==1?productList():
        postList(),

        // CustomScrollView(
        //   slivers: [
        //     // _buildStickBox(),
        //     selectIndex == 0?SliverToBoxAdapter(
        //       child: aboutList(),
        //     ):selectIndex==1? SliverFillRemaining(
        //       // padding: EdgeInsets.only(left: 15, right: 15),
        //       child: waterFallList(),
        //     ):SliverFillRemaining(
        //       child: postList(),
        //     )
        //   ],
        // ),
      ),
    );
  }

  /// 供應商簡介
  Widget aboutList(){
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(I18nContent.about.tr,style: Theme.of(context).textTheme.headlineSmall,),
          ),
          Padding(padding: EdgeInsets.only(left: 25,right: 15),
            child: Text(_supplierInfoModel?.data?.introduce==''?
            '暫無':'${_supplierInfoModel?.data?.introduce}',style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: kDTCloudGray,fontSize: 16
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25,top: 15),
            child: Text('Overseas',style: Theme.of(context).textTheme.headlineSmall,),
          ),
          Padding(padding: EdgeInsets.only(left: 25,right: 15),
            child: Text('Accept Overseas business',style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: kDTCloudGray,fontSize: 16
            ),),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25,top: 15),
            child: Text(I18nContent.files.tr,style: Theme.of(context).textTheme.headlineSmall,),
          ),
          Padding(padding: EdgeInsets.only(left: 25,right: 15),
            child: Text('暫無',style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: kDTCloudGray,fontSize: 16
            ),),
          ),
          // Text('暱稱：${_supplierInfoModel?.data?.nickName}'),
          // SizedBox(height: 10,),
          // Text('公司序列號：${_supplierInfoModel?.data?.brNo}'),
          // SizedBox(height: 10,),
          // Text('營業執照：${_supplierInfoModel?.data?.brFile}'),
          // SizedBox(height: 10,),
          // Text('公司簡介：'),
          // SizedBox(height: 10,),
          // Text('${_supplierInfoModel?.data?.introduce}'),

        ],
      ),
    );
  }

  /// product 列表
  Widget waterFallList() {
    return dataArr.isEmpty?NoDataPage(
      onTap: (){},
    ): MasonryGridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      itemBuilder: (context, index) {
        HomeList model = dataArr[index];
        return model.resType == 0
            ? GestureDetector(
          onTap: () {
            // Get.to(YouTubePlayerPage(ids: '',));
            Get.to(HomeDetailPage(id: model.id,));
          },
          child: Container(
            // height: 100,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${model.title}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Text(
                  //   '${model.body}',
                  //   style: Theme.of(context).textTheme.bodySmall,
                  // ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: Get.width/2,
                    padding: const EdgeInsets.only(right: 5),
                    child:  Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(25)),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: CachedNetworkImage(
                                imageUrl:
                                '${Address.storage}/${model.avatar}',
                                progressIndicatorBuilder: (context, url,
                                    downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${model.nickName}',
                              style:Theme.of(context).textTheme.labelSmall!.copyWith(
                                  color: kDTCloudGray
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset('images/ic_like.png',width: 20,height: 20,
                              color: kDTCloudGray,),
                            const SizedBox(width: 5,),
                            Text(formatNumber(model.zanCount!),style: Theme.of(context).
                            textTheme.labelLarge!.copyWith(
                                color: kDTCloudGray
                            ),)
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
            : GestureDetector(
          onTap: () {
            Get.to(HomeDetailPage(id: model.id!,));
          },
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            // height: 330,

            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                model.resType==3?const SizedBox():
                CachedNetworkImage(
                  imageUrl: '${Address.storage}'
                      '/${model.res?.split(',')[0]}',height: 220,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Text(
                    '${model.title}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                // Container(
                //   padding: const EdgeInsets.only(left: 5,),
                //   child: Text(
                //     '${model.body}',
                //     style: Theme.of(context).textTheme.bodySmall,
                //   ),
                // ),
                // const SizedBox(
                //   height: 5,
                // ),
                Container(
                  width: Get.width/2,
                  padding: const EdgeInsets.only(left: 8,right: 5,bottom: 5),
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(25)),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              imageUrl:
                              '${Address.storage}/${model.avatar}',
                              progressIndicatorBuilder: (context, url,
                                  downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${model.nickName}',
                            style:Theme.of(context).textTheme.labelSmall!.copyWith(
                                color: kDTCloudGray
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          model.isZan==1?
                          Image.asset('images/ic_zan-select.png',width: 20,height: 20,
                            color: Colors.red,):
                          Image.asset('images/ic_like.png',width: 20,height: 20,
                            color: kDTCloudGray,),
                          const SizedBox(width: 5,),
                          Text('${model.zanCount}',style: Theme.of(context).
                          textTheme.labelLarge!.copyWith(
                              color: kDTCloudGray
                          ),)
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2
      ),itemCount: dataArr.length,
    );
  }
  /// product 列表
  Widget productList(){

    return dataArr.isEmpty?NoDataPage(
      onTap: (){
        requestDataWithProductList();
      },
    ): ListView.builder(itemBuilder: (context,index){
      HomeList model = dataArr[index];
      return GestureDetector(
        onTap: (){
          Get.to(HomeDetailPage(id: model.id!,));
        },
        child: Container(
          padding: EdgeInsets.only(right: 15),
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      // width: Get.width-100,
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 10,right: 10),
                                child: Text(
                                  '${model.title}',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),

                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: Get.width,
                            padding: const EdgeInsets.only(left: 8,right: 5,bottom: 5),
                            child:  Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                        '${Address.storage}/${model.avatar}',
                                        progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                            CircularProgressIndicator(
                                                value: downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${model.nickName}',
                                      style:Theme.of(context).textTheme.labelSmall!.copyWith(
                                          color: kDTCloudGray
                                      ),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     model.isZan==1?
                                //     Image.asset('images/ic_zan-select.png',width: 20,height: 20,
                                //       color: Colors.red,):
                                //     Image.asset('images/ic_like.png',width: 20,height: 20,
                                //       color: kDTCloudGray,),
                                //     const SizedBox(width: 5,),
                                //     Text('${model.zanCount}',style: Theme.of(context).
                                //     textTheme.labelLarge!.copyWith(
                                //         color: kDTCloudGray
                                //     ),)
                                //   ],
                                // )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  model.res==null?const SizedBox():
                  CachedNetworkImage(
                    imageUrl: '${Address.storage}'
                        '/${model.res?.split(',')[0]}',height: 65,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              Container(
                color: kDTCloudGray,
                height: 0.2,
              )
            ],
          ),
        ),
      );
    },itemCount:dataArr.length ,);
  }

  /// post 列表
  Widget postList() {
    return dataPostArr.isEmpty?NoDataPage(): MasonryGridView.builder(
      shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5,
          bottom: kBottomNavigationBarHeight),
      itemBuilder: (context, index) {
        HomeList model = dataPostArr[index];
        return model.resType == 0
            ? GestureDetector(
          onTap: () {
            // Get.to(YouTubePlayerPage(ids: '',));
            Get.to(HomeDetailPage(id: model.id,));
          },
          child: Container(
            // height: 100,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${model.title}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Text(
                  //   '${model.body}',
                  //   style: Theme.of(context).textTheme.bodySmall,
                  // ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: Get.width/2,
                    padding: const EdgeInsets.only(right: 5),
                    child:  Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(25)),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: CachedNetworkImage(
                                imageUrl:
                                '${Address.storage}/${model.avatar}',
                                progressIndicatorBuilder: (context, url,
                                    downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${model.nickName}',
                              style:Theme.of(context).textTheme.labelSmall!.copyWith(
                                  color: kDTCloudGray
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset('images/ic_like.png',width: 20,height: 20,
                              color: kDTCloudGray,),
                            const SizedBox(width: 5,),
                            Text(formatNumber(model.zanCount!),style: Theme.of(context).
                            textTheme.labelLarge!.copyWith(
                                color: kDTCloudGray
                            ),)
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
            : GestureDetector(
          onTap: () {
            Get.to(HomeDetailPage(id: model.id!,));
          },
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            // height: 330,

            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                model.resType==3?const SizedBox():
                CachedNetworkImage(
                  imageUrl: '${Address.storage}'
                      '/${model.res?.split(',')[0]}',height: 220,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Text(
                    '${model.title}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                // Container(
                //   padding: const EdgeInsets.only(left: 5,),
                //   child: Text(
                //     '${model.body}',
                //     style: Theme.of(context).textTheme.bodySmall,
                //   ),
                // ),
                // const SizedBox(
                //   height: 5,
                // ),
                Container(
                  width: Get.width/2,
                  padding: const EdgeInsets.only(left: 8,right: 5,bottom: 5),
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(25)),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              imageUrl:
                              '${Address.storage}/${model.avatar}',
                              progressIndicatorBuilder: (context, url,
                                  downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${model.nickName}',
                            style:Theme.of(context).textTheme.labelSmall!.copyWith(
                                color: kDTCloudGray
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          model.isZan==1?
                          Image.asset('images/ic_zan-select.png',width: 20,height: 20,
                            color: Colors.red,):
                          Image.asset('images/ic_like.png',width: 20,height: 20,
                            color: kDTCloudGray,),
                          const SizedBox(width: 5,),
                          Text('${model.zanCount}',style: Theme.of(context).
                          textTheme.labelLarge!.copyWith(
                              color: kDTCloudGray
                          ),)
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2
      ),itemCount: dataPostArr.length,
    );
  }

  Widget _buildStickBox() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: FixedPersistentHeaderDelegate(onClick,height: 54),
    );
  }

  onClick(int index){
    setState(() {
      selectIndex = index;
    });

    if(index == 0){
      requestDataWithInfo();
    }else if(index == 1){
      requestDataWithProductList();
    }else{
      requestDataWithPostList();
    }
  }
}

typedef CallbackFunction = void Function(int);

class FixedPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {

  final CallbackFunction callback;

  final double height;
  FixedPersistentHeaderDelegate(this.callback,{required this.height});



  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        height: height,
        alignment: Alignment.center,
        color: Colors.white,
        child: buildTabBar());
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant FixedPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.height != height;
  }

  Widget buildTabBar() {
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(),
        onTap: (index){
          callback(index);
        },
        // indicator: const BubbleTabIndicator(
        //     indicatorHeight: 45.0,
        //     indicatorColor: Colors.yellow,
        //     tabBarIndicatorSize: TabBarIndicatorSize.tab,
        //     // Other flags
        //     indicatorRadius: 8,
        //     insets: EdgeInsets.all(1),
        //     padding: EdgeInsets.all(155)
        // ),
        isScrollable: false,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        unselectedLabelColor: Colors.grey,
        labelColor: AppColor.themeColor,
        tabs: _tabs.map((String name) => Tab(text: name)).toList(),
        controller: tabController,
      ),
    );
  }
}
