import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/login_modules/login_model.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:food_buyer/utils/hexcolor.dart';
import 'package:food_buyer/utils/persisten_storage.dart';
import 'package:get/get.dart';

import '../bottom_nav_moudules/bottom_tab_controller.dart';
import '../home_modules/home_page.dart';

class LoginInPage extends StatefulWidget {
  const LoginInPage({Key? key}) : super(key: key);

  @override
  State<LoginInPage> createState() => _LoginInPageState();
}

class _LoginInPageState extends State<LoginInPage> {

  TextEditingController emailAddressTextEditingController = TextEditingController();
  TextEditingController passWordTextEditingController = TextEditingController();

  requestDataWithLogin()async{
    var params = {
      'phone':emailAddressTextEditingController.text,
      'password':passWordTextEditingController.text
    };
    var json = await DioManager().kkRequest(Address.userLogin,bodyParams: params);
    LoginModel loginModel = LoginModel.fromJson(json);
    if(loginModel.code == 200){
      await PersistentStorage().setStorage('token', loginModel.data?.token);
      await PersistentStorage().setStorage('socket_key', loginModel.data?.socketKey);
      await PersistentStorage().setStorage('id', loginModel.data?.id);
      await PersistentStorage().setStorage('phone', loginModel.data?.phone);

      Get.offAll(TabPage1());

    }else{
      BotToast.showText(text: loginModel.message!);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
         Padding(padding: EdgeInsets.symmetric(horizontal: 25,vertical: 15),
           child:  RichText(text: TextSpan(
             children: [
               TextSpan(text: 'WelCome to ',style: TextStyle(fontSize: 22,
                   fontWeight: FontWeight.w700,color: Colors.black)),
               TextSpan(text: 'FoodBuyer',style: TextStyle(fontSize: 22,
                   fontWeight: FontWeight.w700,color: AppColor.themeColor)),

             ]
         )),),

          Container(
            width: 200,
              color: Colors.white,
              margin: EdgeInsets.only(left: 25,top: 15,right: 55),
            child: Text(
              'Please your register email address and password',style: TextStyle(
              color: AppColor.smallTextColor,fontSize: 19,fontWeight: FontWeight.w600
            ),
            )),

          Container(
            padding: EdgeInsets.only(left: 25,top: 45),
            child: Text(I18nContent.phoneLabel.tr,style: TextStyle(
              fontWeight: FontWeight.w700,fontSize: 22,color: Colors.black
            ),),
          ),
          SizedBox(height: 10,),
          Center(
            child: Container(
              height: 60,
              margin: const EdgeInsets.only(left: 25,right: 25),
              padding: const EdgeInsets.only(left: 15),
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColor.searchBgColor,
                borderRadius: const BorderRadius.all(Radius.circular(8))
              ),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: emailAddressTextEditingController,
                style: TextStyle(fontSize: 18
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 18),
                  hintText: I18nContent.pleaseEnterYourPhone.tr
                ),
              ),
            ),
          ),

          SizedBox(height: 25,),
          Container(
            padding: EdgeInsets.only(left: 25,top: 0),
            child: Text(I18nContent.passWord.tr,style: TextStyle(
                fontWeight: FontWeight.w700,fontSize: 22,color: Colors.black
            ),),
          ),
          SizedBox(height: 10,),
          Center(
            child: Container(
              height: 60,
              margin: const EdgeInsets.only(left: 25,right: 25),
              padding: const EdgeInsets.only(left: 15),
              width: Get.width,
              decoration: BoxDecoration(
                  color: HexColor('#F5F5F5'),
                  borderRadius: const BorderRadius.all(Radius.circular(8))
              ),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: passWordTextEditingController,
                obscureText: true,
                style: TextStyle(fontSize: 18
                ),
                decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 18),
                    hintText: I18nContent.pleaseEnterYourPassword.tr
                ),
              ),
            ),
          ),
          SizedBox(height: 55,),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15),
            child:   MaterialButton(onPressed: (){

              requestDataWithLogin();
              // if(emailAddressTextEditingController.text == '123'){
              //   Get.offAll(TabPage());
              // }

            },child: Text(I18nContent.loginLabel.tr,style: TextStyle(color: Colors.white,fontSize: 18),)
              ,color: AppColor.themeColor,minWidth: Get.width,height: 55,shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),),
          ),
        ],
      ),
    );
  }
}
