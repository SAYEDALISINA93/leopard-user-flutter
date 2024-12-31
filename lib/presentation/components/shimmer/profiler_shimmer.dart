import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/presentation/components/shimmer/my_shimmer.dart';

class ProfilerShimmer extends StatelessWidget {
  const ProfilerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.space10, vertical: Dimensions.space5),
      decoration: BoxDecoration(
        border: Border.all(color: MyColor.borderColor, width: .5),
        borderRadius: BorderRadius.circular(Dimensions.space10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyShimmerWidget(
            child: Container(
              height: Dimensions.space50 + 35,
              width: Dimensions.space50 + 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColor.colorGrey.withOpacity(0.3),
              ),
            ),
          ),
          SizedBox(width: Dimensions.space10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyShimmerWidget(
                child: Container(
                  height: 5,
                  width: context.width / 3,
                  decoration: BoxDecoration(
                    color: MyColor.colorGrey.withOpacity(0.3),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.space5),
              MyShimmerWidget(
                child: Container(
                  height: 5,
                  width: context.width / 3 - 50,
                  decoration:
                      BoxDecoration(color: MyColor.colorGrey.withOpacity(0.3)),
                ),
              ),
              SizedBox(height: Dimensions.space5),
              MyShimmerWidget(
                child: Container(
                  height: 5,
                  width: context.width / 4,
                  decoration: BoxDecoration(
                    color: MyColor.colorGrey.withOpacity(0.3),
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
