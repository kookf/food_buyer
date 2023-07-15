import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/colors.dart';
import '../../../services/address.dart';
import '../../../services/dio_manager.dart';

class CountDownButton extends StatefulWidget {


  TextEditingController emailController;
    CountDownButton(this.emailController,{Key? key}) : super(key: key);

  @override
  State<CountDownButton> createState() => _CountDownButtonState();
}

class _CountDownButtonState extends State<CountDownButton> {

  requestDataWithSendEmail()async{
    var param = {
      'method':'auth.forget_send_code',
      'email':widget.emailController.text,
    };

    var json = await DioManager().kkRequest(Address.host,params: param);
    if(json['code'] == 200){
      startCountDown();
      BotToast.showText(text: '發送成功');
    }else{
      BotToast.showText(text: json['message']);
    }
  }


  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('counter dispose');
    _timer!.cancel();
  }
  String mes = '發送驗證碼';

  void startCountDown(){
    int counter = 59;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      counter--;
        if (counter == 1) {
           print('Cancel timer');
           mes ='發送驗證碼';
           timer.cancel();
         }else{
          mes = '重新發送${counter}';
        }

        setState(() {

        });
      // print(counter--);
    });

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(mes == '發送驗證碼'){
          print('==${widget.emailController.text}');
          if(GetUtils.isEmail(widget.emailController.text)){
            requestDataWithSendEmail();
          }else{
            BotToast.showText(text: '請輸入正確的電郵');
          }
        }else{

        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 45,
        decoration: BoxDecoration(
          color: AppColor.themeColor,
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        // color: Colors.white,
        child: Text(mes,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Colors.white
          ),)
      ),
    );
  }
}
