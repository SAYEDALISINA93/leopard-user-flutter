import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route.dart';
import 'package:leoparduser/core/utils/dimensions.dart';
import 'package:leoparduser/core/utils/my_color.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/core/utils/style.dart';
import 'package:leoparduser/data/controller/auth/auth/phone_registration_controller.dart';
import 'package:leoparduser/presentation/components/buttons/rounded_button.dart';
import 'package:leoparduser/presentation/components/text-form-field/custom_text_field.dart';

class PhoneRegistrationForm extends StatefulWidget {
  const PhoneRegistrationForm({super.key});

  @override
  State<PhoneRegistrationForm> createState() => _PhoneRegistrationFormState();
}

class _PhoneRegistrationFormState extends State<PhoneRegistrationForm> {
  bool isNumberBlank = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhoneRegistrationController>(
      builder: (controller) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                animatedLabel: true,
                needOutlineBorder: true,
                labelText: MyStrings.phoneNumber.tr,
                controller: controller.mobileController,
                focusNode: controller.mobileFocusNode,
                textInputType: TextInputType.phone,
                nextFocus: controller.mobileFocusNode,
                prefixIcon: Container(
                  alignment: Alignment.center,
                  width: 48,
                  child: Text(
                    MyStrings.afgCode,
                    style: regularDefault.copyWith(
                      color: MyColor.getTextColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return MyStrings.kEmptyPhoneNumberError.tr;
                  } else if (!MyStrings.phoneValidatorRegExp.hasMatch(value)) {
                    return MyStrings.kInvalidPhoneNumberError.tr;
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  return;
                },
              ),
              const SizedBox(height: Dimensions.space25),
              Visibility(
                visible: controller.needAgree,
                child: Row(
                  children: [
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Dimensions.defaultRadius)),
                        activeColor: MyColor.primaryColor,
                        checkColor: MyColor.colorWhite,
                        value: controller.agreeTC,
                        side: WidgetStateBorderSide.resolveWith((states) =>
                            BorderSide(
                                width: 1.0,
                                color: controller.agreeTC
                                    ? MyColor.getTextFieldEnableBorder()
                                    : MyColor.getTextFieldDisableBorder())),
                        onChanged: (bool? value) {
                          controller.updateAgreeTC();
                        },
                      ),
                    ),
                    if (controller.generalSettingRepo.apiClient
                        .isAgreePolicyEnabled()) ...[
                      const SizedBox(width: Dimensions.space8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.updateAgreeTC();
                          },
                          child: RichText(
                            text: TextSpan(
                              text: MyStrings.regTerm.tr,
                              style: lightDefault.copyWith(
                                  color: MyColor.colorGrey, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: " ${MyStrings.privacyPolicy.tr}",
                                  style: boldDefault.copyWith(
                                      color: MyColor.colorGrey,
                                      fontWeight: FontWeight.w600,
                                      height: 1.7,
                                      fontSize: 14),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.toNamed(RouteHelper.privacyScreen);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.space30),
              RoundedButton(
                isLoading: controller.submitLoading,
                text: MyStrings.signUp.tr,
                press: () {
                  if (formKey.currentState!.validate()) {
                    // controller.signUpUser();
                    controller.verifyPhone();
                  }
                },
              ),
              const SizedBox(height: Dimensions.space30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(MyStrings.alreadyAccount.tr,
                      overflow: TextOverflow.ellipsis,
                      style: lightLarge.copyWith(
                          color: MyColor.getBodyTextColor(),
                          fontWeight: FontWeight.normal)),
                  const SizedBox(width: Dimensions.space5),
                  InkWell(
                    onTap: () {
                      Get.offAllNamed(RouteHelper.loginScreen);
                      loggerX('tap');
                    },
                    child: Text(MyStrings.signIn.tr,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: boldLarge.copyWith(
                            color: MyColor.getPrimaryColor())),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
