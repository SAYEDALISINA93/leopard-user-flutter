import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';

import 'package:leoparduser/presentation/components/shimmer/my_shimmer.dart';

class RideServiceShimmer extends StatelessWidget {
  const RideServiceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(10, (index) {
          return Container(
            margin: const EdgeInsets.only(right: 5),
            child: Column(
              children: [
                MyShimmerWidget(
                  child: Container(
                    height: 60,
                    width: 60,
                    margin: const EdgeInsets.only(right: Dimensions.space10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimensions.mediumRadius,
                      ),
                      color: MyColor.colorGrey.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.space5),
                MyShimmerWidget(
                  child: Container(
                    height: 10,
                    width: 60,
                    margin: const EdgeInsets.only(right: Dimensions.space10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: MyColor.colorGrey.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
