import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/app_status.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/coupon/coupon_controller.dart';
import 'package:leoparduser/data/controller/payment/ride_payment_controller.dart';
import 'package:leoparduser/data/model/global/app/ride_model.dart';
import 'package:leoparduser/data/repo/coupon/coupon_repo.dart';
import 'package:leoparduser/data/repo/payment/payment_repo.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import 'package:leoparduser/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/divider/custom_divider.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:leoparduser/presentation/screens/coupon/widget/coupon_widget.dart';
import 'package:leoparduser/presentation/screens/payment/widget/payment_bottom_sheet.dart';
import 'package:leoparduser/presentation/screens/payment/widget/payment_ride_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:leoparduser/presentation/screens/payment/widget/tips_bottom_sheet_body.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    RideModel ride = Get.arguments;

    Get.put(CouponRepo(apiClient: Get.find()));
    Get.put(
      CouponController(couponRepo: Get.find(), rideId: ride.id.toString()),
    );
    Get.put(PaymentRepo(apiClient: Get.find()));
    final controller = Get.put(
      RidePaymentController(repo: Get.find(), couponController: Get.find()),
    );
    super.initState();
    printX(ride.id);
    WidgetsBinding.instance.addPostFrameCallback((time) {
      controller.initialData(ride);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RidePaymentController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: MyColor.screenBgColor,
          appBar: CustomAppBar(title: MyStrings.payment),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: Dimensions.screenPaddingHV,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentRideDetailsCard(
                  currency: controller.defaultCurrencySymbol,
                  ride: controller.ride,
                  driverImageUrl:
                      '${controller.driverImagePath}/${controller.ride.driver?.avatar}',
                ),
                const SizedBox(height: Dimensions.space15),
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: Dimensions.space15,
                    vertical: Dimensions.space20,
                  ),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    boxShadow: MyUtils.getShadow2(blurRadius: 10),
                    borderRadius: BorderRadius.circular(
                      Dimensions.mediumRadius,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            MyIcons.discount,
                            height: Dimensions.space30,
                            width: Dimensions.space30,
                          ),
                          const SizedBox(width: Dimensions.space12 - 1),
                          Text(
                            MyStrings.addCouponCode.tr,
                            style: mediumMediumLarge.copyWith(),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            RouteHelper.couponScreen,
                            arguments: controller.ride.id.toString(),
                          );
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: MyColor.primaryColor.withValues(alpha: 0.05),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: MyColor.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.space12),
                GetBuilder<CouponController>(
                  builder: (couponController) {
                    return couponController.selectedCoupon.id != '-1'
                        ? Container(
                            padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: Dimensions.space15,
                              vertical: Dimensions.space20,
                            ),
                            decoration: BoxDecoration(
                              color: MyColor.colorWhite,
                              boxShadow: MyUtils.getShadow2(blurRadius: 10),
                              borderRadius: BorderRadius.circular(
                                Dimensions.mediumRadius,
                              ),
                            ),
                            child: Column(
                              children: [
                                MyCouponCard(
                                  coupon: couponController.selectedCoupon,
                                  currencySym: controller.defaultCurrencySymbol,
                                  apply: () {},
                                  isApplied: true,
                                  remove: () {
                                    if (couponController.isRemoveLoading) {
                                      return;
                                    }
                                    couponController.removeCoupon(
                                      couponController.selectedCoupon,
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: Dimensions.space12),
                Container(
                  width: context.width,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: Dimensions.space15,
                    vertical: Dimensions.space20,
                  ),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    boxShadow: MyUtils.getShadow2(blurRadius: 10),
                    borderRadius: BorderRadius.circular(
                      Dimensions.mediumRadius,
                    ),
                  ),
                  child: GetBuilder<CouponController>(
                    builder: (couponController) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            MyStrings.rideSummary.tr,
                            style: mediumMediumLarge,
                          ),
                          const SizedBox(height: Dimensions.space12),
                          summaryRow(
                            title: MyStrings.rideAmount,
                            amount:
                                "${controller.defaultCurrencySymbol}${StringConverter.formatNumber(controller.ride.amount ?? '0')}",
                          ),
                          const CustomDivider(
                            color: MyColor.rideSub,
                            space: Dimensions.space10,
                          ),
                          summaryRow(
                            title: MyStrings.discount,
                            amount:
                                "${couponController.selectedCoupon.discountType == AppStatus.DISCOUNT_FIXED ? controller.defaultCurrencySymbol : ''}"
                                "${StringConverter.formatNumber(couponController.selectedCoupon.amount ?? '0', precision: couponController.selectedCoupon.discountType == AppStatus.DISCOUNT_PERCENT ? 0 : 2)}"
                                "${couponController.selectedCoupon.discountType == AppStatus.DISCOUNT_PERCENT ? '%' : ''}",
                          ),
                          const CustomDivider(
                            color: MyColor.rideSub,
                            space: Dimensions.space10,
                          ),
                          summaryRow(
                            title: MyStrings.paymentMethod,
                            amount:
                                controller.selectedMethod.method?.name ?? '',
                            widget: GestureDetector(
                              onTap: () {
                                CustomBottomSheet(
                                  child: const PaymentMethodListBottomSheet(),
                                ).customBottomSheet(context);
                              },
                              child: controller.selectedMethod.id == "-9"
                                  ? Image.asset(
                                      controller.selectedMethod.method?.image ??
                                          '',
                                      width: Dimensions.space50 + 8,
                                      height: Dimensions.fontExtraLarge + 15,
                                      color: MyColor.primaryColor,
                                    )
                                  : MyImageWidget(
                                      imageUrl:
                                          '${controller.imagePath}/${controller.selectedMethod.method?.image}',
                                      width: 50,
                                      height: 50,
                                      radius: 25,
                                    ),
                            ),
                            isTitleBold: true,
                          ),
                          const CustomDivider(
                            color: MyColor.rideSub,
                            space: Dimensions.space10,
                          ),
                          summaryRow(
                            title: MyStrings.tips,
                            amount:
                                controller.selectedMethod.method?.name ?? '',
                            widget: GestureDetector(
                              onTap: () {
                                CustomBottomSheet(
                                  child: const TipsBottomSheet(),
                                ).customBottomSheet(context);
                              },
                              child: controller.tipsController.text.isEmpty
                                  ? Icon(Icons.add)
                                  : Text(
                                      "${controller.defaultCurrencySymbol}${StringConverter.formatNumber(controller.tipsController.text, precision: 2)}",
                                      style: regularDefault.copyWith(
                                        color: MyColor.greenP,
                                      ),
                                    ),
                            ),
                            isTitleBold: true,
                          ),
                          const CustomDivider(
                            color: MyColor.rideSub,
                            space: Dimensions.space10,
                          ),
                          summaryRow(
                            title: MyStrings.payableAmount,
                            amount:
                                "${controller.defaultCurrencySymbol}${StringConverter.sum(StringConverter.calculateDiscount(controller.ride.amount ?? '0', couponController.selectedCoupon.amount ?? '0', isPercentageCalculation: couponController.selectedCoupon.discountType == AppStatus.DISCOUNT_PERCENT), controller.tipsController.text)}",
                            isTitleBold: true,
                          ),
                          const SizedBox(height: Dimensions.space25 - 1),
                          RoundedButton(
                            text: MyStrings.pay,
                            press: () {
                              controller.submitPayment();
                            },
                            isLoading: controller.isSubmitBtnLoading,
                            isOutlined: false,
                            textStyle: boldMediumLarge.copyWith(
                              color: MyColor.colorWhite,
                            ),
                          ),
                        ],
                      ).animate().shimmer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Row summaryRow({
    required String title,
    required String amount,
    bool? isTitleBold = false,
    Widget? widget,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title.tr,
            overflow: TextOverflow.ellipsis,
            style: isTitleBold!
                ? regularMediumLarge.copyWith(color: MyColor.colorBlack)
                : regularMediumLarge.copyWith(color: MyColor.rideSub),
          ),
        ),
        // spaceSide(width: Dimensions.space15),
        Flexible(
          child: widget ??
              Text(
                amount.tr,
                overflow: TextOverflow.ellipsis,
                style: boldMediumLarge.copyWith(color: MyColor.colorBlack),
              ),
        ),
      ],
    );
  }
}
