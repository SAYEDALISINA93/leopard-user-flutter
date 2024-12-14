// ignore_for_file: unrelated_type_equality_checks

import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/data/model/global/app/app_payment_method.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/style.dart';

// ignore: must_be_immutable
class TopUpCard extends StatelessWidget {
  final VoidCallback press;
  AppPaymentMethod paymentMethod;
  bool selected = false;
  TopUpCard({
    super.key,
    required this.press,
    required this.paymentMethod,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        printx('=> press');
      },
      child: Container(
        margin: const EdgeInsetsDirectional.only(top: 10),
        child: Material(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.space10),
            side: BorderSide(
              color: selected
                  ? MyColor.primaryColor
                  : MyColor.rideBorderColor.withOpacity(.9),
            ),
          ),
          color: Colors.white,
          child: CheckboxListTile(
            value: selected,
            checkboxShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.space10),
            ),
            onChanged: (val) {
              press();
            },
            contentPadding: const EdgeInsetsDirectional.only(
              start: Dimensions.space20,
              end: Dimensions.space20,
              top: Dimensions.space1,
              bottom: Dimensions.space1,
            ),
            activeColor: MyColor.primaryColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (paymentMethod.id == "-9" || paymentMethod.id == "-99") ...[
                  Image.asset(
                    paymentMethod.method?.image ?? '',
                    width: Dimensions.space50 + 8,
                    height: Dimensions.fontExtraLarge + 15,
                  )
                ] else ...[
                  MyImageWidget(
                    imageUrl: paymentMethod.method?.image ?? '',
                    width: Dimensions.space50 + 8,
                    height: Dimensions.fontExtraLarge + 15,
                    boxFit: BoxFit.fitWidth,
                    radius: 4,
                  ),
                ],
                spaceSide(Dimensions.space10),
                Text(
                  paymentMethod.method?.name ?? '',
                  style: semiBoldDefault.copyWith(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
