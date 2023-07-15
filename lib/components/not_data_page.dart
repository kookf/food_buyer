import 'package:flutter/material.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';

import '../common/colors.dart';
import '../lang/message.dart';
import 'package:get/get.dart';

class NoDataPage extends StatefulWidget {

  VoidCallback? onTap;

  NoDataPage({this.onTap,Key? key}) : super(key: key);

  @override
  State<NoDataPage> createState() => _NoDataPageState();
}

class _NoDataPageState extends State<NoDataPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.onTap!();
      },
      child: Material(
          // color: Colors.red,
          child: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              I18nContent.notData.tr,
              style: TextStyle(color: AppColor.smallTextColor),
            ),
            SizedBox(height: 5,),
            Container(
              alignment: Alignment.center,
              width: 75,height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  border: Border.all(width: 0.3,color: kDTCloudGray),
                ),
                child: Text(I18nContent.reload.tr,style: Theme.of(context).textTheme.labelMedium,)),
          ],
        ),
      )),
    );
  }
}
