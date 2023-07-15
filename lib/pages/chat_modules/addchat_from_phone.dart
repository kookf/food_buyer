import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/pages/chat_modules/components/body.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:get/get.dart';
import '../../common/style.dart';
import '../../components/not_data_page.dart';

class AddChatFromPhone extends StatefulWidget {
  const AddChatFromPhone({Key? key}) : super(key: key);

  @override
  State<AddChatFromPhone> createState() => _AddChatFromPhoneState();
}

class _AddChatFromPhoneState extends State<AddChatFromPhone> {
  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  var searchTextEditingController = TextEditingController();
  var selectValue = '供應商';

  var page = 1;
  var type = 3;
  List dataArr = [];
  requestDataWithUserList() async {
    var params = {
      'keyword': searchTextEditingController.text,
      // 'keyword': 'Foodbuyer Demo Company ',
      'type': type,
      'page': page,
      'page_size': 10,
    };
    var json =
        await DioManager().kkRequest(Address.searchUse, bodyParams: params);
    AddUserModel model = AddUserModel.fromJson(json);

    if (page == 1) {
      if (model.data!.list == null) {
        easyRefreshController.finishRefresh(IndicatorResult.fail);
      }
      easyRefreshController.resetFooter();
      dataArr.clear();
      dataArr.addAll(model.data!.list!);
      easyRefreshController.finishRefresh(IndicatorResult.success);
    } else if (model.data!.list!.isNotEmpty) {
      dataArr.addAll(model.data!.list!);
      easyRefreshController.finishLoad(IndicatorResult.success);
    } else {
      easyRefreshController.finishLoad(IndicatorResult.noMore);
    }
    setState(() {});
  }

