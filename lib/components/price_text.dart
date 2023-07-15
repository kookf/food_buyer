import 'package:flutter/material.dart';

class PriceText extends StatelessWidget {
  var price;
  final TextStyle? style;

  PriceText({required this.price, this.style});

  @override
  Widget build(BuildContext context) {
    return price==null?SizedBox(): Text(
      'HK\$${price}',
      style: style,
    );
  }
}
