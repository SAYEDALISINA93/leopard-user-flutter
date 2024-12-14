import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/presentation/components/bottom-sheet/my_bottom_sheet_bar.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';

class RideCityWarningBottomSheetBody extends StatelessWidget {
  final VoidCallback yes;
  final VoidCallback no;
  const RideCityWarningBottomSheetBody({
    super.key,
    required this.yes,
    required this.no,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.space15, vertical: Dimensions.space10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyBottomSheetBar(),
          Text('Do you want to InterCity ride ?',
              style: boldOverLarge.copyWith()),
          const SizedBox(height: Dimensions.space5),
          Text('You entered both addresses within the different city',
              style: regularMediumLarge.copyWith(color: MyColor.bodyText)),
          const SizedBox(height: Dimensions.space45),
          RoundedButton(
            text: 'Go to InterCity',
            press: () {
              yes();
            },
            verticalPadding: 20,
          ),
          const SizedBox(height: Dimensions.space15),
          RoundedButton(
            text: 'Stay in City to City',
            textColor: MyColor.getTextColor(),
            isOutlined: true,
            verticalPadding: 20,
            press: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
