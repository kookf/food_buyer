import 'package:bot_toast/bot_toast.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_buyer/pages/login_modules/register_modules/register_complete_page.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:image_pickers/image_pickers.dart';

import '../../../common/colors.dart';
import '../../../common/foodbuyer_colors.dart';
import '../../../common/style.dart';
import '../../../lang/message.dart';
import '../../../utils/hexcolor.dart';
import 'package:get/get.dart';
import '../verification_code_page.dart';

class SignUpSupplierPage extends StatefulWidget {
  const SignUpSupplierPage({Key? key}) : super(key: key);

  @override
  State<SignUpSupplierPage> createState() => _SignUpSupplierPageState();
}

class _SignUpSupplierPageState extends State<SignUpSupplierPage> {
  bool verify = false;

  TextEditingController userNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyNameEnController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController contactEmailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController introduceController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmedPasswordController = TextEditingController();

  requestDataWithCreateSupplier() async {
    var params = {
      'nick_name': userNameController.text,
      'company_name': companyNameController.text,
      'company_name_en': companyNameEnController.text,
      'contact_name': contactNameController.text,
      'contact_number': contactNumberController.text,
      'contact_email': contactEmailController.text,
      'location': locationController.text,
      'introduce': locationController.text,
      'password': passwordController.text,
      'confirmed_password': confirmedPasswordController.text,
    };
    var json = await DioManager()
        .kkRequest(Address.userCreateSupplier, bodyParams: params);
    if (json['code'] == 200) {
      BotToast.showText(text: '注冊成功');
      Get.back();
      Get.to(RegisterCompletePage());
    } else {
      BotToast.showText(text: json['message']);
    }
  }

  /// 上传一張图片
  List<Media> imageArr = [];
  selectImages() async {
    try {
      ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        showGif: false,
        selectCount: 1,
        showCamera: true,
        cropConfig: CropConfig(enableCrop: true, height: 1, width: 1),
        compressSize: 50,
        uiConfig: UIConfig(
          uiThemeColor: kDTCloud700,
        ),
      ).then((value) {
        imageArr.insertAll(0, value);
        setState(() {});
      });
    } on PlatformException {
      BotToast.showText(text: 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            text: '${I18nContent.signupLabel.tr} ',
                            style: Theme.of(context).textTheme.headlineSmall,
                            children: [
                              TextSpan(
                                  text: I18nContent.supplier.tr,
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                    color: kDTCloud500
                                  ))
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
                        style: Theme.of(context).textTheme.headlineSmall,
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
                        controller: userNameController,
                        decoration: InputDecoration(
                            hintText:
                            'Type in your user name(display in chatroom)',
                            border: InputBorder.none),
                      ),
                    ),
                    verify == false
                        ? SizedBox.shrink()
                        : userNameController.text.isEmpty
                        ? errorText()
                        : SizedBox.shrink(),

                    Container(
                      margin: EdgeInsets.only(left: 35, top: 25),
                      child: Text(
                        I18nContent.companyNameLocal.tr,
                        style: Theme.of(context).textTheme.headlineSmall,
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
                        controller: companyNameController,
                        decoration: InputDecoration(
                            hintText: 'Type in your company name',
                            border: InputBorder.none),
                      ),
                    ),
                    verify == false
                        ? SizedBox.shrink()
                        : companyNameController.text.isEmpty
                        ? errorText()
                        : SizedBox.shrink(),

