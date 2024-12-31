import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/auth/forget_password/verify_password_controller.dart';
import 'package:leoparduser/data/repo/auth/login_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/app-bar/custom_appbar.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/text/default_text.dart';

class VerifyForgetPassScreen extends StatefulWidget {
  const VerifyForgetPassScreen({super.key});

  @override
  State<VerifyForgetPassScreen> createState() => _VerifyForgetPassScreenState();
}

class _VerifyForgetPassScreenState extends State<VerifyForgetPassScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoginRepo(apiClient: Get.find()));
    final controller = Get.put(VerifyPasswordController(loginRepo: Get.find()));

    controller.email = Get.arguments;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(),
      appBar: CustomAppBar(
          fromAuth: true,
          isShowBackBtn: true,
          bgColor: MyColor.getAppBarColor(),
          title: MyStrings.emailVerification.tr,
          isTitleCenter: true),
      body: GetBuilder<VerifyPasswordController>(
        builder: (controller) => controller.isLoading
            ? Center(
                child:
                    CircularProgressIndicator(color: MyColor.getPrimaryColor()))
            : SingleChildScrollView(
                padding: Dimensions.screenPaddingHV,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: Dimensions.space50),
                      Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: MyColor.primaryColor.withOpacity(.07),
                            shape: BoxShape.circle),
                        child: Icon(Icons.email_outlined,
                            size: 50, color: MyColor.getPrimaryColor()),
                      ),
                      const SizedBox(height: Dimensions.space25),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: DefaultText(
                              text:
                                  '${MyStrings.verifyPasswordSubText.tr} : ${controller.getFormatMail().tr}',
                              textAlign: TextAlign.center,
                              textColor: MyColor.getContentTextColor())),
                      const SizedBox(height: Dimensions.space40),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space30),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: regularDefault.copyWith(
                              color: MyColor.getPrimaryColor()),
                          length: 6,
                          textStyle: regularDefault.copyWith(
                              color: MyColor.getTextColor()),
                          obscureText: false,
                          obscuringCharacter: '*',
                          blinkWhenObscuring: false,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderWidth: 1,
                              borderRadius: BorderRadius.circular(8),
                              fieldHeight: 40,
                              fieldWidth: 40,
                              inactiveColor:
                                  MyColor.getTextFieldDisableBorder(),
                              inactiveFillColor: MyColor.getScreenBgColor(),
                              activeFillColor: MyColor.getScreenBgColor(),
                              activeColor: MyColor.getPrimaryColor(),
                              selectedFillColor: MyColor.getScreenBgColor(),
                              selectedColor: MyColor.getPrimaryColor()),
                          cursorColor: MyColor.getTextColor(),
                          animationDuration: const Duration(milliseconds: 100),
                          enableActiveFill: true,
                          keyboardType: TextInputType.number,
                          beforeTextPaste: (text) {
                            return true;
                          },
                          onChanged: (value) {
                            setState(() {
                              controller.currentText = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: Dimensions.space25),
                      RoundedButton(
                          isLoading: controller.verifyLoading,
                          text: MyStrings.verify.tr,
                          press: () {
                            if (controller.currentText.length != 6) {
                              controller.hasError = true;
                            } else {
                              controller.verifyForgetPasswordCode(
                                  controller.currentText);
                            }
                          }),
                      const SizedBox(height: Dimensions.space25),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DefaultText(
                                text: MyStrings.didNotReceiveCode.tr,
                                textColor: MyColor.getTextColor()),
                            SizedBox(width: Dimensions.space5),
                            controller.isResendLoading
                                ? const SizedBox(
                                    height: 17,
                                    width: 17,
                                    child: CircularProgressIndicator(
                                        color: MyColor.primaryColor))
                                : GestureDetector(
                                    onTap: () {
                                      controller.resendForgetPassCode();
                                    },
                                    child: Text(MyStrings.resend.tr,
                                        style: regularDefault.copyWith(
                                            color: MyColor.getPrimaryColor())),
                                  )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
