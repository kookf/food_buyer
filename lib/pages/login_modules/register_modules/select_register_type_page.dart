import 'package:flutter/material.dart';
import 'package:food_buyer/lang/message.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: ListView(
        children: [
          Center(
            child: Text(I18nContent.selectAccountLabel,style: size21BlackW700,),
          ),
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Center(
              child: Text('Please select an account ty'
                  'pe that is most suited to your business needs',
                style: size17SmailW700,textAlign: TextAlign.center,),
            ),
          ),
          const SizedBox(height: 55,),

          Padding(
            padding: const EdgeInsets.only(left: 25,right: 0),
            child: Text(I18nContent.buyerLabel,
              style: size21BlackW700,),
          ),
          GestureDetector(
              onTap: (){
                Get.to(page)
              },
              child: Image.asset('images/register_bg1.png')),
          Image.asset('images/register_bg2.png'),


          Padding(
            padding: const EdgeInsets.only(left: 25,right: 0),
            child: Text(I18nContent.supplier,
              style: size21BlackW700,),
          ),
          Image.asset('images/register_bg3.png'),
        ],
      ),
    );
  }
}
