import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_buyer/pages/login_modules/login_page.dart';
import 'package:get/get.dart';
import '../../utils/persisten_storage.dart';
import 'bottom_tab_controller.dart';


class GuidePage extends StatefulWidget {
  const GuidePage({Key? key}) : super(key: key);

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {

  Timer? _t;
  bool? isLogin;

  @override
  void initState() {
    // Get.offAll(LoginPage(),curve:Curves.linear,transition:Transition.zoom);
    getToken();
    super.initState();
    _t = Timer(const Duration(milliseconds: 1), () {
    if(isLogin == false){
      // Get.offAllNamed(AppRoutes.login,);
    }else{
      // Get.offAllNamed(AppRoutes.bottomMain);
    }
    });
  }

  getToken()async{
    if(await PersistentStorage().getStorage('token')==null){
      isLogin = false;
      Get.offAll(LoginPage());
    }else{
      isLogin = true;
      Get.offAll(TabPage1());

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

      ),
    );
  }
}
