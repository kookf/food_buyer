import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/pages/home_modules/comment_modules/comment_model.dart';
import 'package:food_buyer/pages/home_modules/comment_modules/commnet_sublist_model.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:food_buyer/utils/time_ago.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import '../../../utils/event_utils.dart';
import 'comment_page.dart';

class CommentListPage extends StatefulWidget {

  int? postId;


  CommentListPage({required this.postId,Key? key}) : super(key: key);

  @override
  State<CommentListPage> createState() => _CommentListPageState();
}

class _CommentListPageState extends State<CommentListPage> {


  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: false,
    controlFinishLoad: true,
  );
  int page = 1;
  List dataArr = [];

  /// 評論列表
  requestDataWithList()async{
   var params = {
     'post_id':widget.postId,
     'page':page,
     'page_size':20,
   };
   var json = await DioManager().kkRequest(Address.postReplyList,bodyParams: params);
   CommentModel model = CommentModel.fromJson(json);
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

  var eventBusFn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithList();
    eventBusFn = EventBusUtil.listen((event) {
      print('menuRefresh===${event}');
      if (event == 'postCommentListRefresh') {
        requestDataWithList();
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventBusFn!.cancel();
  }

  /// 點贊
  Future requestDataWithLike(int replyId)async{
    var params = {
      'post_id':widget.postId,
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
  Future requestDataWithCancelLike(int replyId)async{
    var params = {
      'post_id':widget.postId,
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



  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: EasyRefresh(
        onRefresh: ()async{
          page = 1;
          requestDataWithList();
        },
        onLoad: ()async{
          page++;
          requestDataWithList();
        },
        controller: easyRefreshController,
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context,index){
            CommentList model = dataArr[index];
            return GestureDetector(
              onTap: (){
                //回复1级评论， reply_user_id=0,
                // 回复二级评论，reply_user_id=4，才会显示 回复：郭大侠：

                Get.bottomSheet(
                    CommentPage(
                      postId:widget.postId!,
                      replyUserId: 0,
                      name: model.nickName,
                      rootId: model.id,));
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    // height: 55,
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: CachedNetworkImage(
                                imageUrl:'${Address.storage}/${model.avatar}',
                                width: 25,height: 25,
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Container(
                              width: Get.width-80,
                              child: Text('${model.nickName}',style: Theme.of(context).textTheme.labelSmall!
                                  .copyWith(color: kDTCloudGray),),
                            )
                          ],
                        ),
                        const SizedBox(height: 0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: const EdgeInsets.only(left: 30,),
                              child:  Text('${model.body}',
                                style: Theme.of(context).textTheme.bodySmall,),
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 1),
                                  alignment: Alignment.center,
                                  // color: Colors.yellow,
                                  child: LikeButton(
                                    size: 20,
                                    isLiked: model.isZan==1?true:false,
                                    onTap: (bool isLiked)async{

                                      // final bool success = await requestDataWithLike();
                                      // requestDataWithDetail();
                                      //   return success? !isLiked:isLiked;
                                      if(model.isZan==0){
                                        final bool success = await requestDataWithLike(model.id!);
                                        requestDataWithList();
                                        return success? !isLiked:isLiked;
                                      }else{
                                        final bool success = await requestDataWithCancelLike(model.id!);
                                        requestDataWithList();
                                        return success? isLiked:!isLiked;
                                      }
                                      // return !isLiked;
                                    },
                                  ),
                                ),
                                Text('${model.zanCount}',style: Theme.of(context).textTheme.
                                labelSmall!.copyWith(
                                    color: kDTCloudGray
                                ),)
                              ],
                            )
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text('${getTimeAgo(model.createdAt!)}',style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: kDTCloudGray,fontSize: 10
                          ),),
                        ),
                      model.replyCount==0?SizedBox():Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(

                            child: ListView.builder(
                              padding: const EdgeInsets.only(left: 30,top: 0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context,a){
                                Replys replyModel = model.replys![a];
                                // CommentSubList replyModel = replyArr[a];
                                return GestureDetector(
                                  onTap: (){
                                    // 回复1级评论， reply_user_id=0,
                                    // 回复二级评论，reply_user_id=4，才会显示 回复：郭大侠：
                                    print('回复二级评论${ replyModel.userId}${replyModel.nickName}');
                                    Get.bottomSheet(
                                        CommentPage(
                                          postId:widget.postId!,
                                          replyUserId: replyModel.userId,
                                          name: replyModel.nickName,
                                          rootId: model.id,));
                                  },
                                  child: Container(
                                    // height: 35,
                                    padding: EdgeInsets.only(bottom: 0),
                                    color: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: '${Address.storage}/${replyModel.avatar}',
                                              width: 25,height: 25,
                                            ),
                                            const SizedBox(width: 5,),
                                            Text('${replyModel.nickName}',
                                              style: Theme.of(context).textTheme.labelSmall!.
                                              copyWith(
                                                  color: kDTCloudGray
                                              ),),
                                          ],
                                        ),
                                        const SizedBox(height: 0,),
                                       replyModel.replyNickName==null?
                                        Padding(
                                          padding: const EdgeInsets.only(left: 30),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                    text: '${replyModel.body}',
                                                    style: Theme.of(context).textTheme.bodySmall,
                                                    children: [
                                                      TextSpan(
                                                        text: ' ${getTimeAgo(replyModel.createdAt!)}',
                                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                            color: kDTCloudGray,fontSize: 9
                                                        ),
                                                      )
                                                    ]
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(left: 1),
                                                    alignment: Alignment.center,
                                                    // color: Colors.yellow,
                                                    child: LikeButton(
                                                      size: 20,
                                                      isLiked: replyModel.isZan==1?true:false,
                                                      onTap: (bool isLiked)async{

                                                        // final bool success = await requestDataWithLike();
                                                        // requestDataWithDetail();
                                                        //   return success? !isLiked:isLiked;
                                                        if(replyModel.isZan==0){
                                                          final bool success = await requestDataWithLike(replyModel.id!);
                                                          requestDataWithList();
                                                          return success? !isLiked:isLiked;
                                                        }else{
                                                          final bool success = await requestDataWithCancelLike(replyModel.id!);
                                                          requestDataWithList();
                                                          return success? isLiked:!isLiked;
                                                        }
                                                        // return !isLiked;
                                                      },
                                                    ),
                                                  ),
                                                  Text('${replyModel.zanCount}',style: Theme.of(context).textTheme.
                                                  labelSmall!.copyWith(
                                                      color: kDTCloudGray
                                                  ),)
                                                ],
                                              )
                                            ],
                                          )
                                        ):
                                        Padding(
                                         padding: const EdgeInsets.only(left: 30),
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             RichText(
                                               text: TextSpan(
                                                   text: '回復 ',
                                                   style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                       color: Colors.black87
                                                   ),
                                                   children: [
                                                     TextSpan(
                                                       text: '${replyModel.replyNickName}:',
                                                       style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                           color: kDTCloudGray
                                                       ),
                                                     ),
                                                     TextSpan(
                                                         text: '${replyModel.body}',
                                                         style: Theme.of(context).textTheme.bodySmall
                                                     ),
                                                     TextSpan(
                                                       text: ' ${getTimeAgo(replyModel.createdAt!)}',
                                                       style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                           color: kDTCloudGray,fontSize: 9
                                                       ),
                                                     ),
                                                   ]
                                               ),
                                             ),
                                             Column(
                                               children: [
                                                 Container(
                                                   padding: EdgeInsets.only(left: 1),
                                                   alignment: Alignment.center,
                                                   // color: Colors.yellow,
                                                   child: LikeButton(
                                                     size: 20,
                                                     isLiked: replyModel.isZan==1?true:false,
                                                     onTap: (bool isLiked)async{

                                                       // final bool success = await requestDataWithLike();
                                                       // requestDataWithDetail();
                                                       //   return success? !isLiked:isLiked;
                                                       if(replyModel.isZan==0){
                                                         final bool success = await requestDataWithLike(replyModel.id!);
                                                         requestDataWithList();
                                                         return success? !isLiked:isLiked;
                                                       }else{
                                                         final bool success = await requestDataWithCancelLike(replyModel.id!);
                                                         requestDataWithList();
                                                         return success? isLiked:!isLiked;
                                                       }
                                                       // return !isLiked;
                                                     },
                                                   ),
                                                 ),
                                                 Text('${replyModel.zanCount}',style: Theme.of(context).textTheme.
                                                 labelSmall!.copyWith(
                                                     color: kDTCloudGray
                                                 ),)
                                               ],
                                             )
                                           ],
                                         )

                                         // Text('回復：${replyModel.replyNickName}:'
                                         //     '${replyModel.body}',
                                         //   style: Theme.of(context).textTheme.bodySmall,),
                                       ),
                                      ],
                                    ),
                                  ),
                                );
                              },itemCount:model.isExpand?model.replys?.length??0:1,),
                          ),
                          model.isExpand?SizedBox():GestureDetector(
                            onTap: (){
                                model.isExpand = true;
                                setState(() {

                                });
                            },
                            child: Container(
                              // height: 50,
                              // color: Colors.red,
                              margin: const EdgeInsets.only(left: 60),
                              child:Text('展開${model.replys?.length}回復',
                                  style: Theme.of(context).textTheme
                                      .labelMedium!.copyWith(color: kDTCloud700)
                              )
                              // TextButton(onPressed: () {
                              //   model.isExpand = true;
                              //   setState(() {
                              //
                              //   });
                              // }, child: Text(
                              //     '展開${model.replys?.length}回復',
                              //     style: Theme.of(context).textTheme
                              //         .labelMedium!.copyWith(color: kDTCloud700)
                              // ),),
                            ),
                          )
                        ],
                      ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(left: 10,right: 10),
                    color: kDTCloudGray,
                    height: 0.1,
                  )
                ],
              ),
            );
          },itemCount: dataArr.length,),
      ),
    );
  }
}
