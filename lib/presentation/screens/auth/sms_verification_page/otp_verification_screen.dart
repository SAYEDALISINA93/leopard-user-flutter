import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/auth/auth/otp_verification_controller.dart';
import 'package:leoparduser/data/controller/auth/auth/phone_registration_controller.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/repo/auth/sms_email_verification_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/will_pop_widget.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;
  final String verificationId;
  const OTPVerificationScreen(
      {super.key,
      required this.phoneNumber,
      required this.countryCode,
      required this.verificationId});

  @override
  State<OTPVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OTPVerificationScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SmsEmailVerificationRepo(apiClient: Get.find()));
    final controller = Get.put(OtpVerificationController(repo: Get.find()));
    Get.lazyPut(() => PhoneRegistrationController(
          registrationRepo: Get.find(),
          generalSettingRepo: Get.find(),
        )); // Ensure PhoneRegistrationController is initialized
    super.initState();

    controller.countryCode = widget.countryCode;
    controller.userPhone = widget.phoneNumber;
    controller.verificationId = widget.verificationId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // controller.isProfileCompleteEnable = Get.arguments[0];
      controller.isProfileCompleteEnable = false;
      controller.loadBefore();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: WillPopWidget(
        nextRoute: RouteHelper.loginScreen,
        child: Scaffold(
          backgroundColor: MyColor.getScreenBgColor(),
          body: GetBuilder<OtpVerificationController>(
            builder: (controller) => controller.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        color: MyColor.getPrimaryColor()))
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: Dimensions.screenPaddingHV,
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(MyImages.appLogoWhite,
                              width: MediaQuery.of(context).size.width / 3),
                          Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(MyIcons.bg,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  height: 200)),
                          Container(
                            padding: const EdgeInsetsDirectional.only(
                                top: Dimensions.space20,
                                bottom: Dimensions.space20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                spaceDown(Dimensions.space20),
                                Align(
                                    alignment: Alignment.center,
                                    child: Text(MyStrings.verifyYourPhone.tr,
                                        style: boldExtraLarge.copyWith(
                                            fontSize:
                                                Dimensions.fontExtraLarge +
                                                    5))),
                                const SizedBox(height: Dimensions.space5),
                                Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        '${MyStrings.codeHasBeenSendTo.tr} ${MyUtils.maskSensitiveInformation(controller.userPhone)}'
                                            .tr,
                                        style: regularDefault.copyWith(
                                            color: MyColor.getBodyTextColor(),
                                            fontSize: Dimensions.fontLarge))),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .04),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.space30),
                                  child: PinCodeTextField(
                                    appContext: context,
                                    pastedTextStyle: regularDefault.copyWith(
                                        color: MyColor.getPrimaryColor()),
                                    length: 6,
                                    textStyle: regularDefault.copyWith(
                                        color: MyColor.getPrimaryColor()),
                                    obscureText: false,
                                    obscuringCharacter: '*',
                                    blinkWhenObscuring: false,
                                    animationType: AnimationType.slide,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(8),
                                      borderWidth: 1,
                                      fieldHeight: 40,
                                      fieldWidth: 40,
                                      inactiveColor:
                                          MyColor.getTextFieldDisableBorder(),
                                      inactiveFillColor:
                                          MyColor.getScreenBgColor(),
                                      activeFillColor:
                                          MyColor.getScreenBgColor(),
                                      activeColor: MyColor.getPrimaryColor(),
                                      selectedFillColor:
                                          MyColor.getScreenBgColor(),
                                      selectedColor: MyColor.getPrimaryColor(),
                                    ),
                                    cursorColor: MyColor.getTextColor(),
                                    animationDuration:
                                        const Duration(milliseconds: 100),
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
                                const SizedBox(height: Dimensions.space30),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: Dimensions.space20,
                                      end: Dimensions.space20),
                                  child: RoundedButton(
                                    isLoading: controller.submitLoading,
                                    text: MyStrings.verify.tr,
                                    press: () {
                                      controller.verifyYourSms(
                                          controller.currentText);
                                    },
                                  ),
                                ),
                                const SizedBox(height: Dimensions.space30),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.space30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(MyStrings.didNotReceiveCode.tr,
                                          style: regularDefault.copyWith(
                                              color:
                                                  MyColor.getLabelTextColor())),
                                      const SizedBox(width: Dimensions.space5),
                                      controller.resendLoading
                                          ? Container(
                                              margin: const EdgeInsets.all(5),
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                  color: MyColor
                                                      .getPrimaryColor()))
                                          : GestureDetector(
                                              onTap: () {
                                                controller.sendCodeAgain();
                                              },
                                              child: Text(
                                                  MyStrings.resendCode.tr,
                                                  style: regularDefault.copyWith(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: MyColor
                                                          .getPrimaryColor())),
                                            ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
          ),
        ),
      ),
    );
  }
}
