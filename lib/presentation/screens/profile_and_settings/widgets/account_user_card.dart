import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_icons.dart';
import '../../../components/image/custom_svg_picture.dart';

class AccountUserCard extends StatelessWidget {
  final String? username, fullName, subtitle;
  final String? image;
  final bool isAsset;
  final bool noAvatar;
  final TextStyle? titleStyle, subtitleStyle;
  final Widget? imgWidget;
  final Widget? rightWidget;
  final double? imgHeight;
  final double? imgWidth;
  final VoidCallback? onTap;
  final String? rating;
  const AccountUserCard({
    super.key,
    this.username,
    this.fullName,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.rightWidget,
    this.image = MyIcons.avatar,
    this.isAsset = true,
    this.noAvatar = false,
    this.imgHeight,
    this.imgWidth,
    this.imgWidget,
    this.onTap,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (imgWidget != null)
                    imgWidget!
                  else
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyColor.primaryColor,
                      ),
                      child: const CustomSvgPicture(image: MyIcons.avatar),
                    ),
                  const SizedBox(
                    width: Dimensions.space15,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text("$fullName".toUpperCase(),
                              style: titleStyle ??
                                  boldDefault.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.fontLarge + 3),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(
                          height: Dimensions.space3,
                        ),
                        Text("@$username",
                            style: titleStyle ??
                                regularDefault.copyWith(
                                    fontSize: Dimensions.fontSmall),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: Dimensions.space5),
                        Text(subtitle ?? "",
                            style: subtitleStyle ??
                                regularDefault.copyWith(
                                    fontSize: Dimensions.fontSmall,
                                    color: MyColor.bodyText
                                        .withValues(alpha: 0.8)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: Dimensions.space5),
                        Container(
                          decoration: BoxDecoration(
                              color: MyColor.colorBlack,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.space20)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.space10,
                              vertical: Dimensions.space5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: MyColor.colorOrange,
                                  size: Dimensions.fontLarge),
                              const SizedBox(width: 5),
                              Text(
                                  rating == '0.00'
                                      ? MyStrings.nA.tr
                                      : (rating ?? ''),
                                  style: boldDefault.copyWith(
                                      fontSize: Dimensions.fontDefault,
                                      color: MyColor.colorWhite))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            rightWidget ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
