import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:get/get.dart';
import 'components/body.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);
  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> with TickerProviderStateMixin{

  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: 2, vsync: this);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(I18nContent.chatTitle.tr),
        actions: [
          TextButton(onPressed: (){

          }, child: Text(I18nContent.searchEdit.tr,
            style: const TextStyle(color: Colors.black),))
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 15),
              margin: const EdgeInsets.only(left: 15,right: 15),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: Colors.grey.shade200,
              ),
              height: 55,
              child: Row(
                children: [
                  Image.asset('images/ic_search.png',width: 25,height: 25,),
                  const SizedBox(width: 15,),
                   Expanded(child: TextField(
                     style:const TextStyle(
                       fontSize: 16
                     ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                      hintText: I18nContent.searchChat.tr,
                      hintStyle:const TextStyle(fontSize: 16,color: Colors.black),
                    ),
                  ))
                ],
              ),
            ),
          ),
          const SizedBox(height: 15,),
          Container(
            height: 50,
            color: Colors.white,
            child:  TabBar(
                controller: tabController,
                labelColor: Colors.blueAccent,
                unselectedLabelColor: Colors.grey,
                labelStyle:const TextStyle(fontSize: 18,fontWeight: FontWeight.w700),
                indicator: const BoxDecoration(),
                tabs: [
                  Text(I18nContent.chatIndividual.tr),
                  Text(I18nContent.chatQuotation.tr),
                ]),
          ),
          Expanded(child: EasyRefresh.custom(slivers: [
            SliverList(delegate:_mySliverChildBuildList())
          ]))
        ],
      ),
    );
  }
  SliverChildBuilderDelegate _mySliverChildBuildList (){
    return SliverChildBuilderDelegate((context, index) {
      return GestureDetector(
        onTap: (){
          Get.to(ChatPage());
        },
        child: Column(
          children: [
            Container(
              height: 100,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  const CircleAvatar(radius: 40,child: FlutterLogo(),),
                  Expanded(child: Container(
                    padding: const EdgeInsets.only(right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:const [
                            Text('Name'),
                            SizedBox(height: 25,),
                            Text('Messages'),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:const [
                            Text('Name'),
                            SizedBox(height: 25,),
                            Text('19:00'),
                          ],
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Container(
              color: Colors.grey,
              width: Get.width,
              height: 0.3,
            )
          ],
        ),
      );
    },childCount: 15);
  }
}
