import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/coupon/coupon_controller.dart';
import 'package:leoparduser/data/repo/coupon/coupon_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:leoparduser/presentation/components/text-form-field/custom_text_field.dart';
import 'package:leoparduser/presentation/screens/coupon/widget/coupon_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(CouponRepo(apiClient: Get.find()));
    Get.put(CouponController(couponRepo: Get.find(), rideId: Get.arguments));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: CustomAppBar(title: MyStrings.applyCoupon),
      body: GetBuilder<CouponController>(
        builder: (controller) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: Dimensions.screenPaddingHV,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.space15 + 1,
                      vertical: Dimensions.space25 - 1),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius:
                        BorderRadius.circular(Dimensions.mediumRadius),
                  ),
                  child: Column(
                    children: [
                      CustomTextField(
                        onChanged: (val) {},
                        needOutlineBorder: true,
                        animatedLabel: true,
                        radius: Dimensions.mediumRadius,
                        labelText: MyStrings.enterCouponCode,
                        controller: controller.applyTextController,
                      ),
                      const SizedBox(height: Dimensions.space25 - 1),
                      RoundedButton(
                        text: MyStrings.apply,
                        isLoading: controller.isApplyLoading,
                        press: () {
                          if (controller.applyTextController.text.isNotEmpty) {
                            controller.apply();
                          } else {
                            CustomSnackBar.error(
                                errorList: [MyStrings.enterCouponCode.tr]);
                          }
                        },
                        color: MyColor.colorBlack,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.space20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.space15 + 1,
                      vertical: Dimensions.space25 - 1),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius:
                        BorderRadius.circular(Dimensions.mediumRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(MyStrings.selectCoupon.tr, style: boldExtraLarge),
                      const SizedBox(height: Dimensions.space12),
                      Column(
                        children: List.generate(
                          controller.couponList.length,
                          (index) => MyCouponCard(
                            isApplied:
                                controller.couponList[index].code.toString() ==
                                    controller.selectedCoupon.code.toString(),
                            coupon: controller.couponList[index],
                            currencySym: controller.defaultCurrencySymbol,
                            apply: () {
                              controller
                                  .applyCoupon(controller.couponList[index]);
                            },
                            remove: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
