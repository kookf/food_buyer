import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_buyer/lang/message.dart';
import 'package:get/get.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

import '../../common/colors.dart';
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
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            color: Colors.white,
            width: Get.width,
            padding: EdgeInsets.only(left: 15),
            height: 80,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(child: Text(I18nContent.appTitleLabel,style: TextStyle(fontWeight: FontWeight.w600,
                    fontSize: 22
                ),),flex: 3,),
                Expanded(flex: 1,child:
                Center(
                  child: Container(
                    width: 50,height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Icon(Icons.search)
                  ),
                ),)
              ],
            )
          ),
          buildTabBar(),
          Expanded(child: Container(
            padding: EdgeInsets.all(0),
            color: Colors.white,
            child: EasyRefresh.custom(
              slivers: [
                SliverPadding(padding: EdgeInsets.all(0),
                  sliver: SliverFillRemaining(
                  child:waterFallList() ,
                ),
                )
              ],
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

  Widget waterFallList(){
    return MasonryGridView.count(
      // shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
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
          color: Colors.white,
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

}




