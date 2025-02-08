import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/home/home_controller.dart';
import 'package:leoparduser/presentation/components/bottom-sheet/my_bottom_sheet_bar.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';

class PassengerBottomSheet extends StatelessWidget {
  const PassengerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.space15, vertical: Dimensions.space10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyBottomSheetBar(),
            const SizedBox(height: Dimensions.space10),
            Text(MyStrings.howManyOfYouWillGo.tr,
                style: boldExtraLarge.copyWith()),
            const SizedBox(height: Dimensions.space40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => controller.updatePassenger(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space25,
                        vertical: Dimensions.space5),
                    decoration: BoxDecoration(
                      color: MyColor.borderColor.withValues(alpha: 0.5),
                      borderRadius:
                          BorderRadius.circular(Dimensions.largeRadius),
                    ),
                    child: Text(
                      '-',
                      style: regularDefault.copyWith(
                          fontSize: Dimensions.fontBalance),
                    ),
                  ),
                ),
                Text(
                  controller.passenger.toString(),
                  style:
                      boldExtraLarge.copyWith(fontSize: Dimensions.fontBalance),
                ),
                InkWell(
                  onTap: () => controller.updatePassenger(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space25,
                        vertical: Dimensions.space5),
                    decoration: BoxDecoration(
                        color: MyColor.borderColor.withValues(alpha: 0.5),
                        borderRadius:
                            BorderRadius.circular(Dimensions.largeRadius)),
                    child: Text(
                      '+',
                      style: regularDefault.copyWith(
                          fontSize: Dimensions.fontBalance),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.space40),
            RoundedButton(
              text: MyStrings.done.toTitleCase(),
              press: () {
                Get.back();
              },
            )
          ],
        ),
      );
    });
  }
}
