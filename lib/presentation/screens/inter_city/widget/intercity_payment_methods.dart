import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/data/controller/inter_city/inter_city_controller.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/style.dart';
import '../../../components/bottom-sheet/bottom_sheet_header_row.dart';
import '../../../components/divider/custom_spacer.dart';
import '../../../components/text/header_text.dart';
import '../../topup_screen/payment_method_card.dart';

class InterCitySelectPaymentMethod extends StatelessWidget {
  const InterCitySelectPaymentMethod({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InterCityController>(builder: (controller) {
      return Container(
        height: context.height / 1.6,
        color: MyColor.colorWhite,
        child: Column(
          children: [
            const BottomSheetHeaderRow(),
            HeaderText(
                text: MyStrings.selectPaymentMethod,
                textStyle: mediumOverLarge.copyWith(
                    fontSize: Dimensions.fontOverLarge,
                    fontWeight: FontWeight.normal,
                    color: MyColor.colorBlack)),
            spaceDown(Dimensions.space15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    controller.paymentMethodList.length,
                    (index) => PaymentMethodCard(
                      assetPath: '',
                      paymentMethod: controller.paymentMethodList[index],
                      selected:
                          controller.paymentMethodList[index].id.toString() ==
                              controller.selectedPaymentMethod.id.toString(),
                      press: () {
                        controller.selectPaymentMethod(
                            controller.paymentMethodList[index]);
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
