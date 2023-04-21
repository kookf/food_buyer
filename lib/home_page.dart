// import 'package:flutter/material.dart';
// import 'package:food_buyer/lang/message.dart';
// import 'package:get/get.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           TextButton(onPressed: ()async{
//             var locale = Locale('en', 'US');
//             await Get.updateLocale(locale);
//
//           }, child: Text('切换',style: TextStyle(color: Colors.red),))
//         ],
//       ),
//       body:  Column(
//         children: [
//           Text(I18nContent.bottomBarTQuotation.tr),
//         ],
//       ),
//     );
//   }
// }
