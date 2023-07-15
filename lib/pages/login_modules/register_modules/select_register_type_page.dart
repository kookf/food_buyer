import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/login_modules/register_modules/sign_up_enterprise_buyer_page.dart';
import 'package:food_buyer/pages/login_modules/register_modules/sign_up_individual_buyer_page.dart';
import 'package:food_buyer/pages/login_modules/register_modules/sign_up_supplier_page.dart';
import '../../../common/style.dart';
import 'package:get/get.dart';

class SelectRegisterTypePage extends StatefulWidget {
  const SelectRegisterTypePage({Key? key}) : super(key: key);

  @override
  State<SelectRegisterTypePage> createState() => _SelectRegisterTypePageState();
}

class _SelectRegisterTypePageState extends State<SelectRegisterTypePage> {
  @override
  Widget build(BuildContext context) {
    ThemeData baseColor = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Center(
            child: Text(
              I18nContent.selectAccountLabel.tr,
              style: baseColor.textTheme.headlineSmall!
                  .copyWith(color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Center(
              child: Text(
                'Please select an account ty'
                'pe that is most suited to your business needs',
                style: baseColor.textTheme.titleLarge!
                    .copyWith(color: kDTCloudGray),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 55,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 0),
            child: Text(
              I18nContent.buyerLabel,
              style: baseColor.textTheme.headlineSmall!
                  .copyWith(color: Colors.black),
            ),
          ),
          GestureDetector(
              onTap: () {
                Get.to(SignUpIndividualBuyerPage());
              },
              child: Image.asset('images/register_bg1.png')),

          Padding(
            padding: const EdgeInsets.only(left: 25, right: 0),
            child: Text(
              I18nContent.executive.tr,
              style: baseColor.textTheme.headlineSmall!
                  .copyWith(color: Colors.black),
            ),
          ),
          GestureDetector(
            onTap: () {
              // BotToast.showText(text: '暂不开放注册');
              // return;
              Get.to(SignUpEnterPriseBuyerPage());
            },
            child: Image.asset('images/register_bg2.png'),
          ),
          GestureDetector(
            onTap: () {
              // BotToast.showText(text: '暂不开放注册');
              // return;
              Get.to(SignUpSupplierPage());
            },
            child: Image.asset('images/register_bg3.png'),
          )
        ],
      ),
    );
  }
}
