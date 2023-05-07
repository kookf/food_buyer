import 'package:flutter/material.dart';
import 'package:food_buyer/utils/hexcolor.dart';
import 'colors.dart';

final ThemeData appThemeData = ThemeData(
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColor.themeColor,
    selectionColor:  AppColor.smallTextColor,
    selectionHandleColor:  AppColor.smallTextColor,
  ),
  hintColor: AppColor.smallTextColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: _appbarTheme(),
  iconTheme: const IconThemeData(
      color: Colors.blueAccent
  ),
  textTheme:TextTheme(
      bodyText1: TextStyle(color: AppColor.textColor,fontSize: 16),
      subtitle1: TextStyle(color: AppColor.smallTextColor,fontSize: 12)
  ),

);

AppBarTheme _appbarTheme() {
  return  const AppBarTheme(
    centerTitle: true,
    // color: new Color.fromRGBO(38,116,251,1),
    backgroundColor: Colors.white,
    // color: HexColor('#2A39E1'),
    elevation: 0,
    titleTextStyle:  TextStyle(fontSize: 18,color: Colors.black,
        fontWeight: FontWeight.w600),
    iconTheme: IconThemeData(color:Colors.black87),  // 图标

  );
}