import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe_payment/flutter_stripe_payment.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'dart:io';

import 'package:food_buyer/main.dart';

import '../../services/dio_manager.dart';

class VipPage extends StatefulWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  State<VipPage> createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> {

  String? _paymentMethodId;
  String? _errorMessage = "";
  final _stripePayment = FlutterStripePayment();
  var _isNativePayAvailable = false;

  /// 支付信息
  requestDataWithPay(String token)async{
    var params = {
      'plan':'1',
      'token':token,
    };
    var json = await DioManager().kkRequest('/api/v1/stripe.config',params: params);
    if(json['code'] == 200){
      BotToast.showText(text: '支付成功');
    }else{
      BotToast.showText(text: json['message']);
    }
  }


  @override
  void initState() {
    super.initState();
    _stripePayment.setStripeSettings(
        "pk_test_51I1WYkC2Sx1aM4gYCd4LJkcnjUYbyVMJSmB2LKwZH1w1LCpuamo0VSn7gNYssqtFESlcDOjiNcU86yNxvWDuOZj0007WlOXEJ1", "{STRIPE_APPLE_PAY_MERCHANTID}");
    _stripePayment.onCancel = () {
      print("the payment form was cancelled");
    };
    checkIfAppleOrGooglePayIsAvailable();
  }
  void checkIfAppleOrGooglePayIsAvailable() async {
    var available = await _stripePayment.isNativePayAvailable();
    setState(() {
      _isNativePayAvailable = available;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vip'),),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _paymentMethodId != null
                      ? Text(
                    "Payment Method Returned is $_paymentMethodId",
                    textAlign: TextAlign.center,
                  )
                      : Container(
                    child: Text(_errorMessage ?? ""),
                  ),
                  ElevatedButton(
                    child: Text("Create a Card Payment Method"),
                    onPressed: () async {
                      var paymentResponse = await _stripePayment.addPaymentMethod();
                      setState(() {
                        if (paymentResponse.status ==
                            PaymentResponseStatus.succeeded) {
                          _paymentMethodId = paymentResponse.paymentMethodId;
                          // requestDataWithPay(_paymentMethodId!);
                        } else {
                          _errorMessage = paymentResponse.errorMessage;
                          BotToast.showText(text: _errorMessage!);
                        }
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: !_isNativePayAvailable ? null : () async {
                      var paymentItem =
                      PaymentItem(label: 'VIP', amount: 399);
                      // var taxItem =
                      // PaymentItem(label: 'NY Sales Tax', amount: 21.87);
                      // var shippingItem =
                      // PaymentItem(label: 'Shipping', amount: 5.99);
                      var stripeToken =
                      await _stripePayment.getPaymentMethodFromNativePay(
                          countryCode: "HK",
                          currencyCode: "HKD",
                          paymentNetworks: [
                            PaymentNetwork.visa,
                            PaymentNetwork.mastercard,
                            PaymentNetwork.amex,
                            PaymentNetwork.discover
                          ],
                          merchantName: "FoodBuyer",
                          isPending: false,
                          paymentItems: [paymentItem, ]);
                      print("Stripe Payment Token from Apple Pay: $stripeToken");
                      // requestDataWithPay(stripeToken);
                    },
                    child: Text(
                        "Get ${Platform.isIOS ? "Apple" : (Platform.isAndroid ? "Google" : "Native")} Pay Token"),
                  )
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(15),
            sliver: SliverToBoxAdapter(
              child: Center(child: Text('想更多潜在客藏你 ?想把握每的報價的機會 ?',
              style: Theme.of(context).textTheme.titleLarge,
              )),
            ),
          ),
          SliverGrid(delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              margin: EdgeInsets.only(left: 5,right: 5,bottom: 5),
              decoration: BoxDecoration(
                color: kDTCloud500,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(

                children: [
                  SizedBox(height: 5,),
                  Text('STARTER (每月)',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white
                    ),),
                  SizedBox(height: 5,),
                  Text('HK\$399',style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white
                  ),),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/ic_check.png',width: 15,height: 15,color: Colors.white,),
                      SizedBox(width: 6,),
                      Text('接收胃家的查韵',style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white
                      ),)
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/ic_check.png',width: 15,height: 15,color: Colors.white,),
                      SizedBox(width: 6,),
                      Text('接收胃家的查韵',style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white
                      ),)
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/ic_check.png',width: 15,height: 15,color: Colors.white,),
                      SizedBox(width: 6,),
                      Text('50件座品供置家',style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white
                      ),)
                    ],
                  ),
                  MaterialButton(onPressed: ()async{
                    var paymentResponse = await _stripePayment.addPaymentMethod();
                    setState(() {
                      if (paymentResponse.status ==
                          PaymentResponseStatus.succeeded) {
                        _paymentMethodId = paymentResponse.paymentMethodId;
                      } else {
                        _errorMessage = paymentResponse.errorMessage;
                        BotToast.showText(text: _errorMessage!);
                      }
                    });
                  },child: Text('Purase'),color: Colors.white,shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                  ),)
                ],
              ),
            );
          },childCount: 3), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,childAspectRatio: 1/1.5,
              crossAxisSpacing: 0,mainAxisSpacing: 0))
        ],
      ),
    );
  }
}
