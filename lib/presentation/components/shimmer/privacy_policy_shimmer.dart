import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/presentation/components/shimmer/my_shimmer.dart';

class PrivacyPolicyShimmer extends StatelessWidget {
  const PrivacyPolicyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: MyColor.colorWhite,
        borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
      ),
      width: context.width,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.space15,
        vertical: Dimensions.space15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyShimmerWidget(
            child: Container(
              width: context.width / 4 - 20,
              height: 4,
              decoration: BoxDecoration(
                color: MyColor.colorGrey2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.space5),
          MyShimmerWidget(
            child: Container(
              width: context.width,
              height: 3,
              decoration: BoxDecoration(
                color: MyColor.colorGrey2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.space5),
          MyShimmerWidget(
            child: Container(
              width: context.width - 60,
              height: 3,
              decoration: BoxDecoration(
                color: MyColor.colorGrey2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.space5),
          MyShimmerWidget(
            child: Container(
              width: context.width - 50,
              height: 3,
              decoration: BoxDecoration(
                color: MyColor.colorGrey2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.space5),
          MyShimmerWidget(
            child: Container(
              width: context.width - 40,
              height: 3,
              decoration: BoxDecoration(
                color: MyColor.colorGrey2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.space5),
          MyShimmerWidget(
            child: Container(
              width: context.width / 2,
              height: 3,
              decoration: BoxDecoration(
                color: MyColor.colorGrey2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.space5),
        ],
      ),
    );
  }
}
