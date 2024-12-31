import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:get/get.dart';

import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';

class LabelColumn extends StatelessWidget {
  final String header;
  final String body;
  final bool alignmentEnd;
  final bool lastTextRed;
  final bool isSmallFont;

  const LabelColumn(
      {super.key,
      this.isSmallFont = false,
      this.lastTextRed = false,
      this.alignmentEnd = false,
      required this.header,
      required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignmentEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(header.tr,
            style: regularDefault.copyWith(
                fontSize:
                    isSmallFont ? Dimensions.fontSmall : Dimensions.fontDefault,
                color: MyColor.getTextColor(),
                fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis),
        const SizedBox(
          height: 5,
        ),
        Text(
          body.tr,
          style: lastTextRed
              ? regularDefault.copyWith(
                  fontSize: isSmallFont
                      ? Dimensions.fontSmall
                      : Dimensions.fontDefault,
                  color: MyColor.redCancelTextColor)
              : regularDefault.copyWith(
                  fontSize: isSmallFont
                      ? Dimensions.fontSmall
                      : Dimensions.fontDefault,
                ),
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}
