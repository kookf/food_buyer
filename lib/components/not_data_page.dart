import 'package:flutter/material.dart';

import '../common/colors.dart';
import '../lang/message.dart';
import 'package:get/get.dart';
class NoDataPage extends StatefulWidget {
  const NoDataPage({Key? key}) : super(key: key);

  @override
  State<NoDataPage> createState() => _NoDataPageState();
}

class _NoDataPageState extends State<NoDataPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      // color: Colors.red,
      child: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(I18nContent.notData.tr,style: TextStyle(
              color: AppColor.smallTextColor
            ),)
          ],
        ),
      )

    );
  }
}
