import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/auth/forget_password/reset_password_controller.dart';
import 'package:leoparduser/data/repo/auth/login_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/text-form-field/custom_text_field.dart';
import 'package:leoparduser/presentation/components/text/default_text.dart';
import 'package:leoparduser/presentation/components/text/header_text.dart';
import 'package:leoparduser/presentation/components/will_pop_widget.dart';
import 'package:leoparduser/presentation/screens/auth/registration/widget/validation_widget.dart';

import '../../../../components/app-bar/custom_appbar.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoginRepo(apiClient: Get.find()));
    final controller = Get.put(ResetPasswordController(loginRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.email = Get.arguments[0];
      controller.code = Get.arguments[1];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      nextRoute: RouteHelper.loginScreen,
      child: Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
            title: MyStrings.resetPassword.tr,
            fromAuth: true,
            bgColor: MyColor.getAppBarColor()),
        body: GetBuilder<ResetPasswordController>(
          builder: (controller) => SingleChildScrollView(
            padding: Dimensions.screenPaddingHV,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: Dimensions.space30),
                  HeaderText(text: MyStrings.resetPassword.tr),
                  const SizedBox(height: Dimensions.space15),
                  DefaultText(
                      text: MyStrings.resetPassContent.tr,
                      textStyle: regularDefault.copyWith(
                          color:
                              MyColor.getTextColor().withValues(alpha: 0.8))),
                  const SizedBox(height: Dimensions.space15),
                  Focus(
                    onFocusChange: (hasFocus) {
                      controller.changePasswordFocus(hasFocus);
                    },
                    child: CustomTextField(
                        animatedLabel: true,
                        needOutlineBorder: true,
                        focusNode: controller.passwordFocusNode,
                        nextFocus: controller.confirmPasswordFocusNode,
                        labelText: MyStrings.password,
                        isShowSuffixIcon: true,
                        isPassword: true,
                        textInputType: TextInputType.text,
                        controller: controller.passController,
                        validator: (value) {
                          return controller.validatePassword(value);
                        },
                        onChanged: (value) {
                          if (controller.checkPasswordStrength) {
                            controller.updateValidationList(value);
                          }
                          return;
                        }),
                  ),
                  Visibility(
                      visible: controller.hasPasswordFocus &&
                          controller.checkPasswordStrength,
                      child: ValidationWidget(
                        list: controller.passwordValidationRules,
                        fromReset: true,
                      )),
                  const SizedBox(height: Dimensions.space15),
                  CustomTextField(
                    animatedLabel: true,
                    needOutlineBorder: true,
                    inputAction: TextInputAction.done,
                    isPassword: true,
                    labelText: MyStrings.confirmPassword.tr,
                    hintText: MyStrings.confirmYourPassword.tr,
                    isShowSuffixIcon: true,
                    controller: controller.confirmPassController,
                    onChanged: (value) {
                      return;
                    },
                    validator: (value) {
                      if (controller.passController.text.toLowerCase() !=
                          controller.confirmPassController.text.toLowerCase()) {
                        return MyStrings.kMatchPassError.tr;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: Dimensions.space35),
                  RoundedButton(
                    text: MyStrings.submit.tr,
                    isLoading: controller.submitLoading,
                    press: () {
                      if (formKey.currentState!.validate()) {
                        controller.resetPassword();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
