import 'package:flutter/material.dart';
import 'package:leoparduser/core/helper/date_converter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/presentation/components/divider/custom_divider.dart';
import 'package:get/get.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../data/controller/payment_history/payment_history_controller.dart';
import '../../../components/animated_widget/expanded_widget.dart';
import '../../../components/column_widget/card_column.dart';

class CustomPaymentCard extends StatelessWidget {
  final int index;
  final int expandIndex;

  const CustomPaymentCard(
      {super.key, required this.index, required this.expandIndex});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentHistoryController>(builder: (controller) {
      final payment = controller.transactionList[index];

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${controller.currencySym}${Converter.formatNumber(payment.amount.toString())}",
                      style: boldLarge.copyWith(
                          fontWeight: FontWeight.w800,
                          color: MyColor.rideTitle),
                    ),
                    Text(
                      payment.ride?.uid ?? '',
                      style: regularSmall.copyWith(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.space5,
                          vertical: Dimensions.space2),
                      decoration: BoxDecoration(
                          color: MyUtils.paymentStatusColor(
                                  payment.paymentType ?? '0')
                              .withOpacity(0.01),
                          borderRadius:
                              BorderRadius.circular(Dimensions.defaultRadius),
                          border: Border.all(
                              color: MyUtils.paymentStatusColor(
                                  payment.paymentType ?? '0'))),
                      child: Text(
                          MyUtils.paymentStatus(payment.paymentType ?? '0'),
                          style: regularDefault.copyWith(
                              fontSize: 16,
                              color: MyUtils.paymentStatusColor(
                                  payment.paymentType ?? '0'))),
                    ),
                    spaceDown(Dimensions.space10),
                    Text(
                      DateConverter.isoToLocalDateAndTime(
                          payment.createdAt.toString()),
                      style: regularSmall.copyWith(
                          color: MyColor.hintTextColor,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ],
            ),
            ExpandedSection(
              expand: controller.expandIndex == index,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomDivider(space: Dimensions.space15),
                  Row(
                    children: [
                      Expanded(
                        child: CardColumn(
                          header: MyStrings.pickUpLocation,
                          body: payment.ride?.pickupLocation ?? "",
                          bodyMaxLine: 3,
                          space: Dimensions.space10,
                          headerTextStyle: regularDefault,
                          bodyTextStyle: regularSmall.copyWith(
                              fontWeight: FontWeight.w500,
                              color: MyColor.getTextColor().withOpacity(0.6)),
                        ),
                      ),
                      Expanded(
                        child: CardColumn(
                          alignmentEnd: true,
                          header: MyStrings.destination,
                          body: payment.ride?.destination ?? "",
                          bodyMaxLine: 3,
                          space: Dimensions.space8,
                          headerTextStyle: regularDefault,
                          bodyTextStyle: regularSmall.copyWith(
                              fontWeight: FontWeight.w500,
                              color: MyColor.getTextColor().withOpacity(0.6)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space10),
                  Row(
                    children: [
                      Expanded(
                        child: CardColumn(
                          header: MyStrings.distance,
                          body:
                              '${payment.ride?.distance ?? ''}${MyStrings.km.tr}',
                          headerTextStyle: regularDefault,
                          bodyTextStyle: regularSmall.copyWith(
                              fontWeight: FontWeight.w500,
                              color: MyColor.getTextColor().withOpacity(0.6)),
                        ),
                      ),
                      Expanded(
                        child: CardColumn(
                          alignmentEnd: true,
                          header: MyStrings.duration,
                          body: payment.ride?.duration ?? '',
                          headerTextStyle: regularDefault,
                          bodyTextStyle: regularSmall.copyWith(
                              fontWeight: FontWeight.w500,
                              color: MyColor.getTextColor().withOpacity(0.6)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
