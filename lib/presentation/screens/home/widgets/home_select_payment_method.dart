import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/controller/home/home_controller.dart';
import 'package:leoparduser/presentation/components/bottom-sheet/my_bottom_sheet_bar.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/style.dart';
import '../../../components/divider/custom_spacer.dart';
import '../../../components/text/header_text.dart';
import '../../topup_screen/payment_method_card.dart';

class HomeSelectPaymentMethod extends StatelessWidget {
  const HomeSelectPaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Container(
        height: context.height / 1.6,
        color: MyColor.colorWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyBottomSheetBar(),
            HeaderText(
                text: MyStrings.selectPaymentMethod,
                textStyle: mediumOverLarge.copyWith(
                    fontSize: Dimensions.fontOverLarge,
                    fontWeight: FontWeight.normal,
                    color: MyColor.colorBlack)),
            spaceDown(Dimensions.space15),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.paymentMethodList.length,
                itemBuilder: (context, index) {
                  return PaymentMethodCard(
                    paymentMethod: controller.paymentMethodList[index],
                    selected:
                        controller.paymentMethodList[index].id.toString() ==
                            controller.selectedPaymentMethod.id.toString(),
                    assetPath:
                        '${UrlContainer.domainUrl}/${controller.gatewayImagePath}/',
                    press: () {
                      controller.selectPaymentMethod(
                          controller.paymentMethodList[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
