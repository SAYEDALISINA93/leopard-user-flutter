import 'package:leoparduser/core/helper/date_converter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/app_status.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/my_icons.dart';
import '../../../components/divider/custom_spacer.dart';
import '../../../components/image/custom_svg_picture.dart';
import '../../../components/timeline/custom_time_line.dart';

class RideDetailsCard extends StatelessWidget {
  RideModel ride;
  String currency;
  VoidCallback callback;

  RideDetailsCard({
    super.key,
    required this.ride,
    required this.currency,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.only(bottom: 8),
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
              Text(
                MyStrings.ridePlace.tr,
                style: regularDefault.copyWith(fontSize: 16),
              ),
              Text(
                "$currency${StringConverter.formatNumber(ride.offerAmount.toString())}",
                style: boldLarge.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: MyColor.rideTitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space20),
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              height: Dimensions.space50 + 80,
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
                        child: Text(
                          MyStrings.pickUpLocation.tr,
                          style: boldLarge.copyWith(
                            color: MyColor.rideTitle,
                            fontSize: Dimensions.fontLarge - 1,
                            fontWeight: FontWeight.w700,
                          ),
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
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                        child: Text(
                          MyStrings.destination.tr,
                          style: boldLarge.copyWith(
                            color: MyColor.rideTitle,
                            fontSize: Dimensions.fontLarge - 1,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: Dimensions.space5 - 1),
                      Text(
                        ride.destination ?? '',
                        style: regularDefault.copyWith(
                          color: MyColor.getRideSubTitleColor(),
                          fontSize: Dimensions.fontSmall,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          spaceDown(Dimensions.space15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MyColor.colorGrey2.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (ride.status == AppStatus.RIDE_ACTIVE.toString()) ...[
                  Row(
                    children: [
                      Text(
                        "${MyStrings.otp.tr}: ${ride.otp}",
                        style: boldDefault.copyWith(color: MyColor.bodyText),
                      ),
                      const SizedBox(width: Dimensions.space5),
                      InkWell(
                        onTap: () {
                          printX(ride.otp);
                        },
                        child: const CustomSvgPicture(
                          image: MyIcons.copy,
                          color: MyColor.bodyText,
                          height: 14,
                          width: 12,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    "${MyStrings.createdTime.tr} ",
                    style: boldDefault.copyWith(color: MyColor.bodyText),
                  ),
                ],
                Text(
                  DateConverter.estimatedDate(
                    DateTime.tryParse('${ride.createdAt}') ?? DateTime.now(),
                  ),
                  style: boldDefault.copyWith(color: MyColor.colorGrey),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.space20),
          RoundedButton(
            text: MyStrings.cancel,
            press: callback,
            isOutlined: false,
            color: MyColor.redCancelTextColor,
            textColor: MyColor.colorWhite,
          ),
          const SizedBox(height: Dimensions.space10),
        ],
      ),
    );
  }
}
