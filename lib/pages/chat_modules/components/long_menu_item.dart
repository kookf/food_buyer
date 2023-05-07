import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/utils/hexcolor.dart';
import 'package:get/get.dart';
class LongMenuItem extends StatefulWidget {

  VoidCallback? replyVoid;
  VoidCallback? forwardVoid;
  VoidCallback? copyVoid;
  VoidCallback? sendVoid;
  VoidCallback? reportVoid;
  VoidCallback? addToNotepadVoid;
  VoidCallback? deleteVoid;



   LongMenuItem(
      {this.addToNotepadVoid,Key? key}) : super(key: key);

  @override
  State<LongMenuItem> createState() => _LongMenuItemState();
}

class _LongMenuItemState extends State<LongMenuItem> {

  List item = ['Reply','Forward','Copy','Report','Add to Notepad','Delete'];
  List itemImg = ['ic_reply','ic_forward','ic_copy','ic_report','ic_add_to_notdpad','ic_delete'];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: HexColor('#EDEDED'),
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          width: 250,
          height: 280,
          child:ListView.builder(
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                Get.back();
                if(item[index]=='Add to Notepad'){
                  widget.addToNotepadVoid!();
                }

                print('${item[index]}');
                // BotToast.showText(text: item[index]);
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item[index],style: TextStyle(fontSize: 17,
                              fontWeight: FontWeight.w600,color:
                              index==4?AppColor.themeColor:
                              index==5?Colors.red:Colors.black),),
                          Image.asset('images/${itemImg[index]}.png',width: 25,height: 25,),
                        ],
                      ),
                    ),
                    index+1==item.length?SizedBox():Container(
                      height: 1,
                      color: AppColor.lineColor,
                    )
                  ],
                ),
              ),
            );
          },itemCount:item.length,),
        ),
      ),
    );
  }
}
