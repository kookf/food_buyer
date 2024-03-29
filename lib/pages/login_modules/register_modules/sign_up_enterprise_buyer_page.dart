import 'package:bot_toast/bot_toast.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/pages/login_modules/register_modules/register_complete_page.dart';
import 'package:image_pickers/image_pickers.dart';

import '../../../common/colors.dart';
import '../../../common/style.dart';
import '../../../lang/message.dart';
import '../../../services/address.dart';
import '../../../services/dio_manager.dart';
import '../../../utils/hexcolor.dart';
import 'package:get/get.dart';

import '../verification_code_page.dart';

class SignUpEnterPriseBuyerPage extends StatefulWidget {
  const SignUpEnterPriseBuyerPage({Key? key}) : super(key: key);

  @override
  State<SignUpEnterPriseBuyerPage> createState() =>
      _SignUpEnterPriseBuyerPageState();
}

class _SignUpEnterPriseBuyerPageState extends State<SignUpEnterPriseBuyerPage> {
  List listFilePaths = [];

  /// 上传图片
  selectImages() async {
    print(listFilePaths.length);

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
      setState(() {});
    });
  }

  /// 注册一个公司账号
  bool verify = false;

  TextEditingController userNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyNameEnController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController contactEmailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmedPasswordController = TextEditingController();

  requestDataWithCreateIndividual() async {
    var params = {
      'nick_name': userNameController.text,
      'company_name': companyNameController.text,
      'company_name_en': companyNameEnController.text,
      'contact_name': contactNameController.text,
      'contact_number': contactNumberController.text,
      'contact_email': contactEmailController.text,
      'location': locationController.text,
      'password': passwordController.text,
      'confirmed_password': confirmedPasswordController.text,
    };
    var json = await DioManager()
        .kkRequest(Address.userCreateCompany, bodyParams: params);
    if (json['code'] == 200) {
      BotToast.showText(text: I18nContent.registerSuccessful);
      Get.back();
      Get.to(RegisterCompletePage());
    } else {
      BotToast.showText(text: json['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData baseColor = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 35, top: 15),
                    child: RichText(
                      text: TextSpan(
                          text: I18nContent.signupLabel.tr,
                          style: baseColor.textTheme.headlineSmall!
                              .copyWith(color: Colors.black),
                          children: [
                            TextSpan(
                                text: ' ${I18nContent.enterPriseBuyerLabel.tr}',
                                style: baseColor.textTheme.headlineSmall)
                          ]),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 35, right: 55, top: 15),
                    child: Center(
                      child: Text(
                          'Please your registered email address and password',
                          style: baseColor.textTheme.titleLarge!
                              .copyWith(color: kDTCloudGray)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.userNameDisPlayInChatroom.tr,
                      style: baseColor.textTheme.headlineSmall!
                          .copyWith(color: Colors.black),
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
                      decoration: InputDecoration(
                          hintText: 'Type in your user name',
                          border: InputBorder.none),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.companyNameLocal.tr,
                      style: baseColor.textTheme.headlineSmall!
                          .copyWith(color: Colors.black),
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
                      decoration: InputDecoration(
                          hintText: 'Type in your company name',
                          border: InputBorder.none),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.companyNameEn.tr,
                      style: baseColor.textTheme.headlineSmall!
                          .copyWith(color: Colors.black),
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
                      decoration: InputDecoration(
                          hintText: 'Type in your company name',
                          border: InputBorder.none),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.businessRegistrationNumber.tr,
                      style: baseColor.textTheme.headlineSmall!
                          .copyWith(color: Colors.black),
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
                      decoration: InputDecoration(
                          hintText: 'Type in your business registration number',
                          border: InputBorder.none),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.uploadBusinessRegistration.tr,
                      style: baseColor.textTheme.headlineSmall!
                          .copyWith(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 120,
                    margin: EdgeInsets.only(left: 35, right: 35),
                    child: DottedBorder(
                      color: Colors.grey,
                      borderType: BorderType.RRect,
                      radius: Radius.circular(10),
                      strokeWidth: 0.5,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('images/ic_add.png'),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Add image of business registration',
                                  style: size17SmailW700,
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.companyLogo.tr,
                      style: baseColor.textTheme.headlineSmall!
                          .copyWith(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 120,
                    margin: EdgeInsets.only(left: 35, right: 35),
                    child: DottedBorder(
                      color: Colors.grey,
                      borderType: BorderType.RRect,
                      radius: Radius.circular(10),
                      strokeWidth: 0.5,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('images/ic_add.png'),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Add image of company logo',
                                  style: size17SmailW700,
                                )
                              ],
                            ),
                          )),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.companyDescriptionOptional.tr,
                      style: baseColor.textTheme.headlineSmall!
                          .copyWith(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 35, right: 35),
                    padding: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5, color: AppColor.smallTextColor),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Type in your description',
                          border: InputBorder.none),
                      maxLines: 5,
                    ),
                    height: 200,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.primaryContactName,
                      style: baseColor.textTheme.headlineSmall!
                          .copyWith(color: Colors.black),
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
                      decoration: InputDecoration(
                          hintText: 'Type in your user name',
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.contactNumber.tr,
                      style: baseColor.textTheme.headlineSmall!
                          .copyWith(color: Colors.black),
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
                      decoration: InputDecoration(
                          hintText: 'Type in your contact number',
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      'Location',
                      style: baseColor.textTheme.headlineSmall!
                          .copyWith(color: Colors.black),
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
                      decoration: InputDecoration(
                          hintText: 'Type in your contact number',
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.primaryContactEmail.tr,
                      style: baseColor.textTheme.headlineSmall!
                          .copyWith(color: Colors.black),
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
                      decoration: InputDecoration(
                          hintText: 'Type in your contact number',
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 35, top: 25),
                    child: Text(
                      I18nContent.primaryContactPassword,
                      style: baseColor.textTheme.headlineSmall!
                          .copyWith(color: Colors.black),
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
                      decoration: InputDecoration(
                          hintText: 'Type in your contact number',
                          border: InputBorder.none),
                    ),
                  ),

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
                  //         width: Get.width - 100,
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
                    // Get.to(VerificationCodePage());

                    requestDataWithCreateIndividual();
                  },
                  color: AppColor.themeColor,
                  minWidth: Get.width - 80,
                  height: 45,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22))),
                  child: const Text(
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
      ),
    );
  }
}
