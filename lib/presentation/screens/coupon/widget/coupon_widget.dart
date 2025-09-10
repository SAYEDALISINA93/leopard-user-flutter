import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/app_status.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/model/global/app/app_coupon_model.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyCouponCard extends StatelessWidget {
  bool isApplied = false;
  String currencySym;
  CouponModel coupon;
  VoidCallback apply;
  VoidCallback remove;

  MyCouponCard({
    super.key,
    required this.coupon,
    required this.currencySym,
    required this.apply,
    required this.remove,
    this.isApplied = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        // height: 150,
        padding: const EdgeInsets.all(Dimensions.space10),
        child: CouponCard(
          firstChild: Container(
            padding: const EdgeInsets.all(Dimensions.space12),
            child: SvgPicture.asset(
              MyIcons.discount,
              height: Dimensions.space10,
              width: Dimensions.space10,
              colorFilter: const ColorFilter.mode(
                MyColor.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          secondChild: Container(
            padding: const EdgeInsets.all(Dimensions.space12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${MyStrings.missYouHeres.tr} ${coupon.discountType == AppStatus.DISCOUNT_FIXED ? currencySym : ''}${StringConverter.formatNumber(coupon.amount.toString(), precision: coupon.discountType == AppStatus.DISCOUNT_PERCENT ? 0 : 2)}${coupon.discountType == AppStatus.DISCOUNT_PERCENT ? '%' : ''} ${MyStrings.off.tr}",
                        style: regularDefault.copyWith(),
                        maxLines: 2,
                      ),
                    ),
                    isApplied
                        ? const SizedBox.shrink()
                        : InkWell(
                            onTap: apply,
                            child: Text(
                              MyStrings.apply.tr,
                              style: mediumDefault.copyWith(
                                color: MyColor.primaryColor,
                              ),
                            ),
                          ),
                  ],
                ),
                spaceDown(Dimensions.space8),
                Text(
                  "${coupon.discountType == AppStatus.DISCOUNT_FIXED ? currencySym : ''}${StringConverter.formatNumber(coupon.amount.toString(), precision: coupon.discountType == AppStatus.DISCOUNT_PERCENT ? 0 : 2)}${coupon.discountType == AppStatus.DISCOUNT_PERCENT ? '%' : ''}",
                  style: boldExtraLarge.copyWith(color: MyColor.primaryColor),
                ),
                spaceDown(Dimensions.space8),
                isApplied
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.space10,
                              vertical: Dimensions.space5,
                            ),
                            decoration: BoxDecoration(
                              color: MyColor.colorGreen.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(
                                Dimensions.mediumRadius,
                              ),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  MyIcons.tickMark,
                                  colorFilter: const ColorFilter.mode(
                                    MyColor.colorGreen,
                                    BlendMode.srcIn,
                                  ),
                                  height: Dimensions.fontSmall,
                                ),
                                const SizedBox(width: Dimensions.space5),
                                Text(
                                  MyStrings.codeApplied.tr,
                                  style: boldLarge.copyWith(
                                    color: MyColor.colorGreen,
                                    fontSize: Dimensions.fontSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: remove,
                            child: Text(
                              MyStrings.removed.tr,
                              style: boldLarge.copyWith(
                                color: MyColor.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.space10,
                          vertical: Dimensions.space5,
                        ),
                        decoration: BoxDecoration(
                          color: MyColor.primaryColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(
                            Dimensions.mediumRadius,
                          ),
                        ),
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              coupon.minimumAmount != 'null'
                                  ? Text(
                                      "${MyStrings.minSpend.tr} $currencySym${StringConverter.formatNumber(coupon.minimumAmount.toString())}",
                                      style: regularDefault.copyWith(
                                        color: MyColor.rideTitle,
                                        fontSize: Dimensions.fontSmall,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              spaceSide(Dimensions.space10),
                              Text(
                                "${MyStrings.exOn.tr} ${coupon.endAt.toString()}",
                                style: regularDefault.copyWith(
                                  color: MyColor.rideTitle,
                                  fontSize: Dimensions.fontSmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                spaceDown(Dimensions.space8),
              ],
            ),
          ),
          curveAxis: Axis.vertical,
          border: const BorderSide(color: MyColor.borderColor, width: .5),
          curvePosition: 60,
          clockwise: false,
          curveRadius: 20,
          height: 150,
        ),
      ),
    );
  }
}
