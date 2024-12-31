import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/components/timeline/custom_timeLine.dart';

class RideDestination extends StatelessWidget {
  RideModel ride;
  RideDestination({
    super.key,
    required this.ride,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTimeLine(
      indicatorPosition: 0.1,
      dashColor: MyColor.colorYellow,
      firstWidget: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                MyStrings.pickUpLocation.tr,
                style: boldLarge.copyWith(
                    color: MyColor.rideTitle,
                    fontSize: Dimensions.fontLarge - 1,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            spaceDown(Dimensions.space5),
            Text(
              ride.pickupLocation ?? '',
              style: regularDefault.copyWith(
                color: MyColor.getRideSubTitleColor(),
                fontSize: Dimensions.fontSmall,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            spaceDown(Dimensions.space15),
          ],
        ),
      ),
      secondWidget: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                MyStrings.destination.tr,
                style: boldLarge.copyWith(
                    color: MyColor.rideTitle,
                    fontSize: Dimensions.fontLarge - 1,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: Dimensions.space5 - 1,
            ),
            Text(
              ride.destination ?? '',
              style: regularDefault.copyWith(
                color: MyColor.getRideSubTitleColor(),
                fontSize: Dimensions.fontSmall,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
