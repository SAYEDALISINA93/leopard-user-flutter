import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/helper/string_format_helper.dart';
import 'package:leoparduser/core/route/route_middleware.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/auth/login/login_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/repo/auth/login_repo.dart';
import 'package:leoparduser/data/repo/auth/sms_email_verification_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class SmsVerificationController extends GetxController {
  // SmsEmailVerificationRepo repo;
  // SmsVerificationController({required this.repo});

  LoginRepo repo;
  SmsVerificationController({required this.repo});

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
    // userPhone = repo.apiClient.sharedPreferences
    //         .getString(SharedPreferenceHelper.userPhoneNumberKey) ??
    //     '';

    userCompletePhone = '+${countryCode + userPhone}';

    print("User Phone: $userPhone ");
    update();
    // await repo.sendAuthorizationRequest();
    isLoading = false;
    update();
    return;
  }

  bool submitLoading = false;
  SmsEmailVerificationRepo smsRepo = Get.find();

  verifyYourSms(String currentText) async {
    if (currentText.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.otpFieldEmptyMsg.tr]);
      return;
    }

    submitLoading = true;
    update();

    try {
      ResponseModel responseModel =
          await smsRepo.verifyFirebase(currentText, verificationId);

      if (responseModel.statusCode == 200) {
        CustomSnackBar.success(successList: [responseModel.message]);
        verificationToken = jsonDecode(responseModel.responseJson)['token'];
        await callLoginApi();
      } else {
        CustomSnackBar.error(errorList: [
          '${MyStrings.sms.tr} ${MyStrings.verificationFailed.tr}: Please check the code and try again.'
        ]);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [
        '${MyStrings.sms.tr} ${MyStrings.verificationFailed.tr}: An unexpected error occurred. Please try again later.'
      ]);
    }

    submitLoading = false;
    update();
  }

  Future<void> callLoginApi() async {
    ResponseModel model =
        await repo.loginWithPhone(userPhone, countryCode, verificationToken);

    if (model.statusCode == 200) {
      LoginResponseModel loginModel =
          LoginResponseModel.fromJson(jsonDecode(model.responseJson));

      print("Login Model: ${model.responseJson}");
      if (loginModel.status.toString().toLowerCase() ==
          MyStrings.success.toLowerCase()) {
        // checkAndGotoNextStep(loginModel);
        await repo.apiClient.sharedPreferences
            .setBool(SharedPreferenceHelper.rememberMeKey, true);
        loggerI(loginModel.data?.toJson());
        RouteMiddleware.checkNGotoNext(
          accessToken: loginModel.data?.accessToken ?? '',
          tokenType: loginModel.data?.tokenType ?? '',
          user: loginModel.data?.user,
        );
      } else {
        CustomSnackBar.error(
            errorList: loginModel.message ?? [MyStrings.loginFailedTryAgain]);
      }
    } else {
      CustomSnackBar.error(errorList: [model.message]);
    }
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
