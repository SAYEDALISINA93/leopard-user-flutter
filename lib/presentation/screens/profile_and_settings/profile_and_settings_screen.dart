import 'package:flutter/cupertino.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/data/controller/account/profile_controller.dart';
import 'package:leoparduser/data/controller/menu/my_menu_controller.dart';
import 'package:leoparduser/data/repo/account/profile_repo.dart';
import 'package:leoparduser/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/components/shimmer/profiler_shimmer.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:leoparduser/presentation/components/text/header_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/presentation/screens/profile_and_settings/widgets/delete_account_bottom_sheet.dart';
import '../../../core/route/route.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/my_images.dart';
import '../../../core/utils/my_strings.dart';
import '../../../core/utils/style.dart';
import '../../../core/utils/util.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../components/divider/custom_divider.dart';
import '../../components/image/my_network_image_widget.dart';
import 'widgets/account_user_card.dart';
import 'widgets/menu_row_widget.dart';

class ProfileAndSettingsScreen extends StatefulWidget {
  const ProfileAndSettingsScreen({super.key});

  @override
  State<ProfileAndSettingsScreen> createState() =>
      _ProfileAndSettingsScreenState();
}

class _ProfileAndSettingsScreenState extends State<ProfileAndSettingsScreen> {
  @override
  void initState() {
    Get.put(ProfileRepo(apiClient: Get.find()));
    final controller = Get.put(ProfileController(profileRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProfileInfo();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: CustomAppBar(
        title: MyStrings.accountAndSettings,
        isShowBackBtn: true,
        isTitleCenter: true,
      ),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          return RefreshIndicator(
            color: MyColor.colorWhite,
            backgroundColor: MyColor.primaryColor,
            onRefresh: () async {
              controller.loadProfileInfo();
            },
            child: SingleChildScrollView(
              padding: Dimensions.screenPaddingHV,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(bottom: context.width / 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //header
                    controller.isLoading
                        ? ProfilerShimmer()
                        : Container(
                            decoration: BoxDecoration(
                              color: MyColor.getCardBgColor(),
                              borderRadius: BorderRadius.circular(
                                Dimensions.space12,
                              ),
                              boxShadow: MyUtils.getCardShadow(),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: Dimensions.space15,
                                end: Dimensions.space15,
                                top: Dimensions.space15,
                                bottom: Dimensions.space15,
                              ),
                              child: AccountUserCard(
                                onTap: () =>
                                    Get.toNamed(RouteHelper.profileScreen),
                                fullName:
                                    '${controller.firstNameController.text} ${controller.lastNameController.text}',
                                username: controller.user.username,
                                subtitle:
                                    "+${controller.user.dialCode}${controller.user.mobile}",
                                rating: controller.user.avgRating,
                                imgWidget: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: MyColor.borderColor,
                                      width: 0.5,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  height: Dimensions.space50 + 35,
                                  width: Dimensions.space50 + 35,
                                  child: ClipOval(
                                    child: MyImageWidget(
                                      imageUrl: controller.imageUrl,
                                      boxFit: BoxFit.cover,
                                      isProfile: true,
                                    ),
                                  ),
                                ),
                                imgHeight: 40,
                                imgWidth: 40,
                              ),
                            ),
                          ),
                    spaceDown(Dimensions.space15),
                    Container(
                      padding: const EdgeInsets.all(Dimensions.space15),
                      decoration: BoxDecoration(
                        color: MyColor.getCardBgColor(),
                        borderRadius: BorderRadius.circular(Dimensions.space12),
                        boxShadow: MyUtils.getCardShadow(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          HeaderText(
                            text: MyStrings.account.tr.toUpperCase(),
                            textStyle: regularLarge.copyWith(
                              color: MyColor.bodyText,
                            ),
                          ),
                          const SizedBox(height: Dimensions.space20),
                          MenuRowWidget(
                            image: MyImages.user,
                            label: MyStrings.profile,
                            onPressed: () =>
                                Get.toNamed(RouteHelper.profileScreen),
                          ),
                          const CustomDivider(space: Dimensions.space15),
                          MenuRowWidget(
                            image: MyImages.review,
                            label: MyStrings.review,
                            onPressed: () => Get.toNamed(
                              RouteHelper.myReviewScreen,
                              arguments: '${controller.user.avgRating}',
                            ),
                          ),
                          // const CustomDivider(space: Dimensions.space15),
                          // MenuRowWidget(
                          //   image: MyImages.changePassword,
                          //   label: MyStrings.changePassword,
                          //   onPressed: () => Get.toNamed(
                          //     RouteHelper.changePasswordScreen,
                          //   ),
                          // ),
                          spaceDown(Dimensions.space10),
                        ],
                      ),
                    ),
                    spaceDown(Dimensions.space15),
                    Container(
                      padding: const EdgeInsets.all(Dimensions.space15),
                      decoration: BoxDecoration(
                        color: MyColor.getCardBgColor(),
                        borderRadius: BorderRadius.circular(Dimensions.space12),
                        boxShadow: MyUtils.getCardShadow(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          HeaderText(
                            text: MyStrings.ride.tr.toUpperCase(),
                            textStyle: regularLarge.copyWith(
                              color: MyColor.bodyText,
                            ),
                          ),
                          const SizedBox(height: Dimensions.space20),
                          MenuRowWidget(
                            image: MyImages.cityRide,
                            label: MyStrings.city,
                            onPressed: () => Get.toNamed(
                              RouteHelper.rideScreen,
                              arguments: MyStrings.city,
                            ),
                          ),
                          const CustomDivider(space: Dimensions.space15),
                          MenuRowWidget(
                            image: MyImages.interCityRide,
                            label: MyStrings.interCity,
                            onPressed: () => Get.toNamed(
                              RouteHelper.rideScreen,
                              arguments: MyStrings.interCity,
                            ),
                          ),
                          const CustomDivider(space: Dimensions.space15),
                          MenuRowWidget(
                            image: MyImages.transaction,
                            label: MyStrings.paymentHistory,
                            onPressed: () => Get.toNamed(
                              RouteHelper.paymentHistoryScreen,
                            ),
                          ),
                          spaceDown(Dimensions.space10),
                        ],
                      ),
                    ),
                    spaceDown(Dimensions.space15),
                    Container(
                      padding: const EdgeInsets.all(Dimensions.space15),
                      decoration: BoxDecoration(
                        color: MyColor.getCardBgColor(),
                        borderRadius: BorderRadius.circular(Dimensions.space12),
                        boxShadow: MyUtils.getShadow(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          HeaderText(
                            text: MyStrings.settingsAndSupport.tr.toUpperCase(),
                            textStyle: regularLarge.copyWith(
                              color: MyColor.bodyText,
                            ),
                          ),
                          const SizedBox(height: Dimensions.space20),
                          if (controller.profileRepo.apiClient
                              .isMultiLanguageEnabled()) ...[
                            MenuRowWidget(
                              image: MyImages.language,
                              label: MyStrings.language,
                              onPressed: () =>
                                  Get.toNamed(RouteHelper.languageScreen),
                            ),
                            const CustomDivider(space: Dimensions.space15),
                          ],
                          MenuRowWidget(
                            image: MyImages.support,
                            label: MyStrings.supportTicket,
                            onPressed: () => Get.toNamed(
                              RouteHelper.supportTicketScreen,
                            ),
                          ),
                          const CustomDivider(space: Dimensions.space15),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsetsDirectional.symmetric(
                              vertical: Dimensions.space5,
                              horizontal: Dimensions.space12,
                            ),
                            color: MyColor.transparentColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      controller.repo.apiClient
                                              .isNotificationAudioEnable()
                                          ? CupertinoIcons.speaker
                                          : CupertinoIcons.speaker_slash,
                                      color: MyColor.getRideSubTitleColor(),
                                      size: 24,
                                    ),
                                    const SizedBox(width: Dimensions.space15),
                                    Text(
                                      MyStrings.soundNotification.tr,
                                      style: regularDefault.copyWith(
                                        color: MyColor.getTextColor(),
                                      ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  activeTrackColor: MyColor.greenSuccessColor,
                                  activeColor: MyColor.colorWhite,
                                  inactiveTrackColor:
                                      MyColor.redCancelTextColor,
                                  inactiveThumbColor: MyColor.colorWhite,
                                  trackOutlineColor: WidgetStateProperty.all(
                                    MyColor.colorWhite,
                                  ),
                                  value: controller.repo.apiClient
                                      .isNotificationAudioEnable(),
                                  onChanged: (value) {
                                    controller.repo.apiClient
                                        .storeNotificationAudioEnable(value);
                                    controller.update();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    spaceDown(Dimensions.space15),
                    Container(
                      padding: const EdgeInsets.all(Dimensions.space15),
                      decoration: BoxDecoration(
                        color: MyColor.getCardBgColor(),
                        borderRadius: BorderRadius.circular(Dimensions.space12),
                        boxShadow: MyUtils.getShadow(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          HeaderText(
                            text: MyStrings.more.tr.toUpperCase(),
                            textStyle: regularLarge.copyWith(
                              color: MyColor.bodyText,
                            ),
                          ),
                          spaceDown(Dimensions.space20),
                          MenuRowWidget(
                            image: MyImages.policy,
                            label: MyStrings.policies,
                            onPressed: () =>
                                Get.toNamed(RouteHelper.privacyScreen),
                          ),
                          const CustomDivider(space: Dimensions.space15),
                          MenuRowWidget(
                            image: MyIcons.info,
                            label: MyStrings.faq,
                            onPressed: () => Get.toNamed(RouteHelper.faqScreen),
                          ),
                          const CustomDivider(space: Dimensions.space15),
                          MenuRowWidget(
                            image: MyImages.rateUs,
                            label: MyStrings.rateUs.tr,
                            onPressed: () async {
                              if (await controller.inAppReview.isAvailable()) {
                                controller.inAppReview.requestReview();
                              } else {
                                CustomSnackBar.error(
                                  errorList: [
                                    MyStrings.pleaseUploadYourAppOnPlayStore,
                                  ],
                                );
                              }
                            },
                          ),
                          const CustomDivider(space: Dimensions.space15),
                          GetBuilder<MyMenuController>(
                            builder: (mController) {
                              return MenuRowWidget(
                                image: MyImages.userDelete,
                                label: mController.isDeleteBtnLoading
                                    ? "${MyStrings.loading}..."
                                    : MyStrings.deleteAccount,
                                onPressed: () {
                                  CustomBottomSheet(
                                    bgColor: MyColor.getScreenBgColor(),
                                    child: DeleteAccountBottomSheetBody(
                                      controller: mController,
                                    ),
                                  ).customBottomSheet(context);
                                },
                              );
                            },
                          ),
                          const CustomDivider(space: Dimensions.space15),
                          MenuRowWidget(
                            image: MyImages.logout,
                            imgColor: MyColor.redCancelTextColor,
                            textColor: MyColor.redCancelTextColor,
                            label: controller.logoutLoading
                                ? '${MyStrings.loading}...'
                                : MyStrings.logout,
                            onPressed: () {
                              if (controller.logoutLoading == false) {
                                controller.logout();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    spaceDown(Dimensions.space50 * 2)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
