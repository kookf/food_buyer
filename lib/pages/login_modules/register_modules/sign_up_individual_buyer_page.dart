import 'package:bot_toast/bot_toast.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/login_modules/register_modules/register_complete_page.dart';
import 'package:food_buyer/utils/hexcolor.dart';
import 'package:get/get.dart';
import 'package:image_pickers/image_pickers.dart';
import '../../../common/style.dart';
import '../../../services/address.dart';
import '../../../services/dio_manager.dart';
import '../verification_code_page.dart';

class SignUpIndividualBuyerPage extends StatefulWidget {
  const SignUpIndividualBuyerPage({Key? key}) : super(key: key);

  @override
  State<SignUpIndividualBuyerPage> createState() =>
      _SignUpIndividualBuyerPageState();
}

class _SignUpIndividualBuyerPageState extends State<SignUpIndividualBuyerPage> {

  bool verify = false;

  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController nickNameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmedPasswordTextEditingController = TextEditingController();


  List listFilePaths = [];

  /// 上传图片
  selectImages() async {

    print(listFilePaths.length);
    try {
      // _galleryMode = GalleryMode.image;
      // listFilePaths = await ImagePickers.pickerPaths(
      //   galleryMode: GalleryMode.image,
      //   showGif: false,
      //   selectCount: 1,
      //   showCamera: false,
      //   cropConfig: CropConfig(enableCrop: true, height: 1, width: 1),
      //   compressSize: 300,
      //   uiConfig: UIConfig(
      //     uiThemeColor: AppColor.themeColor,
      //   ),
      // );
      ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        showGif: false,
        selectCount: 1,
        showCamera: true,
        cropConfig: CropConfig(enableCrop: true, height: 1, width: 1),
        compressSize: 300,
        uiConfig: UIConfig(
          uiThemeColor: AppColor.themeColor,
        ),
      ).then((value) {
        listFilePaths.clear();
        listFilePaths.addAll(value);
        print(listFilePaths.length);
        // if (listFilePaths.length > 0) {
        //   MultipartFile multipartFile = MultipartFile.fromFileSync(
        //     '${listFilePaths![0].path}',filename: 'avator_userinfo',
        //   );
        //   requestDataWithUpdataInfo(avatar: multipartFile);
        //   listFilePaths!.forEach((media) {
        //     print('media.path.toString() ==== ${media.path.toString()}');
        //   });
        // }
        setState(() {

        });
      });


    } on PlatformException {

    }
  }
  /// 注册一个个人账号


  requestDataWithRegister()async{
    var params = {
      'name':userNameTextEditingController.text,
      'nick_name':nickNameTextEditingController.text,
      'phone':phoneTextEditingController.text,
      'email':emailTextEditingController.text,
      'location':locationTextEditingController.text,
      'password':passwordTextEditingController.text,
      'confirmed_password':passwordTextEditingController.text,
    };
    var json = await DioManager().kkRequest(Address.userCreate,
        bodyParams: params);
    if(json['code']==200){
      Get.back();
      Get.to(RegisterCompletePage());
      BotToast.showText(text: '注册成功');
    }else{
      BotToast.showText(text: json['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 35, top: 15),
                    child: RichText(
                      text: TextSpan(
                          text: '${I18nContent.signupLabel.tr} ',
                          style: size21BlackW700,
                          children: [
                            TextSpan(
                                text: I18nContent.individualBuyer.tr,
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.themeColor))
                          ]),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 35, right: 55, top: 15),
                    child: Center(
                        child: Text(
                      'Please your registered email address and password',
                      style: TextStyle(
                          color: AppColor.smallTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.userNameDisPlayInChatroom.tr,
                      style: size18BlackW700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: HexColor('#F5F5F5'),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.only(left: 30, right: 35),
                    padding: EdgeInsets.only(left: 15),
                    child: TextField(
                      style: TextStyle(color: AppColor.themeColor),
                      controller: nickNameTextEditingController,
                      decoration: InputDecoration(
                          hintText: 'Type in your user name (display chat room)',
                          border: InputBorder.none),
                    ),
                  ),
                  verify==false?SizedBox.shrink():
                  nickNameTextEditingController.text.isEmpty?
                  errorText():SizedBox.shrink(),


                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.primaryContactName,
                      style: size18BlackW700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: HexColor('#F5F5F5'),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.only(left: 30, right: 35),
                    padding: EdgeInsets.only(left: 15),
                    child: TextField(
                      controller: userNameTextEditingController,
                      style: TextStyle(color: AppColor.themeColor),
                      decoration: InputDecoration(
                          hintText: 'Type in your user name',
                          border: InputBorder.none),
                    ),
                  ),
                  verify==false?SizedBox.shrink():
                  userNameTextEditingController.text.isEmpty?
                  errorText():SizedBox.shrink(),

                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.contactNumber.tr,
                      style: size18BlackW700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: HexColor('#F5F5F5'),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.only(left: 30, right: 35),
                    padding: EdgeInsets.only(left: 15),
                    child: TextField(
                      style: TextStyle(color: AppColor.themeColor),

                      controller: phoneTextEditingController,
                      decoration: InputDecoration(
                          hintText: 'Type in your contact number',
                          border: InputBorder.none),
                    ),
                  ),
                  verify==false?SizedBox.shrink():
                  phoneTextEditingController.text.isEmpty?
                  errorText():SizedBox.shrink(),

                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.primaryContactEmail.tr,
                      style: size18BlackW700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: HexColor('#F5F5F5'),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.only(left: 30, right: 35),
                    padding: EdgeInsets.only(left: 15),
                    child: TextField(
                      style: TextStyle(color: AppColor.themeColor),

                      keyboardType: TextInputType.emailAddress,
                      controller: emailTextEditingController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintText: 'Type in your email',
                          border: InputBorder.none),
                    ),
                  ),
                  verify==false?SizedBox.shrink():
                  emailTextEditingController.text.isEmpty?
                  errorText():SizedBox.shrink(),
                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.primaryContactPassword,
                      style: size18BlackW700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: HexColor('#F5F5F5'),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.only(left: 30, right: 35),
                    padding: EdgeInsets.only(left: 15),
                    child: TextField(
                      style: TextStyle(color: AppColor.themeColor),
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Type in your password',
                          border: InputBorder.none),
                    ),
                  ),

                  verify==false?SizedBox.shrink():
                  emailTextEditingController.text.isEmpty?
                  errorText():SizedBox.shrink(),

                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.confirmedPassword,
                      style: size18BlackW700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: HexColor('#F5F5F5'),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.only(left: 30, right: 35),
                    padding: EdgeInsets.only(left: 15),
                    child: TextField(
                      style: TextStyle(color: AppColor.themeColor),
                      controller: confirmedPasswordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Type in your confirmed password',
                          border: InputBorder.none),
                    ),
                  ),
                  verify==false?SizedBox.shrink():
                  emailTextEditingController.text.isEmpty?
                  errorText():SizedBox.shrink(),
                  SizedBox(height: 55,),

                  // Container(
                  //   margin: EdgeInsets.only(left: 35, top: 25),
                  //   child: Text(
                  //     I18nContent.advertisementOptional.tr,
                  //     style: size18BlackW700,
                  //   ),
                  // ),
                  // Container(
                  //   color: Colors.white,
                  //   padding: EdgeInsets.only(left: 35,right: 0,top: 5),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       // Radio(value: 0, groupValue: 0, onChanged: (onChanged){
                  //       //
                  //       // }),
                  //       Padding(padding: EdgeInsets.only(top: 3),child: Image.asset('images/ic_radio.png',width: 20,height: 20,),),
                  //       SizedBox(width: 15,),
                  //       Container(
                  //         height: 55,
                  //         width: Get.width -100,
                  //         child:Text('Lorem ipsum dolor sit amet consectetur. '
                  //             'Tristique urna feugiat feugiat diam nascetur vestibulum eget bibendum. ',style: TextStyle(
                  //           fontSize: 14,color: AppColor.smallTextColor,
                  //         ),maxLines: 3,),
                  //       )
                  //
                  //     ],
                  //   ),
                  // ),
                  //
                  // Container(
                  //   margin: EdgeInsets.only(left: 35, top: 25),
                  //   child: Text(
                  //     'Terms and agreement  ',
                  //     style: size18BlackW700,
                  //   ),
                  // ),
                  // Container(
                  //   color: Colors.white,
                  //   padding: EdgeInsets.only(left: 35,right: 0,top: 5),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       // Radio(value: 0, groupValue: 0, onChanged: (onChanged){
                  //       //
                  //       // }),
                  //       Padding(padding: EdgeInsets.only(top: 3),child: Image.asset('images/ic_radio.png',width: 20,height: 20,),),
                  //       SizedBox(width: 15,),
                  //       Container(
                  //         height: 55,
                  //         width: Get.width -100,
                  //         child:Text('Lorem ipsum dolor sit amet consectetur. '
                  //             'Tristique urna feugiat feugiat diam nascetur vestibulum eget bibendum. ',style: TextStyle(
                  //           fontSize: 14,color: AppColor.smallTextColor,
                  //         ),maxLines: 3,),
                  //       )
                  //
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
            Container(
              height: 55,
              child: Center(
                child: MaterialButton(
                  onPressed: () {

                    verify = true;
                    setState(() {

                    });
                    requestDataWithRegister();
                    // Get.to(VerificationCodePage());
                  },
                  child: Text(
                    I18nContent.sendRequest,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: AppColor.themeColor,
                  minWidth: Get.width - 80,
                  height: 45,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22))),
                ),
              ),
            )
          ],
        )
    );
  }
  errorText(){
    return Padding(padding: EdgeInsets.only(left: 35,),
      child: Text(I18nContent.errorText.tr,
        style: const TextStyle(
            fontSize: 12,color: Colors.red
        ),),
    );
  }
}
