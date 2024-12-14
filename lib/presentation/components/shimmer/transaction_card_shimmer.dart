import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:shimmer/shimmer.dart';

class TransactionCardShimmer extends StatelessWidget {
  const TransactionCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    double width = context.width / 6;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Shimmer.fromColors(
                baseColor: MyColor.colorGrey.withOpacity(0.2),
                highlightColor: MyColor.primaryColor.withOpacity(0.7),
                child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: MyColor.colorGrey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50)),
                    height: 40,
                    width: 40)),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                    baseColor: MyColor.colorGrey.withOpacity(0.2),
                    highlightColor: MyColor.primaryColor.withOpacity(0.7),
                    child: Container(
                        decoration: BoxDecoration(
                            color: MyColor.colorGrey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(1)),
                        height: 10,
                        width: width * 1.5)),
                const SizedBox(height: 5),
                Shimmer.fromColors(
                    baseColor: MyColor.colorGrey.withOpacity(0.2),
                    highlightColor: MyColor.primaryColor.withOpacity(0.7),
                    child: Container(
                        decoration: BoxDecoration(
                            color: MyColor.colorGrey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(1)),
                        height: 7,
                        width: width * 1.5)),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Shimmer.fromColors(
              baseColor: MyColor.colorGrey.withOpacity(0.2),
              highlightColor: MyColor.primaryColor.withOpacity(0.7),
              child: Container(
                  decoration: BoxDecoration(
                      color: MyColor.colorGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(1)),
                  height: 7,
                  width: width * 1.5),
            ),
            const SizedBox(height: 5),
            Shimmer.fromColors(
              baseColor: MyColor.colorGrey.withOpacity(0.2),
              highlightColor: MyColor.primaryColor.withOpacity(0.7),
              child: Container(
                  decoration: BoxDecoration(
                      color: MyColor.colorGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(1)),
                  height: 7,
                  width: width * 1.5),
            ),
          ],
        ),
        const SizedBox(width: Dimensions.space5)
      ],
    );
  }
}
