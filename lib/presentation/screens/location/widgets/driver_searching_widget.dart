import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_animation.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/presentation/components/image/my_local_image_widget.dart';

class DriverSearchWidget extends StatelessWidget {
  final String bids;
  final VoidCallback onTap;
  const DriverSearchWidget({
    super.key,
    required this.bids,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
              top: -40,
              child: Align(
                  alignment: Alignment.center,
                  child: LottieBuilder.asset(MyAnimation.searching))),
          Positioned.fill(
              top: 30,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(MyStrings.searching.tr,
                      style:
                          regularOverSmall.copyWith(color: MyColor.bodyText)))),
          Positioned(
            right: 5,
            top: 10,
            child: InkWell(
              onTap: onTap,
              child: Align(
                alignment: Alignment.topRight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: MyColor.primaryColor.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(Dimensions.mediumRadius)),
                        padding: const EdgeInsets.all(Dimensions.space5),
                        child: const MyLocalImageWidget(
                            imagePath: MyImages.mapDriver,
                            height: 40,
                            width: 40)),
                    Positioned(
                      bottom: -5,
                      left: -10,
                      child: Container(
                          decoration: BoxDecoration(
                              color: MyColor.greenSuccessColor,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.mediumRadius)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.space5),
                          child: Text(bids,
                              style: boldDefault.copyWith(
                                  color: MyColor.colorWhite))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
