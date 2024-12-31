import 'package:leoparduser/core/helper/date_converter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/app_status.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/ride/active_ride/ride_history_controller.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/divider/custom_spacer.dart';
import '../../../components/timeline/custom_timeLine.dart';

class ActiveRideCard extends StatelessWidget {
  String currency;
  RideModel ride;
  ActiveRideCard({super.key, required this.currency, required this.ride});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideHistoryController>(
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          margin: const EdgeInsets.only(bottom: 8),
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
                  if (ride.status == AppStatus.RIDE_RUNNING.toString()) ...[
                    Text(MyStrings.runningRide.tr,
                        style: regularDefault.copyWith(fontSize: 16)),
                  ] else ...[
                    Text(MyStrings.ride.tr,
                        style: regularDefault.copyWith(fontSize: 16)),
                  ],
                  Text(
                    "$currency${Converter.formatNumber(ride.amount.toString())}",
                    style: boldLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: MyColor.rideTitle),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.space20),
              //Location Timeline
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteHelper.rideDetailsScreen,
                      arguments: ride.id.toString());
                },
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
                        Text(ride.pickupLocation ?? '',
                            style: regularDefault.copyWith(
                                color: MyColor.getRideSubTitleColor(),
                                fontSize: Dimensions.fontSmall),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        spaceDown(Dimensions.space8),
                        Text(ride.startTime ?? '',
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
                        Text(ride.destination ?? '',
                            style: regularDefault.copyWith(
                                color: MyColor.getRideSubTitleColor(),
                                fontSize: Dimensions.fontSmall),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        if (ride.status !=
                            AppStatus.RIDE_RUNNING.toString()) ...[
                          spaceDown(Dimensions.space8),
                          Text(ride.endTime ?? '',
                              style: regularDefault.copyWith(
                                  color: MyColor.getRideSubTitleColor(),
                                  fontSize: Dimensions.fontSmall),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              spaceDown(Dimensions.space10),
              ride.status == AppStatus.RIDE_PENDING
                  ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: MyColor.colorGrey2.withOpacity(0.5),
                            borderRadius:
                                BorderRadius.circular(Dimensions.mediumRadius),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(MyStrings.rideCreated.tr,
                                  style: boldDefault.copyWith(
                                      color: MyColor.colorGrey)),
                              Text(
                                DateConverter.estimatedDate(
                                    DateTime.tryParse('${ride.createdAt}') ??
                                        DateTime.now()),
                                style: boldDefault.copyWith(
                                    color: MyColor.colorGrey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Dimensions.space25 - 1),
                        RoundedButton(
                          text: MyStrings.viewBids.tr,
                          press: () {
                            Get.toNamed(RouteHelper.rideBidScreen,
                                arguments: ride.id.toString());
                          },
                          isOutlined: false,
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              const SizedBox(height: Dimensions.space10),
            ],
          ),
        );
      },
    );
  }
}
