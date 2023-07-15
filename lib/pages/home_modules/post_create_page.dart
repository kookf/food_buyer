import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/pages/home_modules/post_cate_modules/post_cate_page.dart';
import 'package:food_buyer/services/address.dart';
import 'package:food_buyer/services/dio_manager.dart';
import 'package:image_pickers/image_pickers.dart';
import '../../components/tag_inputfield.dart';
import '../../lang/message.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/utils.dart';
import 'package:get/route_manager.dart';

class PostCreatePage extends StatefulWidget {
  const PostCreatePage({Key? key}) : super(key: key);

  @override
  State<PostCreatePage> createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String cateIds = '-1';
  String tag = '';
  int resType = 0; /// 0 无 1 单图 2 多图 3 视频 4 視頻鏈接
  String cateName = '請選擇一個類別';
  bool isProduct = false;

  final TextEditingController _copyController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  /// 獲取文件地址
  Future<List> requestDataWithPath() async {

    List pathArr = [];

    imageArr.removeWhere((element) => element.path =='images/photo_add.png');

    for(int i = 0;i<imageArr.length;i++){
      MultipartFile multipartFile = MultipartFile.fromFileSync(
        '${imageArr[i].path}',
      );
      FormData formData = FormData.fromMap({
        'dir': 'image',
        'type': 'image',
        'file': multipartFile,
      });
      var json =
      await DioManager().kkRequest(Address.upload, bodyParams: formData,
          isShowLoad: true);

      pathArr.add(json['data']['path'],);
    }

    return pathArr;
  }

