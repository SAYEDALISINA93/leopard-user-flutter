import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/style.dart';

class MenuRowWidget extends StatelessWidget {
  final String image;
  final double? imageSize;
  final Color? imgColor;
  final Color? textColor;
  final String label;
  final String? counter;
  final bool counterEnabled;
  final VoidCallback onPressed;
  final Widget? endWidget;

  const MenuRowWidget({
    super.key,
    required this.image,
    required this.label,
    required this.onPressed,
    this.counter,
    this.counterEnabled = false,
    this.imageSize = 24,
    this.endWidget,
    this.imgColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsetsDirectional.symmetric(vertical: Dimensions.space5, horizontal: Dimensions.space12),
        color: MyColor.transparentColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  image.contains('svg')
                      ? SvgPicture.asset(
                          image,
                          colorFilter: ColorFilter.mode(imgColor ?? MyColor.getRideSubTitleColor(), BlendMode.srcIn),
                          height: imageSize,
                          width: imageSize,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          image,
                          color: imgColor ?? MyColor.getRideSubTitleColor(),
                          height: imageSize,
                          width: imageSize,
                          fit: BoxFit.contain,
                        ),
                  const SizedBox(width: Dimensions.space15),
                  Expanded(
                    child: Text(
                      label.tr,
                      style: regularDefault.copyWith(color: textColor ?? MyColor.getTextColor()),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (counterEnabled == true && counter != '0')
              Container(
                decoration: BoxDecoration(color: MyColor.colorRed, borderRadius: BorderRadius.circular(Dimensions.space2)),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.space5),
                child: Text(
                  "$counter",
                  style: regularDefault.copyWith(
                    color: MyColor.colorWhite,
                  ),
                ),
              )
            else
              endWidget ?? Icon(Icons.arrow_forward_ios_rounded, color: MyColor.getIconColor(), size: 12.5)
          ],
        ),
      ),
    );
  }
}
