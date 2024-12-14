import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/style.dart';

class ProfileCardColumn extends StatelessWidget {
  final String header;
  final String body;
  final bool alignmentEnd;
  final Color? textColor;
  final String? subBody;
  final TextStyle? headerTextDecoration;
  final TextStyle? bodyTextDecoration;
  final TextStyle? subBodyTextDecoration;
  final double? space = 5;
  final Widget? endWidget;

  const ProfileCardColumn({
    super.key,
    this.alignmentEnd = false,
    required this.header,
    this.textColor,
    this.headerTextDecoration,
    this.bodyTextDecoration,
    required this.body,
    this.subBody,
    this.subBodyTextDecoration,
    this.endWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: alignmentEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              header.tr,
              style: headerTextDecoration ?? boldDefault.copyWith(color: MyColor.getTextColor().withOpacity(0.6)),
              overflow: TextOverflow.ellipsis,
            ),
             SizedBox(
              height: space,
            ),
            Text(
              body.tr,
              style: bodyTextDecoration ??
                  regularDefault.copyWith(
                    fontSize: Dimensions.fontExtraLarge-1,
                    color: textColor ?? MyColor.getTextColor(),
                  ),
              // maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        if (endWidget != null) ...[endWidget!]
      ],
    );
  }
}
