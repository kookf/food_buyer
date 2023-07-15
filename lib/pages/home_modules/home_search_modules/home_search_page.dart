import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_buyer/components/not_data_page.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/home_modules/home_search_modules/home_search_model.dart';
import 'package:food_buyer/pages/home_modules/home_search_modules/search_history_model.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:get/get.dart';

import '../../../common/foodbuyer_colors.dart';
import '../../../utils/time_ago.dart';
import '../home_detail_page.dart';
class HomeSearchPage extends StatefulWidget {
  const HomeSearchPage({Key? key}) : super(key: key);

  @override
  State<HomeSearchPage> createState() => _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearchPage> {

  final TextEditingController _editingController = TextEditingController();

  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: false,
    controlFinishLoad: true,
  );
  int page = 1;
  List dataArr = [];

  /// 搜索
  requestDataWithSearch()async{
    var params = {
      'page':page,
      'keyword':_editingController.text,
      'tag':''
    };
    var json = await DioManager().kkRequest(Address.postSearch,bodyParams: params);
    HomeSearchModel model = HomeSearchModel.fromJson(json);
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

  /// 搜索歷史
  List<String> tagList = [];
  requestDataWithSearchHistory()async{

    var json = await DioManager().kkRequest(Address.searchHistory,);

    SearchHistoryModel model = SearchHistoryModel.fromJson(json);
    print(model.data!.list!.map((e) => e.keyword).toList());

    for(int i = 0;i<model.data!.list!.length;i++){
      tagList.add('${model.data!.list![i].keyword}');
    }

    // List<String> s  = model.data!.list!.map((e) => e.keyword!).toList();
    // tagList = s;
    setState(() {

    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithSearchHistory();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18nContent.searchChat),
      ),
      body: Column(
        children: [
          Container(
            // height: 60,
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _editingController,
                  onChanged: (value){
                    // _editingController.text = value;
                    // requestDataWithSearch();
                  },
                  onSubmitted: (value){
                    requestDataWithSearch();
                  },
                  decoration: InputDecoration(
                      hintText: '請輸入搜索內容'
                  ),
                ),
                SizedBox(height: 5,),
                Text('搜索歷史'),
                SizedBox(height: 5,),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: tagWidget(),
                )
              ],
            ),
          ),
          Expanded(child: Container(
            padding: const EdgeInsets.all(0),
            color: Colors.grey[200],
            child: EasyRefresh(
              controller: easyRefreshController,
              onRefresh: () async {
                page = 1;
                requestDataWithSearch();
              },
              onLoad: ()async{
                page++;
                requestDataWithSearch();
              },
              child: CustomScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverFillRemaining(
                    child:dataArr.isEmpty?
                    NoDataPage():
                    waterFallList(),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  List<Widget> tagWidget(){

    List<Widget> page = [];
    for(int i = 0;i<tagList.length;i++){
      page.add(GestureDetector(
        onTap: (){
          _editingController.text = tagList[i];
          requestDataWithSearch();
        },
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: kDTCloud100
          ),
          padding: const EdgeInsets.all(10),
          child: Text('${tagList[i]}'),
        ),
      ));
    }
    return page;
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
        HomeSearchList model = dataArr[index];
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
