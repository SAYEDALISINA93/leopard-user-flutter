import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/ride/ride_bid_list/ride_bid_list_controller.dart';
import 'package:leoparduser/data/model/global/bid/bid_model.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/presentation/components/buttons/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';

import '../../../components/divider/custom_spacer.dart';

class BidCard extends StatelessWidget {
  BidModel bid;
  RideModel ride;
  String currency;

  BidCard(
      {super.key,
      required this.bid,
      required this.ride,
      required this.currency});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideBidListController>(builder: (controller) {
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.toNamed(RouteHelper.driverReviewScreen,
                          arguments: bid.driver?.id),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: MyColor.borderColor, width: .5),
                            shape: BoxShape.circle),
                        child: MyImageWidget(
                            imageUrl:
                                '${controller.driverImagePath}${bid.driver?.avatar}',
                            isProfile: true,
                            height: 40,
                            width: 40,
                            radius: 15),
                      ),
                    ),
                    const SizedBox(width: Dimensions.space10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${bid.driver?.firstname} ${bid.driver?.lastname}",
                            style: regularDefault.copyWith(fontSize: 16)),
                        Row(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star,
                                    size: 12, color: MyColor.colorYellow),
                                const SizedBox(width: Dimensions.space2),
                                Text("${bid.driver?.avgRating}",
                                    style: boldDefault.copyWith(
                                        color: MyColor.colorGrey,
                                        fontSize: Dimensions.fontDefault,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                            const SizedBox(width: Dimensions.space8),
                            Text(
                                "${ride.duration}, ${ride.distance}${MyStrings.km.tr}",
                                style: boldDefault.copyWith(
                                    color: MyColor.primaryColor))
                          ],
                        ),
                        const SizedBox(height: Dimensions.space5),
                      ],
                    ),
                  ],
                ),
                Text(
                    "$currency${Converter.formatDouble(bid.bidAmount.toString())}",
                    style: boldLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: MyColor.rideTitle)),
              ],
            ),
            spaceDown(Dimensions.space20),
            if (bid.driver?.rules?.isNotEmpty ?? false) ...[
              Text(MyStrings.rideRulse.tr, style: boldLarge.copyWith()),
              spaceDown(Dimensions.space20),
              Column(
                children: List.generate(
                  (bid.driver?.rules?.length ?? 0),
                  (index) => rulseData(text: bid.driver?.rules?[index] ?? ""),
                ),
              ),
              spaceDown(Dimensions.space20),
            ],
            Row(
              children: [
                Expanded(
                  child: CustomElevatedBtn(
                      text: MyStrings.rejectRequest.tr,
                      press: () => controller.rejectBid(bid.id.toString()),
                      isLoading: controller.isRejectLoading &&
                          controller.selectedId == bid.id.toString(),
                      bgColor: MyColor.redCancelTextColor,
                      elevation: 0),
                ),
                spaceSide(Dimensions.space10),
                Expanded(
                  child: CustomElevatedBtn(
                    text: MyStrings.acceptRequest.tr,
                    press: () => controller.acceptBid(
                        bid.id.toString(), ride.id.toString()),
                    isLoading: controller.isAcceptLoading &&
                        controller.selectedId == bid.id.toString(),
                  ),
                ),
              ],
            ),
            spaceDown(Dimensions.space10),
          ],
        ),
      );
    });
  }

  Widget rulseData({required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: MyColor.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(
            width: Dimensions.space8,
          ),
          Text(
            text.tr.toTitleCase(),
            style: regularDefault.copyWith(color: MyColor.bodyTextColor),
          )
        ],
      ),
    );
  }
}
