import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/data/controller/payment/ride_payment_controller.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/image/custom_svg_picture.dart';
import 'package:leoparduser/presentation/components/text-form-field/custom_text_field.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/style.dart';
import '../../../components/bottom-sheet/bottom_sheet_header_row.dart';
import '../../../components/divider/custom_spacer.dart';

class TipsBottomSheet extends StatelessWidget {
  const TipsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RidePaymentController>(
      builder: (controller) {
        return Container(
          height: context.height * .4,
          color: MyColor.colorWhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BottomSheetHeaderRow(),
              spaceDown(Dimensions.space20),
              Flexible(
                child: ListView(
                  children: [
                    spaceDown(Dimensions.space15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 15,
                        children: List.generate(
                          controller.tipsList.length,
                          (index) => ZoomTapAnimation(
                            onTap: () {
                              controller.updateTips(controller.tipsList[index]);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.space15,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: MyColor.appBarColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${controller.defaultCurrencySymbol}${controller.tipsList[index]}",
                                style: regularDefault.copyWith(
                                  color: MyColor.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    spaceDown(Dimensions.space30),
                    CustomTextField(
                      animatedLabel: false,
                      needOutlineBorder: true,
                      controller: controller.tipsController,
                      labelText: MyStrings.amount.tr,
                      onChanged: (value) {},
                      textInputType: TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      inputAction: TextInputAction.done,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CustomSvgPicture(
                          image: MyIcons.coin,
                          color: MyColor.primaryColor,
                        ),
                      ),
                      validator: (value) {
                        return;
                      },
                      onSubmit: () {
                        Get.back();
                      },
                    ),
                    spaceDown(Dimensions.space30),
                    RoundedButton(
                      text: MyStrings.continue_.tr,
                      press: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
