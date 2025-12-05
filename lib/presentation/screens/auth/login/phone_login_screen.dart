import 'package:flutter_svg/svg.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/auth/login_controller.dart';
import 'package:leoparduser/data/controller/auth/social_auth_controller.dart';
import 'package:leoparduser/data/repo/auth/login_repo.dart';
import 'package:leoparduser/data/repo/auth/socail_repo.dart';
import 'package:leoparduser/data/services/api_client.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/image/custom_svg_picture.dart';
import 'package:leoparduser/presentation/components/text-form-field/custom_text_field.dart';
import 'package:leoparduser/presentation/components/will_pop_widget.dart';
import 'package:leoparduser/presentation/screens/auth/social_auth/social_auth_section.dart';

import '../../../../core/utils/my_images.dart';
import '../../../components/divider/custom_spacer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoginRepo(apiClient: Get.find()));
    Get.put(LoginController(loginRepo: Get.find()));
    Get.put(SocialAuthRepo(apiClient: Get.find()));
    Get.put(SocialAuthController(authRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LoginController>().remember = false;
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
        nextRoute: '',
        child: Scaffold(
          backgroundColor: MyColor.colorWhite,
          body: GetBuilder<LoginController>(
            builder: (controller) => SingleChildScrollView(
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
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: Dimensions.space15,
                          vertical: Dimensions.space10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          spaceDown(Dimensions.space20),
                          Text(
                            MyStrings.loginScreenTitle.tr,
                            style: boldExtraLarge.copyWith(
                                fontSize: 32, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: Dimensions.space5),
                          Text(
                            MyStrings.loginScreenSubTitle.tr,
                            style: lightDefault.copyWith(
                                color: MyColor.bodyText,
                                fontSize: Dimensions.fontLarge),
                          ),
                          spaceDown(Dimensions.space20),
                          SocialAuthSection(),
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                spaceDown(Dimensions.space20),
                                CustomTextField(
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  controller: controller.mobileNumberController,
                                  labelText: MyStrings.enterYourPhoneNumber.tr,
                                  onChanged: (value) {},
                                  focusNode: controller.mobileNumberFocusNode,
                                  // nextFocus: controller.passwordFocusNode,
                                  textInputType: TextInputType.phone,
                                  inputAction: TextInputAction.next,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: CustomSvgPicture(
                                        image: MyIcons.phone,
                                        color: MyColor.primaryColor),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return MyStrings.fieldErrorMsg.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                spaceDown(Dimensions.space25),
                                RoundedButton(
                                  isLoading: controller.isSubmitLoading,
                                  text: MyStrings.signIn.tr,
                                  press: () {
                                    if (formKey.currentState!.validate()) {
                                      controller.loginUser();
                                    }
                                  },
                                ),
                                spaceDown(Dimensions.space30),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(MyStrings.doNotHaveAccount.tr,
                                        overflow: TextOverflow.ellipsis,
                                        style: regularLarge.copyWith(
                                            color: MyColor.getBodyTextColor(),
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14)),
                                    const SizedBox(width: Dimensions.space5),
                                    InkWell(
                                      onTap: () {
                                        // Get.offAndToNamed(
                                        // RouteHelper.registrationScreen);
                                        Get.defaultDialog(
                                          title: "Under Development",
                                          middleText:
                                              "This feature is under development.",
                                          textConfirm: "OK",
                                          onConfirm: () {
                                            Get.back();
                                          },
                                        );
                                      },
                                      child: Text(MyStrings.signUp.tr,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: boldLarge.copyWith(
                                              color:
                                                  MyColor.getPrimaryColor())),
                                    )
                                  ],
                                ),
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
