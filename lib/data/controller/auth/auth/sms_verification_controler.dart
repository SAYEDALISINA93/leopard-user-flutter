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
import 'package:firebase_auth/firebase_auth.dart';

class SmsVerificationController extends GetxController {
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

    userCompletePhone = '+${countryCode + userPhone}';

    print("User Phone: $userPhone ");
    update();
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
      printX(
          "Verifying SMS with code: $currentText and verificationId: $verificationId");
      ResponseModel responseModel =
          await smsRepo.verifyFirebase(currentText, verificationId);

      printX("SMS Verification Response: ${responseModel.responseJson} ");

      if (responseModel.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            jsonDecode(responseModel.responseJson);
        CustomSnackBar.success(successList: [responseModel.message]);
        verificationToken = jsonResponse['token'];
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
      printX("SmsVerificationController verifyYourSms Error: $e");
    }

    submitLoading = false;
    update();
  }

  Future<void> callLoginApi() async {
    printX(
        "Calling login API with phone: $userPhone, countryCode: $countryCode, verificationToken: $verificationToken");
    ResponseModel model =
        await repo.loginWithPhone(userPhone, countryCode, verificationToken);

    if (model.statusCode == 200) {
      LoginResponseModel loginModel =
          LoginResponseModel.fromJson(model.responseJson);

      if (loginModel.status.toString().toLowerCase() ==
          MyStrings.success.toLowerCase()) {
        await repo.apiClient.sharedPreferences
            .setBool(SharedPreferenceHelper.rememberMeKey, true);
        loggerX(loginModel.data?.toJson());
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
  var resendOtpTimer = 60.obs; // Observable countdown timer
  Timer? _resendOtpCountdownTimer;

  void startResendOtpTimer() {
    resendOtpTimer.value = 60; // Reset the timer
    _resendOtpCountdownTimer?.cancel(); // Cancel any existing timer
    _resendOtpCountdownTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendOtpTimer.value > 0) {
        resendOtpTimer.value--; // Decrement the timer value
        resendOtpTimer.refresh(); // Ensure observable triggers UI updates
      } else {
        timer.cancel(); // Stop the timer when it reaches 0
        resendOtpTimer.refresh(); // Ensure UI reflects the final state
      }
    });
  }

  Future<bool> resendPhoneOtpWithFirebase(
      {required String phoneNumber, String countryCode = "+93"}) async {
    if (phoneNumber.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterPhoneNumber]);
      return false;
    }
    try {
      String verificationId = '';
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryCode + phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          CustomSnackBar.error(
              errorList: [e.message ?? MyStrings.loginFailedTryAgain]);
        },
        codeSent: (String verId, int? resendToken) {
          verificationId = verId;
          CustomSnackBar.success(
              successList: [MyStrings.successfullyCodeResend]);
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );
      return true;
    } catch (e) {
      CustomSnackBar.error(errorList: [e.toString()]);
      return false;
    }
  }

  Future<void> sendCodeAgain() async {
    resendLoading = true;
    update();
    bool success = await resendPhoneOtpWithFirebase(
      phoneNumber: userPhone,
      countryCode: countryCode.isNotEmpty ? '+$countryCode' : '+93',
    );
    if (success) {
      startResendOtpTimer();
    }
    resendLoading = false;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    startResendOtpTimer();
  }

  @override
  void onClose() {
    super.onClose();
    _resendOtpCountdownTimer?.cancel();
  }
}
