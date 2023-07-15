import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/services/dio_manager.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initPaymentSheet();
  }
  
  requestDataWithPayInfo()async{

    var params = {
      'plan':1,
      'token':''
    };
    var json = await DioManager().kkRequest('/api/v1/stripe.create',bodyParams:params);

  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [

        ],
      ),
    );
  }

}
