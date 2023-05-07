import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/persisten_storage.dart';
import 'address.dart';
import 'package:get/get.dart';

class DioManager{

  static final DioManager _instance = DioManager._internal();

  factory DioManager() => _instance;

  DioManager._internal() {
    init();
  }

  late Dio dio;

  late BaseOptions baseOptions;

  init() {
    baseOptions = BaseOptions(
      baseUrl: Address.homeHost,
      connectTimeout: 5000,
    );
    dio = Dio(baseOptions);
  }

  Future kkRequest(
    String url, {
    bool isShowLoad = true,
    String method = 'post',
    Map<String, dynamic>? params,
    var bodyParams,
    String contentType = Headers.formUrlEncodedContentType,
    Map<String, dynamic>? header,
  }) async {
    if (await PersistentStorage().hasKey('urlStr')) {
      baseOptions.baseUrl = await PersistentStorage().getStorage('urlStr');
      print('baseOptions.baseUrl == ${baseOptions.baseUrl}');
    }
    if (isShowLoad == true) {
      BotToast.showCustomLoading(clickClose: true, toastBuilder: (void Function() cancelFunc) {
        return const CupertinoActivityIndicator();
      },backgroundColor: Colors.transparent);
    }

    Map<String, dynamic> baseHeader = {
      'Authorization': 'Bearer ${await PersistentStorage().getStorage('token')}',
    };

    print('baseHeader ================ $baseHeader');
    Options options =
        Options(method: method, contentType: contentType, headers: baseHeader);

    print(
        '请求地址 ==== ${baseOptions.baseUrl}$url 请求参数===== $params 请求body =====$bodyParams');

    try {
      var json = await dio.request(url,
          options: options, queryParameters: params, data: bodyParams);

      var s = jsonEncode(json.data);
      print('请求结果===== result.data ======= ${s}');

      if(json.data['code']==400){
        BotToast.showText(text: '${json.data['message']}');
        // Get.offNamed(AppRoutes.login);
      }
      BotToast.closeAllLoading();
      return json.data;
    } on DioError catch (error) {
      print('请求结果===== ${error}');

      if(error.response?.statusCode==302){

      }else if(error.response?.statusCode ==413){
        BotToast.showText(text: '上傳文件超出指定空間，請使用1MB或以下的相片');
      }

      BotToast.closeAllLoading();

      BotToast.showText(text: error.message);
    }
  }
}
