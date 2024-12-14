import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/ride/ride_bid_list/ride_bid_list_controller.dart';
import 'package:leoparduser/presentation/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/text-form-field/custom_text_field.dart';

class CancelBottomSheet extends StatelessWidget {
  const CancelBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideBidListController>(builder: (controller) {
      return Column(
        children: [
          const BottomSheetHeaderRow(),
          const SizedBox(height: Dimensions.space10),
          CustomTextField(
            labelTextStyle: boldDefault.copyWith(),
            animatedLabel: false,
            needOutlineBorder: true,
            fillColor: MyColor.colorGrey.withOpacity(0.1),
            labelText: MyStrings.cancelReason.tr,
            hintText: MyStrings.cancelationReason,
            maxLines: 6,
            controller: controller.cancelReasonController,
            onChanged: (c) {},
          ),
          const SizedBox(height: Dimensions.space20),
          RoundedButton(
              text: MyStrings.cancel,
              isLoading: controller.isCancelLoading,
              press: () {
                if (controller.cancelReasonController.text.isNotEmpty) {
                  controller.cancelRide();
                }
              }),
          const SizedBox(height: Dimensions.space10),
        ],
      );
    });
  }
}
