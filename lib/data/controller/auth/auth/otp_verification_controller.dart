import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/controller/auth/auth/phone_registration_controller.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/repo/auth/general_setting_repo.dart';
import 'package:leoparduser/data/repo/auth/phone_signup_repo.dart';
import 'package:leoparduser/data/repo/auth/sms_email_verification_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class OtpVerificationController extends GetxController {
  SmsEmailVerificationRepo repo;

  OtpVerificationController({required this.repo});

  bool hasError = false;
  bool isLoading = true;
  String currentText = '';
  String userPhone = '';
  String userCompletePhone = '';
  bool isProfileCompleteEnable = false;
  String countryCode = '';
  String verificationId = '';
  String verificationToken = '';

  Future<void> loadBefore() async {
    isLoading = true;

    userCompletePhone = '+${countryCode + userPhone}';

    print("User Phone: $userPhone ");
    update();

    isLoading = false;
    update();
    return;
  }

  bool submitLoading = false;
  verifyYourSms(String currentText) async {
    if (currentText.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.otpFieldEmptyMsg.tr]);
      return;
    }

    submitLoading = true;
    update();

    try {
      ResponseModel response =
          await repo.verifyFirebase(currentText, verificationId);
      if (response.statusCode == 200) {
        CustomSnackBar.success(successList: [
          '${MyStrings.sms.tr} ${MyStrings.verificationSuccess.tr}'
        ]);

        var responseJson = jsonDecode(response.responseJson);

        // Register the PhoneRegistrationController if not already registered
        if (!Get.isRegistered<PhoneRegistrationController>()) {
          Get.put(PhoneRegistrationController(
            registrationRepo: PhoneRegistrationRepo(apiClient: Get.find()),
            generalSettingRepo: GeneralSettingRepo(apiClient: Get.find()),
          ));
        }

        // now navigate back to the registration screen
        Get.back(result: responseJson['token']);
        // Call the controller of the registration screen
        PhoneRegistrationController registrationController = Get.find();
        registrationController.setToken(responseJson['token']);
        registrationController.agreeTC = true;
        registrationController.mobileController.text = userPhone;
        registrationController.countryController.text = countryCode;
        registrationController.signUpUser();
      } else {
        CustomSnackBar.error(errorList: [
          '${MyStrings.sms.tr} ${MyStrings.verificationFailed.tr}'
        ]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [
        '${MyStrings.sms.tr} ${MyStrings.verificationFailed.tr}: $e'
      ]);
      print("Error: $e");
    }

    submitLoading = false;
    update();
  }

  bool resendLoading = false;
  Future<void> sendCodeAgain() async {
    // resendLoading = true;
    // update();
    // await repo.resendVerifyCode(isEmail: false);
    // resendLoading = false;
    // update();
  }
}
