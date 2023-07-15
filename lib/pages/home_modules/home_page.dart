import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/home_modules/home_detail_page.dart';
import 'package:food_buyer/pages/home_modules/home_model.dart';
import 'package:food_buyer/pages/home_modules/home_search_modules/home_search_page.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:food_buyer/utils/time_ago.dart';
import 'package:get/get.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:easy_refresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {

  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: false,
    controlFinishLoad: true,
  );

  int page = 1;
  List dataArr = [];
  String order = 'all';
  requestDataWithList()async{
    var params = {
      'page':page,
      'page_size':20,
      'is_product':'',
      'supplier_id':'',
      'order':order, //对应 all,latest,most
    };
    var json = await DioManager().kkRequest(Address.homeList,bodyParams: params);
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
    setState(() {});
  }

  final List<String> _tabs = <String>[
    I18nContent.all.tr,
    I18nContent.latest.tr,
    I18nContent.mostView.tr,
  ];
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithList();
    tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              color: Colors.white,
              width: Get.width,
              padding: const EdgeInsets.only(left: 15, right: 15),
              height: 80,
              child: Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      I18nContent.appTitleLabel,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.to(const HomeSearchPage());
                      // Get.to(const PostCreatePage());
                    },
                    child: Center(
                      child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: const BorderRadius.all(Radius.circular(5))),
                          child: const Icon(Icons.search)),
                    ),
                  ),
                ],
              )),
          buildTabBar(),
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
                    child: waterFallList(),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget buildTabBar() {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child: TabBar(
        onTap: (index){
          if(index == 0){
            page = 1;
            order = 'all';
            requestDataWithList();
          }else if(index == 1){
            page = 1;
            order = 'latest';
            requestDataWithList();
          }else if(index == 2){
            page = 1;
            order = 'most';
            requestDataWithList();
          }
        },
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: const BubbleTabIndicator(
            indicatorHeight: 45.0,
            indicatorColor: Colors.black,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
            // Other flags
            indicatorRadius: 8,
            insets: EdgeInsets.all(1),
            padding: EdgeInsets.all(155)),
        isScrollable: true,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        unselectedLabelColor: Colors.black,
        labelColor: Colors.white,
        tabs: _tabs.map((String name) => Tab(text: name)).toList(),
        controller: tabController,
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
}
