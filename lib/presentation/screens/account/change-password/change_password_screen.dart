import 'package:flutter/services.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/account/change_password_controller.dart';
import 'package:leoparduser/data/repo/account/change_password_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/screens/account/change-password/widget/change_password_form.dart';

import '../../../../core/utils/dimensions.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ChangePasswordRepo(apiClient: Get.find()));
    Get.put(ChangePasswordController(changePasswordRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ChangePasswordController>().clearData();
    });
  }

  @override
  void dispose() {
    Get.find<ChangePasswordController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
            title: MyStrings.changePassword.tr, isShowBackBtn: true),
        body: GetBuilder<ChangePasswordController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: Dimensions.screenPaddingHV,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // spaceDown(Dimensions.space30 * 3),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.space20,
                        vertical: Dimensions.space20),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.mediumRadius),
                      color: MyColor.colorWhite,
                      boxShadow: [
                        BoxShadow(
                            color: MyColor.shadowColor,
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: Offset(0, 1))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Text(MyStrings.changePassword.tr,
                                style: regularExtraLarge.copyWith(
                                    color: MyColor.getTextColor(),
                                    fontWeight: FontWeight.w500))),
                        spaceDown(Dimensions.space10),
                        Align(
                            alignment: Alignment.center,
                            child: Text(MyStrings.createPasswordSubText.tr,
                                textAlign: TextAlign.center,
                                style: regularDefault.copyWith(
                                    color: MyColor.getTextColor()
                                        .withValues(alpha: 0.8)))),
                        spaceDown(Dimensions.space30),
                        const ChangePasswordForm()
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
