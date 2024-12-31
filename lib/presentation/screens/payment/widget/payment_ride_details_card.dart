import 'package:leoparduser/core/helper/date_converter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:leoparduser/presentation/components/timeline/custom_timeLine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/dotted_border/dotted_border.dart';

class PaymentRideDetailsCard extends StatelessWidget {
  RideModel ride;
  String currency;
  String driverImageUrl;

  PaymentRideDetailsCard({
    super.key,
    required this.ride,
    required this.currency,
    required this.driverImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.space12, vertical: Dimensions.space15),
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
              Expanded(
                child: Row(
                  children: [
                    MyImageWidget(
                        imageUrl: driverImageUrl,
                        height: 45,
                        width: 45,
                        isProfile: true),
                    const SizedBox(
                      width: Dimensions.space10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${ride.driver?.firstname} ${ride.driver?.lastname}",
                              overflow: TextOverflow.ellipsis,
                              style: boldExtraLarge),
                          spaceDown(Dimensions.space5),
                          FittedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(Icons.star,
                                        size: Dimensions.fontOverLarge2,
                                        color: MyColor.colorYellow),
                                    const SizedBox(width: Dimensions.space2),
                                    Text(
                                      "${double.tryParse(ride.driver?.avgRating ?? '0')}",
                                      style: boldDefault.copyWith(
                                          color: MyColor.getRideSubTitleColor(),
                                          fontSize: Dimensions.fontDefault + 2,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: Dimensions.space8),
                                Text(
                                  "${ride.duration}, ${ride.distance} ${MyStrings.km.tr}",
                                  style: boldDefault.copyWith(
                                      color: MyColor.primaryColor,
                                      fontSize: Dimensions.fontDefault + 2,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              spaceSide(Dimensions.space10),
              FittedBox(
                child: Text(
                  "$currency${Converter.formatNumber(ride.amount.toString())}",
                  overflow: TextOverflow.ellipsis,
                  style: boldLarge.copyWith(
                      fontSize: Dimensions.fontExtraLarge,
                      fontWeight: FontWeight.w700,
                      color: MyColor.rideTitle),
                ),
              ),
            ],
          ),

          spaceDown(Dimensions.space30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10),
            child: DottedLine(lineColor: MyColor.getRideSubTitleColor()),
          ),
          spaceDown(Dimensions.space20),
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
                          overflow: TextOverflow.ellipsis),
                    ),
                    spaceDown(Dimensions.space8),
                    Text(ride.pickupLocation ?? '',
                        style: regularDefault.copyWith(
                            color: MyColor.getRideSubTitleColor(),
                            fontSize: Dimensions.fontSmall,
                            fontWeight: FontWeight.w600),
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
                    spaceDown(Dimensions.space8),
                    Text(ride.destination ?? '',
                        style: regularDefault.copyWith(
                            color: MyColor.getRideSubTitleColor(),
                            fontSize: Dimensions.fontSmall,
                            fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: Dimensions.space20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MyColor.bodyTextBgColor,
              borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(MyStrings.rideCompleted.tr,
                    style: boldDefault.copyWith(color: MyColor.bodyText)),
                Text(
                    DateConverter.estimatedDate(
                        DateTime.tryParse('${ride.endTime}') ?? DateTime.now()),
                    style: boldDefault.copyWith(color: MyColor.bodyText)),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.space10),
        ],
      ),
    );
  }
}
