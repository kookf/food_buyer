import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/pages/chat_modules/note_pad_model.dart';
import 'package:food_buyer/pages/chat_modules/notepad_detail_page.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/not_data_page.dart';
import '../../lang/message.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

import '../../utils/event_utils.dart';
import 'create_category_page.dart';
import 'create_notepad_page.dart';

class NotePadPage extends StatefulWidget {
  const NotePadPage({Key? key}) : super(key: key);

  @override
  State<NotePadPage> createState() => _NotePadPageState();
}

class _NotePadPageState extends State<NotePadPage>
    with AutomaticKeepAliveClientMixin {
  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  /// 獲取列表
  List notePadArr = [];
  int page = 1;
  requestDataWithNotPadList() async {
    var params = {
      'page': page,
      'page_size': 20,
    };
    var json =
        await DioManager().kkRequest(Address.notePadCates, bodyParams: params);
    NotePadModel notePadModel = NotePadModel.fromJson(json);
    if (page == 1) {
      notePadArr.clear();
      notePadArr.addAll(notePadModel.data!.list!);
      easyRefreshController.finishRefresh(IndicatorResult.success);
      easyRefreshController.resetFooter();
    } else if (notePadModel.data!.list!.isNotEmpty) {
      notePadArr.addAll(notePadModel.data!.list!);
      easyRefreshController.finishLoad(IndicatorResult.success);
    } else {
      easyRefreshController.finishLoad(IndicatorResult.noMore);
    }
    setState(() {});
  }

  ///刪除
  requestDataWithDeleteNotePad(var notepad_id) async {
    var params = {
      'notepad_id': notepad_id,
    };
    var json =
        await DioManager().kkRequest(Address.notePaDelete, bodyParams: params);
    if (json['code'] == 200) {
      BotToast.showText(text: 'successfully delete');
    } else {
      BotToast.showText(text: json['msg']);
    }
    requestDataWithNotPadList();
  }
  StreamSubscription? eventBusFn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithNotPadList();
    eventBusFn = EventBusUtil.listen((event) {
      print('notepadRefresh===${event}');
      if (event == 'notepadRefresh') {
        requestDataWithNotPadList();
      }
    });

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: EasyRefresh(
            controller: easyRefreshController,
            header: const ClassicHeader(),
            footer: const ClassicFooter(),
            onRefresh: () async {
              page = 1;
              requestDataWithNotPadList();
            },
            onLoad: () async {
              page++;
              requestDataWithNotPadList();
            },
            child: notePadArr.isEmpty
                ?  NoDataPage()
                : ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemBuilder: itemBuilder,
                    itemCount: notePadArr.length,
                  ),
          )),
          Container(
            color: Colors.white,
            height: 55,
            child: Center(
              child: MaterialButton(
                onPressed: () {
                  // Get.to(CreateNotePadPage());
                  Get.to(const CreateCategoryPage());
                },
                color: kDTCloud700,
                minWidth: Get.width - 80,
                height: 45,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.
                    all(Radius.circular(22))),
                child: Text(
                  I18nContent.createCategory.tr,
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

  Widget itemBuilder(BuildContext context, int index) {
    ThemeData baseColor = Theme.of(context);
    NotePodListItem model = notePadArr[index];
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            Get.to(NotePadDetailPage(cateName: model.cateName!,cateId: model.cateId!,));
          },
          child: Container(
            padding: EdgeInsets.only(left: 15,right: 15),
            alignment: Alignment.centerLeft,
            width: Get.width,
            height: 55,
            color: kDTCloud50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Get.width - 100,
                  child: Text(model.cateName!,style: baseColor.textTheme.titleLarge!.
                  copyWith(
                    color: Colors.black,overflow: TextOverflow.ellipsis
                  ),maxLines: 1,),
                ),
                Icon(Icons.arrow_forward_ios,size: 15,)
              ],
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context,a){
            return SwipeActionCell(
              key: ObjectKey(model.notepads?[a]),
              trailingActions: <SwipeAction>[
                SwipeAction(
                    title: "delete",
                    onTap: (CompletionHandler handler) async {
                      requestDataWithDeleteNotePad(model.notepads?[a].notepadId);
                      await handler(true);
                      model.notepads?.removeAt(a);
                      setState(() {});
                    },
                    color: Colors.red),
              ],
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                    // height: 50,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        model.notepads?[a].type == 1
                            ? Text(
                          '${model.notepads?[a].msg}',
                          style: baseColor.textTheme.titleLarge,
                        )
                            : model.notepads?[a].type == 2
                            ? CachedNetworkImage(
                            imageUrl: '${Address.storage}/${model.notepads?[a].msg}')
                            : GestureDetector(
                          onTap: () async {
                            await launch(
                                '${Address.homeHost}/storage/${model.notepads?[a].msg}');
                          },
                          child: Text(
                            '附件：${model.notepads?[a].fileName}',
                            style: baseColor.textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              model.notepads?[a].type == 1
                                  ? '文本'
                                  : model.notepads?[a].type == 2
                                  ? '圖片'
                                  : '附件',
                              style: baseColor.textTheme.bodySmall!
                                  .copyWith(color: kDTCloudGray),
                            ),
                            Text(
                              '${model.notepads?[a].msgTime}',
                              style: baseColor.textTheme.bodySmall!
                                  .copyWith(color: kDTCloudGray),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 0.5,
                    color: kDTCloudGray,
                  )
                ],
              ),
            );
          },itemCount: 0,
        // model.notepads?.length??0,
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
