import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:food_buyer/common/style.dart';
import 'package:food_buyer/pages/chat_modules/note_pad_model.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/colors.dart';
import '../../components/not_data_page.dart';
import '../../lang/message.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

class NotePadPage extends StatefulWidget {
  const NotePadPage({Key? key}) : super(key: key);

  @override
  State<NotePadPage> createState() => _NotePadPageState();
}

class _NotePadPageState extends State<NotePadPage> {

  EasyRefreshController easyRefreshController =
  EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  /// 獲取列表
  List notePadArr = [];
  int page = 1;
  requestDataWithNotPadList()async{
    var params = {
      'page':page,
    };
    var json = await DioManager().kkRequest(Address.notePadList,
    bodyParams: params);
    NotePadModel notePadModel = NotePadModel.fromJson(json);
    if(page == 1){
      notePadArr.clear();
      notePadArr.addAll(notePadModel.data!.list!);
      easyRefreshController.finishRefresh();
      easyRefreshController.resetFooter();
    }else if(notePadModel.data!.list!.isNotEmpty){
      notePadArr.addAll(notePadModel.data!.list!);
      easyRefreshController.finishLoad(IndicatorResult.success);
    }else{
      easyRefreshController.finishLoad(IndicatorResult.noMore);
    }
    setState(() {

    });
  }

  ///刪除
  requestDataWithDeleteNotePad(var notepad_id)async{
    var params = {
      'notepad_id':notepad_id,
    };
    var json = await DioManager().kkRequest(Address.notePaDelete,bodyParams:
    params);
    if(json['code']==200){
      BotToast.showText(text: '刪除成功');
    }else{
      BotToast.showText(text: json['msg']);
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithNotPadList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: EasyRefresh(
            controller: easyRefreshController,
            header: const ClassicHeader(),
            footer: const ClassicFooter(),
            onRefresh: () async {
              page = 1;
              requestDataWithNotPadList();
            },
            onLoad: ()async{
              page++;
              requestDataWithNotPadList();
            },
            child: notePadArr.isEmpty?NoDataPage():ListView.builder(padding:EdgeInsets.all(0),
              itemBuilder: itemBuilder,itemCount: notePadArr.length,),)),
            Container(
            color: Colors.white,
            height: 55,
            child: Center(
              child: MaterialButton(
                onPressed: () {

                },
                color: AppColor.themeColor,
                minWidth: Get.width - 80,
                height: 45,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.
                    all(Radius.circular(22))),
                child: Text(
                  I18nContent.addNewNotePad,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget itemBuilder(BuildContext context,int index){
    NotePadItem model = notePadArr[index];

    return SwipeActionCell(
      key: ObjectKey(notePadArr[index]),
      trailingActions: <SwipeAction>[
        SwipeAction(
            title: "delete",
            onTap: (CompletionHandler handler) async {
              requestDataWithDeleteNotePad(model.notepad_id);
              await handler(true);
              notePadArr.removeAt(index);
              setState(() {});
            },
            color: Colors.red),
      ],
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 35,right: 15,top: 15),
            // height: 50,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                model.type==1?Text('${model.msg}',style: size18BlackW700,):
                model.type==2? CachedNetworkImage(imageUrl: '${Address.homeHost}'
                    '${Address.storage}/${model.msg}'):
                GestureDetector(
                  onTap: ()async{
                    await launch('${Address.homeHost}/storage/${model.msg}');

                  },
                  child:  Text('附件：${model.file_name}',style: TextStyle(
                      fontSize: 18,color: AppColor.themeColor,
                      fontWeight: FontWeight.w600
                  ),),
                ),

                SizedBox(height: 10,),
                Container(
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${model.type==1?'文本':model.type==2?'圖片':
                      '附件'}',
                        style: TextStyle(fontSize: 12,
                            color: AppColor.smallTextColor),),
                      Text('${model.msgTime}',style: TextStyle(fontSize: 12,
                          color: AppColor.smallTextColor),)

                    ],
                  ),
                ),
                SizedBox(height: 15,),
              ],
            ),
          ),
          Container(
            height: 0.5,
            color: AppColor.lineColor,
          )
        ],
      ),
    );

  }
}
