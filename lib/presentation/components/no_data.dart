import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_animation.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:lottie/lottie.dart';

class NoDataWidget extends StatelessWidget {
  final double margin;
  final bool fromRide;
  final String text;
  const NoDataWidget(
      {super.key,
      this.margin = 4,
      this.fromRide = false,
      this.text = MyStrings.noDataToShow});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / margin),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            fromRide
                ? Image.asset(MyImages.noRideFound, height: 120, width: 120)
                : Lottie.asset(MyAnimation.notFound, height: 150, width: 150),
            const SizedBox(height: Dimensions.space15),
            Text(text.tr,
                style: regularLarge.copyWith(color: MyColor.getBodyTextColor()))
          ],
        ),
      ),
    );
  }
}
