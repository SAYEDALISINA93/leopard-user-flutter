import 'package:flutter/material.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/data/controller/payment_history/payment_history_controller.dart';
import 'package:get/get.dart';
import 'package:leoparduser/presentation/components/annotated_region/annotated_region_widget.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/style.dart';
import '../../../components/bottom-sheet/custom_bottom_sheet.dart';
import '../../../components/row_widget/bottom_sheet_top_row.dart';

void showTrxBottomSheet(
  List<String>? list,
  int callFrom,
  String header, {
  required BuildContext context,
}) {
  if (list != null && list.isNotEmpty) {
    CustomBottomSheet(
      bgColor: MyColor.getScreenBgColor(),
      child: AnnotatedRegionWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BottomSheetTopRow(header: header, bgColor: MyColor.colorWhite),
            SizedBox(
              child: ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        String selectedValue = list[index];
                        final controller = Get.find<PaymentHistoryController>();

                        if (callFrom == 1) {
                          controller.changeSelectedTrxType(selectedValue);
                          controller.filterData();
                        } else if (callFrom == 2) {
                          controller.changeSelectedRemark(selectedValue);
                          controller.filterData();
                        }

                        Navigator.pop(context);
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: MyColor.getCardBgColor(),
                        ),
                        child: Text(
                          ' ${callFrom == 2 ? StringConverter.replaceUnderscoreWithSpace(list[index].capitalizeFirst ?? '') : list[index]}',
                          style: regularDefault.copyWith(
                            fontSize: Dimensions.fontDefault,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ).customBottomSheet(context);
  }
}
