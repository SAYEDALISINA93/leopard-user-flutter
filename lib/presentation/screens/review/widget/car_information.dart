import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/review/review_controller.dart';
import 'package:leoparduser/data/model/global/user/global_driver_model.dart';
import 'package:leoparduser/presentation/components/column_widget/card_column.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';

class CarInformation extends StatefulWidget {
  const CarInformation({super.key});

  @override
  State<CarInformation> createState() => _CarInformationState();
}

class _CarInformationState extends State<CarInformation> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(
      builder: (controller) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(),
          padding: EdgeInsets.symmetric(horizontal: Dimensions.space10),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  spaceDown(Dimensions.space20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.space10,
                        vertical: Dimensions.space10),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.mediumRadius),
                      color: MyColor.colorWhite,
                      boxShadow: MyUtils.getCardShadow(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(MyStrings.driverInformation.tr,
                            style: boldDefault.copyWith()),
                        spaceDown(Dimensions.space10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 10,
                            children: [
                              verifiedChip(
                                  text: MyStrings.email.tr,
                                  isVerified: controller.driver?.ev == "1"),
                              verifiedChip(
                                  text: MyStrings.phone.tr,
                                  isVerified: controller.driver?.sv == "1"),
                              verifiedChip(
                                  text: MyStrings.driver.tr,
                                  isVerified: controller.driver?.dv == "1"),
                              verifiedChip(
                                  text: MyStrings.vehicle.tr,
                                  isVerified: controller.driver?.vv == "1"),
                            ],
                          ),
                        ),
                        spaceDown(Dimensions.space10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            controller.driver?.driverData?.length ?? 0,
                            (index) => vehicleData(
                                data: controller.driver?.driverData?[index] ??
                                    KycPendingData()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  spaceDown(Dimensions.space20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.space10,
                        vertical: Dimensions.space10),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.mediumRadius),
                      color: MyColor.colorWhite,
                      boxShadow: MyUtils.getCardShadow(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(MyStrings.additionalInformation.tr,
                            style: boldDefault.copyWith()),
                        spaceDown(Dimensions.space10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            controller.driver?.vehicleData?.length ?? 0,
                            (index) => vehicleData(
                                data: controller.driver?.vehicleData?[index] ??
                                    KycPendingData()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  spaceDown(Dimensions.space20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.space10,
                        vertical: Dimensions.space10),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.mediumRadius),
                      color: MyColor.colorWhite,
                      boxShadow: MyUtils.getCardShadow(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(MyStrings.carRules.tr,
                            style: boldDefault.copyWith()),
                        spaceDown(Dimensions.space10),
                        Column(
                          children: List.generate(
                            (controller.driver?.rules?.length ?? 0),
                            (index) => rulesData(
                                text: controller.driver?.rules?[index] ?? ""),
                          ),
                        ),
                      ],
                    ),
                  ),
                  spaceDown(Dimensions.space20),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget verifiedChip({required String text, bool isVerified = false}) {
    return ChipTheme(
      data: ChipTheme.of(context),
      child: Chip(
        backgroundColor: isVerified
            ? MyColor.greenSuccessColor.withValues(alpha: 0.1)
            : MyColor.redCancelTextColor.withValues(alpha: 0.1),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(
            color: isVerified
                ? MyColor.greenSuccessColor
                : MyColor.redCancelTextColor),
        label: Row(
          children: [
            Icon(isVerified ? Icons.check_circle_outline : Icons.close_outlined,
                color: isVerified
                    ? MyColor.greenSuccessColor
                    : MyColor.redCancelTextColor),
            const SizedBox(width: Dimensions.space5),
            Text(
              text.tr,
              style: boldDefault.copyWith(
                  color: isVerified
                      ? MyColor.greenSuccessColor
                      : MyColor.redCancelTextColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget rulesData({required String text}) {
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

  Widget vehicleData({required KycPendingData data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: CardColumn(
        header: data.name ?? '',
        body: data.type == "file" ? "Attachment".tr : data.value ?? '',
        bodyMaxLine: 2,
        headerTextStyle: regularDefault.copyWith(color: MyColor.bodyTextColor),
        bodyTextStyle: boldDefault.copyWith(color: MyColor.colorBlack),
      ),
    );
  }
}