  /// 创建一个聊天室
  requestDataWithCreateChat(int targetId) async {
    var params = {'target_id': targetId};
    var json =
        await DioManager().kkRequest(Address.chatCreate, bodyParams: params);
    if (json['code'] == 200) {
      BotToast.showText(text: json['message']);
      Get.back(result: 'refresh');
      // Get.to(ChatPage(roomKey, model1))
    } else {
      BotToast.showText(text: json['message']);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // requestDataWithUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('查找供應商'),
      ),
      body: Column(
        children: [
          searchContainer(),
          Expanded(
              child: EasyRefresh(
            onRefresh: () async {
              page = 1;
              requestDataWithUserList();
            },
            onLoad: () async {
              page++;
              requestDataWithUserList();
            },
            controller: easyRefreshController,
            child: dataArr.isEmpty
                ? NoDataPage()
                : ListView.builder(
                    padding: EdgeInsets.only(top: 5),
                    itemBuilder: (context, index) {
                      AddUserList model = dataArr[index];
                      return Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 15),
                            color: Colors.white,
                            width: Get.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
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
                                  width: 15,
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // SizedBox(height: 10,),
                                    Text('昵稱:${model.nickName}'),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      child: Text('公司名稱:${model.supplierName}'),
                                    ),

                                    // Container(
                                    //   padding: EdgeInsets.only(left: 65),
                                    //   child: Text('角色:${model.type==1?
                                    //   '個人':model.type==2?'公司':'供應商'}'),
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text('電郵:${model.email}'),
                                        ),
                                      ],
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        requestDataWithCreateChat(model.id!);
                                      },
                                      color: kDTCloud700,
                                      child: Text(
                                        '立即聊天',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: Colors.white),
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            ),
                          ),
                          Container(
                            height: 0.5,
                            color: AppColor.lineColor,
                          )
                        ],
                      );
                    },
                    itemCount: dataArr.length,
                  ),
          ))
        ],
      ),
    );
  }

  Widget searchContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        border: Border.all(width: 0.5, color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      height: 55,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                color: Colors.white,
                child: CustomDropdownButton2(
                  dropdownWidth: 100,
                  buttonWidth: 110,
                  hint: '',
                  dropdownItems: const [
                    // '個人',
                    // '公司',
                    '供應商',
                  ],
                  value: selectValue,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 20,
                  ),
                  buttonDecoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(borderRadius))),
                  onChanged: (value) {
                    print(selectValue);
                    selectValue = value!;
                    if (selectValue == '個人') {
                      type = 1;
                    } else if (selectValue == '公司') {
                      type = 2;
                    } else {
                      type = 3;
                    }
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              color: Colors.white,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius:
                          BorderRadius.all(Radius.circular(borderRadius))),
                  margin: const EdgeInsets.only(left: 0, right: 15),
                  height: 40,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'images/ic_search.png',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          child: SizedBox(
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.text,
                          autofocus: true,
                          onSubmitted: (value) {
                            print('value ======${value}');
                            if (selectValue == '個人') {
                              type = 1;
                              requestDataWithUserList();
                            }
                            if (selectValue == '公司') {
                              type = 2;
                              requestDataWithUserList();
                            }
                            if (selectValue == '供應商') {
                              type = 3;
                              requestDataWithUserList();
                            }
                            setState(() {});
                          },
                          controller: searchTextEditingController,
                          decoration: InputDecoration(
                              hintText: '請輸入${selectValue}名稱',
                              border: InputBorder.none,
                              isCollapsed: true),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddUserModel {
  int? code;
  String? message;
  Data? data;

  AddUserModel({this.code, this.message, this.data});

  AddUserModel.fromJson(Map<String, dynamic> json) {
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
  List<AddUserList>? list;
  int? totalRows;
  int? totalPage;

  Data({this.list, this.totalRows, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <AddUserList>[];
      json['list'].forEach((v) {
        list!.add(new AddUserList.fromJson(v));
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

class AddUserList {
  int? id;
  String? name;
  String? avatar;
  String? email;
  String? phone;
  String? nickName;
  int? type;
  int? supplier_id;
  var supplierName;
  var location;
  bool? isSelect = false;
  List<ProductList>? productList;


  AddUserList(
      {this.id,
      this.name,
      this.avatar,
      this.email,
      this.phone,
      this.nickName,
      this.type,
        this.productList,
      this.supplier_id,
      this.location,
      this.isSelect,
      this.supplierName});

  AddUserList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    email = json['email'];
    phone = json['phone'];
    supplier_id = json['supplier_id'];
    nickName = json['nick_name'];
    location = json['location'];
    type = json['type'];
    supplierName = json['supplier_name'];
    if (json['product_list'] != null) {
      productList = <ProductList>[];
      json['product_list'].forEach((v) {
        productList!.add(new ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['nick_name'] = this.nickName;
    data['type'] = this.type;
    data['supplier_name'] = this.supplierName;
    return data;
  }
}

class ProductList {
  int? id;
  int? userId;
  int? supplierId;
  String? title;
  String? body;
  int? sort;
  int? status;
  int? cateId;
  String? res;
  String? resLink;
  int? resType;
  int? isProduct;
  String? price;
  int? replyCount;
  int? zanCount;
  int? followCount;
  String? createdAt;
  String? updatedAt;
  var deletedAt;
  String? cateIds;
  String? tag;
  int? isTop;

  ProductList(
      {this.id,
        this.userId,
        this.supplierId,
        this.title,
        this.body,
        this.sort,
        this.status,
        this.cateId,
        this.res,
        this.resLink,
        this.resType,
        this.isProduct,
        this.price,
        this.replyCount,
        this.zanCount,
        this.followCount,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.cateIds,
        this.tag,
        this.isTop});

  ProductList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    supplierId = json['supplier_id'];
    title = json['title'];
    body = json['body'];
    sort = json['sort'];
    status = json['status'];
    cateId = json['cate_id'];
    res = json['res'];
    resLink = json['res_link'];
    resType = json['res_type'];
    isProduct = json['is_product'];
    price = json['price'];
    replyCount = json['reply_count'];
    zanCount = json['zan_count'];
    followCount = json['follow_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    cateIds = json['cate_ids'];
    tag = json['tag'];
    isTop = json['is_top'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['supplier_id'] = this.supplierId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['sort'] = this.sort;
    data['status'] = this.status;
    data['cate_id'] = this.cateId;
    data['res'] = this.res;
    data['res_link'] = this.resLink;
    data['res_type'] = this.resType;
    data['is_product'] = this.isProduct;
    data['price'] = this.price;
    data['reply_count'] = this.replyCount;
    data['zan_count'] = this.zanCount;
    data['follow_count'] = this.followCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['cate_ids'] = this.cateIds;
    data['tag'] = this.tag;
    data['is_top'] = this.isTop;
    return data;
  }
}