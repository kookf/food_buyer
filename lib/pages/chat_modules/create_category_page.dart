import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:get/get.dart';

import '../../lang/message.dart';
class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({Key? key}) : super(key: key);

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {



  TextEditingController nameController = TextEditingController();

  requestDataWithCreateCate()async{
    var params = {
      'name':nameController.text,
    };
    var json = await DioManager().kkRequest(Address.cateCreate,bodyParams: params);
    if(json['code'] == 200){
      BotToast.showText(text:'創建成功');
      Get.back(result: 'refresh');
    }else{
      BotToast.showText(text:json['message']);
    }
  }



  @override
  Widget build(BuildContext context) {
    ThemeData baseColor  = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: Text(
                        'Category',
                        style: baseColor.textTheme.titleLarge!.copyWith(
                            color: Colors.black
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 15),
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      height: 55,
                      decoration: BoxDecoration(
                          border:
                          Border.all(width: 0.5, color: kDTCloudGray),
                          borderRadius:
                          BorderRadius.all(Radius.circular(8))),
                      child: TextField(
                        autofocus: true,
                        controller: nameController,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(30) //限制长度
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '請輸入category',
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: EdgeInsets.only(left: 15, top: 15),
                    //   child: Text(
                    //     'Messages',
                    //     style: baseColor.textTheme.titleLarge!.copyWith(
                    //         color: Colors.black
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   // alignment: Alignment.center,
                    //   padding: EdgeInsets.only(left: 15),
                    //   margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                    //   height: 100,
                    //   decoration: BoxDecoration(
                    //       border:
                    //       Border.all(width: 0.5, color: kDTCloudGray),
                    //       borderRadius:
                    //       BorderRadius.all(Radius.circular(8))),
                    //   child: TextField(
                    //     controller: contentController,
                    //     decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //       hintText: 'Messages',
                    //     ),
                    //     maxLines: 5,
                    //   ),
                    // )
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
                    if (nameController.text.isEmpty) {
                      BotToast.showText(text: 'The name cannot be empty');
                      return;
                    }
                    requestDataWithCreateCate();
                  },
                  color: kDTCloud700,
                  minWidth: Get.width - 80,
                  height: 45,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22))),
                  child: Text(
                    'Create Category',
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
    );
  }
}
