import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/pages/chat_modules/category_model.dart';

import '../../services/address.dart';
import '../../services/dio_manager.dart';
import 'package:get/get.dart';

import 'create_category_page.dart';
class CateListPage extends StatefulWidget {
  const CateListPage({Key? key}) : super(key: key);

  @override
  State<CateListPage> createState() => _CateListPageState();
}

class _CateListPageState extends State<CateListPage> {

  /// 拉取分類列表
  int page = 1;
  CategoryModel? _categoryModel;
  requestDataWithCateList()async{
    var params = {
      'keyword':'',
      'page':page,
      'page_size':30
    };
    var json = await DioManager().kkRequest(Address.cateList, bodyParams: params);

    CategoryModel model = CategoryModel.fromJson(json);

    _categoryModel = model;

    setState(() {

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestDataWithCateList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Select Category'),
      ),
      body:SafeArea(
        child:  Column(
          children: [
            Expanded(child: ListView.builder(
              itemBuilder: (context,index){
                return GestureDetector(
                  onTap: (){
                    var params = {
                      'cate_id':_categoryModel?.data?.list?[index].cateId,
                      'cate_name':_categoryModel?.data?.list?[index].cateName
                    };
                    Get.back(result:params);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 15,),
                                alignment: Alignment.centerLeft,
                                height: 55,
                                child: Text('${_categoryModel?.data?.list?[index].cateName}'),
                              ),
                              Icon(Icons.arrow_forward_ios,size: 15,)

                            ],
                          ),
                        ),
                        Container(
                          color: kDTCloudGray,
                          height: 0.5,
                        )
                      ],
                    ),
                  ),
                );
              },itemCount: _categoryModel?.data?.list?.length??0,)),
            Container(
              color: Colors.white,
              height: 55,
              child: Center(
                child: MaterialButton(
                  onPressed: () async{
                    // Get.to(CreateNotePadPage());
                   var data = await Get.to(const CreateCategoryPage());
                   if(data == 'refresh'){
                     requestDataWithCateList();
                   }
                  },
                  color: kDTCloud700,
                  minWidth: Get.width - 80,
                  height: 45,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.
                      all(Radius.circular(22))),
                  child: Text(
                    'Create a Category',
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
