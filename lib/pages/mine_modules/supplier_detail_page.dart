import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/filter_search_module/supplier_info_model.dart';
import 'package:get/get.dart';

import '../../common/foodbuyer_colors.dart';
import '../../services/address.dart';

class SupplierDetailPage extends StatefulWidget {

  SupplierInfoModel? supplierInfoModel;

   SupplierDetailPage(this.supplierInfoModel, {Key? key}) : super(key: key);

  @override
  State<SupplierDetailPage> createState() => _SupplierDetailPageState();
}

class _SupplierDetailPageState extends State<SupplierDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18nContent.information.tr),
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment(0, 0.2),
            child: Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                color: kDTCloud50,
                borderRadius:
                BorderRadius.all(Radius.circular(60)),
              ),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                imageUrl:
                '${Address.storage}/'
                    '${widget.supplierInfoModel?.data?.avatar}',
                fit: BoxFit.contain,
                progressIndicatorBuilder:
                    (context, url, downloadProgress) =>
                    CircularProgressIndicator(
                        value: downloadProgress.progress),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(height: 5,),
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Text('${widget.supplierInfoModel?.data?.supplierName}',
            style: Theme.of(context).textTheme.headlineSmall,),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('HONG KONG',style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: kDTCloudGray
            ),),
          ),
          Container(
            margin: const EdgeInsets.only(left: 35, right: 35,top: 25),
            child: MaterialButton(
              onPressed: () {

              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              color: kDTCloud700,
              height: 55,
              child: Text(
                I18nContent.goToProfile.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.only(left: 5),
            margin: EdgeInsets.only(left: 35,right: 35,top: 15),
            decoration: BoxDecoration(
              border: Border.all(width: 0.5,color: kDTCloudGray),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            // height: 115,
            child: TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: '请输入',
                border: InputBorder.none
              ),
            ),
          ),
          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            height: 40,
            color: kDTCloud50,
            child: Text('General information',style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: kDTCloud700
            ),),
          ),
          SizedBox(height: 10,),
          Container(
            child: ListTile(
              leading: Image.asset('images/ic_picture.png',width: 45,height: 45,),
              title: Text('Media,Link',style: Theme.of(context).textTheme.bodyLarge,),
              trailing: Icon(Icons.arrow_forward_ios,size: 15,),
              onTap: (){

              },
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            height: 40,
            color: kDTCloud50,
            child: Text('Participants in the message',style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: kDTCloud700
            ),),
          ),
          Container(
            height: 170,
            color: Colors.white,
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemBuilder: (context,index){
                return Container(
                  child:Container(
                    child: ListTile(
                      leading: Image.asset('images/ic_picture.png',width: 45,height: 45,),
                      title: Text('Media,Link',style: Theme.of(context).textTheme.bodyLarge,),
                      subtitle: Text('HONG KONG',style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: kDTCloudGray
                      ),),
                      onTap: (){

                      },
                    ),
                  ) ,
                );
              },itemCount: 2,),
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            height: 40,
            color: kDTCloud50,
            child: Text('Settings',style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: kDTCloud700
            ),),
          ),
          Container(
            child: ListTile(
              leading: Image.asset('images/ic_block_account.png',width: 45,height: 45,),
              title: Text('Block this Account',style: Theme.of(context).textTheme.bodyLarge,),
              trailing: Icon(Icons.arrow_forward_ios,size: 15,),
              onTap: (){

              },
            ),
          ),
          Container(
            child: ListTile(
              leading: Image.asset('images/ic_report_account.png',width: 45,height: 45,),
              title: Text('Block this Account',style: Theme.of(context).textTheme.bodyLarge,),
              trailing: Icon(Icons.arrow_forward_ios,size: 15,),
              onTap: (){

              },
            ),
          ),
        ],
      ),
    );
  }
}
