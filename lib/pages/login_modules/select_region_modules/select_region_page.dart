import 'package:flutter/material.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/bottom_nav_moudules/guide_page.dart';
import 'package:food_buyer/pages/login_modules/select_region_modules/select_language_page.dart';
import 'package:get/get.dart';

import '../../../utils/persisten_storage.dart';
import '../login_page.dart';
import 'select_region_detail_page.dart';
class SelectRegionPage extends StatefulWidget {
  const SelectRegionPage({Key? key}) : super(key: key);

  @override
  State<SelectRegionPage> createState() => _SelectRegionPageState();
}

class _SelectRegionPageState extends State<SelectRegionPage> {

  String region = 'Hong Kong';
  String language = '';

  initData()async{
    String type = await PersistentStorage().getStorage('language');
    if (type == 'english') {
      language = 'English';
    } else if(type == 'chineseT'){
      language = '繁体中文';
    }else {
      language = '简体中文';
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(I18nContent.selectRegion.tr,style: Theme.of(context).textTheme.headlineSmall,),
          ),
          const SizedBox(height: 55,),

          Container(
            padding: const EdgeInsets.only(left: 30),
            child: Text(I18nContent.selectRegion.tr),
          ),
          const SizedBox(height: 5,),
          Center(
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border.all(color: kDTCloudGray,width: 1),
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              alignment: Alignment.centerLeft,
              width: Get.width-50,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      region == 'Hong Kong'?Image.asset('images/ic_hongkong.png',width: 35,
                      height: 35,
                      ):region == 'Macao'?Image.asset('images/ic_macao.png',width: 35,
                     height: 35,):Image.asset('images/ic_china.png',width: 35,height: 35,),
                      const SizedBox(width: 5,),
                      Text(region),
                    ],
                  ),
                  TextButton(onPressed: ()async{
                    var data = await Get.to(SelectCountryDetailPage());
                    if(data == 1){
                      region = 'Hong Kong';
                    }else if(data == 2){
                      region = 'Macao';
                    }else{
                      region = 'China';
                    }
                    setState(() {

                    });
                  }, child: Text(I18nContent.change.tr))
                ],
              ),

            ),
          ),
          SizedBox(height: 5,),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: Text(I18nContent.selectLanguage.tr),
          ),
          SizedBox(height: 5,),
          Center(
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: kDTCloudGray,width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              alignment: Alignment.centerLeft,
              width: Get.width-50,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language),
                  TextButton(onPressed: ()async{
                    var data = await Get.to(SelectLanguagePage());
                    if(data == 'refresh'){
                      initData();
                    }
                  }, child: Text(I18nContent.change.tr))
                ],
              ),
            ),
          ),

          SizedBox(height: 15,),
          Center(
            child: MaterialButton(
              onPressed: (){
                Get.to(LoginPage());

              },color: kDTCloud700,
              minWidth: Get.width-50,
              height: 45,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),child: Text(I18nContent.next.tr,style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: Colors.white,
            ),),
            ),
          )
        ],
      ),
    );
  }
}