                    Container(
                      margin: EdgeInsets.only(left: 35, top: 25),
                      child: Text(
                        I18nContent.companyNameEn.tr,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: HexColor('#F5F5F5'),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(5))),
                      margin: const EdgeInsets.only(left: 30, right: 35),
                      padding: const EdgeInsets.only(left: 15),
                      child: TextField(
                        controller: introduceController,
                        decoration: const InputDecoration(
                            hintText: 'Type in your company name(English)',
                            border: InputBorder.none),
                      ),
                    ),
                    verify == false
                        ? SizedBox.shrink()
                        : companyNameEnController.text.isEmpty
                        ? errorText()
                        : SizedBox.shrink(),

                    Container(
                      margin: EdgeInsets.only(left: 35, top: 25),
                      child: Text(
                        I18nContent.businessRegistrationNumber.tr,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: HexColor('#F5F5F5'),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(5))),
                      margin: const EdgeInsets.only(left: 30, right: 35),
                      padding: const EdgeInsets.only(left: 15),
                      child: const TextField(
                        decoration: InputDecoration(
                            hintText:
                            'Type in your business registration number name',
                            border: InputBorder.none),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 35, top: 25),
                      child: Text(
                        I18nContent.uploadBusinessRegistration.tr,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: (){
                        selectImages();
                      },
                      child: Container(
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
                                      style: size17SmailW700,textAlign:
                                    TextAlign.center,
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 35, top: 25),
                      child: Text(
                        I18nContent.companyLogo.tr,
                        style: Theme.of(context).textTheme.headlineSmall,
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
                        style: Theme.of(context).textTheme.headlineSmall,
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
                        style: Theme.of(context).textTheme.headlineSmall,
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
                        controller: contactNameController,
                        decoration: InputDecoration(
                            hintText: 'Type in your contact name',
                            border: InputBorder.none),
                      ),
                    ),
                    verify == false
                        ? SizedBox.shrink()
                        : contactNameController.text.isEmpty
                        ? errorText()
                        : SizedBox.shrink(),
                    Container(
                      margin: EdgeInsets.only(left: 35, top: 25),
                      child: Text(
                        I18nContent.contactNumber.tr,
                        style: Theme.of(context).textTheme.headlineSmall,
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
                        controller: contactNumberController,
                        decoration: InputDecoration(
                            hintText: 'Type in your contact number',
                            border: InputBorder.none),
                      ),
                    ),
                    verify == false
                        ? SizedBox.shrink()
                        : contactNumberController.text.isEmpty
                        ? errorText()
                        : SizedBox.shrink(),
                    Container(
                      margin: EdgeInsets.only(left: 35, top: 25),
                      child: Text(
                        'Location',
                        style: Theme.of(context).textTheme.headlineSmall,
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
                        controller: locationController,
                        decoration: InputDecoration(
                            hintText: 'Type in your Location',
                            border: InputBorder.none),
                      ),
                    ),
                    verify == false
                        ? SizedBox.shrink()
                        : locationController.text.isEmpty
                        ? errorText()
                        : SizedBox.shrink(),

                    Container(
                      margin: EdgeInsets.only(left: 35, top: 25),
                      child: Text(
                        I18nContent.primaryContactEmail.tr,
                        style: Theme.of(context).textTheme.headlineSmall,
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
                        controller: contactEmailController,
                        decoration: InputDecoration(
                            hintText: 'Type in your email',
                            border: InputBorder.none),
                      ),
                    ),
                    verify == false
                        ? SizedBox.shrink()
                        : contactEmailController.text.isEmpty
                        ? errorText()
                        : SizedBox.shrink(),
                    Container(
                      margin: EdgeInsets.only(left: 35, top: 25),
                      child: Text(
                        I18nContent.primaryContactPassword,
                        style: Theme.of(context).textTheme.headlineSmall,
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
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                            hintText: 'Type in your password',
                            border: InputBorder.none),
                      ),
                    ),
                    verify == false
                        ? SizedBox.shrink()
                        : passwordController.text.isEmpty
                        ? errorText()
                        : SizedBox.shrink(),

                    Container(
                      margin: EdgeInsets.only(left: 35, top: 25),
                      child: Text(
                        I18nContent.pleaseEnterYourPassword.tr,
                        style: Theme.of(context).textTheme.headlineSmall,
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
                        obscureText: true,
                        controller: confirmedPasswordController,
                        decoration: InputDecoration(
                            hintText: 'Type in your confirmed  password',
                            border: InputBorder.none),
                      ),
                    ),
                    verify == false
                        ? SizedBox.shrink()
                        : confirmedPasswordController.text.isEmpty
                        ? errorText()
                        : SizedBox.shrink(),
                    const SizedBox(
                      height: 50,
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
                    //         width: Get.width - 100,
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
                      setState(() {});
                      if (userNameController.text.isEmpty ||
                          companyNameController.text.isEmpty ||
                          contactNameController.text.isEmpty ||
                          contactNumberController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        return;
                      }
                      requestDataWithCreateSupplier();
                      // Get.to(VerificationCodePage());
                      setState(() {});
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
          ),
        )
    );
  }

  errorText() {
    return Padding(
      padding: EdgeInsets.only(
        left: 35,
      ),
      child: Text(
        I18nContent.errorText.tr,
        style: const TextStyle(fontSize: 12, color: Colors.red),
      ),
    );
  }
}
