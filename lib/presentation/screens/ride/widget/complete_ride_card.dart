import 'package:leoparduser/core/helper/date_converter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';

import '../../../components/divider/custom_spacer.dart';
import '../../../components/dotted_border/dotted_border.dart';
import '../../../components/timeline/custom_timeLine.dart';

class CompleteRideCard extends StatelessWidget {
  bool isPaymentDone;
  bool isReviewDone;
  RideModel ride;
  String currency;
  VoidCallback reviewBtnCallback;
  CompleteRideCard({
    super.key,
    required this.isPaymentDone,
    required this.isReviewDone,
    required this.ride,
    required this.currency,
    required this.reviewBtnCallback,
  });

  @override
  Widget build(BuildContext context) {
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
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.space5, vertical: Dimensions.space5),
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
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: MyColor.colorWhite,
                                border: Border.all(color: MyColor.borderColor),
                                shape: BoxShape.circle),
                            child: MyImageWidget(
                                imageUrl: ride.driver?.imageWithPath ?? '',
                                height: 45,
                                width: 45,
                                radius: 50,
                                isProfile: true,
                                errorWidget: Image.asset(MyImages.defaultAvatar,
                                    height: 45, width: 45)),
                          ),
                          const SizedBox(width: Dimensions.space10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${ride.driver?.firstname} ${ride.driver?.lastname}"
                                        .toTitleCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: boldMediumLarge),
                                spaceDown(Dimensions.space5),
                                FittedBox(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(Icons.star,
                                              size: Dimensions.fontExtraLarge,
                                              color: MyColor.colorYellow),
                                          const SizedBox(
                                              width: Dimensions.space2),
                                          Text("${ride.driver?.avgRating}",
                                              style: boldDefault.copyWith(
                                                  color: MyColor
                                                      .getRideSubTitleColor(),
                                                  fontSize:
                                                      Dimensions.fontDefault,
                                                  fontWeight: FontWeight.w700)),
                                        ],
                                      ),
                                      const SizedBox(width: Dimensions.space8),
                                      Text(
                                        "${ride.duration}, ${ride.distance}${MyStrings.km.tr}",
                                        style: boldDefault.copyWith(
                                            color: MyColor.primaryColor,
                                            fontSize: Dimensions.fontDefault,
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
                        "$currency${Converter.formatNumber(ride.offerAmount ?? '0')}",
                        overflow: TextOverflow.ellipsis,
                        style: boldLarge.copyWith(
                            fontSize: Dimensions.fontExtraLarge,
                            fontWeight: FontWeight.w900,
                            color: MyColor.rideTitle),
                      ),
                    ),
                  ],
                ),

                spaceDown(Dimensions.space30),

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
                          Text(ride.pickupLocation ?? '',
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
                        ],
                      ),
                    ),
                  ),
                ),

                spaceDown(Dimensions.space10),
                const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.space5),
                    child: DottedLine(lineColor: MyColor.borderColor)),
                spaceDown(Dimensions.space20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: MyColor.bodyTextBgColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.mediumRadius)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(MyStrings.rideCompleted.tr,
                          style: boldDefault.copyWith(color: MyColor.bodyText)),
                      Text(DateConverter.estimatedDate(DateTime.now()),
                          style: boldDefault.copyWith(color: MyColor.bodyText)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          spaceDown(Dimensions.space10),
          isReviewDone
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    spaceDown(Dimensions.space10),
                    RoundedButton(
                      text: MyStrings.review,
                      press: () {
                        reviewBtnCallback();
                      },
                      isColorChange: true,
                      verticalPadding: 15,
                      borderColor: MyColor.primaryColor,
                      textColor: MyColor.getRideTitleColor(),
                      isOutlined: true,
                      textStyle: regularDefault.copyWith(),
                    ),
                    const SizedBox(height: Dimensions.space12),
                  ],
                ),
        ],
      ),
    );
  }
}
