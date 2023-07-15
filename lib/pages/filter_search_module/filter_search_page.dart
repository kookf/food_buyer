import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/pages/filter_search_module/supplier_cate_model.dart';
import 'package:food_buyer/pages/home_modules/home_detail_page.dart';
import 'package:simple_tags/simple_tags.dart';

import '../../common/colors.dart';
import '../../lang/message.dart';
import 'package:get/get.dart';

import '../../services/address.dart';
import '../../services/dio_manager.dart';
import '../chat_modules/addchat_from_phone.dart';
import '../mine_modules/supplier_mine_page.dart';
import 'filter_message_page.dart';
class FilterSearchPage extends StatefulWidget {
  const FilterSearchPage({Key? key}) : super(key: key);

  @override
  State<FilterSearchPage> createState() => _FilterSearchPageState();
}

class _FilterSearchPageState extends State<FilterSearchPage>with SingleTickerProviderStateMixin {

  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: false,
    controlFinishLoad: true,
  );

  bool isShowCategory = false;

  List categoryArr = [
    'Location',
    '水果及蔬菜',
    '其他',
  ];

  List <AddUserList>filterMessageArr = [];

  TextEditingController searchTextEditingController = TextEditingController();

  int page = 1;
  List dataArr = [];
  requestDataWithUserList() async {
    var params = {
      'keyword': searchTextEditingController.text,
      // 'keyword': 'Foodbuyer Demo Company ',
      // 'type': 3,
      'page': page,
      'page_size': 10,
    };
    var json =
    await DioManager().kkRequest(Address.searchSupplier, bodyParams: params);
    AddUserModel model = AddUserModel.fromJson(json);

    if (page == 1) {
      if (model.data!.list == null) {
        easyRefreshController.finishRefresh(IndicatorResult.fail);
      }
      page = 1;
      easyRefreshController.resetFooter();
      dataArr.clear();
      dataArr.addAll(model.data!.list!);
    } else if (model.data!.list!.isNotEmpty) {
      dataArr.addAll(model.data!.list!);
      easyRefreshController.finishLoad(IndicatorResult.success);
    } else {
      easyRefreshController.finishLoad(IndicatorResult.noMore);
    }
    setState(() {});
  }
  /// 類別
  ///
  SupplierCateModel? _supplierCateModel;
  requestDataWithCate()async{
    var json =
    await DioManager().kkRequest(Address.supplierCate, );

    SupplierCateModel model = SupplierCateModel.fromJson(json);
    _supplierCateModel = model;
    setState(() {

    });

  }

  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithCate();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18nContent.filterSearch.tr),
        actions: [
          // GestureDetector(
          //   onTap: (){
          //     isShowCategory =! isShowCategory;
          //     requestDataWithCate();
          //     setState(() {
          //
          //     });
          //   },
          //   child: Container(
          //     margin: EdgeInsets.only(right: 15),
          //     height: 35,
          //     width: 35,
          //     alignment: Alignment.center,
          //     decoration: const BoxDecoration(
          //       color: kDTCloud50,
          //       borderRadius: BorderRadius.all(Radius.circular(5))
          //     ),
          //     child: Image.asset('images/filter_icon.png',width: 15,height: 15,),
          //   ),
          // )
        ],
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // 阴影的偏移量，可以调整阴影的位置
                  ),
                ]
            ),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 15),
              margin: const EdgeInsets.only(left: 15, right: 15,top: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                color: AppColor.searchBgColor,
              ),
              height: 55,
              child: Row(
                children: [
                  Image.asset(
                    'images/ic_search.png',
                    width: 25,
                    height: 25,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        onSubmitted: (value){
                          requestDataWithUserList();
                        },
                        textInputAction: TextInputAction.search,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                          hintText: I18nContent.searchChat.tr,
                        ),
                      ))
                ],
              ),
            ),
          ),
          Container(
            width: Get.width,
            height: 45,
            child: TabBar(
                controller: _tabController, tabs: [
                  Text('類型'),
                  Text('地區'),
            ],
             ),
          ),
          Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            // isShowCategory =! isShowCategory;
                            // setState(() {
                            //
                            // });
                          },
                          child: Column(
                            children: [
                              Container(
                                child:  ListTile(
                                  title: Text('${_supplierCateModel?.data?.list?[index].cateName}'),
                                  // trailing: Icon(Icons.arrow_forward_ios,size: 15,),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context,a){
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(left: 35,right: 35),
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          width: Get.width,
                                          color:kDTCloud50,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${_supplierCateModel?.data?.list?[index].subCateList?[a].name}'),
                                              Image.asset('images/ic_filter_check.png',width: 15,height: 15,)
                                            ],
                                          )
                                      ),
                                      Container(height: 0.1,
                                        color: Colors.grey,)
                                    ],
                                  );
                                },itemCount: _supplierCateModel?.data?.list?[index].subCateList?.length??0,),
                              Container(
                                height: 0.1,
                                color: Colors.black87,
                              )
                            ],
                          ),
                        );
                      }, itemCount: _supplierCateModel?.data?.list?.length??0,),
                    supplierList(),

          ])),
          // isShowCategory == true?
          // Expanded(child: supplierList()):
          // Expanded(child: ListView.builder(
          //   itemBuilder: (context,index){
          //   return GestureDetector(
          //     onTap: (){
          //       // isShowCategory =! isShowCategory;
          //       // setState(() {
          //       //
          //       // });
          //     },
          //     child: Column(
          //       children: [
          //         Container(
          //           child:  ListTile(
          //             title: Text('${_supplierCateModel?.data?.list?[index].cateName}'),
          //             // trailing: Icon(Icons.arrow_forward_ios,size: 15,),
          //           ),
          //         ),
          //         ListView.builder(
          //           shrinkWrap: true,
          //             physics: const NeverScrollableScrollPhysics(),
          //             itemBuilder: (context,a){
          //           return Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Container(
          //                 padding: EdgeInsets.only(left: 35,right: 35),
          //                 alignment: Alignment.centerLeft,
          //                 height: 55,
          //                 width: Get.width,
          //                 color:kDTCloud50,
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Text('${_supplierCateModel?.data?.list?[index].subCateList?[a].name}'),
          //                     Image.asset('images/ic_filter_check.png',width: 15,height: 15,)
          //                   ],
          //                 )
          //               ),
          //               Container(height: 0.1,
          //               color: Colors.grey,)
          //             ],
          //           );
          //         },itemCount: _supplierCateModel?.data?.list?[index].subCateList?.length??0,),
          //         Container(
          //           height: 0.1,
          //           color: Colors.black87,
          //         )
          //       ],
          //     ),
          //   );
          // }, itemCount: _supplierCateModel?.data?.list?.length??0,)),

          Container(
            color: Colors.white,
            height: 75,
            child: Center(
              child: MaterialButton(
                onPressed: () {
                  // Get.to(CreateNotePadPage());
                  // requestDataWithUserList();

                  filterMessageArr.clear();

                  for(int i = 0;i<dataArr.length;i++){
                    AddUserList model = dataArr[i];
                    if(model.isSelect==true){
                      filterMessageArr.add(model);
                    }else if(model.isSelect==false){
                      filterMessageArr.remove(model);
                    }
                  }
                  if(filterMessageArr.isEmpty){
                    BotToast.showText(text: '至少選擇一個供應商');
                    return;
                  }
                  // print(filterMessageArr.length);
                  Get.to(FilterMessagePage(filterMessageArr));
                },
                color: kDTCloud700,
                minWidth: Get.width - 80,
                height: 45,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.
                    all(Radius.circular(22))),
                child: filterMessageArr.isEmpty?Text('Selected ${I18nContent.supplier}',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),
                ):Text(
                  '"${filterMessageArr.length}" Selected for ${I18nContent.boardcast}',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget supplierList(){
    return EasyRefresh(
        controller: easyRefreshController,
        onRefresh: ()async{
          page = 1;
          requestDataWithUserList();
        },
        onLoad: ()async{
          page++;
          requestDataWithUserList();
        },
        child: ListView.builder(itemBuilder: (context,index){
          AddUserList model = dataArr[index];
      return GestureDetector(
        onTap: (){
          Get.to(SupplierMinePage(model.supplier_id!));
        },
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                child: Column(
                  children: [
                    SizedBox(height: 15,),

                    Container(
                      padding: const EdgeInsets.only(left: 15, right: 25),
                      // height: 75,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                    width: Get.width -150,
                                    child: Text(
                                      '${model.supplierName}',style: Theme.of(context).
                                    textTheme.titleLarge,maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                      '${model.location}',style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: kDTCloudGray)
                                  ),
                                  SizedBox(height: 5,),
                                  // productTag(model.productList!),

                                ],
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: (){
                              model.isSelect =! model.isSelect!;

                              filterMessageArr.clear();

                              for(int i = 0;i<dataArr.length;i++){
                                AddUserList model = dataArr[i];
                                if(model.isSelect==true){
                                  filterMessageArr.add(model);
                                }else if(model.isSelect==false){
                                  filterMessageArr.remove(model);
                                }
                              }
                              print(filterMessageArr);
                              print('object');
                              setState(() {

                              });
                            },
                            child:  model.isSelect == false?Image.asset(
                              'images/ic_filter_check.png',
                              width: 20,
                              height: 20,
                            ):Image.asset('images/ic_check.png',width: 20,height: 20,
                            color: kDTCloud500,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    model.productList!.isEmpty?SizedBox():Container(
                      height: 55,
                      width: Get.width-25,
                      child: ListView.builder(
                        padding: EdgeInsets.only(left: 15),
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,a){
                          return GestureDetector(
                            onTap: (){
                              Get.to(HomeDetailPage(id: model.productList?[a].id,));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.5,color: kDTCloudGray),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              child: Text('${model.productList?[a].title}'),
                            ),
                          );
                        },itemCount: model.productList?.length??0,),
                    ),
                    Container(
                      height: 0.3,
                      color: kDTCloudGray,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },itemCount: dataArr.length,));
  }
  Widget productTag(List<ProductList> productList){

    List<String> name = [];
    for(int i = 0;i<productList.length;i++){
      name.add(productList[i].title!);
    }

    return Container(
      width: Get.width-150,
      child: SimpleTags(
        content: name,
        wrapSpacing: 4,
        wrapRunSpacing: 4,
        tagContainerPadding: EdgeInsets.all(6),
        onTagPress: (tag) {
          for(int i = 0;i<productList.length;i++){
            if(productList[i].title == tag){
              Get.to(HomeDetailPage(id:productList[i].id,));
            }
          }
        },
        tagContainerDecoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    );
  }



}
