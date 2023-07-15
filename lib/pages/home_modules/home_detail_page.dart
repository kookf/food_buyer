import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/components/zhihu_swiper_pagination.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:get/get.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:like_button/like_button.dart';
import '../../common/colors.dart';
import '../../common/foodbuyer_colors.dart';
import '../../components/price_text.dart';
import '../../components/youtube_player_page.dart';
import '../../lang/message.dart';
import '../../utils/event_utils.dart';
import '../chat_modules/components/body.dart';
import 'package:card_swiper/card_swiper.dart';

import 'comment_modules/comment_list_page.dart';
import 'comment_modules/comment_page.dart';

class HomeDetailPage extends StatefulWidget {

  int? id;
  HomeDetailPage({this.id,Key? key}) : super(key: key);

  @override
  State<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends State<HomeDetailPage> {


  HomeDetailModel? _homeDetailModel;

  List? imageStrPath;
  // List? imageArr;
  /// 獲取詳情
 requestDataWithDetail()async{
    var params = {
      'id':widget.id,
    };
    var json = await DioManager().kkRequest(Address.postGet,bodyParams: params);

    HomeDetailModel model = HomeDetailModel.fromJson(json);

    _homeDetailModel = model;

    imageStrPath = _homeDetailModel?.data?.res?.split(',');

    setState(() {

    });
  }
  /// 點贊
  Future requestDataWithLike([int replyId = 0])async{
   var params = {
     'post_id':widget.id,
     'reply_id':replyId,
   };
   var json = await DioManager().kkRequest(Address.postLike,bodyParams: params);

   bool like;
   if(json['code'] == 200){
     like = true;
   }else{
     like = false;
   }
   return like;
  }
  /// 取消點贊
  Future requestDataWithCancelLike([int replyId = 0])async{
    var params = {
      'post_id':widget.id,
      'reply_id':replyId,
    };
    var json = await DioManager().kkRequest(Address.postDeleteLike,bodyParams: params);

    bool like;
    if(json['code'] == 200){
      BotToast.showText(text: '取消了點贊');
      like = true;
    }else{
      like = false;
    }
    return like;
  }


  /// 收藏
  requestDataWithCollection()async{
    var params = {
      'post_id':widget.id,
    };
   var json = await DioManager().kkRequest(Address.postFollow,bodyParams: params);
   if(json['code']==200){
     BotToast.showText(text: '收藏成功');
   }else{

   }
   requestDataWithDetail();
  }

  /// 取消收藏
  requestDataWithCancelCollection()async{
    var params = {
      'post_id':widget.id,
    };
    var json = await DioManager().kkRequest(Address.postFollowDelete,bodyParams: params);
    if(json['code']==200){
      BotToast.showText(text: '取消收藏');
    }else{

    }
    requestDataWithDetail();
  }

  /// 创建一个聊天室
  void requestDataWithCreateChat(int targetId) async {
    var params = {'target_id': targetId};
    var json =
    await DioManager().kkRequest(Address.chatCreate, bodyParams: params);
    if (json['code'] == 200) {
      BotToast.showText(text: json['message']);
      // Get.back(result: 'refresh');
      Get.to(ChatPage(json['data']['room_key'],
        roomName: json['data']['target_name'], member: 2,));
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
    if(json['code'] == 200){
      BotToast.showText(text: json['message']);
    }else{
      BotToast.showText(text: json['message']['message']);
    }
  }

  var eventBusFn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithDetail();
    eventBusFn = EventBusUtil.listen((event) {
      print('menuRefresh===${event}');
      if (event == 'postCommentListRefresh') {
        requestDataWithDetail();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    eventBusFn!.cancel();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                        expandedHeight: 100,
                        // floating: true,
                        // snap: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          titlePadding: const EdgeInsets.only(left: 35,top: 0,bottom: 15),
                          title:Container(
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            height: 25,
                            width: Get.width,
                            color: Colors.transparent,
                            child:   Row(
                              children: [
                                CircleAvatar(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                    imageUrl: '${Address.storage}'
                                        '/${_homeDetailModel?.data?.avatar}',
                                  ),
                                ),
                                const SizedBox(
                                  width: 0,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_homeDetailModel?.data?.nickName}',
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                        // Text(
                                        //   'Hong Kong',
                                        //   style: TextStyle(
                                        //       fontSize: 15,
                                        //       fontWeight: FontWeight.w500,
                                        //       color: AppColor.smallTextColor),
                                        // ),
                                      ],
                                    ),
                                    Center(
                                      child: GestureDetector(
                                        onTap: (){
                                          requestDataWithCreateChat(_homeDetailModel!.data!.user_id!);
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.only(left: 10),
                                            height: 15,
                                            width: 15,
                                            child: Image.asset('images/ic_chat.png',)),
                                      ),
                                    ),
                                    // IconButton(onPressed: (){
                                    //   requestDataWithCreateChat(_homeDetailModel!.data!.user_id!);
                                    //   // Get.to(ChatPage(roomKey, model1))
                                    // }, icon: Image.asset('images/ic_chat.png',),iconSize: 15,)
                                  ],
                                )
                              ],
                            ),
                          ),
                          //标题是否居中
                          centerTitle: false,
                          //标题间距
                          //titlePadding: EdgeInsetsDirectional.only(start: 0, bottom: 16),
                          collapseMode: CollapseMode.none,
                        )),

                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          _homeDetailModel?.data?.resType==0?const SizedBox():
                          _homeDetailModel?.data?.resType==4?
                          Container(
                            color: Colors.red,
                            height: 250,
                            child: YouTubePlayerPage(
                              ids: '${_homeDetailModel?.data?.res_link!.split('/').last}',),
                          )
                              :SizedBox(
                            height:380,
                            child:imageStrPath!.length==1?SizedBox(
                              width: Get.width,
                              child:  GestureDetector(
                                onTap: (){
                                  List<String> imagePath = _homeDetailModel!.data!.res!.split(',').map((e) => '${Address.storage}/$e').toList();
                                  print(imagePath);
                                  ImagePickers.previewImages(imagePath, 0);
                                },
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                                  imageUrl: '${Address.storage}/${imageStrPath![0]}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ): Swiper(
                              autoplay: false,
                              // pagination: const SwiperPagination(alignment: Alignment.bottomCenter),
                              itemCount: _homeDetailModel?.data?.res?.split(',').length??10,
                              itemBuilder: (context,index){
                                return GestureDetector(
                                  onTap: (){
                                    List<String> imagePath = _homeDetailModel!.data!.res!.split(',').map((e) => '${Address.storage}/$e').toList();
                                    print(imagePath);
                                    ImagePickers.previewImages(imagePath, index);
                                  },
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                    imageUrl: '${Address.storage}/${_homeDetailModel?.data?.res?.split(',')[index]}',
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                              pagination: ZhiHuSwiperPagination(),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    requestDataWithFollow(_homeDetailModel?.data?.supplier_id);
                                    // Get.to(const MinePage());
                                  },
                                  color: kDTCloud700,
                                  minWidth: 150,
                                  height: 45,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(25))),
                                  child: const Text(
                                    I18nContent.following,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('images/ic_shard.png',width: 15,height: 15,))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 20, right: 25),
                            alignment: Alignment.centerLeft,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Text(
                                  '${_homeDetailModel?.data?.title}',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 25),
                            child: Text('${_homeDetailModel?.data?.body}',
                              style:Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 20),
                          //   child: PriceText(
                          //     price: _homeDetailModel?.data?.price,
                          //     style: Theme.of(context).textTheme.bodySmall,
                          //   ),
                          // ),
                          const SizedBox(height: 15,),
                          _homeDetailModel?.data?.tag==''?const SizedBox():
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 15),
                            child: ragWidget(),
                          ),


                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 25),
                            child: Text('創建於${_homeDetailModel?.data?.createdAt}',
                              style:Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: kDTCloudGray
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.only(left: 5,right: 5,top: 15),
                        height: 0.5,
                        color: kDTCloudGray,
                      ),
                    ),

                    // SliverToBoxAdapter(
                    //   child:Container(
                    //     margin: const EdgeInsets.only(left: 15,top: 15),
                    //    child: Text('共${_homeDetailModel?.data?.replyCount}評論'),
                    //   ),
                    // ),
                    //
                    //
                    // SliverToBoxAdapter(
                    //   child: CommentListPage(postId: widget.id,),
                    // )
                  ],
                )),

            Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            width: 0.2,
                            color: kDTCloudGray
                        )
                    )
                ),
                padding: const EdgeInsets.all(10),
                height: 70,
              child: MaterialButton(
                onPressed: () {
                  requestDataWithCreateChat(_homeDetailModel!.data!.user_id!);
                },color: kDTCloud700,
                minWidth: Get.width -50,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))
                ),
                child: Text(I18nContent.beginChat.tr,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white
                ),),
              ),
            )
            // Container(
            //   decoration: const BoxDecoration(
            //       border: Border(
            //           top: BorderSide(
            //               width: 0.2,
            //               color: kDTCloudGray
            //           )
            //       )
            //   ),
            //   padding: const EdgeInsets.only(left: 15,right: 15),
            //   height: 55,
            //   child: Row(
            //     children: [
            //       SizedBox(
            //         width: Get.width/2-50,
            //         child: OutlinedButton(
            //           onPressed: () {
            //             // Get.to(ChatPage());
            //             Get.bottomSheet(CommentPage(
            //               postId: _homeDetailModel!.data!.id!,rootId: 0,),);
            //           },
            //           style: OutlinedButton.styleFrom(
            //             backgroundColor: Colors.grey.shade200,
            //             side: const BorderSide(width: 0.0,color: Colors.transparent)
            //           ),
            //           // minWidth: Get.width /2 ,
            //           // height: 45,
            //           // shape: const RoundedRectangleBorder(
            //           //     borderRadius: BorderRadius.all(Radius.circular(22))),
            //           child:Row(
            //             children: [
            //               Image.asset('images/ic_left_comment.png',width: 15,
            //               height: 15,),
            //               const SizedBox(width: 5,),
            //               Text(
            //                   I18nContent.saySomething.tr,
            //                   style: Theme.of(context).textTheme.labelSmall
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //       Expanded(child:
            //       SizedBox(
            //         height: 50,
            //         width: 50,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceAround,
            //           children: [
            //             Row(
            //               children: [
            //                 // Image.asset('images/ic_like.png',width: 20,height: 20,
            //                 //   color: Colors.black87,),
            //                 LikeButton(
            //                   size: 25,
            //                   isLiked: _homeDetailModel?.data?.isZan==1?true:false,
            //                   onTap: (bool isLiked)async{
            //
            //                   // final bool success = await requestDataWithLike();
            //                   // requestDataWithDetail();
            //                   //   return success? !isLiked:isLiked;
            //                     if(_homeDetailModel?.data?.isZan==0){
            //                       final bool success = await requestDataWithLike();
            //                       requestDataWithDetail();
            //                       return success? !isLiked:isLiked;
            //                     }else{
            //                       final bool success = await requestDataWithCancelLike();
            //                       requestDataWithDetail();
            //                       return success? isLiked:!isLiked;
            //                     }
            //                     // return !isLiked;
            //                   },
            //                 ),
            //                 // LikeAnimation(),
            //                 const SizedBox(width: 5,),
            //
            //                 Text('${_homeDetailModel?.data?.zanCount??0}',
            //                   style: Theme.of(context).
            //                 textTheme.bodyLarge!.copyWith(
            //                     color: Colors.black87
            //                 ),)
            //               ],
            //             ),
            //             GestureDetector(
            //               onTap: (){
            //                 if(_homeDetailModel?.data?.isFollow == 0){
            //                   requestDataWithCollection();
            //                 }else{
            //                   requestDataWithCancelCollection();
            //                 }
            //               },
            //               child: SizedBox(
            //                 width: 50,
            //                 height: 50,
            //                 child: Row(
            //                   children: [
            //                     Image.asset(
            //                       _homeDetailModel?.data?.isFollow==1?
            //                       'images/ic_collection_sel.png':
            //                       'images/ic_colloection.png',width: 25,height: 25,
            //                       color: _homeDetailModel?.data?.isFollow==1?Colors.red:
            //                       Colors.black87,),
            //                     const SizedBox(width: 5,),
            //                     Text('${_homeDetailModel?.data?.followCount??0}',style: Theme.of(context).
            //                     textTheme.bodyLarge!.copyWith(
            //                         color: Colors.black87
            //                     ),)
            //                   ],
            //                 ),
            //               ),
            //             ),
            //             SizedBox(
            //               width: 50,
            //               height: 50,
            //               child: Row(
            //                 children: [
            //                   Image.asset('images/ic_comment.png',width: 22,height: 22,
            //                     color:
            //                     Colors.black87,),
            //                   const SizedBox(width: 2,),
            //                   Text('${_homeDetailModel?.data?.replyCount??0}',
            //                     style: Theme.of(context).
            //                   textTheme.bodyLarge!.copyWith(
            //                       color: Colors.black87,fontWeight: FontWeight.w500
            //                   ),)
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ))
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget ragWidget(){
   return Container(
     padding: const EdgeInsets.only(bottom: 15),
     child: Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
          Padding(
           padding: const EdgeInsets.only(top: 5),
           child: Text('${I18nContent.tagLabel.tr}: '),
         ),
         const SizedBox(width: 5,),

         Expanded(
           child: GridView.builder(
             padding: const EdgeInsets.all(0),
               shrinkWrap: true,
               physics:const NeverScrollableScrollPhysics(),
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 5,
                 crossAxisSpacing: 5,
                 childAspectRatio: 2/1
           ), itemBuilder: (context,index){
               List<String>? s = _homeDetailModel?.data?.tag?.split(',');
             return Container(
               alignment: Alignment.center,
               padding: const EdgeInsets.all(5),
               decoration: const BoxDecoration(
                 color:kDTCloud200,
                 borderRadius: BorderRadius.all(Radius.circular(kRadialReactionRadius))
               ),
               child: Text(s![index],style: Theme.of(context).textTheme.labelSmall!.copyWith(
                 color: Colors.white
               ),),
             );
           },itemCount: _homeDetailModel?.data?.tag?.split(',').length??0,),
         )
       ],
     ),
   );
  }
}

