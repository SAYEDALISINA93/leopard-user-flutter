import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:leoparduser/core/helper/shared_preference_helper.dart';
import 'package:leoparduser/core/route/route_middleware.dart';
import 'package:leoparduser/core/utils/my_strings.dart';
import 'package:leoparduser/data/model/authorization/authorization_response_model.dart';
import 'package:leoparduser/data/model/global/response_model/response_model.dart';
import 'package:leoparduser/data/repo/auth/sms_email_verification_repo.dart';
import 'package:leoparduser/presentation/components/snack_bar/show_custom_snackbar.dart';

class SmsVerificationController extends GetxController {
  SmsEmailVerificationRepo repo;
  SmsVerificationController({required this.repo});

  bool hasError = false;
  bool isLoading = true;
  String currentText = '';
  String userPhone = '';
  bool isProfileCompleteEnable = false;

  Future<void> loadBefore() async {
    isLoading = true;
    userPhone = repo.apiClient.sharedPreferences
            .getString(SharedPreferenceHelper.userPhoneNumberKey) ??
        '';
    update();
    await repo.sendAuthorizationRequest();
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

    ResponseModel responseModel =
        await repo.verify(currentText, isEmail: false, isTFA: false);

    if (responseModel.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));

      if (model.status == MyStrings.success) {
        CustomSnackBar.success(
            successList: model.message ??
                ['${MyStrings.sms.tr} ${MyStrings.verificationSuccess.tr}']);
        RouteMiddleware.checkNGotoNext(user: model.data?.user);
        // Get.offAndToNamed(isProfileCompleteEnable ? RouteHelper.profileCompleteScreen : RouteHelper.dashboard);
      } else {
        CustomSnackBar.error(
            errorList: model.message ??
                ['${MyStrings.sms.tr} ${MyStrings.verificationFailed}']);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    submitLoading = false;
    update();
  }

  bool resendLoading = false;
  Future<void> sendCodeAgain() async {
    resendLoading = true;
    update();
    await repo.resendVerifyCode(isEmail: false);
    resendLoading = false;
    update();
  }
}
