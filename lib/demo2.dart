// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
//
//
// class Demo2 extends StatefulWidget {
//   const Demo2({Key? key}) : super(key: key);
//
//   @override
//   State<Demo2> createState() => _Demo2State();
// }
//
// class _Demo2State extends State<Demo2> {
//
//   int step = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           TextButton(onPressed: (){
//             initPaymentSheet();
//           }, child: Text('ffff')),
//           TextButton(onPressed: (){
//             confirmPayment();
//           }, child: Text('123'))
//         ],
//       ),
//     );
//   }
//
//   // Future<Map<String, dynamic>> _createTestPaymentSheet() async {
//   //
//   // }
//
//   Future<void> initPaymentSheet() async {
//     try {
//       // 1. create payment intent on the server
//       // final data = await _createTestPaymentSheet();
//
//       // create some billingdetails
//       final billingDetails = BillingDetails(
//         name: 'Flutter Stripe',
//         email: 'email@stripe.com',
//         phone: '+48888000888',
//         address: Address(
//           city: 'Houston',
//           country: 'US',
//           line1: '1459  Circle Drive',
//           line2: '',
//           state: 'Texas',
//           postalCode: '77063',
//         ),
//       ); // mocked data for tests
//
//       // 2. initialize the payment sheet
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           // Main params
//           paymentIntentClientSecret: '',
//           merchantDisplayName: 'Flutter Stripe Store Demo',
//           customFlow: true,
//           // Customer params
//           customerId: '',
//           customerEphemeralKeySecret: '',
//           // Extra params
//           primaryButtonLabel: 'Pay now',
//           applePay: PaymentSheetApplePay(
//             merchantCountryCode: 'DE',
//           ),
//           googlePay: PaymentSheetGooglePay(
//             merchantCountryCode: 'DE',
//             testEnv: true,
//           ),
//           style: ThemeMode.dark,
//           appearance: PaymentSheetAppearance(
//             colors: PaymentSheetAppearanceColors(
//               background: Colors.lightBlue,
//               primary: Colors.blue,
//               componentBorder: Colors.red,
//             ),
//             shapes: PaymentSheetShape(
//               borderWidth: 4,
//               shadow: PaymentSheetShadowParams(color: Colors.red),
//             ),
//             primaryButton: PaymentSheetPrimaryButtonAppearance(
//               shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
//               colors: PaymentSheetPrimaryButtonTheme(
//                 light: PaymentSheetPrimaryButtonThemeColors(
//                   background: Color.fromARGB(255, 231, 235, 30),
//                   text: Color.fromARGB(255, 235, 92, 30),
//                   border: Color.fromARGB(255, 235, 92, 30),
//                 ),
//               ),
//             ),
//           ),
//           billingDetails: billingDetails,
//         ),
//       );
//       setState(() {
//         step = 1;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//       rethrow;
//     }
//   }
//
//   Future<void> confirmPayment() async {
//     try {
//       // 3. display the payment sheet.
//       await Stripe.instance.presentPaymentSheet();
//
//       setState(() {
//         step = 0;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Payment succesfully completed'),
//         ),
//       );
//     } on Exception catch (e) {
//       if (e is StripeException) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error from Stripe: ${e.error.localizedMessage}'),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Unforeseen error: ${e}'),
//           ),
//         );
//       }
//     }
//   }
// }
