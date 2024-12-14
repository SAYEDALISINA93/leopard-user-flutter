import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/core/utils/util.dart';
import 'package:leoparduser/data/controller/auth/auth/email_verification_controler.dart';
import 'package:leoparduser/data/repo/auth/general_setting_repo.dart';
import 'package:leoparduser/data/repo/auth/sms_email_verification_repo.dart';
import 'package:leoparduser/data/services/api_service.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/components/will_pop_widget.dart';

import '../../../components/otp_field_widget/otp_field_widget.dart';

class EmailVerificationScreen extends StatefulWidget {
  final bool needSmsVerification;
  final bool isProfileCompleteEnabled;
  final bool needTwoFactor;

  const EmailVerificationScreen(
      {super.key,
      required this.needSmsVerification,
      required this.isProfileCompleteEnabled,
      required this.needTwoFactor});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SmsEmailVerificationRepo(apiClient: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    final controller = Get.put(EmailVerificationController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.needSmsVerification = widget.needSmsVerification;
      controller.isProfileCompleteEnable = widget.isProfileCompleteEnabled;
      controller.needTwoFactor = widget.needTwoFactor;
      controller.loadData();
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
          body: GetBuilder<EmailVerificationController>(
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
                                    child: Text(MyStrings.verifyYourEmail.tr,
                                        style: boldExtraLarge.copyWith(
                                            fontSize:
                                                Dimensions.fontExtraLarge +
                                                    5))),
                                const SizedBox(height: Dimensions.space5),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      '${MyStrings.verifyYourEmailSubTItle.tr}  ${MyUtils.maskEmail(controller.userEmail)} ',
                                      style: regularDefault.copyWith(
                                          color: MyColor.getBodyTextColor(),
                                          fontSize: Dimensions.fontLarge),
                                      textAlign: TextAlign.center),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .04),
                                OTPFieldWidget(
                                  onChanged: (value) {
                                    controller.currentText = value;
                                  },
                                ),
                                const SizedBox(height: Dimensions.space30),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: Dimensions.space20,
                                      end: Dimensions.space20),
                                  child: RoundedButton(
                                    text: MyStrings.verify.tr,
                                    isLoading: controller.submitLoading,
                                    press: () {
                                      controller
                                          .verifyEmail(controller.currentText);
                                    },
                                  ),
                                ),
                                const SizedBox(height: Dimensions.space30),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.space30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(MyStrings.didNotReceiveCode.tr,
                                          style: regularDefault.copyWith(
                                              color:
                                                  MyColor.getLabelTextColor())),
                                      SizedBox(width: Dimensions.space5),
                                      controller.resendLoading
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5, top: 5),
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
                                                      color: MyColor
                                                          .getPrimaryColor(),
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationColor: MyColor
                                                          .primaryColor)),
                                            )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
