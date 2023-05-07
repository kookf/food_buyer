import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../common/style.dart';
class SubAccountManagermentPage extends StatefulWidget {
  const SubAccountManagermentPage({Key? key}) : super(key: key);

  @override
  State<SubAccountManagermentPage> createState() => _SubAccountManagermentPageState();
}

class _SubAccountManagermentPageState extends State<SubAccountManagermentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub-Account'),
        actions: [
          TextButton(onPressed: (){

          }, child: Text('Edit'))
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ListView.builder(
            padding: EdgeInsets.only(top: 15),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: (){
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
                              CircleAvatar(
                                child: Image.asset('images/ploder_header.png'),
                              ),
                              const SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Company Name',style: TextStyle(
                                      fontSize: 18,fontWeight: FontWeight.w600
                                  ),),
                                  const SizedBox(height: 5,),
                                  Text('Hong Kong',style: TextStyle(color: AppColor.smallTextColor),),
                                ],
                              ),
                            ],
                          ),
                          Image.asset('images/ic_arrow_right.png',width: 10,height: 10,)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: AppColor.lineColor,
                    height: 1,
                  )
                ],
              );
            },
            itemCount: 5,)),
          Container(
            color: Colors.white,
            height: 80,
            child:Center(
              child:  Container(
                height: 65,
                margin: EdgeInsets.only(left: 35, right: 25),
                padding: EdgeInsets.only(right: 0),
                child: DottedBorder(
                  color: Colors.grey,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(4),
                  strokeWidth: 0.5,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Add Sub-accounts',
                              style: TextStyle(fontSize: 14,
                                  color: AppColor.smallTextColor,
                              fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 25,),
                            Image.asset('images/ic_add.png',
                              width: 25,height: 25,),

                          ],
                        ),
                      )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
