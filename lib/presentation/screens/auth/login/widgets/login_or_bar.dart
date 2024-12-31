import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginOrBar extends StatelessWidget {
  final double stock;
  const LoginOrBar({super.key, this.stock = 1});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: double.infinity,
            height: 20,
            color: MyColor.transparentColor),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              //  margin: const EdgeInsets.symmetric(horizontal: Dimensions.space50),
              width: context.width,
              height: stock,
              color: MyColor.borderColor,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 40,
              height: 40,
              color: MyColor.colorWhite,
              child: Center(
                child: Text(MyStrings.or.tr,
                    style: regularLarge.copyWith(color: MyColor.bodyTextColor)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
