import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/chat_modules/chat_list_page.dart';
import 'package:get/get.dart';

import '../../services/address.dart';
import '../../services/dio_manager.dart';
import '../chat_modules/addchat_from_phone.dart';

class FilterMessagePage extends StatefulWidget {

  List<AddUserList> arr;

  FilterMessagePage(this.arr,{Key? key}) : super(key: key);

  @override
  State<FilterMessagePage> createState() => _FilterMessagePageState();
}

class _FilterMessagePageState extends State<FilterMessagePage> {


  TextEditingController messageController = TextEditingController();

  /// 创建一个聊天室
  requestDataWithCreateChat(int targetId) async {
    var params = {
      'target_id': targetId,
      'message':messageController.text
    };
    var json =
    await DioManager().kkRequest(Address.chatCreate, bodyParams: params);
    if (json['code'] == 200) {
      BotToast.showText(text: json['message']);
    } else {
      BotToast.showText(text: json['message']);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageController.text = '我對你的產品很感興趣,方便溝通麽';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(I18nContent.message.tr),
        actions: [
          TextButton(onPressed: (){}, child: Text(I18nContent.searchCancel.tr))
        ],
      ),
      body:Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(I18nContent.description,style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: 16
                  ),),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          hintText: '請輸入信息',
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text(I18nContent.supplier,style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: 16
                  ),),
                  Expanded(child: ListView.builder(itemBuilder: (context,index){
                    AddUserList model = widget.arr[index];
                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: ListTile(
                        title: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(30)),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: CachedNetworkImage(
                                imageUrl:
                                '${Address.storage}/'
                                    '${model.avatar}',
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            ),
                            SizedBox(width: 5,),
                            SizedBox(
                                width: Get.width - 200,
                                child: Text('${model.supplierName}',maxLines: 1,)),
                          ],
                        ),
                        trailing: IconButton(onPressed: (){
                          if(widget.arr.length==1){
                            BotToast.showText(text: '至少有一個');
                            return;
                          }
                          print(index);
                          widget.arr.removeAt(index);
                          setState(() {

                          });
                        },icon: Icon(Icons.close),)
                      ),
                    );
                  },itemCount: widget.arr.length,)),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: 100,
            child: Center(
              child: MaterialButton(
                onPressed: () {
                  // Get.to(CreateNotePadPage());
                  // requestDataWithUserList();

                  for(int i = 0;i<widget.arr.length;i++){
                    AddUserList model = widget.arr[i];
                    requestDataWithCreateChat(model.id!);
                  }
                  Get.to(ChatListPage());
                },
                color: kDTCloud700,
                minWidth: Get.width - 80,
                height: 45,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.
                    all(Radius.circular(22))),
                child: Text(
                  I18nContent.boardcast.tr,
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
}
