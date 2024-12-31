import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/home/home_controller.dart';
import 'package:leoparduser/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/components/image/custom_svg_picture.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:leoparduser/presentation/screens/home/widgets/home_offer_rate_widget.dart';
import 'package:leoparduser/presentation/screens/home/widgets/home_select_payment_method.dart';
import 'package:leoparduser/presentation/screens/home/widgets/passenger_bottom_sheet.dart';

class RideCreateForm extends StatelessWidget {
  const RideCreateForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                CustomBottomSheet(child: const HomeSelectPaymentMethod())
                    .customBottomSheet(context);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(color: MyColor.borderColor, width: 0.5),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomSvgPicture(
                            image: MyIcons.money, color: MyColor.primaryColor),
                        SizedBox(width: Dimensions.space5),
                        Text(
                            (controller.selectedPaymentMethod.id == '-1'
                                    ? MyStrings.paymentMethod.tr
                                    : controller.selectedPaymentMethod.method
                                            ?.name ??
                                        MyStrings.paymentMethod)
                                .tr,
                            style: regularDefault.copyWith(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        color: MyColor.getRideSubTitleColor(), size: 16),
                  ],
                ),
              ),
            ),
            spaceDown(Dimensions.space15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      if (controller.selectedService.id != '-99') {
                        controller.updateMainAmount(controller.mainAmount);
                        CustomBottomSheet(
                          child: const HomeOfferRateWidget(),
                        ).customBottomSheet(context);
                      } else {
                        CustomSnackBar.error(
                            errorList: [MyStrings.pleaseSelectAService]);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.space15,
                          vertical: Dimensions.space15),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: MyColor.borderColor, width: 0.5),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Text(
                                controller.mainAmount == 0
                                    ? MyStrings.offerYourRate.tr
                                    : '${Converter.formatDouble(controller.mainAmount.toString())} ${controller.defaultCurrency}',
                                style: regularDefault.copyWith(
                                    color: MyColor.bodyText))
                          ]),
                          Icon(Icons.keyboard_arrow_down_rounded,
                              color: MyColor.getRideSubTitleColor(), size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                spaceSide(Dimensions.space15),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      CustomBottomSheet(child: const PassengerBottomSheet())
                          .customBottomSheet(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.space15,
                          vertical: Dimensions.space15),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: MyColor.borderColor, width: .5),
                          borderRadius:
                              BorderRadius.circular(Dimensions.mediumRadius)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomSvgPicture(
                                  image: MyIcons.user,
                                  color: MyColor.primaryColor),
                              spaceSide(Dimensions.space8),
                              Text(
                                  "${controller.passenger.toString()} ${MyStrings.person.tr}",
                                  style: regularDefault.copyWith()),
                            ],
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded,
                              color: MyColor.getRideSubTitleColor(), size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            spaceDown(Dimensions.space15),
          ],
        );
      },
    );
  }
}
