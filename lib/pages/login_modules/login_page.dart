import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
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
    final baseColor = Theme.of(context);

    // TODO: implement build
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            height: 35,
            width: Get.width,
            color: Colors.white,
            alignment: Alignment.centerRight,
            child: IconButton(onPressed: () {
              Get.to(const SelectLanguagePage());
            }, icon: Image.asset('images/ic_language.png'),),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: Get.width,
            // color: AppColor.themeColor,
            height: Get.height/2-50,
            child: Image.asset(
                'images/ic_login_image.png',cacheHeight: 400,
            cacheWidth: 400,),
          ),
          const SizedBox(height: 15,),
          Center(child:    RichText(text: TextSpan(
              children: [
                TextSpan(text: 'Welcome to ',style:
                Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.black
                )),
                TextSpan(text: 'FoodBuyer ',style: Theme.of(context).textTheme
                .headlineSmall),
              ]
          )),),
          Container(
            margin: const EdgeInsets.only(left: 35,right: 35,top: 25),
            child: Text('''Connect your business with potential Food & Beverage buyer orsuppliers for more business opportunities
          ''',style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: kDTCloudGray
            ),
              textAlign: TextAlign.center,),
          ),
          const SizedBox(height: 55,),
          Container(
            padding: const EdgeInsets.only(left: 15,right: 15),
            child:  MaterialButton(onPressed: (){

              Get.to(const LoginInPage());

            },color: AppColor.themeColor,height: 55,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),child: Text(I18nContent.loginLabel.tr,
              style: baseColor.textTheme.titleLarge!.copyWith(color: Colors.white),)
              ,),
          ),
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 15,right: 15),
            child:MaterialButton(onPressed: (){
              // Get.to(CreateNewAccountPage());

              // Get.to(VerificationCodePage());
              Get.to(const SelectRegisterTypePage());

            },color: kDTCloud50,minWidth: Get.width,height: 55,
              shape:  const RoundedRectangleBorder(
                //边框颜色
                side: BorderSide(
                  color: kDTCloud900,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),child: Text(I18nContent.createNewAccLabel.tr,
              style: baseColor.textTheme.titleLarge,)
              ,),
          ),
          const SizedBox(height: 10,),


        ],
      ),
    );
  }

}