import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/colors.dart';
import '../../../lang/message.dart';

class SelectCountryDetailPage extends StatefulWidget {
  const SelectCountryDetailPage({Key? key}) : super(key: key);

  @override
  State<SelectCountryDetailPage> createState() => _SelectCountryDetailPageState();
}

class _SelectCountryDetailPageState extends State<SelectCountryDetailPage> {


  int? select;

  ///1 英文，2 中午

  List dataArr = [
    I18nContent.hongKongCountry.tr,
    I18nContent.macao.tr,
    I18nContent.china.tr
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18nContent.selectRegion.tr),
        actions: [
          TextButton(
              onPressed: () async {
                Get.back(result: select);
                print(select);
              },
              child: Text(I18nContent.enterLabel.tr))
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  select = index + 1;
                  setState(() {});
                },
                child: Container(
                  height: 55,
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      index == 0
                          ? Text(I18nContent.hongKongCountry.tr):index==1?
                      Text(I18nContent.macao.tr)
                          : Text(I18nContent.china.tr),
                      Image.asset(
                        'images/ic_check.png',
                        width: 25,
                        height: 25,
                        color: select == index + 1
                            ? AppColor.themeColor
                            : Colors.grey,
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
        },
        itemCount: dataArr.length,
      ),
    );
  }
}
