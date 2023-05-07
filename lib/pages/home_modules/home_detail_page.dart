import 'package:flutter/material.dart';
import 'package:food_buyer/common/style.dart';
import 'package:get/get.dart';
import '../../common/colors.dart';
import '../../lang/message.dart';
import '../chat_modules/components/body.dart';
import '../mine_modules/mine_page.dart';

class HomeDetailPage extends StatefulWidget {
  const HomeDetailPage({Key? key}) : super(key: key);

  @override
  State<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends State<HomeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 25,right: 25),
                height: 75,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child:  Image.asset('images/ploder_header.png'),
                        ),
                        const SizedBox(width: 10,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Unknown Company',style: TextStyle(
                                fontSize: 18,fontWeight: FontWeight.w600
                            ),),
                            Text('Hong Kong',style: TextStyle(
                                fontSize: 15,fontWeight: FontWeight.w500,
                              color: AppColor.smallTextColor
                            ),),
                          ],
                        )
                      ],
                    ),
                    Image.asset('images/ic_dot3.png',
                      width: 20,height: 20,)
                  ],
                ),
              ),
              Container(
                child: Image.asset('images/ic_detail.png'),
              ),


              Container(
                padding: EdgeInsets.only(left: 15,right: 15,top: 15),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Get.to(const MinePage());
                      },
                      color: AppColor.themeColor,
                      minWidth: 180,
                      height: 50,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(22))),
                      child: const Text(
                        I18nContent.following,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(onPressed: (){

                    }, icon: Image.asset('images/ic_shard.png'))
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Container(
                padding: EdgeInsets.only(left: 25,right: 25),
                alignment: Alignment.centerLeft,
                color: Colors.white,
                child: Column(
                  children: [
                    Text('Unknown title Two Sentences (X2)',
                      style: size21BlackW700,)
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Container(
                margin: EdgeInsets.only(left: 25,right: 25),
                child: Text('Lorem ipsum dolor sit '
                    'amet consectetur. Arcu v'
                    'itae quam eu egestas. Varius'
                    ' sem fames amet feugiat et rutrum. '
                    'Tempus dui rhoncus orci cras eros. '
                    'Sed dui tempus amet donec egestas faucibus dignissim diam amet.',
                  style: TextStyle(color: AppColor.smallTextColor,fontSize: 14),),
              ),


            ],
          )),
          Container(
            height: 55,
            child: Center(
              child: MaterialButton(
                onPressed: () {
                  // Get.to(ChatPage());
                },
                color: AppColor.themeColor,
                minWidth: Get.width - 80,
                height: 45,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22))),
                child: const Text(
                  I18nContent.beginChat,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
