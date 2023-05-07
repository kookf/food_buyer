import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:food_buyer/pages/home_modules/home_detail_page.dart';
import 'package:get/get.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:easy_refresh/easy_refresh.dart';

import '../../common/colors.dart';
import '../../common/style.dart';
import '../../components/custom_tabbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{


  final List<String> _tabs = <String>['All', 'Latest','Most View',];
  late TabController tabController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: _tabs.length, vsync: this);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).
            padding.top),
            color: Colors.white,
            width: Get.width,
            padding: EdgeInsets.only(left: 15,right: 15),
            height: 80,
            child: Row(
              children: [
                Expanded(child: Text(I18nContent.appTitleLabel,style: TextStyle(fontWeight: FontWeight.w600,
                    fontSize: 22
                ),),flex: 3,),
                Center(
                  child: Container(
                      width: 50,height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Icon(Icons.search)
                  ),
                ),
              ],
            )
          ),
          buildTabBar(),
          Expanded(child: Container(
            padding: EdgeInsets.all(0),
            color: Colors.white,
            child: EasyRefresh(
              onRefresh: ()async{

              },
               child: CustomScrollView(
                 keyboardDismissBehavior:ScrollViewKeyboardDismissBehavior.onDrag ,
                 slivers: [
                   SliverPadding(padding: EdgeInsets.all(10),
                     sliver: SliverFillRemaining(
                       child:waterFallList1() ,
                     ),
                   )
                 ],
               ),
            ),
          ))
        ],
      ),
    );
  }

  Widget buildTabBar(){
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: const BubbleTabIndicator(
            indicatorHeight: 45.0,
            indicatorColor: Colors.black,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
            // Other flags
            indicatorRadius: 8,
            insets: EdgeInsets.all(1),
            padding: EdgeInsets.all(155)
        ),
        isScrollable: true,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18),
        unselectedLabelColor: Colors.black,
        labelColor: Colors.white,
        tabs: _tabs.map((String name) =>
            Tab(text: name)).toList(),
        controller: tabController,
      ),
    );
  }

  Widget waterFallList1(){
    return StaggeredGrid.count(crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('images/ic_mine1.png'),
                Text('Unknown Title',style: itemTitleStyle),
                Text('Unknown Title 123',style: itemTitleStyle),
              ],
            )
        ),
        Container(
            color: Colors.white,
            child: Column(
              children: [
                Image.asset('images/ic_mine2.png'),
                Text('Unknown Title',style: itemTitleStyle),
                Text('Unknown Title 123',style: itemTitleStyle),
              ],
            )
        ),
        Container(
            color: Colors.white,
            child: Column(
              children: [
                Image.asset('images/ic_mine2.png'),
                Text('Unknown Title',style: itemTitleStyle),
                Text('Unknown Title 123',style: itemTitleStyle),
              ],
            )
        ),
        Container(
            color: Colors.white,
            child: Column(
              children: [
                Image.asset('images/ic_mine2.png'),
                Text('Unknown Title',style: itemTitleStyle),
                Text('Unknown Title 123',style: itemTitleStyle),
              ],
            )
        ),

        Text('data'),
        Text('data'),
      ],);
    return
      // GridView.builder(
      // padding: const EdgeInsets.all(5),
      // shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 2,
      //     crossAxisSpacing: 5,
      //     mainAxisSpacing: 5,
      //     childAspectRatio: 1
      // ),
      // itemBuilder:(context,index) {
      //   return Container(
      //     color: Colors.blue,
      //   );
      // },itemCount: 20,);
      MasonryGridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        padding: EdgeInsets.only(left: 0,right: 0,top: 0),
        itemBuilder: (context, index) {
          return index ==0?Container(
            // height: 360,
            color: Colors.white,
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.all(5),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('images/banner1.png'),
                  SizedBox(height: 5,),
                  Text('This is A Label',style: TextStyle(fontWeight: FontWeight.w700),),
                  SizedBox(height: 5,),
                  Text('This is A Label',style: TextStyle(fontWeight: FontWeight.w700),),
                  SizedBox(height: 5,),
                  Row(children: [
                    CircleAvatar(child: FlutterLogo(),radius: 15,),
                    SizedBox(width: 5,),
                    Text('Jack Ma',style: TextStyle(color: Colors.grey,fontSize: 13),),
                  ],)
                ],
              ),
            ),
          ):Container(
            height: 330,
            color: Colors.yellow,
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.all(5),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Image.asset('images/banner2.png'),
            ),
          );
        },
      );

  }

  Widget waterFallList(){
    return MasonryGridView.count(
      // shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      padding: EdgeInsets.only(left: 0,right: 0,top: 0),
      itemBuilder: (context, index) {

        return index ==0?
       GestureDetector(
         onTap: (){
           Get.to(HomeDetailPage());

         },
         child:  Container(
           // height: 360,
           color: Colors.white,
           alignment: Alignment.topCenter,
           child: Container(
             margin: EdgeInsets.all(5),
             clipBehavior: Clip.hardEdge,
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.all(Radius.circular(5))
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Image.asset('images/banner1.png',
                   cacheWidth: 300,height: 300,),
                 SizedBox(height: 5,),
                 Text('This is A Label',style: TextStyle(fontWeight: FontWeight.w700),),
                 SizedBox(height: 5,),
                 Text('This is A Label',style: TextStyle(fontWeight: FontWeight.w700),),
                 SizedBox(height: 5,),
                 Row(children: [
                   CircleAvatar(child: FlutterLogo(),radius: 15,),
                   SizedBox(width: 5,),
                   Text('Jack Ma',style: TextStyle(color: Colors.grey,fontSize: 13),),
                 ],)
               ],
             ),
           ),
         ),
       ):
        GestureDetector(
          onTap: (){
            Get.to(HomeDetailPage());
          },
          child: Container(
            height: 330,
            color: Colors.white,
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.all(5),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Image.asset('images/banner2.png',cacheWidth: 300,
                height: 300,),
            ),
          ),
        );
      },
    );

  }

}




