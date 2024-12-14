import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/ride/active_ride/ride_history_controller.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/divider/custom_spacer.dart';
import '../../../components/timeline/custom_timeLine.dart';

class RideCard extends StatelessWidget {
  String currency;
  RideModel ride;
  RideCard({super.key, required this.currency, required this.ride});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideHistoryController>(
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: MyColor.getCardBgColor(),
            borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
            boxShadow: MyUtils.getCardShadow(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.space5,
                        vertical: Dimensions.space2),
                    decoration: BoxDecoration(
                      color: MyUtils.getRideStatusColor(ride.status ?? '9')
                          .withOpacity(0.01),
                      borderRadius:
                          BorderRadius.circular(Dimensions.defaultRadius),
                      border: Border.all(
                          color:
                              MyUtils.getRideStatusColor(ride.status ?? '9')),
                    ),
                    child: Text(
                      MyUtils.getRideStatus(ride.status ?? '9').tr,
                      style: regularDefault.copyWith(
                          fontSize: 16,
                          color:
                              MyUtils.getRideStatusColor(ride.status ?? '9')),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                          "$currency${Converter.formatNumber(ride.offerAmount.toString())}",
                          style: boldLarge.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: MyColor.rideTitle)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.space20),
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
                                overflow: TextOverflow.ellipsis)),
                        const SizedBox(height: Dimensions.space5 - 1),
                        Text(ride.destination ?? '',
                            style: regularDefault.copyWith(
                                color: MyColor.getRideSubTitleColor(),
                                fontSize: Dimensions.fontSmall),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        spaceDown(Dimensions.space8),
                        Text(ride.endTime ?? '',
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
              const SizedBox(height: Dimensions.space15),
            ],
          ),
        );
      },
    );
  }
}
