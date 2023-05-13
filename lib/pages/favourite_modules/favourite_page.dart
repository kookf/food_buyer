import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../common/colors.dart';
import '../../lang/message.dart';
import 'package:get/get.dart';
class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {

  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18nContent.favourite.tr),
        actions: [
          TextButton(onPressed: (){
            isEdit =! isEdit;
            setState(() {

            });
          }, child: isEdit==false?Text(I18nContent.searchEdit.tr):
          Text(I18nContent.searchCancel.tr))
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 15),
                margin: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  color: AppColor.searchBgColor,
                ),
                height: 55,
                child: Row(
                  children: [
                    Image.asset(
                      'images/ic_search.png',
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: TextField(
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: true,
                            hintText: I18nContent.searchChat.tr,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: EasyRefresh.custom(slivers: [

          ],)),
        ],
      ),
    );
  }
}
