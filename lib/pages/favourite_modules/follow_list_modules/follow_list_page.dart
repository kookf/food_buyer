import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_buyer/components/not_data_page.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:get/get.dart';
import '../../../common/colors.dart';
import '../../../common/foodbuyer_colors.dart';
import '../../../utils/time_ago.dart';
import '../../home_modules/home_detail_page.dart';
import 'follow_model.dart';

class FollowListPage extends StatefulWidget {
  const FollowListPage({Key? key}) : super(key: key);

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {

  bool isEdit = false;

  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: false,
    controlFinishLoad: true,
  );
  int page = 1;
  List dataArr = [];
  requestDataWithList()async{
    var params = {
      'page':page,
      'page_size':20,
      'search':'123',
    };
    var json = await DioManager().kkRequest(Address.postFollowList,bodyParams: params);
    FollowModel model = FollowModel.fromJson(json);
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
        title: Text(I18nContent.favourite.tr),
        actions: [
          TextButton(
              onPressed: () {
                isEdit = !isEdit;
                setState(() {});
              },
              child: isEdit == false
                  ? Text(I18nContent.searchEdit.tr)
                  : Text(I18nContent.searchCancel.tr))
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
          Expanded(child: Container(
            padding: const EdgeInsets.all(0),
            color: Colors.grey[200],
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
              child: CustomScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverFillRemaining(
                    child: dataArr.isEmpty?
                    NoDataPage():
                    waterFallList(),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
  Widget waterFallList() {
    return MasonryGridView.builder(
      // shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      // crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      itemBuilder: (context, index) {
        FollowList model = dataArr[index];
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
      }, gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2
    ),itemCount: dataArr.length,
    );
  }
}
