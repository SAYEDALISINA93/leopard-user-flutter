import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/style.dart';

class CardColumn extends StatelessWidget {
  final String header;
  final String body;
  final bool alignmentEnd;
  final bool alignmentCenter;
  final bool isDate;
  final Color? textColor;
  String? subBody;
  TextStyle? headerTextStyle;
  TextStyle? bodyTextStyle;
  TextStyle? subBodyTextStyle;
  bool? isOnlyHeader;
  bool? isOnlyBody;
  final int bodyMaxLine;
  double? space = 5;
  final int maxLine;

  CardColumn({
    super.key,
    this.maxLine = 1,
    this.bodyMaxLine = 1,
    this.alignmentEnd = false,
    required this.header,
    this.isDate = false,
    this.textColor,
    this.headerTextStyle,
    this.bodyTextStyle,
    required this.body,
    this.subBody,
    this.isOnlyHeader = false,
    this.isOnlyBody = false,
    this.alignmentCenter = false,
    this.space,
  });

  @override
  Widget build(BuildContext context) {
    return isOnlyHeader!
        ? Column(
            crossAxisAlignment: alignmentEnd
                ? CrossAxisAlignment.end
                : alignmentCenter
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
            children: [
              Text(
                header.tr,
                style: headerTextStyle ??
                    regularSmall.copyWith(
                      color: MyColor.getGreyText(),
                      fontWeight: FontWeight.w600,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: space),
            ],
          )
        : Column(
            crossAxisAlignment: alignmentEnd
                ? CrossAxisAlignment.end
                : alignmentCenter
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
            children: [
              Text(
                header.tr,
                style: headerTextStyle ??
                    regularSmall.copyWith(
                      color: MyColor.getTextColor().withValues(alpha: 0.6),
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: maxLine,
              ),
              SizedBox(height: space),
              Text(
                body.tr,
                maxLines: bodyMaxLine,
                style: isDate
                    ? regularDefault.copyWith(
                        fontStyle: FontStyle.italic,
                        color: textColor ?? MyColor.getTextColor(),
                        fontSize: Dimensions.fontSmall,
                      )
                    : bodyTextStyle ??
                        regularSmall.copyWith(
                          color: textColor ?? MyColor.getTextColor(),
                          fontWeight: FontWeight.w500,
                        ),
                overflow: TextOverflow.ellipsis,
                textAlign: alignmentEnd ? TextAlign.end : TextAlign.start,
              ),
              const SizedBox(height: Dimensions.space5),
              subBody != null
                  ? Text(
                      subBody!.tr,
                      maxLines: bodyMaxLine,
                      style: isDate
                          ? regularDefault.copyWith(
                              fontStyle: FontStyle.italic,
                              color: textColor ?? MyColor.getTextColor(),
                              fontSize: Dimensions.fontSmall,
                            )
                          : subBodyTextStyle ??
                              regularSmall.copyWith(
                                color: textColor ??
                                    MyColor.getTextColor().withValues(
                                      alpha: 0.5,
                                    ),
                                fontWeight: FontWeight.w500,
                              ),
                      overflow: TextOverflow.ellipsis,
                    )
                  : const SizedBox.shrink(),
            ],
          );
  }
}
