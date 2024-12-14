import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/url_container.dart';
import 'package:leoparduser/data/controller/home/home_controller.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/components/image/custom_svg_picture.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:leoparduser/presentation/components/text/header_text.dart';

class HomeScreenAppBar extends StatelessWidget {
  HomeController controller;
  Function openDrawer;
  HomeScreenAppBar(
      {super.key, required this.controller, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // decoration: BoxDecoration(color: MyColor.colorWhite),
        padding: EdgeInsets.symmetric(vertical: Dimensions.space12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsetsDirectional.only(
                            end: 3, top: 3, bottom: 3, start: 3),
                        padding: const EdgeInsets.all(5),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteHelper.profileScreen);
                          },
                          child: MyImageWidget(
                            imageUrl:
                                '${UrlContainer.domainUrl}/${controller.userImagePath}/${controller.user.image}',
                            height: 50,
                            width: 50,
                            radius: 50,
                            isProfile: true,
                            errorWidget:
                                Image.asset(MyImages.defaultAvatar, height: 50),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderText(
                              text: controller.user.id == '-1'
                                  ? controller.homeRepo.apiClient
                                      .getCurrencyOrUsername(
                                          isCurrency: false, isSymbol: false)
                                      .toTitleCase()
                                  : '${controller.user.firstname ?? ''} ${controller.user.lastname ?? ''}'
                                      .toTitleCase(),
                              textStyle: boldLarge.copyWith(
                                  color: MyColor.getTextColor(), fontSize: 16),
                            ),
                            Row(
                              children: [
                                CustomSvgPicture(
                                    image: MyIcons.currentLocation,
                                    color: MyColor.primaryColor),
                                SizedBox(width: Dimensions.space3),
                                Expanded(
                                  child: Text(
                                    controller
                                        .appLocationController.currentAddress,
                                    style: regularDefault.copyWith(
                                        color: MyColor.bodyText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            spaceDown(Dimensions.space2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Dimensions.space30),
                InkWell(
                  onTap: () => openDrawer(),
                  splashFactory: NoSplash.splashFactory,
                  splashColor: MyColor.transparentColor,
                  child: Container(
                    margin: const EdgeInsetsDirectional.only(end: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: MyColor.borderColor),
                        borderRadius:
                            BorderRadius.circular(Dimensions.largeRadius)),
                    child: SvgPicture.asset(MyIcons.sideMenu),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
