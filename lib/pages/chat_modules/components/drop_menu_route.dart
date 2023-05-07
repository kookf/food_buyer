import 'package:flutter/material.dart';

///自定义下拉弹窗  实现思路：
///通过自定义路由继承自PopupRoute,并结合Navigator.push使弹出的下拉列表能够覆盖在当前页面显示
///使用CustomSingleChildLayout组件,自定义SingleChildLayoutDelegate并结合RelativeRect来控制下拉列表显示的位置和高度
/// 使用SizeTransition实现下拉列表的下拉动画效果
class DropDownMenuRoute extends PopupRoute {
  ///点击控件的相对位置信息
  final Rect position;
  ///下拉控件高度
  final double menuHeight;
  ///下拉控件宽度
  final double menuWidth;
  ///弹窗控件布局
  final Widget itemView;
  ///偏移量
  final double offset;
  ///构造方法
  DropDownMenuRoute({required this.position,required this.menuWidth, required this.menuHeight,
    required this.offset,required this.itemView});

  @override
  // TODO: implement barrierColor
  Color? get barrierColor => const Color(0x80000000);

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return CustomSingleChildLayout(
      delegate: DropDownMenuRouteLayout(position: position,
          menuWidth: menuWidth, menuHeight: menuHeight,offset:offset),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0
        ).animate(animation),
        child: itemView,
      ),
      ///这里加入了下拉动画
      // child: SizeTransition(
      //   sizeFactor: Tween<double>(
      //       begin: 1.0,
      //       end: 1.0
      //   ).animate(animation),
      //   ///这里写具体布局，通过外面传入
      //   child:itemView,
      // ),
    );
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(milliseconds: 300);

}
///下拉选择布局控制器
class DropDownMenuRouteLayout extends SingleChildLayoutDelegate {
  final Rect position;
  final double menuHeight;
  final double menuWidth;
  final double offset;
  DropDownMenuRouteLayout({required this.position,required this.menuWidth, required this.menuHeight,required this.offset});

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    ///控制下拉控件的宽高

    return BoxConstraints.loose(Size(menuWidth, menuHeight));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    ///控制下拉控件显示位置，这里始终居于点击控件的下方
    return Offset(offset, position.bottom+5);
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    // TODO: implement shouldRelayout
    return true;
  }

}