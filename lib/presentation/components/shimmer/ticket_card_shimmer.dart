import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/presentation/components/shimmer/my_shimmer.dart';

class TicketCardShimmer extends StatelessWidget {
  const TicketCardShimmer({super.key});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyShimmerWidget(
                    child: Container(
                      width: context.width / 3,
                      height: 8,
                      decoration: BoxDecoration(
                        color: MyColor.colorGrey2,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.space5),
                  MyShimmerWidget(
                    child: Container(
                      width: context.width / 4,
                      height: 6,
                      decoration: BoxDecoration(
                        color: MyColor.colorGrey2,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
              MyShimmerWidget(
                child: Container(
                  width: context.width / 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: MyColor.colorGrey2,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyShimmerWidget(
                child: Container(
                  width: context.width / 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: MyColor.colorGrey2,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              MyShimmerWidget(
                child: Container(
                  width: context.width / 5,
                  height: 4,
                  decoration: BoxDecoration(
                    color: MyColor.colorGrey2,
                    borderRadius: BorderRadius.circular(2),
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
