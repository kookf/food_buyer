import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/utils/persisten_storage.dart';
import 'package:get/get.dart';

class SelectLanguagePage extends StatefulWidget {
  const SelectLanguagePage({Key? key}) : super(key: key);

  @override
  State<SelectLanguagePage> createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLanguage();
  }

  void getLanguage()async{
    String type = await PersistentStorage().getStorage('language');
    if(type == 'english'){
      select = 1;
    }else{
      select = 2;
    }
    setState(() {

    });
  }

  int? select ; ///1 英文，2 中午

  List dataArr = [I18nContent.englishLabel.tr,I18nContent.chineseTraditionalLabel.tr];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18nContent.selectLanguage.tr),
        actions: [
          TextButton(onPressed: ()async{
            if(select==1){
              var locale = Locale('en', 'US');
              await Get.updateLocale(locale);
              await PersistentStorage().setStorage('language', 'english');
            }else{
              var locale = Locale('zh', 'Hant');
              await Get.updateLocale(locale);
              await PersistentStorage().setStorage('language', 'chinese');
            }

          }, child: Text(I18nContent.enterLabel.tr))
        ],
      ),
      body: ListView.builder(itemBuilder: (context,index){
        return Column(
          children: [
            GestureDetector(
              onTap: (){
                select  = index+1;
                setState(() {

                });
              },
              child: Container(
                height: 55,
                color: Colors.white,
                padding: EdgeInsets.only(left: 15,right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    index == 0?Text(I18nContent.englishLabel.tr):
                    Text(I18nContent.chineseTraditionalLabel.tr),
                    Image.asset('images/ic_check.png',width: 25,height: 25,
                    color: select==index+1?AppColor.themeColor:Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 0.5,
              color: AppColor.lineColor,
            )
          ],
        );
      },itemCount: dataArr.length,),
    );
  }
}
