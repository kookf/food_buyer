import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/pages/login_modules/login_in_page.dart';
import 'package:food_buyer/pages/login_modules/login_page.dart';
import 'package:food_buyer/pages/mine_modules/sub_account_managerment_page.dart';
import 'package:food_buyer/utils/hexcolor.dart';
import 'package:food_buyer/utils/persisten_storage.dart';
import 'package:get/get.dart';
import '../../services/address.dart';
import '../../services/dio_manager.dart';
import '../../utils/event_utils.dart';
import '../../utils/socket_utils.dart';
import '../../utils/websocket_kk.dart';
import 'account_profile_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  /// 获取个人信息
  ProfileModel? profileModel;
  requestDataWithProfile()async{
    var json = await DioManager().kkRequest(Address.userProfile,);
    ProfileModel model = ProfileModel.fromJson(json);
    profileModel = model;
    setState(() {

    });
  }

  StreamSubscription? eventBusFn;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventBusFn!.cancel();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    requestDataWithProfile();

    eventBusFn = EventBusUtil.listen((event) {
      print('menuRefresh===${event}');
      if(event == 'menuRefresh'){
        requestDataWithProfile();
      }
    });

    // eventBusFn = eventBus.on<EventFn>().listen((event) {
    //
    //   if(event.obj == 'menuRefresh'){
    //     requestDataWithProfile();
    //   }
    //
    // });

  }
  @override
  Widget build(BuildContext context) {

    ThemeData baseColor = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 15),
        children: [
          GestureDetector(
            onTap: (){
              Get.to(const AccountProfilePage());
            },
            child: Container(
              padding: const EdgeInsets.only(left: 25,right: 25),
              height: 75,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Center(
                        child:  Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: CachedNetworkImage(imageUrl:
                          '${Address.homeHost}${Address.storage}/'
                              '${profileModel?.data?.avatar}',
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                CircularProgressIndicator(value: downloadProgress.progress),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${profileModel?.data?.nickName}',
                            style: baseColor.textTheme.titleLarge,),
                          const SizedBox(height: 5,),
                          Text('Hong Kong',style:
                          baseColor.textTheme.bodySmall!.copyWith(color: kDTCloudGray),),
                        ],
                      ),
                    ],
                  ),
                  Image.asset('images/ic_arrow_right.png',width: 10,height: 10,)
                ],
              ),
            ),
          ),
          const SizedBox(height: 15,),
          Container(
            padding: const EdgeInsets.only(left: 25,right: 25),
            height: 75,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('images/ic_accmanagerment.png',width: 35,height: 35,),
                    SizedBox(width: 10,),
                    Text('Account management',style: baseColor.textTheme.titleLarge!.
                    copyWith(
                      color: kDTCloudGray
                    ),),

                  ],
                ),
                Image.asset('images/ic_arrow_right.png',width: 10,height: 10,)
              ],
            ),
          ),


          const SizedBox(height: 1,),
         GestureDetector(
           onTap: (){
           Get.to(SubAccountManagermentPage());
           },
           child:  Container(
             padding: const EdgeInsets.only(left: 25,right: 25),
             height: 75,
             color: Colors.white,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Row(
                   children: [
                     Image.asset('images/ic_sup_acmanager.png',width: 35,height: 35,),
                     SizedBox(width: 10,),
                     Text('Sub - Account management',style: baseColor.textTheme.titleLarge!.
                     copyWith(
                         color: kDTCloudGray
                     ),),

                   ],
                 ),
                 Image.asset('images/ic_arrow_right.png',width: 10,height: 10,)
               ],
             ),
           ),
         ),
          const SizedBox(height: 1,),
          Container(
            padding: const EdgeInsets.only(left: 25,right: 25),
            height: 75,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('images/ic_support_centre.png',width: 35,height: 35,),
                    SizedBox(width: 10,),
                    Text('Support centre',style: TextStyle(color: AppColor.smallTextColor,
                        fontSize: 17
                    ),),

                  ],
                ),
                Image.asset('images/ic_arrow_right.png',width: 10,height: 10,)
              ],
            ),
          ),
          const SizedBox(height: 1,),
          Container(
            padding: const EdgeInsets.only(left: 25,right: 25),
            height: 75,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('images/ic_contactus.png',width: 35,height: 35,),
                    SizedBox(width: 10,),
                    Text('Contact us',style: baseColor.textTheme.titleLarge!.
                    copyWith(
                        color: kDTCloudGray
                    ),),

                  ],
                ),
                Image.asset('images/ic_arrow_right.png',width: 10,height: 10,)
              ],
            ),
          ),

          const SizedBox(height: 1,),
          Container(
            padding: const EdgeInsets.only(left: 25,right: 25),
            height: 75,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('images/ic_promotion.png',width: 35,height: 35,),

                    SizedBox(width: 10,),
                    Text('Promotion notification',style: baseColor.textTheme.titleLarge!.
                    copyWith(
                        color: kDTCloudGray
                    ),),

                  ],
                ),
                Image.asset('images/ic_arrow_right.png',width: 10,height: 10,)
              ],
            ),
          ),
          const SizedBox(height: 1,),
          Container(
            padding: const EdgeInsets.only(left: 25,right: 25),
            height: 75,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('images/ic_setting.png',width: 35,height: 35,),

                    SizedBox(width: 10,),
                    Text('Preference setting',style: baseColor.textTheme.titleLarge!.
                    copyWith(
                        color: kDTCloudGray
                    ),),

                  ],
                ),
                Image.asset('images/ic_arrow_right.png',width: 10,height: 10,)
              ],
            ),
          ),
          const SizedBox(height: 1,),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 25,right: 25),
                  width: Get.width,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image:
                    AssetImage('images/ic_become_enterprise_buyer_bg.png'),
                        fit:BoxFit.contain)
                  ),
                  child: const Text('Become a enterprise buyer',style: TextStyle(
                    color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600
                  ),),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 25,right: 25),
                  width: Get.width,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image:
                    AssetImage('images/ic_become_supplierbg.png'),
                        fit:BoxFit.contain)
                  ),
                  child: const Text('Become a Supplier',style: TextStyle(
                    color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600
                  ),),
                ),
              ],
            ),
          ),

          SizedBox(height: 55,),
          GestureDetector(
            onTap: ()async{

              WebSocketUtility().autoClose = false;
              WebSocketUtility().closeSocket();
              await PersistentStorage().removeStorage('token');
              await PersistentStorage().removeStorage('socket_key');
              Get.offAll(LoginPage());
            },

            child:  Container(
              alignment: Alignment.center,
              height: 65,
              color: kDTCloud50,
              child: Text('Log Out',style: TextStyle(color: AppColor.smallTextColor,
                  fontWeight: FontWeight.w500
              ),),
            ),
          ),
          SizedBox(height: 45,),

        ],
      ),
    );
  }
}
