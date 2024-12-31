import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/data/controller/inter_city/inter_city_controller.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_icons.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/style.dart';
import '../../../../environment.dart';
import '../../../components/bottom-sheet/bottom_sheet_header_row.dart';
import '../../../components/buttons/rounded_button.dart';
import '../../../components/divider/custom_spacer.dart';
import '../../../components/text-form-field/custom_text_field.dart';
import '../../../components/text/header_text.dart';

class InterCityOfferRateWidget extends StatelessWidget {
  const InterCityOfferRateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InterCityController>(builder: (controller) {
      return Container(
        // height: context.height / 1.6,
        color: MyColor.colorWhite,
        child: Column(
          children: [
            const BottomSheetHeaderRow(),
            HeaderText(
                text: MyStrings.offerYourRate,
                textStyle: boldLarge.copyWith(
                    color: MyColor.getRideTitleColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.fontOverLarge)),
            spaceDown(Dimensions.space15),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.space20),
                  decoration: BoxDecoration(
                      color: MyColor.bodyTextBgColor,
                      borderRadius: BorderRadius.circular(Dimensions.space5)),
                  child: Text(
                    MyStrings.recommendPrice.rKv({
                      "priceKey":
                          "${controller.defaultCurrencySymbol}${controller.rideFare.minAmount}",
                      "distanceKey":
                          "${controller.rideFare.distance}${MyStrings.km.tr}",
                    }).tr,
                    style: regularDefault.copyWith(color: MyColor.bodyText),
                  ),
                ),
                spaceDown(Dimensions.space15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.removeMainAmount(10);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.space50),
                          border: Border.all(
                              width: Dimensions.space2,
                              color: MyColor.rideBorderColor,
                              style: BorderStyle.solid),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space10,
                            vertical: Dimensions.space5),
                        child: HeaderText(
                            text: " -10 ",
                            textStyle: boldLarge.copyWith(
                                color: MyColor.bodyText,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.fontOverLarge - 2)),
                      ),
                    ),
                    spaceSide(Dimensions.space10),
                    HeaderText(
                        text:
                            "${Environment.baseCurrency}${controller.mainAmount}",
                        textStyle: boldLarge.copyWith(
                            color: MyColor.getRideTitleColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.fontOverLarge + 2)),
                    spaceSide(Dimensions.space10),
                    GestureDetector(
                      onTap: () {
                        controller.addMainAmount(10);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.space50),
                          border: Border.all(
                              width: Dimensions.space2,
                              color: MyColor.rideBorderColor,
                              style: BorderStyle.solid),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space10,
                            vertical: Dimensions.space5),
                        child: HeaderText(
                            text: " 10+ ",
                            textStyle: boldLarge.copyWith(
                                color: MyColor.bodyText,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.fontOverLarge - 2)),
                      ),
                    ),
                  ],
                ),
                spaceDown(Dimensions.space15),
                CustomTextField(
                  onChanged: (val) {
                    controller
                        .updateMainAmount(double.tryParse(val ?? '0.0') ?? 0.0);
                  },
                  controller: controller.amountController,
                  animatedLabel: true,
                  needOutlineBorder: true,
                  labelText: MyStrings.enterAmount.tr,
                  radius: Dimensions.mediumRadius,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputType: TextInputType.number,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(Dimensions.space10),
                    child: SvgPicture.asset(
                      MyIcons.coin,
                      width: Dimensions.space20,
                      height: Dimensions.space20,
                    ),
                  ),
                ),
                spaceDown(Dimensions.space20),
                RoundedButton(
                  text: MyStrings.done.tr.toUpperCase(),
                  textStyle: boldDefault.copyWith(
                      color: MyColor.colorWhite,
                      fontSize: Dimensions.fontLarge),
                  press: () {
                    Get.back();
                  },
                  isOutlined: false,
                ),
                spaceDown(Dimensions.space20),
              ],
            )
          ],
        ),
      );
    });
  }
}
