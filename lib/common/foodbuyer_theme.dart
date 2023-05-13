import 'package:flutter/material.dart';

import 'foodbuyer_colors.dart';

class FoodBuyerTheme{

  ThemeData buildThemeData(){
    final ThemeData base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: Colors.white,
      colorScheme:base.colorScheme.copyWith(
        primary: kDTCloud700,
        onPrimary: kDTCloud900,
        secondary: kDTCloud900,
        error: kDTCloudRed,
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: base.textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
      ),
      textTheme:_buildFoodBuyerTextTheme(base.textTheme),
      hintColor: kDTCloudGray,
      inputDecorationTheme:const InputDecorationTheme(
        border:OutlineInputBorder(
            borderSide:BorderSide(
                width: 1,
                color: kDTCloud900
            )
        ),
      ),

    );
  }
  TextTheme _buildFoodBuyerTextTheme(TextTheme base){
    return base.copyWith(
      headlineSmall:base.headlineSmall!.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),
      titleLarge: base.titleLarge!.copyWith(
        fontSize: 18.0,
      ),
      bodySmall: base.bodySmall!.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 12.0,
      ),
      bodyLarge: base.bodyLarge!.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      ),
    ).apply(
      fontFamily: 'Rubik',
      displayColor:kDTCloud700,
      bodyColor:kDTCloud700
    );
  }

}