import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:food_buyer/utils/event_utils.dart';
import 'package:food_buyer/utils/hexcolor.dart';
import 'package:get/utils.dart';
import 'package:image_pickers/image_pickers.dart';
import '../../common/colors.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';


class AccountProfilePage extends StatefulWidget {

  const AccountProfilePage({Key? key}) : super(key: key);
  @override
  State<AccountProfilePage> createState() => _AccountProfilePageState();
}

class _AccountProfilePageState extends State<AccountProfilePage> {


  TextEditingController companyController =TextEditingController();
  TextEditingController nicknameController =TextEditingController();
  TextEditingController descriptionController =TextEditingController();
  TextEditingController emailController =TextEditingController();
  TextEditingController supplierNameController =TextEditingController();

  //
  /// 獲取文件地址
  Future requestDataWithPath(var value)async{
    MultipartFile multipartFile = MultipartFile.fromFileSync(
      '${value[0].path}',
    );
    FormData formData = FormData.fromMap({
      'dir':'image',
      'type':'image',
      'file':multipartFile,
    });
    var json = await DioManager().kkRequest(Address.upload,bodyParams:formData);
    return json;
  }

  ///上传头像
  requestDataWithUploadAvatar(avatar)async{
    var params = {
      'avatar':avatar
    };
    var json = await DioManager().kkRequest(Address.updateAvatar,
        bodyParams: params);
    if(json['code'] == 200){
        BotToast.showText(text: '上传成功');
        requestDataWithProfile();
    }else{
      BotToast.showText(text: json['message']);
    }
  }
  /// 上传图片
  selectImages() async {
    ImagePickers.pickerPaths(
      galleryMode: GalleryMode.image,
      showGif: false,
      selectCount: 1,
      showCamera: true,
      cropConfig: CropConfig(enableCrop: true,
          height: 1, width: 1),
      compressSize: 300,
      uiConfig: UIConfig(
        uiThemeColor: AppColor.themeColor,
      ),
    ).then((value) {
      requestDataWithPath(value).then((json1) {
        requestDataWithUploadAvatar(json1['data']['path'],);
      });

      setState(() {

      });
    });
  }


  /// 获取个人信息
  ProfileModel? profileModel;
  requestDataWithProfile()async{
    var json = await DioManager().kkRequest(Address.userProfile,);
    ProfileModel model = ProfileModel.fromJson(json);
    profileModel = model;

    companyController.text = '${profileModel?.data?.name}';
    nicknameController.text = '${profileModel?.data?.nickName}';
    emailController.text = '${profileModel?.data?.email}';


    setState(() {

    });
  }

  /// 修改信息
  requestDataWithUserSave(var nickName)async{
    var params = {
      'nick_name':nickName,
    };
    var json = await DioManager().kkRequest(Address.userSave,bodyParams: params);

    if(json['code']==200){
      BotToast.showText(text: '修改成功');
    }else{
      BotToast.showText(text: json['message']);
    }
    EventBusUtil.fire('menuRefresh');

    requestDataWithProfile();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithProfile();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: (){

          }, child: Text(I18nContent.done.tr))
        ],
        title: Text(I18nContent.accountProfile.tr),
      ),
      body: Container(
        color: AppColor.bgColor,
        child: ListView(
          padding: const EdgeInsets.only(top: 20),
          children: [
            GestureDetector(
              onTap: (){
                selectImages();
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          const Text('Click to edit your '
                              'profile picture',style: TextStyle(
                              fontSize: 15,fontWeight: FontWeight.w600
                          ),),
                          Text('角色:${profileModel?.data?.type==1?'個人':
                          profileModel?.data?.type == 2?'公司':'供應商'
                          }',style: TextStyle(fontWeight: FontWeight.w600),)
                        ],)
                      ],
                    ),
                    Image.asset('images/ic_arrow_right.png',
                      width: 10,height: 10,)
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    padding: EdgeInsets.only(left: 25),
                    width: Get.width,
                    height: 30,
                    alignment: Alignment.centerLeft,
                    child: Text('公司名稱',style: TextStyle(color: AppColor.themeColor),),
                    color: HexColor('#EDF2F9'),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 25),
                    width: Get.width,
                    height: 45,
                    child: TextField(
                      enabled: false,
                      controller: supplierNameController..text
                      = '${profileModel?.data?.supplier_name}',
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your company name',
                      ),
                    ),
                  )

                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    padding: EdgeInsets.only(left: 25),
                    width: Get.width,
                    height: 30,
                    alignment: Alignment.centerLeft,
                    child: Text('Email',style: TextStyle(color: AppColor.themeColor),),
                    color: HexColor('#EDF2F9'),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 25),
                    width: Get.width,
                    height: 45,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your company name',
                      ),
                    ),
                  )

                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 25),
                    width: Get.width,
                    height: 30,
                    alignment: Alignment.centerLeft,
                    child: Text('Nick name',style: TextStyle(color: AppColor.themeColor),),
                    color: HexColor('#EDF2F9'),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25),
                    width: Get.width,
                    height: 45,
                    color: Colors.white,
                    child: TextField(
                      controller: nicknameController,
                      onSubmitted: (value){
                        requestDataWithUserSave(value);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your nick name',
                      ),
                    ),
                  )

                ],
              ),
            ),

            // Container(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Container(
            //         padding: EdgeInsets.only(left: 25),
            //         width: Get.width,
            //         height: 30,
            //         alignment: Alignment.centerLeft,
            //         child: Text('desc',style: TextStyle(color: AppColor.themeColor),),
            //         color: HexColor('#EDF2F9'),
            //       ),
            //       Container(
            //         padding: EdgeInsets.only(left: 25),
            //         width: Get.width,
            //         color: Colors.white,
            //         height: 150,
            //         child: TextField(
            //           controller: descriptionController,
            //           decoration: InputDecoration(
            //             border: InputBorder.none,
            //             hintText: 'Enter your user name',
            //           ),maxLines: 5,
            //         ),
            //       )
            //     ],
            //   ),
            // ),

          ],
        ),
      )
    );
  }
}

class ProfileModel {
  int? code;
  String? message;
  Data? data;

  ProfileModel({this.code, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? avatar;
  String? email;
  String? phone;
  String? nickName;
  int? type;
  var supplier_name;

  Data(
      {this.id,
        this.name,
        this.avatar,
        this.email,
        this.phone,
        this.nickName,
        this.supplier_name,
        this.type});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    email = json['email'];
    phone = json['phone'];
    nickName = json['nick_name'];
    supplier_name = json['supplier_name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['nick_name'] = this.nickName;
    data['type'] = this.type;
    return data;
  }
}
