import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:leoparduser/presentation/components/text/small_text.dart';

class LanguageCard extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final bool isShowTopRight;
  final String langName;
  final String flag;

  const LanguageCard({
    super.key,
    required this.index,
    required this.selectedIndex,
    this.isShowTopRight = false,
    required this.langName,
    required this.flag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: Dimensions.space20,
        vertical: Dimensions.space5,
      ),
      margin: EdgeInsets.only(bottom: Dimensions.space10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: MyColor.getCardBgColor(),
        borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
        boxShadow: MyUtils.getCardShadow(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 55,
                width: 55,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: MyColor.getScreenBgColor(),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(Dimensions.space4),
                child: flag.isNotEmpty
                    ? MyImageWidget(height: 60, width: 100, imageUrl: flag)
                    : Icon(
                        Icons.g_translate,
                        color: MyColor.primaryColor,
                        size: 22.5,
                      ),
              ),
              const SizedBox(width: Dimensions.space10),
              SmallText(
                text: langName.tr,
                textStyle: semiBoldSmall.copyWith(
                  color: MyColor.getTextColor(),
                ),
              ),
            ],
          ),
          Container(
            height: 20,
            width: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: index == selectedIndex
                  ? MyColor.getPrimaryColor()
                  : MyColor.colorWhite,
              shape: BoxShape.circle,
              border: index != selectedIndex
                  ? Border.all(color: MyColor.primaryColor)
                  : null,
            ),
            child: index == selectedIndex
                ? Icon(Icons.check, color: MyColor.colorWhite, size: 14)
                : null,
          ),
        ],
      ),
    );
  }
}
