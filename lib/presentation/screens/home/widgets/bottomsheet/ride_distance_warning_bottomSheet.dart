import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/presentation/components/annotated_region/annotated_region_widget.dart';
import 'package:leoparduser/presentation/components/bottom-sheet/my_bottom_sheet_bar.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';

class RideDistanceWarningBottomSheetBody extends StatelessWidget {
  final VoidCallback yes;

  final String distance;
  const RideDistanceWarningBottomSheetBody({
    super.key,
    required this.yes,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegionWidget(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.space15,
          vertical: Dimensions.space10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyBottomSheetBar(),
            // const BottomSheetHeaderRow(),
            Text(MyStrings.distanceALartTitle.tr,
                style: boldOverLarge.copyWith()),
            const SizedBox(height: Dimensions.space5),
            Text(
              '${MyStrings.distanceALartMsg.tr} ${distance}km ',
              style: regularMediumLarge.copyWith(color: MyColor.bodyText),
            ),
            const SizedBox(height: Dimensions.space45),
            RoundedButton(
              text: MyStrings.continue_.tr,
              press: () {
                yes();
              },
              verticalPadding: 20,
            ),
            const SizedBox(height: Dimensions.space15),
          ],
        ),
      ),
    );
  }
}
