import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/data/controller/reference/reference_contrller.dart';
import 'package:leoparduser/data/repo/refer/reference_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/column_widget/card_column.dart';
import 'package:leoparduser/presentation/components/image/my_local_image_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/presentation/components/image/my_network_image_widget.dart';
import 'package:leoparduser/presentation/components/no_data.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/my_icons.dart';
import '../../../core/utils/my_images.dart';
import '../../../core/utils/my_strings.dart';
import '../../../core/utils/style.dart';
import '../../../core/utils/util.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../components/buttons/rounded_button.dart';
import '../../components/divider/custom_spacer.dart';
import '../../components/text/header_text.dart';

class ReferralAFriendsScreen extends StatefulWidget {
  const ReferralAFriendsScreen({super.key});

  @override
  State<ReferralAFriendsScreen> createState() => _ReferralAFriendsScreenState();
}

class _ReferralAFriendsScreenState extends State<ReferralAFriendsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ReferenceRepo(apiClient: Get.find()));
    final controller = Get.put(ReferenceController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      controller.getReferData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: CustomAppBar(
          title: MyStrings.referralAFriends.toCapitalized(), elevation: 3),
      body: GetBuilder<ReferenceController>(builder: (controller) {
        return SingleChildScrollView(
          padding: Dimensions.screenPaddingHV,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spaceDown(Dimensions.space15),
              Container(
                  padding: EdgeInsets.zero,
                  width: context.width,
                  child: const MyLocalImageWidget(
                      imagePath: MyImages.banner,
                      radius: Dimensions.mediumRadius,
                      height: Dimensions.space50 * 2.3,
                      boxFit: BoxFit.contain)),
              spaceDown(Dimensions.space20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.space15),
                decoration: BoxDecoration(
                    color: MyColor.getCardBgColor(),
                    borderRadius: BorderRadius.circular(Dimensions.space12),
                    boxShadow: MyUtils.getCardShadow()),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: Dimensions.space10, end: Dimensions.space20),
                        child: MyLocalImageWidget(
                            imagePath: MyIcons.colorCoin,
                            height: Dimensions.space40)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HeaderText(
                              text: MyStrings.inviteFriends,
                              textStyle: regularDefault.copyWith(
                                  color: MyColor.getBodyTextColor())),
                          spaceDown(Dimensions.space3),
                          HeaderText(
                            text:
                                "${MyStrings.earn} ${controller.currencySym}${Converter.formatNumber(controller.repo.apiClient.getReferAmount())}",
                            textStyle: boldMediumLarge.copyWith(
                                color: MyColor.colorBlack,
                                fontSize: Dimensions.fontLarge + 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              spaceDown(Dimensions.space10),
              //Invite Code Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.space15),
                decoration: BoxDecoration(
                    color: MyColor.getCardBgColor(),
                    borderRadius: BorderRadius.circular(Dimensions.space12),
                    boxShadow: MyUtils.getCardShadow()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeaderText(
                        text: MyStrings.inviteFriends,
                        textStyle: boldMediumLarge.copyWith(
                            color: MyColor.colorBlack,
                            fontSize: Dimensions.fontLarge + 1)),
                    spaceDown(Dimensions.space3),
                    Text(
                        "${MyStrings.referralSubtitle.tr} ${controller.currencySym}${Converter.formatNumber(controller.repo.apiClient.getReferAmount())} ${controller.repo.apiClient.getCurrencyOrUsername(isCurrency: true)} ${MyStrings.firstOrder.tr}",
                        style: regularDefault.copyWith(
                            color: MyColor.bodyText,
                            fontSize: Dimensions.fontMedium)),
                    spaceDown(Dimensions.space10),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.8),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            color: MyColor.borderColor,
                            radius:
                                const Radius.circular(Dimensions.mediumRadius),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: MyColor.bodyTextBgColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.mediumRadius - 1)),
                              width: double.infinity,
                              padding: const EdgeInsets.all(Dimensions.space15),
                              child: Text(
                                  controller.isLoading
                                      ? '${MyStrings.loading.tr}...'
                                      : (controller.user.username ?? '')
                                          .toUpperCase(),
                                  style: regularDefault.copyWith(
                                      color: MyColor.bodyText,
                                      fontSize: Dimensions.fontMedium)),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              MyUtils.copy(
                                  text: (controller.user.username ?? ''));
                            },
                            child: Container(
                              width: Dimensions.space50 + 10,
                              decoration: const BoxDecoration(
                                  color: MyColor.primaryColor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                          Dimensions.mediumRadius - 1),
                                      bottomRight: Radius.circular(
                                          Dimensions.mediumRadius - 1))),
                              child: const FittedBox(
                                child: Padding(
                                    padding: EdgeInsets.all(Dimensions.space3),
                                    child: MyLocalImageWidget(
                                        imagePath: MyIcons.copy,
                                        height: 10,
                                        width: 10)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    spaceDown(Dimensions.space20),
                    HeaderText(
                      text: MyStrings.inviteFriends,
                      textStyle: boldMediumLarge.copyWith(
                          color: MyColor.colorBlack,
                          fontSize: Dimensions.fontLarge - 1),
                    ),
                    spaceDown(Dimensions.space10),
                    rulesWidget(text: MyStrings.inviteRules1),
                    rulesWidget(text: MyStrings.inviteRules2),
                    rulesWidget(text: MyStrings.inviteRules3),
                    spaceDown(Dimensions.space20),
                    RoundedButton(
                      text: MyStrings.referFriends,
                      press: () {
                        controller.shareImage();
                      },
                      textColor: MyColor.colorWhite,
                      isOutlined: false,
                    ),
                  ],
                ),
              ),
              spaceDown(Dimensions.space30),
              HeaderText(
                text: MyStrings.yourReferences,
                textStyle: boldMediumLarge.copyWith(
                    color: MyColor.colorBlack,
                    fontSize: Dimensions.fontLarge - 1),
              ),
              spaceDown(Dimensions.space10),

              controller.referUsers.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.space10,
                          vertical: Dimensions.space20),
                      decoration: BoxDecoration(
                          color: MyColor.colorWhite,
                          boxShadow: MyUtils.getShadow2(),
                          borderRadius:
                              BorderRadius.circular(Dimensions.mediumRadius)),
                      child: Center(child: NoDataWidget()),
                    )
                  : Column(
                      children: List.generate(
                        controller.referUsers.length,
                        (index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.space10,
                                vertical: Dimensions.space10),
                            margin: const EdgeInsets.symmetric(
                                vertical: Dimensions.space8),
                            decoration: BoxDecoration(
                              color: MyColor.getCardBgColor(),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.cardRadius),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyImageWidget(
                                    width: 40,
                                    height: 40,
                                    radius: 20,
                                    imageUrl: controller
                                            .referUsers[index].imageWithPath ??
                                        '',
                                    isProfile: true),
                                const SizedBox(width: Dimensions.space10),
                                Expanded(
                                    flex: 3,
                                    child: CardColumn(
                                        header:
                                            "${controller.referUsers[index].firstname?.removeNull()} ${controller.referUsers[index].lastname}"
                                                .toTitleCase(),
                                        body:
                                            '${controller.referUsers[index].email}')),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.space10,
                                      vertical: Dimensions.space2),
                                  decoration: BoxDecoration(
                                      color: MyColor.primaryColor
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.defaultRadius)),
                                  child: Text(MyStrings.reFerred.tr,
                                      style: boldDefault.copyWith(
                                          color: MyColor.primaryColor)),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        );
      }),
    );
  }

  Widget rulesWidget({required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: MyColor.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(
            width: Dimensions.space8,
          ),
          Expanded(
            child: Text(
              text.tr,
              style: regularDefault.copyWith(color: MyColor.bodyTextColor),
            ),
          )
        ],
      ),
    );
  }
}
