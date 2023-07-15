import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:get/get.dart';
import '../../../common/foodbuyer_colors.dart';
import '../../../lang/message.dart';
import '../register_modules/countdown_button.dart';

class VerifiedEmailPage extends StatefulWidget {
  const VerifiedEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifiedEmailPage> createState() => _VerifiedEmailPageState();
}

class _VerifiedEmailPageState extends State<VerifiedEmailPage> {


  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  requestDataWithVerifiedEmail()async{
    var params = {
      'email':emailController.text,
      'code':codeController.text,
    };
    var json = await DioManager().kkRequest(Address.userEmailVerified,
        bodyParams: params);
    BotToast.showText(text: json['message']);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18nContent.verifyEmail.tr),
      ),
      body: Column(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container(
                  margin: const EdgeInsets.only(top: 5,left: 30),
                  padding: const EdgeInsets.only(left: 15),
                  //边框设置
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    // //设置四周圆角 角度
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    // //设置四周边框
                    // border: Border.all(
                    //     width: 1, color: AppColor.textFieldBorderColor),
                  ),
                  child: TextField(
                    controller: emailController,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(50) //限制长度
                    ],
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value){
                      // emailController.text = value;
                      // setState(() {
                      //
                      // });
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type in your email'),
                  ),
                ),),
                SizedBox(width: 5,),
                CountDownButton(emailController),
                SizedBox(width: 30,),

              ],
            ),
          ),
          SizedBox(height: 15,),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.only(left: 15),
              width: Get.width - 60,
              //边框设置
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                // //设置四周圆角 角度
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                // //设置四周边框
                // border: Border.all(
                //     width: 1, color: AppColor.textFieldBorderColor),
              ),
              child: TextField(
                controller: codeController,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(20) //限制长度
                ],
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type in your code'),
              ),
            ),
          ),
          SizedBox(height: 50,),
          Container(
            height: 55,
            child: Center(
              child: MaterialButton(
                onPressed: () {

                  if(emailController.text.isEmpty||codeController.text.isEmpty){
                    BotToast.showText(text: '');
                    return;
                  }

                  requestDataWithVerifiedEmail();
                  // Get.to(VerificationCodePage());
                },
                color: kDTCloud700,
                minWidth: Get.width - 80,
                height: 45,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22))),
                child: Text(
                  I18nContent.sendRequest,
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
