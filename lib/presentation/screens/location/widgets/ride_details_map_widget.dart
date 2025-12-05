import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/app_status.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/ride/ride_details/ride_details_controller.dart';
import 'package:leoparduser/data/controller/ride/ride_meassage/ride_meassage_controller.dart';
import 'package:leoparduser/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:leoparduser/presentation/components/buttons/icon_button.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/column_widget/card_column.dart';
import 'package:leoparduser/presentation/packages/simple_ripple_animation.dart';
import 'package:leoparduser/presentation/screens/location/widgets/driver_profile_widget.dart';
import 'package:leoparduser/presentation/screens/location/widgets/driver_searching_widget.dart';
import 'package:leoparduser/presentation/screens/location/widgets/ride_cancel_bottom_sheet_body.dart';
import 'package:leoparduser/presentation/screens/location/widgets/ride_details_review_bottom_sheet.dart';
import 'package:leoparduser/presentation/screens/location/widgets/ride_otp_widget.dart';
import 'package:leoparduser/presentation/screens/location/widgets/ride_sos_bottom_sheet_body.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RideDetailsMapWidget extends StatelessWidget {
  final ScrollController scrollController;

  final DraggableScrollableController draggableScrollableController;
  const RideDetailsMapWidget({
    super.key,
    required this.scrollController,
    required this.draggableScrollableController,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideDetailsController>(
      builder: (controller) {
        final ride = controller.ride;
        final currency = controller.currency;

        return Container(
          decoration: const BoxDecoration(
            color: MyColor.colorWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
          ),
          child: ListView(
            clipBehavior: Clip.none,
            controller: scrollController,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    width: context.width,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.space10,
                      vertical: Dimensions.space10,
                    ),
                    margin: EdgeInsets.only(top: ride.driver == null ? 60 : 0),
                    decoration: const BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (ride.driver != null) ...[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 5,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: MyColor.colorGrey.withValues(alpha: 0.2),
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.space20),
                        ],
                        if (ride.driver != null) ...[
                          DriverProfileWidget(
                            driver: ride.driver,
                            driverImage:
                                '${controller.driverImagePath}/${ride.driver?.avatar ?? ''}',
                            serviceImage:
                                '${controller.serviceImagePath}/${ride.service?.image ?? ''}',
                            totalCompletedRide:
                                controller.driverTotalCompletedRide,
                          ),
                          const SizedBox(height: Dimensions.space20),
                        ],
                        if (ride.status == "2") ...[
                          RideOtpWidget(ride: ride),
                          const SizedBox(height: Dimensions.space20),
                        ],
                        //messages
                        Row(
                          children: [
                            Expanded(
                              child: GetBuilder<RideMessageController>(
                                builder: (msgController) {
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      CustomIconButton(
                                        name: MyStrings.message,
                                        icon: MyIcons.messageIcon,
                                        isSvg: true,
                                        bgColor: (ride.status !=
                                                    AppStatus.RIDE_RUNNING &&
                                                ride.status !=
                                                    AppStatus.RIDE_ACTIVE &&
                                                ride.status !=
                                                    AppStatus
                                                        .RIDE_PAYMENT_REQUESTED)
                                            ? MyColor.colorGrey
                                            : MyColor.primaryColor,
                                        press: () {
                                          msgController.updateCount(0);
                                          Get.toNamed(
                                              RouteHelper.rideMessageScreen,
                                              arguments: [
                                                ride.id.toString(),
                                                ride.driver?.getFullName(),
                                                ride.status.toString()
                                              ]);
                                        },
                                      ),
                                      if (msgController.unreadMsg != 0) ...[
                                        Positioned(
                                          top: -5,
                                          right: 0,
                                          child: Badge.count(
                                            count: msgController.unreadMsg,
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: Dimensions.space10),
                            Expanded(
                              child: CustomIconButton(
                                name: MyStrings.call,
                                icon: MyIcons.callIcon,
                                isSvg: true,
                                textColor: MyColor.getTextColor(),
                                iconColor: MyColor.colorBlack,
                                bgColor: (ride.status !=
                                            AppStatus.RIDE_RUNNING &&
                                        ride.status != AppStatus.RIDE_ACTIVE &&
                                        ride.status !=
                                            AppStatus.RIDE_PAYMENT_REQUESTED)
                                    ? MyColor.colorGrey
                                    : MyColor.primaryColor,
                                isOutline: true,
                                press: () {
                                  if (ride.status == AppStatus.RIDE_RUNNING ||
                                      ride.status == AppStatus.RIDE_ACTIVE ||
                                      ride.status ==
                                          AppStatus.RIDE_PAYMENT_REQUESTED) {
                                    MyUtils.launchPhone(
                                      '${ride.driver?.mobile}',
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.space20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space10,
                            vertical: Dimensions.space15,
                          ),
                          decoration: BoxDecoration(
                            color: MyColor.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              Dimensions.mediumRadius,
                            ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: Dimensions.space20),
                                rideCardDetails(
                                  title: '${ride.distance} ${MyStrings.km.tr}',
                                  description: MyStrings.distanceAway,
                                ),
                                const SizedBox(width: Dimensions.space25),
                                rideCardDetails(
                                  title: '${ride.duration}',
                                  description: MyStrings.estimatedDuration,
                                ),
                                const SizedBox(width: Dimensions.space25),
                                rideCardDetails(
                                  title:
                                      '${StringConverter.formatNumber(ride.amount.toString())} $currency',
                                  description: MyStrings.rideFare,
                                ),
                                const SizedBox(width: Dimensions.space20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.space20),
                        if (ride.status == AppStatus.RIDE_RUNNING) ...[
                          const SizedBox(height: Dimensions.space20),
                          RoundedButton(
                            text: MyStrings.sos,
                            color: MyColor.redCancelTextColor,
                            isLoading: controller.isSosLoading,
                            press: () {
                              CustomBottomSheet(
                                child: RideDetailsSosBottomSheetBody(
                                  controller: controller,
                                  id: ride.id ?? '-1',
                                ),
                              ).customBottomSheet(context);
                            },
                          ),
                        ],
                        if (ride.status == AppStatus.RIDE_ACTIVE ||
                            ride.status == AppStatus.RIDE_PENDING) ...[
                          const SizedBox(height: Dimensions.space20),
                          RoundedButton(
                            text: MyStrings.cancelRide.tr,
                            press: () {
                              CustomBottomSheet(
                                child: const RideCancelBottomSheetBody(),
                              ).customBottomSheet(context);
                            },
                            color: MyColor.redCancelTextColor,
                          ),
                        ] else if (ride.paymentStatus == '1' &&
                            ride.driverReview == null) ...[
                          RoundedButton(
                            text: MyStrings.review,
                            isOutlined: false,
                            press: () {
                              CustomBottomSheet(
                                child: RideDetailsReviewBottomSheet(
                                  ride: controller.ride,
                                ),
                              ).customBottomSheet(context);
                            },
                            textColor: MyColor.colorWhite,
                          ),
                        ] else if (controller.ride.status == "4") ...[
                          if (ride.paymentStatus == '2' &&
                              controller.isPaymentRequested == false) ...[
                            SizedBox(height: Dimensions.space20),
                            RoundedButton(
                              text: MyStrings.paymentNow,
                              isOutlined: false,
                              press: () {
                                Get.toNamed(
                                  RouteHelper.paymentScreen,
                                  arguments: ride,
                                );
                              },
                              textColor: MyColor.colorWhite,
                            ).animate().shakeX(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                ),
                          ] else ...[
                            Column(
                              children: [
                                const SizedBox(height: Dimensions.space10),
                                RippleAnimation(
                                  repeat: true,
                                  color: MyColor.primaryColor,
                                  minRadius: 18,
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                      Dimensions.space15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: MyColor.primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.space20),
                                Center(
                                  child: Text(
                                    MyStrings.waitForDriverResponse,
                                    style: boldDefault.copyWith(
                                      color: MyColor.primaryColor,
                                    ),
                                  ).animate(
                                    onComplete: (controller) {
                                      controller.repeat();
                                      MyUtils.vibrate();
                                    },
                                  ).shimmer(
                                    duration: const Duration(seconds: 2),
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                                const SizedBox(height: Dimensions.space10),
                              ],
                            ),
                            SizedBox(height: Dimensions.space20),
                          ],
                        ] else if (controller.ride.status == "1") ...[
                          const SizedBox(height: Dimensions.space25),
                          Container(
                            width: context.width,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: MyColor.greenSuccessColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(
                                Dimensions.mediumRadius,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                MyStrings.rideCompleted.tr,
                                style: boldDefault.copyWith(
                                  color: MyColor.greenSuccessColor,
                                ),
                              ),
                            ),
                          ),
                        ] else if (ride.status == AppStatus.RIDE_CANCELED) ...[
                          const SizedBox(height: Dimensions.space20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(Dimensions.space15),
                            decoration: BoxDecoration(
                              color: MyUtils.getRideStatusColor(
                                AppStatus.RIDE_CANCELED,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                Dimensions.mediumRadius,
                              ),
                              border: Border.all(
                                color: MyUtils.getRideStatusColor(
                                  AppStatus.RIDE_CANCELED,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                MyStrings.rideCanceled.tr,
                                style: boldDefault.copyWith(
                                  color: MyUtils.getRideStatusColor(
                                    AppStatus.RIDE_CANCELED,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: Dimensions.space20),
                      ],
                    ),
                  ),
                  if (ride.driver == null && ride.status == '0') ...[
                    DriverSearchWidget(
                      bids: controller.totalBids.toString(),
                      onTap: () {
                        printX(ride.id.toString());
                        Get.toNamed(
                          RouteHelper.rideBidScreen,
                          arguments: ride.id.toString(),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  CardColumn rideCardDetails({
    required String title,
    required String description,
  }) {
    return CardColumn(
      header: title.tr,
      body: description.tr,
      headerTextStyle: boldMediumLarge.copyWith(color: MyColor.primaryColor),
      bodyTextStyle: regularMediumLarge.copyWith(color: MyColor.bodyText),
      alignmentCenter: true,
    );
  }
}
