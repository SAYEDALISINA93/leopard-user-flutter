import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/auth/social_auth_controller.dart';
import 'package:leoparduser/data/repo/auth/socail_repo.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/components/image/my_local_image_widget.dart';
import 'package:leoparduser/presentation/screens/auth/login/widgets/login_or_bar.dart';

class SocialAuthSection extends StatefulWidget {
  final String googleAuthTitle;
  const SocialAuthSection({super.key, this.googleAuthTitle = MyStrings.google});

  @override
  State<SocialAuthSection> createState() => _SocialAuthSectionState();
}

class _SocialAuthSectionState extends State<SocialAuthSection> {
  @override
  void initState() {
    Get.put(SocialAuthRepo(apiClient: Get.find()));
    Get.put(SocialAuthController(authRepo: Get.find()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialAuthController>(builder: (controller) {
      return Column(
        children: [
          Row(
            children: [
              if (controller.authRepo.apiClient.isGoogleLoginEnable() ==
                  true) ...[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (!controller.isGoogleSignInLoading) {
                        controller.signInWithGoogle();
                      }
                    },
                    customBorder: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.mediumRadius)),
                    splashColor: MyColor.primaryColor.withValues(alpha: 0.1),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.mediumRadius),
                        border:
                            Border.all(color: MyColor.borderColor, width: .5),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.space10,
                          vertical: Dimensions.space15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          controller.isGoogleSignInLoading
                              ? SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                      color: MyColor.primaryColor))
                              : MyLocalImageWidget(
                                  imagePath: MyImages.google,
                                  height: 25,
                                  width: 25,
                                  boxFit: BoxFit.contain),
                          SizedBox(width: Dimensions.space10),
                          Text((widget.googleAuthTitle).tr,
                              style: regularDefault.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              if (controller.authRepo.apiClient.isAppleLoginEnable() == true &&
                  Platform.isIOS) ...[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (!controller.isAppleSignInLoading) {
                        controller.signInWithApple();
                      }
                    },
                    customBorder: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.mediumRadius)),
                    splashColor: MyColor.primaryColor.withValues(alpha: 0.1),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: Dimensions.space10),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.mediumRadius),
                        border:
                            Border.all(color: MyColor.borderColor, width: .5),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.space10,
                          vertical: Dimensions.space15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          controller.isAppleSignInLoading
                              ? SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                      color: MyColor.primaryColor))
                              : MyLocalImageWidget(
                                  imagePath: MyImages.apple,
                                  height: 25,
                                  width: 25,
                                  boxFit: BoxFit.contain),
                          SizedBox(width: Dimensions.space10),
                          Text(MyStrings.apple.tr,
                              style: regularDefault.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ),
          if (controller.authRepo.apiClient.isGoogleLoginEnable() == true ||
              controller.authRepo.apiClient.isAppleLoginEnable() == true) ...[
            spaceDown(Dimensions.space20),
            const LoginOrBar(stock: 0.8),
          ]
        ],
      );
    });
  }
}
