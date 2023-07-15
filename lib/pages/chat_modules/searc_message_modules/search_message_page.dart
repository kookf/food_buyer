import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/components/not_data_page.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/chat_modules/components/body.dart';
import 'package:food_buyer/pages/chat_modules/models/message_model.dart';
import 'package:food_buyer/pages/chat_modules/searc_message_modules/search_message_model.dart';
import 'package:get/get.dart';

import '../../../components/text_highlight.dart';
import '../../../services/address.dart';
import '../../../services/dio_manager.dart';

class SearchMessagePage extends StatefulWidget {


  String keyWord;
   SearchMessagePage(this.keyWord,{Key? key}) : super(key: key);

  @override
  State<SearchMessagePage> createState() => _SearchMessagePageState();
}

class _SearchMessagePageState extends State<SearchMessagePage> {



  TextEditingController searchController = TextEditingController();

  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  /// 搜索
  List dataArr = [];
  int page = 1;

  requestDataWithSearch()async{
    var params = {
      'page': page,
      'keyword': widget.keyWord,
    };
    var json =
    await DioManager().kkRequest(Address.searchChatMeg, bodyParams: params);
    SearchMessageModel model = SearchMessageModel.fromJson(json);
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.text = widget.keyWord;
    requestDataWithSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Container(
            // width: 200,
            height: 55,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: I18nContent.searchChat.tr,
                border: InputBorder.none,
                  suffixIcon: IconButton(onPressed: () {
                    searchController.text = '';
                }, icon: Icon(Icons.close),)
              ),
            ),
          ),
        ),
      ),
      body: EasyRefresh(
        onRefresh: ()async{
          page = 1;
          requestDataWithSearch();
        },
        onLoad: ()async{

        },
        child:dataArr.isEmpty?NoDataPage():
        ListView.builder(itemBuilder: (context,index){
          SearchMessageList model = dataArr[index];
          return GestureDetector(
            onTap: (){
              Get.to(ChatPage(model.roomKey!,
                  roomName: model.nickName!, member: 2));
            },
            child: Container(
              padding: EdgeInsets.only(left: 15,right: 15,top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${model.nickName}'),
                        SizedBox(height: 10,),
                        TextHighlight(
                          '${model.msg}',
                          '${widget.keyWord}',
                          TextStyle(fontSize: 12,color: kDTCloudGray),
                          TextStyle(fontSize: 12,color: kDTCloud500),
                        ),
                        SizedBox(height: 10,),
                        Text('${model.createdAt}'),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    height: 0.2,
                    color: kDTCloudGray,
                  )
                ],
              ),
            ),
          );
        },itemCount: dataArr.length,),
      ),
    );
  }
}
