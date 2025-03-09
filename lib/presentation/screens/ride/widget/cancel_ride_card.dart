import 'package:leoparduser/core/helper/date_converter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/data/controller/ride/cancel_ride/cancel_ride_controller.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';

import '../../../components/divider/custom_spacer.dart';
import '../../../components/timeline/custom_timeLine.dart';

class CancelRideCard extends StatelessWidget {
  RideModel ride;
  CancelRideCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CancelRideController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            color: MyColor.getCardBgColor(),
            borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
            boxShadow: MyUtils.getCardShadow()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(MyStrings.rideCancel.tr,
                    style: regularDefault.copyWith(fontSize: 16)),
                Text(
                    "${controller.defaultCurrencySymbol}${Converter.formatNumber(ride.offerAmount ?? '0')}",
                    style: boldLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: MyColor.rideTitle)),
              ],
            ),
            const SizedBox(height: Dimensions.space20),
            //Location Timeline
            SizedBox(
              height: Dimensions.space50 + 90,
              child: CustomTimeLine(
                indicatorPosition: 0.1,
                dashColor: MyColor.colorYellow,
                firstWidget: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(MyStrings.pickUpLocation.tr,
                              style: boldLarge.copyWith(
                                  color: MyColor.rideTitle,
                                  fontSize: Dimensions.fontLarge - 1,
                                  fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis)),
                      spaceDown(Dimensions.space5),
                      Text("${ride.pickupLocation}",
                          style: regularDefault.copyWith(
                              color: MyColor.getRideSubTitleColor(),
                              fontSize: Dimensions.fontSmall),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      spaceDown(Dimensions.space15),
                    ],
                  ),
                ),
                secondWidget: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(MyStrings.destination.tr,
                            style: boldLarge.copyWith(
                                color: MyColor.rideTitle,
                                fontSize: Dimensions.fontLarge - 1,
                                fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(height: Dimensions.space5 - 1),
                      Text("${ride.destination}",
                          style: regularDefault.copyWith(
                              color: MyColor.getRideSubTitleColor(),
                              fontSize: Dimensions.fontSmall),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
            ),

            spaceDown(Dimensions.space10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: MyColor.colorGrey2.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(Dimensions.mediumRadius)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(MyStrings.rideCancel.tr,
                      style: boldDefault.copyWith(color: MyColor.colorGrey)),
                  Text(
                      DateConverter.estimatedDate(
                          DateTime.tryParse('${ride.cancelDate}') ??
                              DateTime.now()),
                      style: boldDefault.copyWith(color: MyColor.colorGrey)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
