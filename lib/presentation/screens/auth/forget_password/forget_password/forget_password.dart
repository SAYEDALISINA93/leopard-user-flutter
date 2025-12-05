import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_icons.dart';
import 'package:leoparduser/core/utils/my_images.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/auth/forget_password/forget_password_controller.dart';
import 'package:leoparduser/data/repo/auth/login_repo.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/divider/custom_spacer.dart';
import 'package:leoparduser/presentation/components/text-form-field/custom_text_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(LoginRepo(apiClient: Get.find()));
    Get.put(ForgetPasswordController(loginRepo: Get.find()));

    super.initState();
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
      child: Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        body: GetBuilder<ForgetPasswordController>(
          builder: (auth) => SingleChildScrollView(
            padding: Dimensions.screenPaddingHV,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    MyImages.appLogoWhite,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      MyIcons.bg,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsetsDirectional.only(
                      top: Dimensions.space20,
                      start: Dimensions.space20,
                      end: Dimensions.space20,
                      bottom: Dimensions.space20,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          spaceDown(Dimensions.space20),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              MyStrings.recoverAccount.tr,
                              style: boldExtraLarge.copyWith(
                                fontSize: Dimensions.fontExtraLarge + 5,
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.space5),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              MyStrings.forgetPasswordSubText.tr,
                              style: regularDefault.copyWith(
                                color: MyColor.getBodyTextColor(),
                                fontSize: Dimensions.fontLarge,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: Dimensions.space40),
                          CustomTextField(
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: MyStrings.usernameOrEmail.tr,
                            hintText: MyStrings.usernameOrEmailHint.tr,
                            textInputType: TextInputType.emailAddress,
                            inputAction: TextInputAction.done,
                            controller: auth.emailOrUsernameController,
                            onSuffixTap: () {},
                            onChanged: (value) {
                              return;
                            },
                            validator: (value) {
                              if (auth.emailOrUsernameController.text.isEmpty) {
                                return MyStrings.enterEmailOrUserName.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: Dimensions.space25),
                          RoundedButton(
                            isLoading: auth.submitLoading,
                            press: () {
                              if (_formKey.currentState!.validate()) {
                                auth.submitForgetPassCode();
                              }
                            },
                            text: MyStrings.submit.tr,
                          ),
                          const SizedBox(height: Dimensions.space40),
                        ],
                      ),
                    ),
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
