import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:get/get.dart';
import '../../../lang/message.dart';

class PostCreateCatePage extends StatefulWidget {
  const PostCreateCatePage({Key? key}) : super(key: key);

  @override
  State<PostCreateCatePage> createState() => _PostCreateCatePageState();
}

class _PostCreateCatePageState extends State<PostCreateCatePage> {


  bool isProduct = false;

  TextEditingController nameTextEditingController = TextEditingController();

  requestDataWithCreate()async{

    var params = {
      'name':nameTextEditingController.text,
      'is_product':isProduct==false?0:1,
      'pid':0,
      'sort':99,
    };

    var json = await DioManager().kkRequest(Address.postCateCreate,
    bodyParams: params);
    if(json['code'] == 200){
      BotToast.showText(text: '創建成功');
      Get.back(result: 'refresh');
    }else{
      BotToast.showText(text: json['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Category'),
      ),
      body:SafeArea(
        child: Column(
          children: [
            Expanded(child:  ListView(
              padding: EdgeInsets.only(left: 15,right: 15,top: 15),
              children: [
                TextField(
                  controller: nameTextEditingController,
                  decoration: InputDecoration(
                      labelText: '請輸入類別名稱'
                  ),
                ),

                ListTile(
                  title: Text('是否是商品'),
                  trailing:Switch(
                    // This bool value toggles the switch.
                    value: isProduct,
                    activeColor: kDTCloud700,
                    onChanged: (bool value) {
                      // This is called when the user toggles the switch.
                      setState(() {
                        if (value == false) {
                          var locale = Locale('en', 'US');
                          Get.updateLocale(locale);
                        } else {
                          var locale = Locale('zh', );
                          Get.updateLocale(locale);
                        }
                        isProduct = value;
                      });
                    },
                  ),
                ),
              ],
            ),),
            Container(
              height: 55,
              child: Center(
                child: MaterialButton(
                  onPressed: () {
                    if(nameTextEditingController.text.isEmpty){
                      BotToast.showText(text: '請輸入類別名稱');
                      return;
                    }
                    requestDataWithCreate();
                  },
                  child: Text(
                    I18nContent.sendRequest,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: kDTCloud900,
                  minWidth: Get.width - 80,
                  height: 45,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22))),
                ),
              ),
            ),

          ],
        ),
      )
    );
  }
}
