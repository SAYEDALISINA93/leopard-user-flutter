import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/data/controller/payment/ride_payment_controller.dart';
import 'package:leoparduser/presentation/components/annotated_region/annotated_region_widget.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/style.dart';
import '../../../components/bottom-sheet/bottom_sheet_header_row.dart';
import '../../../components/divider/custom_spacer.dart';
import '../../../components/text/header_text.dart';
import '../../topup_screen/payment_method_card.dart';

class PaymentMethodListBottomSheet extends StatelessWidget {
  const PaymentMethodListBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RidePaymentController>(
      builder: (controller) {
        return AnnotatedRegionWidget(
          child: Container(
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
                    color: MyColor.colorBlack,
                  ),
                ),
                spaceDown(Dimensions.space15),
                Flexible(
                  child: ListView.builder(
                    itemCount: controller.methodList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return PaymentMethodCard(
                        paymentMethod: controller.methodList[index],
                        assetPath: controller.imagePath,
                        selected: controller.methodList[index].id.toString() ==
                            controller.selectedMethod.id.toString(),
                        press: () {
                          controller.updateSelectedGateway(
                            controller.methodList[index],
                          );
                        },
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
}
