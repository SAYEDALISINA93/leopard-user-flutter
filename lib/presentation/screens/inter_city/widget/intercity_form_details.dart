import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/date_converter.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:leoparduser/presentation/screens/inter_city/widget/intercity_offer_rate_widget.dart';
import 'package:leoparduser/presentation/screens/inter_city/widget/intercity_payment_methods.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/style.dart';
import '../../../../core/utils/util.dart';
import '../../../components/bottom-sheet/custom_bottom_sheet.dart';
import '../../../components/buttons/rounded_button.dart';
import '../../../components/divider/custom_spacer.dart';
import '../../../components/text-form-field/custom_text_field.dart';
import '../../../components/text/header_text.dart';
import 'package:leoparduser/data/controller/inter_city/inter_city_controller.dart';

class InterCityDetailsCard extends StatelessWidget {
  final InterCityController controller;
  const InterCityDetailsCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spaceDown(Dimensions.space15),
              HeaderText(
                  text: MyStrings.selectService,
                  textStyle: boldLarge.copyWith(
                      color: MyColor.getRideTitleColor(),
                      fontWeight: FontWeight.normal,
                      fontSize: Dimensions.fontOverLarge)),
              spaceDown(Dimensions.space15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(
                    controller.appServices.length,
                    (index) => GestureDetector(
                      onTap: () {
                        controller.selectService(controller.appServices[index]);
                      },
                      child: IntrinsicHeight(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 8),
                          width: Dimensions.space50 + 35,
                          decoration: BoxDecoration(
                            color: MyColor.colorWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: controller.appServices[index].id ==
                                    controller.selectedService.id
                                ? Border.all(
                                    color: MyColor.primaryColor,
                                    width: 1.5,
                                  )
                                : Border.all(
                                    color: MyColor.colorGrey2,
                                    width: 1.2,
                                  ),
                          ),
                          child: FittedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyImageWidget(
                                  imageUrl:
                                      controller.appServices[index].image ?? '',
                                  height: 60,
                                  width: 60,
                                  radius: 10,
                                ),
                                spaceDown(Dimensions.space10),
                                FittedBox(
                                  child: Text(
                                    controller.appServices[index].name ?? '',
                                    style: regularDefault.copyWith(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        //Offer Area
        spaceDown(Dimensions.space30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            decoration: BoxDecoration(
              color: MyColor.colorWhite,
              borderRadius: BorderRadius.circular(Dimensions.space12),
              boxShadow: MyUtils.getCardTopShadow(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.rideFare.status != '-1') ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Dimensions.space20),
                    decoration: BoxDecoration(
                        color: MyColor.bodyTextBgColor,
                        borderRadius: BorderRadius.circular(Dimensions.space5)),
                    child: Text(
                      MyStrings.recommendPrice.rKv({
                        "priceKey":
                            "${controller.defaultCurrencySymbol}${Converter.formatNumber(controller.rideFare.minAmount.toString())}",
                        "distanceKey":
                            "${controller.rideFare.distance}${MyStrings.km.tr}",
                      }).tr,
                      style: regularDefault.copyWith(color: MyColor.bodyText),
                    ),
                  ),
                ],
                spaceDown(Dimensions.space5),
                CustomTextField(
                  onChanged: (val) {},
                  onTap: () {
                    if (controller.selectedService.id != '-99') {
                    } else {
                      CustomSnackBar.error(
                          errorList: [MyStrings.pleaseSelectAService]);
                    }
                  },
                  animatedLabel: false,
                  needOutlineBorder: true,
                  readOnly: true,
                  labelText: '',
                  hintText:
                      DateConverter.formatDate(controller.selectedDateTime),
                  radius: Dimensions.mediumRadius,
                  isShowSuffixIcon: true,
                ),
                spaceDown(Dimensions.space15),
                CustomTextField(
                  onChanged: (val) {},
                  controller: controller.passengerController,
                  animatedLabel: true,
                  needOutlineBorder: true,
                  labelText: MyStrings.numOfPassengers.tr,
                  radius: Dimensions.mediumRadius,
                  textInputType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                spaceDown(Dimensions.space15),
                InkWell(
                  onTap: () {
                    if (controller.rideFare.status != '-1') {
                      CustomBottomSheet(
                        child: const InterCityOfferRateWidget(),
                      ).customBottomSheet(context);
                    } else {
                      CustomSnackBar.error(
                          errorList: [MyStrings.pleaseSelectAService]);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyColor.borderColor, width: 0.5),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              controller.mainAmount == 0
                                  ? MyStrings.offerYourRate.tr
                                  : '${controller.mainAmount} ${controller.defaultCurrency}',
                              style: regularDefault.copyWith(
                                  color: MyColor.getRideSubTitleColor()),
                            ),
                          ],
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded,
                            color: MyColor.getRideSubTitleColor()),
                      ],
                    ),
                  ),
                ),
                spaceDown(Dimensions.space15),
                InkWell(
                  onTap: () {
                    if (controller.rideFare.status != '-1') {
                      CustomBottomSheet(
                        child: const InterCitySelectPaymentMethod(),
                      ).customBottomSheet(context);
                    } else {
                      CustomSnackBar.error(
                          errorList: [MyStrings.pleaseSelectAService]);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyColor.borderColor, width: 0.5),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              controller.selectedPaymentMethod.id == '-99'
                                  ? MyStrings.paymentMethod.tr
                                  : controller.selectedPaymentMethod.name ?? '',
                              style: regularDefault.copyWith(
                                  color: MyColor.getRideSubTitleColor()),
                            ),
                          ],
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded,
                            color: MyColor.getRideSubTitleColor()),
                      ],
                    ),
                  ),
                ),
                spaceDown(Dimensions.space15),
                CustomTextField(
                  onChanged: (val) {},
                  controller: controller.noteController,
                  animatedLabel: true,
                  needOutlineBorder: true,
                  hintText: "",
                  labelText: MyStrings.commentOptional.tr,
                  radius: Dimensions.mediumRadius,
                ),
                spaceDown(Dimensions.space15),
                RoundedButton(
                  text: MyStrings.submit.tr.toUpperCase(),
                  isLoading: controller.isSubmitLoading,
                  textStyle: boldDefault.copyWith(
                      color: MyColor.colorWhite,
                      fontSize: Dimensions.fontLarge),
                  press: () {
                    if (controller.isValidForNewRide()) {
                      controller.createRide();
                    } else {
                      CustomSnackBar.error(
                          errorList: [MyStrings.pleaseFillUpAllOfTheFields]);
                    }
                  },
                  isOutlined: false,
                ),
                spaceDown(Dimensions.space15),
              ],
            ),
          ),
        ),

        spaceDown(Dimensions.space50 + 50),
      ],
    );
  }
}
