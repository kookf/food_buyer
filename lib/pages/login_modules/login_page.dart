import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/login_modules/register_modules/select_register_type_page.dart';
import 'package:food_buyer/pages/login_modules/select_language_page.dart';
import 'package:food_buyer/pages/login_modules/verification_code_page.dart';
import 'package:food_buyer/utils/hexcolor.dart';
import 'package:get/get.dart';

import 'create_new_account_page.dart';
import 'login_in_page.dart';

class LoginPage extends GetView{
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            height: 35,
            width: Get.width,
            color: Colors.red,
            alignment: Alignment.centerRight,
            child: IconButton(onPressed: () {
              Get.to(SelectLanguagePage());
            }, icon: Image.asset('images/ic_language.png'),),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: Get.width,
            // color: AppColor.themeColor,
            height: Get.height/2-50,
            child: Image.asset('images/ic_login_image.png'),
          ),
          SizedBox(height: 15,),
          RichText(text: TextSpan(
            children: [
              TextSpan(text: 'Welcome to ',style:
              TextStyle(fontWeight: FontWeight.w700,fontSize: 25,color: Colors.black)),
              TextSpan(text: 'FoodBuyer ',
                  style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25,color: AppColor.themeColor)),
            ]
          )),
          Container(
            margin: EdgeInsets.only(left: 35,right: 35,top: 25),
            child: Text('''Connect your business with potential Food & Beverage buyer orsuppliers for more lucrativebusiness opportunities
          ''',style: TextStyle(fontSize: 18,color: Colors.grey,fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,),
          ),
          SizedBox(height: 55,),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15),
            child:  MaterialButton(onPressed: (){

              Get.to(LoginInPage());

            },child: Text(I18nContent.loginLabel.tr,style: TextStyle(color: Colors.white,fontSize: 18),)
              ,color: AppColor.themeColor,minWidth: Get.width,height: 55,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15),
            child:     MaterialButton(onPressed: (){
              // Get.to(CreateNewAccountPage());

              // Get.to(VerificationCodePage());
              Get.to(SelectRegisterTypePage());

            },child: Text(I18nContent.createNewAccLabel.tr,style: TextStyle(color: AppColor.themeColor,fontSize: 18),)
              ,color: HexColor('#EDF2F9'),minWidth: Get.width,height: 55,
              shape:  RoundedRectangleBorder(
                //边框颜色
                side: BorderSide(
                  color: AppColor.themeColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),),
          )

        ],
      ),
    );
  }

}