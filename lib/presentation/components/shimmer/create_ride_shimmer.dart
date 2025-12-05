import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/util.dart';

import 'package:leoparduser/presentation/components/shimmer/my_shimmer.dart';

class CreateRideShimmer extends StatelessWidget {
  const CreateRideShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 32),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: MyColor.borderColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(Dimensions.space12),
        boxShadow: MyUtils.getCardTopShadow(),
      ),
      child: Column(
        children: [
          MyShimmerWidget(
            child: Container(
              height: 8,
              margin: const EdgeInsets.symmetric(
                horizontal: Dimensions.space50,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: MyColor.colorGrey.withValues(alpha: 0.3),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.space8),
          MyShimmerWidget(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: MyColor.colorGrey.withValues(alpha: 0.3),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.space20),
          Row(
            children: [
              Expanded(
                child: MyShimmerWidget(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimensions.mediumRadius,
                      ),
                      color: MyColor.colorGrey.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.space10),
              Expanded(
                child: MyShimmerWidget(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimensions.mediumRadius,
                      ),
                      color: MyColor.colorGrey.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space20),
          Row(
            children: [
              Expanded(
                child: MyShimmerWidget(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimensions.mediumRadius,
                      ),
                      color: MyColor.colorGrey.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.space10),
              Expanded(
                child: MyShimmerWidget(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimensions.mediumRadius,
                      ),
                      color: MyColor.colorGrey.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space20),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: MyShimmerWidget(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: MyColor.colorGrey.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.space10),
              Expanded(
                flex: 1,
                child: MyShimmerWidget(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: MyColor.colorGrey.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