class HomeDetailModel {
  int? code;
  String? message;
  Data? data;

  HomeDetailModel({this.code, this.message, this.data});

  HomeDetailModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? cateName;
  String? nickName;
  String? avatar;
  String? title;
  String? body;
  String? res;
  String? res_link;
  int? resType;
  var supplier_id;
  int? isProduct;
  var price;
  var user_id;
  int? replyCount;
  int? zanCount;
  int? followCount;
  String? createdAt;
  String? updatedAt;
  int? isZan;
  int? isFollow;
  String? tag;

  Data(
      {this.id,
        this.cateName,
        this.nickName,
        this.avatar,
        this.supplier_id,
        this.title,
        this.body,
        this.res,
        this.resType,
        this.isProduct,
        this.price,
        this.replyCount,
        this.zanCount,
        this.followCount,
        this.res_link,
        this.createdAt,
        this.updatedAt,
        this.isZan,
        this.user_id,
        this.tag,
        this.isFollow});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cateName = json['cate_name'];
    nickName = json['nick_name'];
    avatar = json['avatar'];
    title = json['title'];
    body = json['body'];
    res = json['res'];
    supplier_id = json['supplier_id'];
    resType = json['res_type'];
    isProduct = json['is_product'];
    price = json['price'];
    replyCount = json['reply_count'];
    zanCount = json['zan_count'];
    followCount = json['follow_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isZan = json['is_zan'];
    res_link = json['res_link'];
    isFollow = json['is_follow'];
    tag = json['tag'];
    user_id = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cate_name'] = this.cateName;
    data['nick_name'] = this.nickName;
    data['avatar'] = this.avatar;
    data['title'] = this.title;
    data['body'] = this.body;
    data['res'] = this.res;
    data['res_type'] = this.resType;
    data['is_product'] = this.isProduct;
    data['price'] = this.price;
    data['reply_count'] = this.replyCount;
    data['zan_count'] = this.zanCount;
    data['follow_count'] = this.followCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_zan'] = this.isZan;
    data['is_follow'] = this.isFollow;
    return data;
  }
}