  requestDataWithPost(String res)async{

    var params = {
      'title':_titleController.text,
      'body':_bodyController.text,
      'cate_ids':cateIds,
      'tag':tag,
      'is_product':isProduct==false?0:1,
      'price':_priceController.text,
      'res_type':resType,
      'res':res,
      'res_link':resType==4?_copyController.text:'',
    };
    var json = await DioManager().kkRequest(Address.postCreate,bodyParams: params);
    if(json['code'] == 200){
      BotToast.showText(text: '創建成功');
    }else{
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
  /// 上传多張图片
  selectMultipleImage()async{
    try {
      ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        showGif: false,
        selectCount: 9,
        showCamera: true,
        cropConfig: CropConfig(enableCrop: true, height: 1, width: 1),
        compressSize: 50,
        uiConfig: UIConfig(
          uiThemeColor: kDTCloud700,
        ),
      ).then((value) {
        imageArr.insertAll(0, value);
        setState(() {

        });
      });
    } on PlatformException {
      BotToast.showText(text: 'error');
    }
  }

  /// 上傳視頻

  selectVideo()async{
    try {
      ImagePickers.pickerPaths(
        galleryMode: GalleryMode.video,
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
        setState(() {

        });
      });
    } on PlatformException {
      BotToast.showText(text: 'error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Media e = Media();
    e.path = 'images/photo_add.png';
    imageArr.insert(0, e);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18nContent.post.tr),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.only(left: 15,right: 15),
                children: [
                  Container(
                      color: Colors.white,
                      width: Get.width,
                      padding: const EdgeInsets.only(left: 0,top: 10,right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(I18nContent.selectPicture.tr,style: Theme.of(context).textTheme
                            .headlineSmall,),
                          const SizedBox(height: 15,),
                          GridView.builder(
                            padding: const EdgeInsets.only(top: 5),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 1),
                            itemBuilder: (context, a) {
                              return GestureDetector(
                                  onTap: (){
                                    if(imageArr.length==a+1){
                                      Get.bottomSheet(Container(
                                          height: 300,
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text(I18nContent.selectAPicture.tr),
                                                onTap: (){
                                                  Get.back();
                                                  resType = 1;
                                                  selectImages();
                                                },
                                                trailing: const Icon(Icons.arrow_forward_ios,size: 15,),
                                              ),
                                               ListTile(
                                                onTap: (){
                                                  Get.back();
                                                  resType = 2;
                                                  selectMultipleImage();
                                                },
                                                title: Text(I18nContent.selectMultipleImages.tr),
                                                trailing: const Icon(Icons.arrow_forward_ios,size: 15,),
                                              ),
                                               ListTile(
                                                onTap: (){
                                                  // Get.back();
                                                  resType = 3;
                                                  BotToast.showText(text: '暫時不能上傳視頻');
                                                  return;
                                                  selectVideo();
                                                },
                                                title: Text(I18nContent.selectVideo.tr),
                                                trailing: const Icon(Icons.arrow_forward_ios,size: 15,),
                                              ),
                                              ListTile(
                                                onTap: (){
                                                  Get.back();
                                                  resType = 4;
                                                  selectImages();
                                                },
                                                title: Text(I18nContent.uploadAVideoLinkMainImage.tr),
                                                trailing: const Icon(Icons.arrow_forward_ios,size: 15,),
                                              ),
                                              MaterialButton(onPressed: (){
                                                Get.back();
                                              },color: kDTCloud700,
                                                minWidth: Get.width-50,height: 45,
                                              child: Text(I18nContent.searchCancel.tr,style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                color: Colors.white
                                              ),),
                                              ),
                                            ],
                                          ),
                                        ));
                                    }else{
                                      List<String?> path = imageArr.map((e) => e.path).toList();

                                      path.removeWhere((element) => element=='images/photo_add.png');
                                      ImagePickers.previewImages(path, a);
                                    }
                                  },
                                  child:Stack(
                                    fit: StackFit.expand,
                                    // alignment: Alignment.bottomRight,
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        child:imageArr.length==a+1?
                                        Image.asset('images/photo_add.png'):
                                        Image.file(File(imageArr[a].thumbPath!),fit: BoxFit.cover,
                                        ),
                                      ),
                                      imageArr.length!=a+1?GestureDetector(
                                        onTap: (){
                                          Get.defaultDialog(
                                            title: '提示',
                                            content: const Text('是否要刪除當前圖片'),
                                            cancel: MaterialButton(onPressed: (){
                                              Get.back();
                                            },child: Text('取消',style: Theme.of(context).textTheme.titleSmall!.copyWith(

                                            ),),),
                                            confirm: MaterialButton(onPressed: (){
                                              imageArr.removeAt(a);
                                              Get.back();
                                              setState(() {

                                              });
                                            },
                                              child: Text('確定',style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                  color: Colors.red
                                              ),),
                                            ),
                                          );
                                        },
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child:Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),
                                            height: 20,
                                            width: 20,
                                            child: Image.asset('images/delete.png',
                                              width: 10,height: 10,color:
                                              Colors.white,scale: 15,),
                                          ),
                                        ),
                                      ):
                                      const SizedBox()
                                    ],
                                  )
                              );
                            },itemCount:resType==1?1:resType==2?
                          imageArr.length>9?9:imageArr.length:1),
                          const Padding(
                            padding:EdgeInsets.only(left: 8,top: 10,bottom: 10),
                            child: Text('注：0 - 9張圖片',),
                          )
                        ],
                      )),

                  resType==4?TextField(
                    controller:_copyController,
                    onChanged: (value){
                      print(GetUtils.isURL(value));
                      if(GetUtils.isURL(value)==false){
                        BotToast.showText(text: '請輸入正確的地址');
                        _copyController.text = '';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: '輸入YouTube視頻地址',
                      suffixIcon: IconButton( onPressed: ()async {
                        ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
                        if (data != null) {
                          setState(() {
                            if(GetUtils.isURL(data.text!)==false){
                              BotToast.showText(text: '請輸入正確的地址');
                              _copyController.text = '';
                              return;
                            }
                            _copyController.text = data.text ?? '';
                          });
                        }
                      }, icon: Icon(Icons.copy),color: Colors.red,)
                    ),
                  ):SizedBox(),
                  Container(
                    height: 45,
                    child: TextFormField(
                      controller: _titleController,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      decoration:  InputDecoration(
                        border: InputBorder.none,
                        hintText: resType == 4?'請填寫視頻標題':'請填寫標題',
                        errorBorder: InputBorder.none
                      ),
                    ),
                  ),

                  Container(
                    height: 0.5,
                    color: kDTCloudGray,
                  ),
                  Container(
                    height: 100,
                    child: TextField(
                      controller: _bodyController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '請填寫內容',
                      ),
                      maxLines: 5,
                    ),
                  ),
                  Container(
                    height: 0.5,
                    color: kDTCloudGray,
                  ),

                  GestureDetector(
                    onTap: ()async{
                      Get.bottomSheet(
                        Container(
                          height: 200,
                          width: Get.width,
                          color: Colors.white,
                          child: Column(
                            children: [
                             Expanded(child: TextButton(onPressed: ()async{
                               Get.back();
                               var data = await Get.to(PostCatePage(isProduct: 1,));
                               if(data != null ){
                                 print('data === = ${data}');
                                 cateName = data['nameArr'].join(',');
                                 cateIds = data['cateIdArr'].join(',');
                                 // cateName = data['cateName'];
                                 // cateId = data['cateId'];
                                 setState(() {

                                 });
                               }
                             },
                               child: Text('商品類別'),),),
                             Expanded(child: TextButton(onPressed: ()async{
                               Get.back();
                               var data = await Get.to(PostCatePage(isProduct: 0,));
                               if(data != null ){
                                 print('data === = ${data}');
                                 cateName = data['nameArr'].join(',');
                                 cateIds = data['cateIdArr'].join(',');
                                 // cateName = data['cateName'];
                                 // cateId = data['cateId'];
                                 setState(() {

                                 });
                               }
                             },child: Text('文章類別'),),),
                            ],
                          ),
                        )
                      );

                    },
                    child: Container(
                      color: Colors.transparent,
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(cateName,maxLines: 2,),),
                          Icon(Icons.arrow_forward_ios,size: 15,),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 0.5,
                    color: kDTCloudGray,
                  ),
                  Container(
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('是否是商品(默認文章)'),
                        Switch(
                          // This bool value toggles the switch.
                          value: isProduct,

                          activeColor: kDTCloud700,
                          onChanged: (bool value) {
                            // This is called when the user toggles the switch.
                            setState(() {
                              // if (value == false) {
                              //   var locale = Locale('en', 'US');
                              //   Get.updateLocale(locale);
                              // } else {
                              //   var locale = Locale('zh', );
                              //   Get.updateLocale(locale);
                              // }
                              isProduct = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    height: 0.5,
                    color: kDTCloudGray,
                  ),

                  isProduct==false?
                  const SizedBox():
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 65,
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(7),
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],

                      decoration: const InputDecoration(
                        labelText: 'Price',
                        prefixText: 'HK',
                        // border: OutlineInputBorder(),
                        // errorBorder: OutlineInputBorder(
                        //
                        // )
                      ),

                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price';
                        }
                        // 可以添加其他自定义验证逻辑，例如检查是否是有效的价格格式
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15,),
                  TagInputField(onTagsChanged: (List<String> value) {
                    print(value);
                    tag = value.join(',');
                  },),
                ],
              ),
            )),
            Container(
              height: 55,
              child: Center(
                child: MaterialButton(
                  onPressed: () {
                    if(_titleController.text.isEmpty||_bodyController.text.isEmpty){
                      BotToast.showText(text: '請輸入詳細內容');
                      return;
                    }
                    if(cateIds =='-1'){
                      BotToast.showText(text: '請選擇一個類別');
                      return;
                    }
                    requestDataWithPath().then((value) {
                      requestDataWithPost(value.join(','));
                    });
                  },
                  color:kDTCloud900,
                  minWidth: Get.width - 80,
                  height: 45,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22))),
                  child: Text(
                    I18nContent.sendRequest.tr,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

