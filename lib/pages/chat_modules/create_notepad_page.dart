import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/chat_modules/cate_list_page.dart';
import 'package:food_buyer/pages/chat_modules/create_category_page.dart';
import 'package:get/get.dart';
import '../../common/foodbuyer_colors.dart';
import '../../common/style.dart';
import '../../services/address.dart';
import '../../services/dio_manager.dart';
import '../../utils/event_utils.dart';
import 'models/ChatMessage.dart';

class CreateNotePadPage extends StatefulWidget {
  final ChatMessage? message;

  const CreateNotePadPage({this.message,Key? key}) : super(key: key);

  @override
  State<CreateNotePadPage> createState() => _CreateNotePadPageState();
}

class _CreateNotePadPageState extends State<CreateNotePadPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  int cateId = -1;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contentController.text = widget.message?.text??'';
  }

  /// 創建
  requestDataWithAddNotPad() async {
    var params = {
      'from_user_id': widget.message?.userId,
      'msg_id': widget.message?.msgId,
      'cate_id': cateId,
      // 'title': titleController.text,
    };
    var json =
        await DioManager().kkRequest(Address.notePadAdd, bodyParams: params);
    if (json['code'] == 200) {
      BotToast.showText(text: '添加成功');
      Get.back();
      EventBusUtil.fire('notepadRefresh');

    } else {
      BotToast.showText(text: json['message']);
    }
  }


  @override
  Widget build(BuildContext context) {

    ThemeData baseColor = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppBar(
        title: Text('Create Notepad'),
        actions: [
          // TextButton(onPressed: ()async{
          //   Get.to(CreateCategoryPage());
          // }, child: Text('Creaet')),

          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(I18nContent.searchCancel))
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          'Category',
                          style: baseColor.textTheme.titleLarge!.copyWith(
                            color: Colors.black
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: ()async{
                         var data = await Get.to(CateListPage());
                         if(data!=null){
                           titleController.text = data['cate_name'];
                           cateId = data['cate_id'];
                           setState(() {

                           });
                         }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 15,right: 15),
                          margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                          height: 55,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.5, color: AppColor.lineColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(borderRadius))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 55,
                                width: 200,
                                child: TextField(
                                  enabled: false,
                                  autofocus: true,
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '請選擇一個category',
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,size: 15,)
                            ],
                          ),
                        ),
                      ),


                      Padding(
                        padding: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          'Messages',
                          style: baseColor.textTheme.titleLarge!.copyWith(
                              color: Colors.black
                          ),
                        ),
                      ),
                      Container(
                        // alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 15),
                        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                        height: 100,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 0.5, color: AppColor.lineColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(borderRadius))),
                        child: TextField(
                          controller: contentController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Messages',
                          ),
                          maxLines: 5,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                height: 55,
                child: Center(
                  child: MaterialButton(
                    onPressed: () {
                      if (titleController.text.isEmpty) {
                        BotToast.showText(text: 'The category cannot be empty');
                        return;
                      }
                      if (contentController.text.isEmpty) {
                        BotToast.showText(text: 'The content cannot be empty');
                        return;
                      }
                      requestDataWithAddNotPad();
                    },
                    color: AppColor.themeColor,
                    minWidth: Get.width - 80,
                    height: 45,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(22))),
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
        ),
      ),
    );
  }
}
