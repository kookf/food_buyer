import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/utils/hexcolor.dart';
import 'package:get/get.dart';

import '../../common/style.dart';
class MinePage extends StatefulWidget {

  const MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

final List<String> _tabs = <String>['About', 'Product','Posts',];
late TabController tabController;


class _MinePageState extends State<MinePage> with SingleTickerProviderStateMixin{




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: _tabs.length, vsync: this);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //
      // ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              height: Get.height/2-100,
              child: Stack(
                children: [
                  Container(
                    width: Get.width,
                    height: 200,
                    color: Colors.white,
                    child: Image.asset('images/ic_mine_bg.png',fit: BoxFit.fill,),
                  ),
                  Container(
                    alignment: Alignment(0,0),
                    child: CircleAvatar(
                      radius: 70,
                      child: FlutterLogo(size: 70,),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 220),
                    alignment: Alignment(0, 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Supplier Name',style: TextStyle(
                            fontSize: 22,fontWeight: FontWeight.w700,color: Colors.black
                        ),),
                        SizedBox(height: 10,),
                        Text('HONG KONG',style: TextStyle(
                            fontSize: 13,fontWeight: FontWeight.w700,color: Colors.grey
                        ),),
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              height: 100,
              child: Row(
                children: [
                  Expanded(flex: 3,child: Container(
                    margin: EdgeInsets.only(left: 5,right: 5),
                    child: MaterialButton(onPressed: (){
                    }, shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),child: Text('Messages',style: TextStyle(
                        color: Colors.white
                    ),),color: AppColor.themeColor,height: 55,),
                  ),),

                  Expanded(flex: 1,child: Container(
                    margin: EdgeInsets.only(left: 5,right: 5),
                    child: MaterialButton(onPressed: (){
                    },
                      child: Image.asset('images/ic_shard.png',width: 25,height: 25,),
                      color: HexColor('#eef2f8'),height: 55,),
                  ),),
                  Expanded(flex: 1,child: Container(
                    margin: EdgeInsets.only(left: 5,right: 5),
                    child: MaterialButton(onPressed: (){
                    },
                      child: Image.asset('images/ic_like.png',width: 25,height: 25,),
                      color: HexColor('#e9e9e9'),height: 55,),
                  ),),
                ],
              ),
            ),
          ),
          _buildStickBox(),
         SliverPadding(padding:EdgeInsets.only(left: 15,right: 15),
           sliver:  SliverToBoxAdapter(
           child:  waterFallList(),
         ),)
        ],
      ),
    );
  }
  Widget waterFallList(){
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


  Widget _buildStickBox() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: FixedPersistentHeaderDelegate(height: 54),
    );
  }
}

class FixedPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;

  FixedPersistentHeaderDelegate({required this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      alignment: Alignment.center,
      color: Colors.white,
      child: buildTabBar()
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant FixedPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.height != height;
  }
  Widget buildTabBar(){
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
        ),
        // indicator: const BubbleTabIndicator(
        //     indicatorHeight: 45.0,
        //     indicatorColor: Colors.yellow,
        //     tabBarIndicatorSize: TabBarIndicatorSize.tab,
        //     // Other flags
        //     indicatorRadius: 8,
        //     insets: EdgeInsets.all(1),
        //     padding: EdgeInsets.all(155)
        // ),
        isScrollable: false,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700,fontSize: 18),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18),
        unselectedLabelColor: Colors.grey,
        labelColor: AppColor.themeColor,
        tabs: _tabs.map((String name) =>
            Tab(text: name)).toList(),
        controller: tabController,
      ),
    );
  }

}
