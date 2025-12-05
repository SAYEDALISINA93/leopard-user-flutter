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

class ActiveRideCard extends StatefulWidget {
  String currency;
  RideModel ride;
  ActiveRideCard({super.key, required this.currency, required this.ride});

  @override
  State<ActiveRideCard> createState() => _ActiveRideCardState();
}

class _ActiveRideCardState extends State<ActiveRideCard> {
  bool isDownLoadLoading = false;

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
            boxShadow: MyUtils.getCardShadow(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.ride.status ==
                      AppStatus.RIDE_RUNNING.toString()) ...[
                    Text(
                      MyStrings.runningRide.tr,
                      style: regularDefault.copyWith(fontSize: 16),
                    ),
                  ] else ...[
                    Text(
                      MyStrings.ride.tr,
                      style: regularDefault.copyWith(fontSize: 16),
                    ),
                  ],
                  Text(
                    "${widget.currency}${StringConverter.formatNumber(widget.ride.amount.toString())}",
                    style: boldLarge.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: MyColor.rideTitle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.space20),
              //Location Timeline
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    RouteHelper.rideDetailsScreen,
                    arguments: widget.ride.id.toString(),
                  );
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
                          widget.ride.pickupLocation ?? '',
                          style: regularDefault.copyWith(
                            color: MyColor.getRideSubTitleColor(),
                            fontSize: Dimensions.fontSmall,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.ride.startTime != null) ...[
                          spaceDown(Dimensions.space8),
                          Text(
                            DateConverter.estimatedDate(
                              DateTime.tryParse('${widget.ride.startTime}') ??
                                  DateTime.now(),
                            ),
                            style: regularDefault.copyWith(
                              color: MyColor.getRideSubTitleColor(),
                              fontSize: Dimensions.fontSmall,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
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
                          widget.ride.destination ?? '',
                          style: regularDefault.copyWith(
                            color: MyColor.getRideSubTitleColor(),
                            fontSize: Dimensions.fontSmall,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.ride.status !=
                            AppStatus.RIDE_RUNNING.toString()) ...[
                          if (widget.ride.endTime != null) ...[
                            spaceDown(Dimensions.space8),
                            Text(
                              DateConverter.estimatedDate(
                                DateTime.tryParse('${widget.ride.endTime}') ??
                                    DateTime.now(),
                              ),
                              style: regularDefault.copyWith(
                                color: MyColor.getRideSubTitleColor(),
                                fontSize: Dimensions.fontSmall,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              spaceDown(Dimensions.space10),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: MyColor.colorGrey2.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(
                        Dimensions.mediumRadius,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          MyStrings.createdTime.tr,
                          style: boldDefault.copyWith(
                            color: MyColor.colorGrey,
                          ),
                        ),
                        Text(
                          DateConverter.estimatedDate(
                            DateTime.tryParse('${widget.ride.createdAt}') ??
                                DateTime.now(),
                          ),
                          style: boldDefault.copyWith(
                            color: MyColor.colorGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.ride.status == AppStatus.RIDE_PENDING) ...[
                    const SizedBox(height: Dimensions.space15),
                    RoundedButton(
                      text:
                          "${MyStrings.viewBids.tr}${widget.ride.bidsCount != null && widget.ride.bidsCount != "0" ? " (${widget.ride.bidsCount})" : ""}",
                      press: () {
                        Get.toNamed(
                          RouteHelper.rideBidScreen,
                          arguments: widget.ride.id.toString(),
                        );
                      },
                      isOutlined: false,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: Dimensions.space10),
              if (widget.ride.status == AppStatus.RIDE_COMPLETED) ...[
                RoundedButton(
                  text: MyStrings.receipt,
                  isLoading: isDownLoadLoading,
                  press: () {
                    setState(() {
                      isDownLoadLoading = true;
                    });
                    printX(isDownLoadLoading);
                    // DownloadService.downloadPDF(
                    //   url: "${UrlContainer.rideReceipt}/${widget.ride.id}",
                    //   fileName: "${Environment.appName}_recipt_${widget.ride.id}.pdf",
                    // );
                    Future.delayed(const Duration(seconds: 1), () {}).then((_) {
                      setState(() {
                        isDownLoadLoading = false;
                      });
                    });

                    printX(isDownLoadLoading);
                  },
                  textColor: MyColor.getRideTitleColor(),
                  textStyle: regularDefault.copyWith(
                    color: MyColor.colorWhite,
                    fontSize: Dimensions.fontLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
