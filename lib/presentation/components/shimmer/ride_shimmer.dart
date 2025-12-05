import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';

import 'package:leoparduser/presentation/components/shimmer/my_shimmer.dart';
import 'package:leoparduser/presentation/components/timeline/custom_time_line.dart';

class RideShimmer extends StatelessWidget {
  const RideShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Container(
      width: w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
        border: Border.all(
          color: MyColor.colorGrey.withValues(alpha: 0.1),
          width: 2,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyShimmerWidget(
                  child: Container(
                    height: 10,
                    width: 100,
                    decoration: BoxDecoration(
                      color: MyColor.colorGrey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                MyShimmerWidget(
                  child: Container(
                    height: 10,
                    width: 100,
                    decoration: BoxDecoration(
                      color: MyColor.colorGrey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.space15),
          CustomTimeLine(
            indicatorPosition: 0.1,
            dashColor: MyColor.colorYellow,
            firstWidget: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: MyShimmerWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 8,
                      width: 100,
                      decoration: BoxDecoration(
                        color: MyColor.colorGrey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: Dimensions.space6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 6,
                          width: 200,
                          decoration: BoxDecoration(
                            color: MyColor.colorGrey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(height: Dimensions.space3),
                        Container(
                          height: 6,
                          width: 200,
                          decoration: BoxDecoration(
                            color: MyColor.colorGrey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(height: Dimensions.space3),
                        Container(
                          height: 6,
                          width: 50,
                          decoration: BoxDecoration(
                            color: MyColor.colorGrey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.space20),
                  ],
                ),
              ),
            ),
            secondWidget: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: MyShimmerWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 8,
                      width: 100,
                      decoration: BoxDecoration(
                        color: MyColor.colorGrey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: Dimensions.space6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 6,
                          width: 200,
                          decoration: BoxDecoration(
                            color: MyColor.colorGrey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(height: Dimensions.space3),
                        Container(
                          height: 6,
                          width: 200,
                          decoration: BoxDecoration(
                            color: MyColor.colorGrey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(height: Dimensions.space3),
                        Container(
                          height: 6,
                          width: 50,
                          decoration: BoxDecoration(
                            color: MyColor.colorGrey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.space10),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.space20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(100, (index) {
                return Container(
                  height: 2,
                  width: 15,
                  margin: const EdgeInsets.only(right: Dimensions.space5),
                  decoration: BoxDecoration(
                    color: MyColor.colorGrey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: Dimensions.space20),
          MyShimmerWidget(
            highlightColor: MyColor.colorGrey.withValues(alpha: 0.1),
            child: Container(
              height: Dimensions.defaultButtonH,
              width: context.width,
              decoration: BoxDecoration(
                color: MyColor.colorGrey,
                borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
