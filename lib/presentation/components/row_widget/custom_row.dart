import 'package:flutter/material.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:get/get.dart';

import '../../../core/utils/my_color.dart';

class CustomRow extends StatelessWidget {
  const CustomRow({
    super.key,
    required this.firstText,
    required this.lastText,
    // this.imageSrc,
    this.showDivider = true,
    this.showImage = false,
    this.isSvg = false,
  });

  final String firstText, lastText;
  final bool showDivider;
  final bool showImage;
  // final String? imageSrc;
  final bool isSvg;
  @override
  Widget build(BuildContext context) {
    return showImage
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Text(firstText.tr,
                        style: boldDefault.copyWith(color: MyColor.colorBlack),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ],
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    lastText.tr,
                    maxLines: 2,
                    style: regularDefault.copyWith(color: MyColor.colorBlack),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ))
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text(
                firstText.tr,
                style: regularDefault.copyWith(
                    color: MyColor.colorBlack.withValues(alpha: 0.6)),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )),
              Flexible(
                  child: Text(
                lastText.tr,
                maxLines: 2,
                style: regularDefault.copyWith(color: MyColor.colorBlack),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ))
            ],
          );
  }
}
