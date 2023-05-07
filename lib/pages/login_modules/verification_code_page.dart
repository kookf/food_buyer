import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/pages/login_modules/register_modules/register_complete_page.dart';
import 'package:get/get.dart';
import '../../lang/message.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({Key? key}) : super(key: key);

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          const Center(
              child: Text(
            'Verification Password',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700, fontSize: 21),
          )),
          Padding(
            padding: const EdgeInsets.only(left: 55, right: 55, top: 15),
            child: Center(
              child: Text(
                'Please enter the 4 digit veri'
                'fication code that is sent to your registered email',
                style: TextStyle(fontSize: 17, color: AppColor.smallTextColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 55,
          ),
          VerificationCode(
            textStyle: TextStyle(fontSize: 20.0, color: AppColor.themeColor,
            fontWeight: FontWeight.w600
            ),
            keyboardType: TextInputType.number,
            underlineColor: Colors.transparent,
            //
            fillColor: Colors.grey.shade200,
            underlineUnfocusedColor: Colors.transparent,
            fullBorder: true,
            itemSize: 70,
            padding: EdgeInsets.all(20),
            // If this is null it will use primaryColor: Colors.red from Theme
            length: 4,
            cursorColor: Colors.blue,
            // If this is null it will default to the ambient
            onCompleted: (String value) {
              setState(() {
                // _code = value;
              });
            },
            onEditing: (bool value) {
              setState(() {
                // _onEditing = value;
              });

              // if (!_onEditing) FocusScope.of(context).unfocus();
            },
          ),
          SizedBox(height: 55,),
          Container(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: MaterialButton(
              onPressed: () {
                Get.to(RegisterCompletePage());
              },
              color: AppColor.themeColor,
              minWidth: Get.width,
              height: 55,
              shape: RoundedRectangleBorder(
                //边框颜色
                side: BorderSide(
                  color: AppColor.themeColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Text(
                I18nContent.sendLabel.tr,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          TextButton(onPressed: (){

          }, child: Text(I18nContent.resendLabel,style: TextStyle(
            fontSize: 15,color: AppColor.themeColor
          ),))
        ],
      ),
    );
  }
}
