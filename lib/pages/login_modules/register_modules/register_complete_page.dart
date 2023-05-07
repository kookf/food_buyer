import 'package:flutter/material.dart';
import 'package:food_buyer/common/style.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../lang/message.dart';
class RegisterCompletePage extends StatefulWidget {
  const RegisterCompletePage({Key? key}) : super(key: key);

  @override
  State<RegisterCompletePage> createState() => _RegisterCompletePageState();
}

class _RegisterCompletePageState extends State<RegisterCompletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
         Center(
           child:  Text(I18nContent.registrationCompleted.tr,
             style: size21BlackW700,),
         ),
         SizedBox(height: 15,),
         Container(
           margin: EdgeInsets.only(left: 35,right: 35),
           child:  Center(
             child: Text('Lorem ipsum dolor sit amet consectetur. '
                 'Lacus nunc fusce sed aenean nisl est vitae. '
                 'Ipsum porttitor elit imperdiet felis iaculis.',
               style: size17SmailW700,textAlign: TextAlign.center,),
           ),
         ),
          Container(
            margin: EdgeInsets.only(left: 35,right: 35),
            child: Image.asset('images/ic_register_complete_bg.png',),
          ),
          SizedBox(height: 15,),
          Container(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: MaterialButton(
              onPressed: () {
                Get.back();
                // Get.to(RegisterCompletePage());
              },
              color: AppColor.themeColor,
              minWidth: Get.width,
              height: 55,
              shape: RoundedRectangleBorder(
                //边框颜色
                side: BorderSide(
                  color: AppColor.themeColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Text(
                I18nContent.confirm.tr,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
