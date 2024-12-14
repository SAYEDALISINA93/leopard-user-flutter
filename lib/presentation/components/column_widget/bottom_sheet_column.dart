import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:get/get.dart';
import '../../../../../../../core/utils/my_color.dart';

class BottomSheetColumn extends StatelessWidget {
  final bool isCharge;
  final String header;
  final String body;
  final bool alignmentEnd;

  const BottomSheetColumn(
      {super.key,
      this.isCharge = false,
      this.alignmentEnd = false,
      required this.header,
      required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignmentEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          header.tr,
          style: regularDefault.copyWith(
              color: MyColor.getLabelTextColor(), fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          body.tr,
          style: isCharge
              ? regularDefault.copyWith(color: MyColor.redCancelTextColor)
              : regularDefault,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}
