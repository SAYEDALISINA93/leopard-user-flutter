import 'package:flutter/services.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/menu/my_menu_controller.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/my_icons.dart';
import '../../../core/utils/my_strings.dart';
import '../../components/divider/custom_divider.dart';
import '../../components/image/my_network_image_widget.dart';
import 'widget/drawer_item_list_card.dart';
import 'widget/drawer_user_info_card.dart';

class AppDrawerScreen extends StatefulWidget {
  Function(int) callback;
  VoidCallback closeFunction;
  AppDrawerScreen(
      {super.key, required this.callback, required this.closeFunction});

  @override
  State<AppDrawerScreen> createState() => _AppDrawerScreenState();
}

class _AppDrawerScreenState extends State<AppDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    String name = Get.find<ApiClient>()
            .sharedPreferences
            .getString(SharedPreferenceHelper.userFullNameKey) ??
        '';
    String userName = Get.find<ApiClient>()
        .getCurrencyOrUsername(isCurrency: false, isSymbol: false);
    String phone = Get.find<ApiClient>()
            .sharedPreferences
            .getString(SharedPreferenceHelper.userPhoneNumberKey) ??
        '';
    String avatar = Get.find<ApiClient>()
            .sharedPreferences
            .getString(SharedPreferenceHelper.userProfileKey) ??
        '';
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: MyColor.colorWhite,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark),
      child: SafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(Dimensions.space15),
            bottomStart: Radius.circular(Dimensions.space15),
          ),
          child: GetBuilder<MyMenuController>(builder: (controller) {
            return Drawer(
              width: MediaQuery.of(context).size.width / 1.5,
              backgroundColor: MyColor.colorWhite,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsetsDirectional.only(
                                end: Dimensions.space15),
                            height: Dimensions.space50,
                            width: double.infinity,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => widget.closeFunction(),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.close_rounded,
                                      size: 30, color: MyColor.getTextColor())),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: Dimensions.space25,
                                end: Dimensions.space15),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(RouteHelper.profileScreen);
                                widget.closeFunction();
                              },
                              child: DrawerUserCard(
                                fullName: name.removeNull(),
                                username: userName.removeNull(),
                                subtitle: "+${phone.removeNull()}",
                                imgWidget: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: MyColor.borderColor,
                                          width: 0.5),
                                      shape: BoxShape.circle),
                                  height: 50,
                                  width: 50,
                                  child: ClipOval(
                                      child: MyImageWidget(
                                          imageUrl: avatar,
                                          boxFit: BoxFit.cover,
                                          isProfile: true)),
                                ),
                                imgHeight: 40,
                                imgWidth: 40,
                              ),
                            ),
                          ),
                          const CustomDivider(
                              onlyTop: true,
                              space: Dimensions.space20,
                              onlyBottom: true),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: Dimensions.space30,
                                top: Dimensions.space10),
                            child: GetBuilder<MyMenuController>(
                              builder: (controller) {
                                return Column(
                                  children: [
                                    DrawerItem(
                                      svgIcon: MyIcons.riders,
                                      name: MyStrings.rides,
                                      titleStyle: boldDefault.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Dimensions.fontLarge),
                                      iconColor: MyColor.getRideSubTitleColor(),
                                      onTap: () {
                                        Get.toNamed(RouteHelper.rideScreen,
                                            arguments: MyStrings.city);
                                      },
                                    ),
                                    spaceDown(Dimensions.space30 + 2),
                                    DrawerItem(
                                      svgIcon: MyIcons.riders,
                                      name: MyStrings.interCityRides.tr,
                                      titleStyle: boldDefault.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Dimensions.fontLarge),
                                      iconColor: MyColor.getRideSubTitleColor(),
                                      onTap: () {
                                        Get.toNamed(RouteHelper.rideScreen,
                                            arguments: MyStrings.interCity);
                                      },
                                    ),
                                    spaceDown(Dimensions.space30 + 2),
                                    DrawerItem(
                                      svgIcon: MyImages.viewTransaction,
                                      name: MyStrings.paymentHistory,
                                      titleStyle: boldDefault.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Dimensions.fontLarge),
                                      iconColor: MyColor.getRideSubTitleColor(),
                                      onTap: () {
                                        Get.toNamed(
                                            RouteHelper.paymentHistoryScreen);
                                      },
                                    ),
                                    if (controller.repo.apiClient
                                        .isReferEnable()) ...[
                                      spaceDown(Dimensions.space30 + 2),
                                      DrawerItem(
                                        svgIcon: MyIcons.referral,
                                        name: MyStrings.referralAFriends,
                                        titleStyle: boldDefault.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: Dimensions.fontLarge),
                                        iconColor:
                                            MyColor.getRideSubTitleColor(),
                                        onTap: () {
                                          Get.toNamed(RouteHelper
                                              .referralAFriendsScreen);
                                        },
                                      ),
                                    ],
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  spaceDown(Dimensions.space10),
                  GestureDetector(
                    onTap: () {
                      if (controller.logoutLoading == false) {
                        controller.logout();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsetsDirectional.only(
                          end: Dimensions.space20, start: Dimensions.space30),
                      padding: const EdgeInsets.all(Dimensions.space15),
                      decoration: BoxDecoration(
                          color: MyColor.colorRed2.withValues(alpha: 0.15),
                          borderRadius:
                              BorderRadius.circular(Dimensions.space5)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(MyIcons.logout,
                              fit: BoxFit.contain,
                              colorFilter: const ColorFilter.mode(
                                  MyColor.colorRed2, BlendMode.srcIn),
                              height: 22,
                              width: 22),
                          spaceSide(Dimensions.space20),
                          Expanded(
                              child: Text(
                                  controller.logoutLoading
                                      ? '${MyStrings.loading.tr}...'
                                      : MyStrings.signOut.tr,
                                  style: regularLarge.copyWith(
                                      color: MyColor.colorRed2,
                                      fontSize: Dimensions.fontExtraLarge,
                                      fontWeight: FontWeight.normal))),
                        ],
                      ),
                    ),
                  ),
                  spaceDown(Dimensions.space20),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
